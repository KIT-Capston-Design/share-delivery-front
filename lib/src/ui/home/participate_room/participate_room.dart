import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:share_delivery/src/controller/home/participate_room/participate_room_controller.dart';
import 'package:share_delivery/src/ui/theme/text_theme.dart';
import 'package:share_delivery/src/ui/widgets/loader_overlay.dart';

class ParticipateRoom extends GetView<ParticipateRoomController> {
  const ParticipateRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: MyLoaderOverlay(
          appBar: appBar(context),
          body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("주문할 메뉴를 입력하세요!", style: infoTextStyle),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: controller.menuList.length,
                    itemBuilder: (_, idx) => menuInfo(idx),
                    separatorBuilder: (_, __) => Divider(height: 0),
                  ),
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        print("add menu");
                        controller.addMenu();
                      },
                      icon: Icon(Icons.add_circle),
                      label: Text("메뉴 추가"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      shape: const Border(bottom: BorderSide(color: Colors.black12, width: 1)),
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
      ),
      title: const Text(
        "참여하기",
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            context.loaderOverlay.show();
            await controller.participateDeliveryRoom(Get.arguments);
            context.loaderOverlay.hide();
          },
          child: const Text("신청", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Widget menuInfo(int idx) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          controller.menuList[idx].parent != -1
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.subdirectory_arrow_right_rounded),
                )
              : SizedBox.shrink(),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      color: Colors.white,
                      width: Get.width * 0.45,
                      height: Get.height * 0.08,
                      child: TextField(
                        controller: controller.menuList[idx].name,
                        maxLength: 20,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10.0),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: "이름",
                          counterText: "",
                        ),
                        style: Get.width < 400 ? TextStyle(fontSize: 14) : null,
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: Get.width * 0.20,
                      height: Get.height * 0.08,
                      child: TextField(
                        controller: controller.menuList[idx].price,
                        keyboardType: TextInputType.number,
                        maxLength: 7,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10.0),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: "가격",
                          counterText: "",
                        ),
                        style: Get.width < 400 ? TextStyle(fontSize: 14) : null,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => controller.decreaseAmount(idx),
                      icon: Icon(Icons.remove_rounded),
                    ),
                    GetBuilder<ParticipateRoomController>(
                      builder: (ctrl) =>
                          Text("${ctrl.menuList[idx].quantity}개"),
                    ),
                    IconButton(
                      onPressed: () => controller.increaseAmount(idx),
                      icon: Icon(Icons.add_rounded),
                    ),
                    controller.menuList[idx].parent == -1
                        ? Expanded(
                            child: Center(
                              child: TextButton.icon(
                                onPressed: () => controller
                                    .addOption(controller.menuList[idx].seq),
                                icon: Icon(Icons.add_circle),
                                label: Text("옵션 넣기"),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => controller.removeMenu(idx),
            icon: Icon(Icons.remove_circle, size: 30, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
