import 'package:conftp/controllers/bottom_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Root extends GetView<BottomController> {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.pages[controller.index.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
              currentIndex: controller.index.value,
              onTap: controller.index,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.upload), label: "서버"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.download), label: "클라이언트")
              ])),
    );
  }
}
