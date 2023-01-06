import 'package:get/get.dart';

import '../controllers/liked_teachers_controller.dart';

class LikedTeachersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LikedTeachersController>(
      () => LikedTeachersController(),
    );
  }
}
