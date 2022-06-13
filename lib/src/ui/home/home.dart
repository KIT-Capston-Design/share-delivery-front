import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_delivery/src/controller/home/home_controller.dart';
import 'package:share_delivery/src/data/provider/home/home_api_client/home_api_client.dart';
import 'package:share_delivery/src/data/provider/home/home_local_client.dart';
import 'package:share_delivery/src/data/provider/widgets/user_location_local_client.dart';
import 'package:share_delivery/src/data/repository/home/home_repository.dart';
import 'package:share_delivery/src/routes/route.dart';
import 'package:share_delivery/src/ui/home/delivery_room_list.dart';
import 'package:share_delivery/src/ui/home/delivery_room_on_map.dart';
import 'package:share_delivery/src/utils/dio_util.dart';

class Home extends GetView<HomeController> {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(
      HomeController(
        repository: HomeRepository(
          apiClient: HomeApiClient(DioUtil.getDio()),
          localClient: HomeLocalClient(),
          userLocationLocalClient: UserLocationLocalClient(),
        ),
      ),
    );

    return Scaffold(
      appBar: appBar(),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: const [
            TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              labelPadding: EdgeInsets.all(8),
              indicatorColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Icon(Icons.list),
                Icon(Icons.map_outlined),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [DeliveryRoomList(), DeliveryRoomOnMap()],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: fab(),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      shape: const Border(
        bottom: BorderSide(
          color: Colors.black26,
          width: 0.5,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      titleSpacing: 0.0,
      title: Row(
        children: [
          TextButton(
            onPressed: () => Get.toNamed(Routes.PICK_USER_LOCATION),
            child: const Text(
              "위치 설정",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            color: Colors.black,
            height: 20,
            width: 1,
          ),
          TextButton(
            onPressed: () => Get.toNamed(Routes.FAST_MATCHING),
            child: const Text(
              "빠른 매칭",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget fab() {
    return FloatingActionButton(
      heroTag: "deliveryRoomRegisterFAB",
      backgroundColor: Colors.orange,
      onPressed: () {
        Get.toNamed(Routes.DELIVERY_ROOM_REGISTER);
      },
      child: const Icon(Icons.add_rounded, size: 40),
    );
  }
}
