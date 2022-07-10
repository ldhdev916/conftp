import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:conftp/services/data_handler.dart';
import 'package:convert/convert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jovial_misc/io_utils.dart';

class TransferController extends GetxController {
  final editController = TextEditingController();
  final Socket socket;
  final handlers = {0: TextDataHandler(), 1: FileDataHandler()};

  TransferController(this.socket);

  @override
  void onInit() {
    super.onInit();

    var identifier = -1;
    var bytesLength = -1;
    var bytesBuffer = <int>[];

    DataInputStream asData(Uint8List data) =>
        DataInputStream(Stream<List<int>>.value(data));

    void handleEvent(Uint8List event) async {
      Future<void> reHandle(void Function(int) setter) async {
        final inputStream = asData(event);
        setter(await inputStream.readInt());
        final bytesAvailable = await inputStream.bytesAvailable;
        if (bytesAvailable > 0) {
          handleEvent(await inputStream.readBytes(bytesAvailable));
        }
      }

      if (identifier == -1) {
        await reHandle((p0) => identifier = p0);
      } else if (bytesLength == -1) {
        await reHandle((p0) => bytesLength = p0);
      } else {
        bytesBuffer += event;
        if (bytesBuffer.length == bytesLength) {
          final value = await handlers[identifier]!
              .handleData(asData(Uint8List.fromList(bytesBuffer)));
          Get.snackbar("데이터 전송", value);

          identifier = -1;
          bytesLength = -1;
          bytesBuffer = [];
        }
      }
    }

    socket.listen(handleEvent, onDone: () => Get.back());
  }

  void _sink(int identifier,
      FutureOr<void> Function(DataOutputSink sink) action) async {
    final output = ByteAccumulatorSink();
    final sink = DataOutputSink(output);

    await action(sink);

    final socketSink = DataOutputSink(socket);

    final bytes = output.bytes;

    socketSink.writeInt(identifier);
    socketSink.writeInt(bytes.length);
    socketSink.writeBytes(bytes);
  }

  void sendText(String text) {
    _sink(0, (sink) {
      sink.writeUTF8(text);
    });
  }

  void sendFiles(Iterable<PlatformFile> files) {
    _sink(1, (sink) async {
      sink.writeInt(files.length);

      for (final file in files) {
        sink.writeUTF8(file.name);

        final bytes = <int>[];

        await file.readStream!.listen(bytes.addAll).asFuture();

        sink.writeInt(bytes.length);
        sink.writeBytes(bytes);
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    socket.close();
  }
}
