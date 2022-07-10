import 'dart:io';

import 'package:get/get.dart';

class ClientController extends GetxController {
  void connect(String ip, int port) async {
    final client =
        await Socket.connect(ip, port, timeout: const Duration(seconds: 5));
    Get.toNamed("/transfer", arguments: client);
  }
}
