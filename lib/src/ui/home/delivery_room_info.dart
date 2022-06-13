import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_delivery/src/controller/home/home_controller.dart';
import 'package:share_delivery/src/data/model/delivery_room/delivery_room/delivery_room.dart';
import 'package:share_delivery/src/routes/route.dart';
import 'package:share_delivery/src/ui/theme/button_theme.dart';
import 'package:share_delivery/src/ui/theme/container_theme.dart';
import 'package:share_delivery/src/ui/theme/text_theme.dart';
import 'package:share_delivery/src/ui/widgets/show_specific_spot.dart';
import 'package:share_delivery/src/utils/categories.dart';
import 'package:share_delivery/src/utils/time_util.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryRoomInfo extends GetView<HomeController> {
  const DeliveryRoomInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: roomInfo(),
          ),
        ),
        bottomSheet: joinButton(),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      elevation: 0,
      shape: const Border(bottom: BorderSide(color: Colors.black12, width: 1)),
      backgroundColor: Colors.white,
      title: Text(
        "모집글 상세보기",
        style: appBarTitle,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      // actions: [
      //   IconButton(
      //     icon: Icon(Icons.share, color: Colors.black),
      //     onPressed: () async {
      //       print('DeliveryRoomInfo.appBar - share');
      //       final result = await Share.shareWithResult("www.naver.com");
      //
      //       print(result.status);
      //     },
      //   ),
      //   IconButton(
      //     icon: Icon(Icons.more_vert, color: Colors.black),
      //     onPressed: () {},
      //   ),
      // ],
    );
  }

  Widget roomInfo() {
    DeliveryRoom deliveryRoom = controller.getDeliveryRoomInfo();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: Get.height * 0.2,
          padding: const EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: Get.height >= 700 ? 20 : 10),
          decoration: neumorphism,
          alignment: Alignment.topLeft,
          child: Stack(
            children: [
              Text(
                deliveryRoom.content,
                style: Get.height >= 700 ? titleTextStyle : smallTitleTextStyle,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width * 0.4,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          deliveryRoom.storeName,
                          style: postStoreName,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          foodCategories
                              .firstWhere((element) =>
                                  element.eng == deliveryRoom.storeCategory)
                              .kor,
                          style: postDetailStyle,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.fiber_manual_record,
                            size: 3,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          TimeUtil.timeAgo(deliveryRoom.createdDateTime),
                          style: postDetailStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: Get.height >= 700 ? 20 : 10),
          decoration: neumorphism,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "방장",
                    style:
                        Get.height >= 700 ? infoTextStyle : smallInfoTextStyle,
                  ),
                  Text(
                    deliveryRoom.leader.nickname,
                    style:
                        Get.height >= 700 ? infoTextStyle : smallInfoTextStyle,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "매너 온도",
                    style:
                        Get.height >= 700 ? infoTextStyle : smallInfoTextStyle,
                  ),
                  Text(
                    "${deliveryRoom.leader.mannerScore}",
                    style:
                        Get.height >= 700 ? infoTextStyle : smallInfoTextStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: Get.height >= 700 ? 20 : 10),
          decoration: neumorphism,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "참여 인원",
                    style:
                        Get.height >= 700 ? infoTextStyle : smallInfoTextStyle,
                  ),
                  Text(
                    deliveryRoom.person.toString() +
                        " / " +
                        deliveryRoom.limitPerson.toString(),
                    style:
                        Get.height >= 700 ? infoTextStyle : smallInfoTextStyle,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "예상 배달비",
                    style:
                        Get.height >= 700 ? infoTextStyle : smallInfoTextStyle,
                  ),
                  Text(
                    "${deliveryRoom.deliveryTip}",
                    style:
                        Get.height >= 700 ? infoTextStyle : smallInfoTextStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
        Center(
          child: Column(
            children: [
              ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "음식점 보러가기",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Icon(Icons.east),
                    Text(
                      deliveryRoom.platformType == "BAEMIN" ? "배민" : "요기요",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  primary: deliveryRoom.platformType == "BAEMIN"
                      ? Color.fromRGBO(42, 193, 188, 1)
                      : Color.fromRGBO(249, 0, 80, 1), // NOTE: 요기요 색깔
                  textStyle: const TextStyle(fontSize: 17),
                  elevation: 0,
                  fixedSize: Size(Get.width * 0.7, Get.height * 0.05),
                ),
                onPressed: () async {
                  String deepLink = deliveryRoom.storeLink;
                  final url = Uri.parse(deepLink);
                  if (await canLaunchUrl(url)) {
                    launchUrl(
                      url,
                      mode: LaunchMode.externalNonBrowserApplication,
                    );
                  }
                },
              ),
              OutlinedButton(
                child: Text(
                  "집결지 보기",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  primary: Colors.black,
                  textStyle: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600),
                  elevation: 0,
                  backgroundColor: Colors.white,
                  fixedSize: Size(Get.width * 0.7, Get.height * 0.05),
                ),
                onPressed: () {
                  // TODO : 집결지 보여주는 기능 필요
                  Get.bottomSheet(
                    ShowSpecificSpot(spot: deliveryRoom.receivingLocation),
                    isScrollControlled: true,
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
        ),
      ],
    );
  }

  Widget joinButton() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black12, width: 1),
        ),
      ),
      height: 70,
      width: double.infinity,
      child: Center(
        child: ElevatedButton(
          child: const Text(
            "지금 참여하기",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          style: orangeBtn,
          onPressed: () {
            // TODO : 모집글 참여 로직 필요
            Get.toNamed(
              Routes.PARTICIPATE_ROOM,
              arguments: controller.getDeliveryRoomInfo(),
            );
          },
        ),
      ),
    );
  }
}
