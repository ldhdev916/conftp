import 'package:conftp/screens/client_page.dart';
import 'package:conftp/screens/server_page.dart';
import 'package:get/get.dart';

class BottomController extends GetxService {
  final index = 0.obs;
  final pages = [ServerPage(), const ClientPage()];
}
