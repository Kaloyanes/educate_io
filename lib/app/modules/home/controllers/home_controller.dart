import 'package:educate_io/app/services/database/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // List<Teacher> teachers = [
  //   Teacher(
  //     imgUrl:
  //         "https://scontent.fsof11-1.fna.fbcdn.net/v/t31.18172-8/21950058_534869006844669_6945425416141678541_o.jpg?_nc_cat=101&ccb=1-7&_nc_sid=174925&_nc_ohc=P_xUMG5ZGXsAX-W0Czn&tn=KtONFRTBWX1fCcTX&_nc_ht=scontent.fsof11-1.fna&oh=00_AfB2QXg8DMsn20sxRgbBnITI8jvNgdbRbH89qrt3pvQxwQ&oe=63D7833D",
  //     name: "Петър Желев",
  //     age: 70,
  //     description:
  //         "Аз съм Петър Желев. Роден съм и се намирам в Бургас. Елате и ме изнаселете",
  //     categories: ["Програмист", "Сертифиран педофил"],
  //     role: "Учител",
  //     phoneNumber: "+359879900137",
  //   ),
  //   Teacher(
  //     imgUrl:
  //         "https://scontent.fsof11-1.fna.fbcdn.net/v/t1.6435-9/89824552_2952344278155746_5720414663200473088_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=730e14&_nc_ohc=FyGA3iBo-KwAX8enAwM&_nc_ht=scontent.fsof11-1.fna&oh=00_AfCIH1hDM3PTkkpkcIA9iMRqj__Qi4zSvHcWxSMruCVDOQ&oe=63C2B929",
  //     name: "Самвел Матинян",
  //     age: 90,
  //     description:
  //         "Здр, малки идиотчета, аз съм Самвел и се намирам във Варна. Обичам да играя шах с малки деца за да ги изнасилвам, Най-голямата ми жертва е Калоян от Бургас и създателя на това приложение, Здр, малки идиотчета, аз съм Самвел и се намирам във Варна. Обичам да играя шах с малки деца за да ги изнасилвам, Най-голямата ми жертва е Калоян от Бургас и създателя на това приложение, Здр, малки идиотчета, аз съм Самвел и се намирам във Варна. Обичам да играя шах с малки деца за да ги изнасилвам, Най-голямата ми жертва е Калоян от Бургас и създателя на това приложение, Здр, малки идиотчета, аз съм Самвел и се намирам във Варна. Обичам да играя шах с малки деца за да ги изнасилвам, Най-голямата ми жертва е Калоян от Бургас и създателя на това приложение",
  //     categories: ["Програмист", "Сертифиран Sex offender"],
  //     role: "Учител",
  //     phoneNumber: "+359879900137",
  //   ),
  //   Teacher(
  //     imgUrl:
  //         "https://scontent.fsof11-1.fna.fbcdn.net/v/t31.18172-8/10003816_1499542633607086_9109329851444695853_o.jpg?_nc_cat=104&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=WYFJ3wouTFkAX9XsxKY&_nc_ht=scontent.fsof11-1.fna&oh=00_AfAnmmJlKI4xXBdcIHP37T1pi5nUD2gSacAiU8UT2pTk_Q&oe=63C2C24F",
  //     name: "Петър Петров",
  //     age: 60,
  //     description: "Обичам малки деца",
  //     categories: [
  //       "Програмист",
  //       "Сертифиран Sex offender",
  //       "Сертифиран педофил"
  //     ],
  //     role: "Учител",
  //     phoneNumber: "+359879900137",
  //   ),
  //   Teacher(
  //     imgUrl:
  //         "https://scontent.fsof11-1.fna.fbcdn.net/v/t31.18172-8/26685457_282701098923361_2465119173584930180_o.jpg?_nc_cat=105&ccb=1-7&_nc_sid=174925&_nc_ohc=y-K30rjDBB8AX-WaRZp&_nc_ht=scontent.fsof11-1.fna&oh=00_AfBdX0IP8SOkGApd5MdJRiGXVh-r2ogzjarQclzBmNnOVQ&oe=63C7B27A",
  //     name: "Станимир Ламбов",
  //     age: 70,
  //     description: "Дано ме изнасили ученика ми",
  //     categories: ["Програмист", "Педофил"],
  //     role: "Учител",
  //     phoneNumber: "+359879900137",
  //   )
  // ];

  Stream authStream = const Stream.empty();

  @override
  void onInit() {
    super.onInit();
    authStream = FirebaseAuth.instance.authStateChanges();
  }

  Future<String> getName() async {
    var data = await FirestoreProfileService.getUserData();
    return data?["name"] ?? "";
  }

  // void showProfileSettings() {
  //   HapticFeedback.selectionClick();
  //   showDialog(
  //     context: Get.context!,
  //     builder: (context) => const ProfileSettingsDialog(),
  //   );
  // }
}
