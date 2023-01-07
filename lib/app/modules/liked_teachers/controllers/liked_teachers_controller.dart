import 'package:get/get.dart';

class LikedTeachersController extends GetxController {
  final heroTransition = true.obs;
  set setTransition(val) => heroTransition.value = val;

  @override
  void onClose() {
    setTransition = false;
    super.onClose();
  }
}
