import 'package:conftp/controllers/bottom_controller.dart';
import 'package:conftp/controllers/client_controller.dart';
import 'package:conftp/controllers/server_controller.dart';
import 'package:conftp/controllers/transfer_controller.dart';
import 'package:conftp/screens/qr_page.dart';
import 'package:conftp/screens/root.dart';
import 'package:conftp/screens/transfer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/qr_controller.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(initialRoute: "/", getPages: [
      GetPage(
          name: "/",
          page: () => const Root(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => BottomController());
            Get.lazyPut(() => ServerController());
            Get.lazyPut(() => ClientController());
          })),
      GetPage(
          name: "/qr",
          page: () => const QRPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => QrController());
          })),
      GetPage(
          name: "/transfer",
          page: () => TransferScreen(),
          binding: BindingsBuilder(() {
            Get.put(TransferController(Get.arguments));
          }))
    ]);
  }
}
