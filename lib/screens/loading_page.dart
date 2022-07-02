import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingPage extends GetResponsiveView {
  LoadingPage({Key? key}) : super(key: key);

  @override
  Widget builder() {
    return Center(
      child: SizedBox(
          width: screen.width / 2,
          height: screen.width / 2,
          child: const CircularProgressIndicator()),
    );
  }
}
