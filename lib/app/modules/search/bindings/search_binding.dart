import 'package:get/get.dart';

import '../controllers/search_teachers_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchTeachersController>(
      () => SearchTeachersController(),
    );
  }
}
