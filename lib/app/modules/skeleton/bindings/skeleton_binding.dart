import 'package:get/get.dart';

import '../controllers/skeleton_controller.dart';

class SkeletonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SkeletonController>(
      () => SkeletonController(),
    );
  }
}
