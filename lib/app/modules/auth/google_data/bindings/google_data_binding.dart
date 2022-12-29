import 'package:get/get.dart';

import '../controllers/google_data_controller.dart';

class GoogleDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoogleDataController>(
      () => GoogleDataController(),
    );
  }
}
