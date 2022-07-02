import 'dart:io';

import 'package:get/get.dart';

class ClientController extends GetxController {
  void connect(String ip) async {
    final client =
        await Socket.connect(ip, 9422, timeout: const Duration(seconds: 5));
    Get.toNamed("/transfer", arguments: client);
  }
}
