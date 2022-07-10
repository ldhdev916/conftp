import 'package:conftp/controllers/transfer_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransferScreen extends GetResponsiveView<TransferController> {
  TransferScreen({Key? key}) : super(key: key);

  @override
  Widget builder() {
    return Scaffold(
      appBar: AppBar(title: const Text("데이터 전송"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screen.width * 0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
                controller: controller.editController,
                maxLines: null,
                decoration: InputDecoration(
                    labelText: "보낼 텍스트",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    suffix: IconButton(
                        onPressed: () =>
                            controller.sendText(controller.editController.text),
                        icon: const Icon(Icons.play_arrow)))),
            SizedBox(
              width: double.infinity,
              height: screen.height * 0.08,
              child: ElevatedButton.icon(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                  onPressed: () async {
                    final result = await FilePicker.platform
                        .pickFiles(allowMultiple: true, withReadStream: true);
                    if (result == null) {
                      Get.snackbar("파일 전송", "파일을 선택 해 주세요");
                      return;
                    }
                    controller.sendFiles(result.files);
                  },
                  icon: const Icon(Icons.file_copy_outlined),
                  label: const Text("파일 전송")),
            )
          ],
        ),
      ),
    );
  }
}
