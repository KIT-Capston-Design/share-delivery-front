import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:share_delivery/src/controller/delivery_order_detail/delivery_order_controller.dart';
import 'package:share_delivery/src/controller/delivery_order_detail/delivery_recruit_controller.dart';
import 'package:share_delivery/src/controller/delivery_order_detail/delivery_room_info_detail_controller.dart';
import 'package:share_delivery/src/controller/login/authentication_controller.dart';
import 'package:share_delivery/src/data/model/user/user/user.dart';
import 'package:share_delivery/src/services/delivery_room_manage_service.dart';
import 'package:share_delivery/src/ui/delivery_post/order/recruit/total_of_orders.dart';
import 'package:share_delivery/src/ui/delivery_post/widget/user_order.dart';

class DeliveryRecruit extends GetView<DeliveryRecruitController> {
  const DeliveryRecruit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int leaderId =
        DeliveryRoomInfoDetailController.to.deliveryRoom.leader.accountId;
    User user = AuthenticationController.to.state.props.first as User;

    return controller.obx(
      (userWithOrderList) => Scaffold(
        body: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                ...userWithOrderList!
                    .map((e) => UserOrder(
                          orderMenuModel: e,
                        ))
                    .toList(),
                _buildPaymentOfOrders(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: leaderId == user.accountId
            ? _buildCheckComplitedButton()
            : SizedBox.shrink(),
      ),
      onLoading: Center(child: CircularProgressIndicator()),
      onError: (error) {
        return Center(
          child: Text(
            'Error: $error',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildPaymentOfOrders() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TotalOfOrders(),
    );
  }

  Widget _buildCheckComplitedButton() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.orange,
        ),
        onPressed: () async {
          if (DeliveryRecruitController.to.orderMenuList.length == 1) {
            Get.snackbar('오류', '혼자서 주문을 진행할 수 없습니다.',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM);
          }
          await DeliveryRecruitController.to.completeRecurit();
          await DeliveryOrderController.to
              .changeStatus(DeliveryRoomState.WAITING_PAYMENT);
          // await DeliveryManageController.to.changeStatus(
          //   describeEnum(DeliveryRoomState.WAITING_PAYMENT),
          // );
        },
        child: Text("주문 진행 확인"),
      ),
    );
  }
}
