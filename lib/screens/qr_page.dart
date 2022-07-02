import 'package:conftp/controllers/qr_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRPage extends GetView<QrController> {
  const QRPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Expanded(
        flex: 6,
        child: QRView(
            key: GlobalKey(),
            overlay: QrScannerOverlayShape(),
            onQRViewCreated: (qrController) {
              controller.qrViewController = qrController;
              qrController.scannedDataStream.listen((event) {
                Get.back(result: event.code);
                qrController.stopCamera();
              });
            }),
      ),
      Expanded(
        flex: 1,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Obx(() => IconButton(
              onPressed: () async {
                await controller.qrViewController!.toggleFlash();
                controller.isFlashEnabled.toggle();
              },
              icon: Icon(Icons.flash_on,
                  color:
                      controller.isFlashEnabled.value ? Colors.yellow : null),
              iconSize: 40)),
          IconButton(
              onPressed: () => controller.qrViewController!.flipCamera(),
              icon: const Icon(Icons.flip_camera_android),
              iconSize: 40)
        ]),
      )
    ]));
  }
}
