import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:share_delivery/src/controller/delivery_order_detail/delivery_order_controller.dart';
import 'package:share_delivery/src/controller/delivery_order_detail/delivery_payment_detail_controller.dart';
import 'package:share_delivery/src/controller/delivery_order_detail/delivery_room_info_detail_controller.dart';
import 'package:share_delivery/src/controller/login/authentication_controller.dart';
import 'package:share_delivery/src/data/model/delivery_order_detail/remittance_res_dto.dart';
import 'package:share_delivery/src/data/model/user/user/user.dart';
import 'package:share_delivery/src/routes/route.dart';
import 'package:share_delivery/src/services/delivery_room_manage_service.dart';
import 'package:share_delivery/src/ui/delivery_post/order/payment/check_remit_of_user_section.dart';
import 'package:share_delivery/src/ui/delivery_post/order/payment/payment_order_form_screen_shot.dart';
import 'package:share_delivery/src/ui/delivery_post/order/payment/total_payment_of_delivery.dart';
import 'package:share_delivery/src/ui/widgets/receiving_location.dart';

class DeliveryPaymentDetail extends GetView<DeliveryPaymentDetailController> {
  const DeliveryPaymentDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DeliveryPaymentDetailController());

    return Obx(
      () => controller.isLoad.value == true
          ? Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    RecevingLocation(),
                    PaymentOrderFormScreenShotSection(),
                    TotalPaymentOfDelivery(),
                    CheckRemitOfUserSection(),
                    SizedBox(height: 50),
                    DeliveryOrderController.to.deliveryOrderStatus.value ==
                            DeliveryRoomState.COMPLETED
                        ? ElevatedButton(
                            onPressed: () {
                              print("--- 유저 평가하기 ---");

                              List<RemittanceResDTO> remittances =
                                  controller.remittances;
                              List<int> remittanceIdList = [];

                              for (int i = 0; i < remittances.length; i++) {
                                remittanceIdList.add(remittances[i].accountId);
                              }

                              Logger().i(remittanceIdList);

                              Get.toNamed(
                                Routes.RATING_USER,
                                arguments: remittanceIdList,
                              );
                            },
                            child: Text("유저 평가하기"),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
              bottomSheet: _buildDeliveryCompleteButton(),
            )
          : Center(
              child: SpinKitThreeBounce(
                size: 25,
                color: Colors.white,
              ),
            ),
    );
  }

  Widget _buildDeliveryCompleteButton() {
    return (AuthenticationController.to.state.props.first as User).accountId ==
                controller.deliveryPaymentDetail.leader.accountId &&
            DeliveryOrderController.to.deliveryOrderStatus.value ==
                DeliveryRoomState.WAITING_DELIVERY
        ? Container(
            margin: const EdgeInsets.all(10.0),
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
              ),
              onPressed: () async {
                await DeliveryPaymentDetailController.to.completeDelivery();
                await DeliveryRoomInfoDetailController.to.getDeliveryRoomInfo();
              },
              child: Text("배달 완료"),
            ),
          )
        : SizedBox.shrink();
  }
}
