import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:share_delivery/src/controller/login/authentication_controller.dart';
import 'package:share_delivery/src/data/model/chat/chat.dart';
import 'package:share_delivery/src/data/model/user/user/user.dart';
import 'package:socket_io_client/socket_io_client.dart';

class FastMatchingChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final messages = [].obs;

  User user = AuthenticationController.to.state.props.first as User;
  Socket? socket;
  int? deliveryRoomId;

  @override
  Future<void> onInit() async {
    super.onInit();
    // deliveryRoomId = Get.arguments['deliveryRoomId'];
    await socketInit();
  }

  Future<void> socketInit() async {
    try {
      String hostName = dotenv.get('CHAT_SERVER_HOST');
      print(
          'FastMatchingChatController.socketInit - ${dotenv.get('CHAT_SERVER_HOST')}');
      // TODO: jwt token
      // String jwtToken = SharedPrefsUtil.instance.getString('accessToken');
      String jwtToken =
          "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NvdW50SWQiOjEsInBob25lTnVtYmVyIjoiMDEwMDAwMDAwMDEiLCJyb2xlIjoiUk9MRV9VU0VSIiwiaXNzIjoia2l0Y2Quc2hhcmUtZGVsaXZlcnkiLCJleHAiOjE2NTY1MDI0Mjd9.gzW_MYwJfzErl0kpj0G5zao5ZPdGOUYCoStt91jF_q4";

      socket = io(
        hostName,
        OptionBuilder()
            .setTransports(['websocket'])
            // .setQuery({'token': jwtToken})
            .disableAutoConnect()
            .build(),
      );

      print('FastMatchingChatController.socketInit - 1');
      socket!.connect();

      socket!.onConnect((data) => print("connected"));

      // socket!.on('connect', (data) {
      //   Logger().i('socket connected', hostName);
      //
      //   // 소켓 연결 후 방 참여
      //   // enterRoom(deliveryRoomId);
      // });

      socket!.on("connect_Error", (data) => print(data));

      socket!.on('message', (data) {
        final message = ChatModel.fromJson(data);
        messages.add(message);
      });

      socket!.onDisconnect((_) => Logger().d('disconnect'));
    } catch (e) {
      print(e);
    }
    super.onInit();
  }

  // void enterRoom(int deliveryRoomId) {
  //   socket!.emit('enter_room', {"payload": deliveryRoomId},
  //       ack: (Map<String, dynamic> data) {
  //     if (!data['isSuccess']) Logger().w("data is null");
  //
  //     for (var chat in data['messageList']) {
  //       messages.add(ChatModel.fromJson(chat));
  //     }
  //   });
  // }

  @override
  void onClose() {
    // socket disconnect

    Logger().w("disconnect socket");
    socket!.emit('disconnect', deliveryRoomId);
    socket!.disconnect();
    super.onClose();
  }
}
