import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:share_delivery/src/controller/delivery_room_register/delivery_room_register_controller.dart';
import 'package:share_delivery/src/controller/delivery_room_register/writing_menu_controller.dart';
import 'package:share_delivery/src/data/provider/delivery_room_register/delivery_room_register_api_client.dart';
import 'package:share_delivery/src/data/repository/delivery_room_register/delivery_room_register_repository.dart';
import 'package:share_delivery/src/utils/dio_util.dart';

class DeliveryRoomRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WritingMenuController());

    Dio dio = DioUtil.getDio();
    final String host = dotenv.get('SERVER_HOST');

    Get.put(
      DeliveryRoomRegisterController(
        writingMenuController: Get.find<WritingMenuController>(),
        repository: DeliveryRoomRegisterRepository(
          apiClient: DeliveryRoomRegisterApiClient(dio, baseUrl: host),
        ),
      ),
    );
  }
}
