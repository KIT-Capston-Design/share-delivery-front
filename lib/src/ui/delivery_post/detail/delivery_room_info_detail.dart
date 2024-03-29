import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:share_delivery/src/controller/delivery_order_detail/delivery_room_info_detail_controller.dart';
import 'package:share_delivery/src/ui/widgets/receiving_location.dart';

class DeliveryRoomInfoDetail extends StatelessWidget {
  const DeliveryRoomInfoDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeliveryRoomInfoDetailController controller =
        DeliveryRoomInfoDetailController.to;

    return Obx(
      () => controller.isLoad.value == true
          ? Container(
              height: double.infinity,
              color: Colors.grey.shade100,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        height: Get.height * 0.2,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.topLeft,
                        child: Text(
                          controller.deliveryRoom.content,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "방장",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  controller.deliveryRoom.leader.nickname,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "매너 온도",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  controller.deliveryRoom.leader.mannerScore
                                      .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "참여 인원",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  (controller.deliveryRoom.person).toString() +
                                      " / " +
                                      controller.deliveryRoom.limitPerson
                                          .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    RecevingLocation(),
                    SizedBox(
                      height: 10,
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
                                  controller.deliveryRoom.platformType ==
                                          "BAEMIN"
                                      ? "배민"
                                      : "요기요",
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: controller.deliveryRoom.platformType ==
                                      "BAEMIN"
                                  ? Color.fromRGBO(42, 193, 188, 1)
                                  : Color.fromRGBO(
                                      249, 0, 80, 1), // NOTE: 요기요 색깔
                              textStyle: const TextStyle(fontSize: 17),
                              elevation: 0,
                              fixedSize:
                                  Size(Get.width * 0.7, Get.height * 0.05),
                            ),
                            onPressed: () {
                              // TODO : 모집글 참여 로직 필요
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: SpinKitThreeBounce(
                size: 25,
                color: Colors.black,
              ),
            ),
    );
  }
}
