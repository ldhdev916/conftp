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

    var expectLength = -1;
    Uint8List? byteBuffer;

    socket.listen((event) async {
      if (expectLength == -1) {
        final inputStream = DataInputStream(Stream<List<int>>.value(event));
        expectLength = await inputStream.readInt();
        byteBuffer =
            await inputStream.readBytes(await inputStream.bytesAvailable);
      } else {
        byteBuffer = Uint8List.fromList(byteBuffer! + event);
      }

      if (byteBuffer!.length == expectLength) {
        try {
          final inputStream =
              DataInputStream(Stream<List<int>>.value(byteBuffer!));
          final identifier = await inputStream.readInt();
          final value = await handlers[identifier]!.handleData(inputStream);
          Get.snackbar("데이터 전송", value);
        } finally {
          expectLength = -1;
          byteBuffer = null;
        }
      }
    }, onDone: () => Get.back());
  }

  void _sendData(Uint8List data) {
    socket.add(data);
  }

  Uint8List _sink(int identifier, void Function(DataOutputSink sink) action) {
    final output = ByteAccumulatorSink();
    final sink = DataOutputSink(output);

    sink.writeInt(identifier);
    action(sink);

    final total = ByteAccumulatorSink();
    final totalSink = DataOutputSink(total);
    totalSink.writeInt(output.bytes.length);
    totalSink.writeBytes(output.bytes);

    return total.bytes;
  }

  void sendText(String text) {
    _sendData(_sink(0, (sink) {
      sink.writeUTF8(text);
    }));
  }

  void sendFiles(Iterable<PlatformFile> files) {
    _sendData(_sink(1, (sink) {
      sink.writeInt(files.length);

      for (final file in files) {
        sink.writeUTF8(file.name);
        final bytes = file.bytes!;
        sink.writeInt(bytes.length);
        sink.writeBytes(bytes);
      }
    }));
  }

  @override
  void onClose() {
    super.onClose();
    socket.close();
  }
}
