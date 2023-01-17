import 'package:get/get.dart';

import 'package:educate_io/app/modules/details/controllers/rating_controller.dart';

import '../controllers/details_controller.dart';

class DetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RatingController>(
      () => RatingController(),
    );
    Get.lazyPut<DetailsController>(
      () => DetailsController(),
    );
  }
}
