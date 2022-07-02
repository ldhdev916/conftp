import 'dart:io';

import 'package:flutter/services.dart';
import 'package:jovial_misc/io_utils.dart';
import 'package:path_provider/path_provider.dart';

abstract class DataHandler {
  Future<String> handleData(DataInputStream dataInput);
}

class TextDataHandler implements DataHandler {
  @override
  Future<String> handleData(DataInputStream dataInput) async {
    final text = await dataInput.readUTF8();
    await Clipboard.setData(ClipboardData(text: text));

    return "텍스트(${text.length}자)";
  }
}

class FileDataHandler implements DataHandler {
  @override
  Future<String> handleData(DataInputStream dataInput) async {
    final separator = Platform.pathSeparator;

    final rootDirectory = await (Platform.isAndroid
        ? getExternalStorageDirectory()
        : getApplicationDocumentsDirectory());

    final directory =
        Directory("${rootDirectory!.path}${separator}DataTransfer");
    if (!(await directory.exists())) {
      await directory.create(recursive: true);
    }

    final totalFiles = await dataInput.readInt();

    final files = <File>[];
    for (var i = 0; i < totalFiles; i++) {
      final name = await dataInput.readUTF8();
      final bytesSize = await dataInput.readInt();

      final bytes = await dataInput.readBytes(bytesSize);

      final path = "${directory.path}$separator$name";
      files.add(await File(path).writeAsBytes(bytes));
    }

    final fileTexts = await Future.wait(files.map((e) async {
      final name = e.path.split(separator).last;
      final bytes = await e.length();

      return "$name($bytes bytes)";
    }));

    return "파일 ${files.length}개 ${fileTexts.join(", ")}";
  }
}
