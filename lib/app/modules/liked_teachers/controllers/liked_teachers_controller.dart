import 'package:get/get.dart';

class LikedTeachersController extends GetxController {
  //TODO: Implement LikedTeachersController

  final count = 0.obs;
  final heroTransition = true.obs;
  set setTransition(val) => heroTransition.value = val;

  @override
  void onClose() {
    setTransition = false;
    super.onClose();
  }

  void increment() => count.value++;
}
