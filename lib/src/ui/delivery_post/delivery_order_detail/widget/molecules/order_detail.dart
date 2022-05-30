import 'package:flutter/material.dart';
import 'package:share_delivery/src/controller/delivery_order_detail/delivery_room_info_detail_controller.dart';
import 'package:share_delivery/src/data/model/delivery_order_detail/order_menu_model.dart';
import 'package:share_delivery/src/ui/delivery_post/delivery_order_detail/widget/atoms/element_with_money.dart';
import 'package:share_delivery/src/ui/delivery_post/delivery_order_detail/widget/atoms/user_with_date.dart';
import 'package:share_delivery/src/ui/theme/text_theme.dart';
import 'package:share_delivery/src/utils/time_util.dart';

class OrderDetail extends StatelessWidget {
  final OrderMenuModel userWithOrderModel;

  const OrderDetail({Key? key, required this.userWithOrderModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int leaderId =
        DeliveryRoomInfoDetailController.to.deliveryRoom.value.leader.accountId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.person),
              ),
              userWithOrderModel.accountId == leaderId
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        "주도자",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              UserWithDate(
                user: userWithOrderModel.phoneNumber + " 님",
                date: TimeUtil.timeAgo(
                    userWithOrderModel.createdDateTime.toLocal()),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: _buildDiscountWidget(),
        )
      ],
    );
  }

  Widget _buildDiscountWidget() {
    return Text("hello");
    // List<ElementWithMoney> discountList = [];

    // userWithOrderModel.menuList.forEach((key, value) {
    //   discountList.add(
    //     ElementWithMoney(
    //       elementName: key,
    //       money: value.toString(),
    //       axisAlignment: MainAxisAlignment.start,
    //       textStyle: paymentTextStyle,
    //     ),
    //   );
    // });

    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: discountList,
    // );
  }
}
