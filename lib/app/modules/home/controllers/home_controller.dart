import 'package:educate_io/app/models/teacher_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  List<Teacher> teachers = [
    new Teacher(
      "https://scontent.fsof11-1.fna.fbcdn.net/v/t31.18172-8/21950058_534869006844669_6945425416141678541_o.jpg?_nc_cat=101&ccb=1-7&_nc_sid=174925&_nc_ohc=jFdDcuF4g3QAX9atVLX&tn=KtONFRTBWX1fCcTX&_nc_ht=scontent.fsof11-1.fna&oh=00_AfCfSyWS5ZQREK_95UO2B6UsbmSIQQJhWpWLuhFr9xOvtA&oe=63C2A37D",
      "Петър Желев",
      70,
      "Мазен идиот съм",
      ["Програмист", "Сертифиран педофил"],
    ),
    new Teacher(
      "https://scontent.fsof11-1.fna.fbcdn.net/v/t1.6435-9/89824552_2952344278155746_5720414663200473088_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=730e14&_nc_ohc=FyGA3iBo-KwAX8enAwM&_nc_ht=scontent.fsof11-1.fna&oh=00_AfCIH1hDM3PTkkpkcIA9iMRqj__Qi4zSvHcWxSMruCVDOQ&oe=63C2B929",
      "Самвел Матинян",
      90,
      "Не съм добре",
      ["Програмист", "Сертифиран Sex offender"],
    ),
    new Teacher(
      "https://scontent.fsof11-1.fna.fbcdn.net/v/t31.18172-8/10003816_1499542633607086_9109329851444695853_o.jpg?_nc_cat=104&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=WYFJ3wouTFkAX9XsxKY&_nc_ht=scontent.fsof11-1.fna&oh=00_AfAnmmJlKI4xXBdcIHP37T1pi5nUD2gSacAiU8UT2pTk_Q&oe=63C2C24F",
      "Петър Петров",
      60,
      "Обичам малки деца",
      ["Програмист", "Сертифиран Sex offender", "Сертифиран педофил"],
    ),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
