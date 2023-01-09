import 'package:get/get.dart';

import '../controllers/teachers_nearby_controller.dart';

class TeachersNearbyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeachersNearbyController>(
      () => TeachersNearbyController(),
    );
  }
}
