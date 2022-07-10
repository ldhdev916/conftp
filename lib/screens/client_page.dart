import 'dart:io';

import 'package:conftp/controllers/client_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainButton extends GetResponsiveView {
  final VoidCallback onPressed;
  final Icon icon;
  final String labelText;
  final Color color;

  MainButton(
      {Key? key,
      required this.onPressed,
      required this.icon,
      required this.labelText,
      required this.color})
      : super(key: key);

  @override
  Widget builder() {
    final width = screen.width * 0.5;
    return SizedBox(
        width: width,
        height: screen.height * 0.06,
        child: ElevatedButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(color),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width)))),
            onPressed: onPressed,
            icon: icon,
            label: Text(labelText)));
  }
}

class ClientPage extends GetResponsiveView<ClientController> {
  ClientPage({Key? key}) : super(key: key);

  @override
  Widget builder() {
    return Scaffold(
        appBar: AppBar(title: const Text("데이터 전송 클라이언트"), centerTitle: true),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MainButton(
                    onPressed: () {
                      final ipController = TextEditingController();
                      final portController = TextEditingController();
                      Get.defaultDialog(
                          title: "IP 입력",
                          content: Column(children: [
                            TextField(
                                autofocus: true,
                                controller: ipController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "IP")),
                            SizedBox(height: screen.height * 0.01),
                            TextField(
                              controller: portController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "포트"),
                            )
                          ]),
                          confirm: TextButton(
                              onPressed: () {
                                Get.back();
                                controller.connect(ipController.text,
                                    int.parse(portController.text));
                              },
                              child: const Text("확인")));
                    },
                    icon: const Icon(Icons.wifi),
                    labelText: "IP 입력",
                    color: Colors.blue),
                MainButton(
                    onPressed: () async {
                      if (!Platform.isAndroid) {
                        Get.snackbar("사용 불가", "안드로이드에서만 사용 할 수 있습니다");
                        return;
                      }

                      final ip = await Get.toNamed("/qr");
                      if (ip == null) {
                        Get.snackbar("연결 실패", "QR코드에서 아이피를 감지하지 못했습니다");
                      } else {
                        final split = (ip as String).split(":");
                        controller.connect(split[0], int.parse(split[1]));
                      }
                    },
                    icon: const Icon(Icons.qr_code),
                    labelText: "QR 스캔",
                    color: Colors.indigo)
              ]),
        ));
  }
}
