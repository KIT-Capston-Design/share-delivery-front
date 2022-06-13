import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_delivery/src/controller/delivery_history/delivery_history_controller.dart';
import 'package:share_delivery/src/data/repository/delivery_history/delivery_history_res_dto.dart';
import 'package:share_delivery/src/routes/route.dart';
import 'package:share_delivery/src/services/setting_service.dart';
import 'package:share_delivery/src/ui/theme/text_theme.dart';

class DeliveryHistory extends GetView<DeliveryHistoryController> {
  const DeliveryHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DeliveryHistoryController());

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "내 배달",
            style: appBarTitle,
          ),
          backgroundColor: Colors.transparent,
          bottom: PreferredSize(
            child: Container(
              color: Colors.grey.shade300,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(1.0),
          ),
          elevation: 0.0,
        ),
        body: Obx(() {
          //TODO: historyPostList 정렬
          return SmartRefresher(
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            enablePullDown: true,
            child: ListView.separated(
              itemBuilder: (context, index) => DeliveryHistoryPost(
                deliveryRoomModel: controller.historyPostList[index],
              ),
              separatorBuilder: (_, index) => Divider(
                endIndent: 20,
                indent: 20,
                color: Colors.grey.shade300,
                height: 0.5,
                thickness: 1,
              ),
              itemCount: controller.historyPostList.length,
            ),
          );
        }));
  }
}

class DeliveryHistoryPost extends StatelessWidget {
  final DeliveryHistoryResDTO deliveryRoomModel;

  const DeliveryHistoryPost({
    Key? key,
    required this.deliveryRoomModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.DELIVERY_HISTORY_DETAIL,
          arguments: {'deliveryRoomId': deliveryRoomModel.roomId},
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(Hive.box('foodCategory')
                          .get(deliveryRoomModel.storeCategory.toString())),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.white,
                  ),
                ),
                Center(
                  child: _buildDeliveryRoomStatus(
                      getDeliveryRoomStateWithColor(
                              deliveryRoomModel.status.toString())
                          .name,
                      getDeliveryRoomStateWithColor(
                              deliveryRoomModel.status.toString())
                          .color),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                // color: Colors.yellow,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deliveryRoomModel.content,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      children: [
                        Text(deliveryRoomModel.receivingLocationDesc),
                        SizedBox(
                          height: 10,
                          child:
                              VerticalDivider(thickness: 1, color: Colors.grey),
                        ),
                        Text("5분전"), //TODO: date 받아오기
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.people,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                              "${deliveryRoomModel.peopleNumber} / ${deliveryRoomModel.limitPerson}")
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryRoomStatus(String status, Color color) {
    return Container(
      width: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
        ),
      ),
      child: Text(status),
    );
  }
}
