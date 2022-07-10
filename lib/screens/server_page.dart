import 'dart:math';

import 'package:conftp/controllers/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'loading_page.dart';

class ServerPage extends GetResponsiveView<ServerController> {
  ServerPage({Key? key}) : super(key: key);

  @override
  Widget builder() {
    return Scaffold(
      appBar:
          AppBar(title: const Text("데이터 전송 서버"), centerTitle: true, actions: [
        Obx(() => Switch(
            value: controller.isOpen.value,
            onChanged: (value) {
              if (value) {
                controller.open();
              } else {
                controller.close();
              }
              controller.isOpen(value);
            }))
      ]),
      body: Obx(() {
        if (controller.isOpen.value) {
          return FutureBuilder(
              future: NetworkInfo().getWifiIP().then((value) async {
                final String ip;
                if (value == null) {
                  final response =
                      await get(Uri.parse("https://api.ipify.org"));
                  ip = response.body;
                } else {
                  ip = value;
                }

                return "$ip:${controller.port}";
              }),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  final ip = snapshot.data as String;
                  return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Text("현재 ip/port : $ip",
                            style: const TextStyle(fontSize: 20)),
                        SizedBox(height: screen.height * 0.05),
                        QrImage(
                            data: ip,
                            size: min(screen.width, screen.height) / 2)
                      ]));
                } else {
                  return LoadingPage();
                }
              });
        } else {
          return const Center(
              child: Text("서버가 닫혀있습니다", style: TextStyle(fontSize: 24)));
        }
      }),
    );
  }
}
