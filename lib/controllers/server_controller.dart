import 'dart:io';

import 'package:get/get.dart';

class ServerController extends GetxController {
  final isOpen = false.obs;
  ServerSocket? _serverSocket;

  int? get port => _serverSocket?.port;

  void open() async {
    _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 0);
    _serverSocket!.listen((event) {
      Get.toNamed("/transfer", arguments: event);
    });
  }

  void close() => _serverSocket!.close();
}
