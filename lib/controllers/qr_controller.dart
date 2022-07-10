import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrController extends GetxController {
  final isFlashEnabled = false.obs;
  QRViewController? qrViewController;
}
