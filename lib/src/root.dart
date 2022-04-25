import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_delivery/src/controller/root_controller.dart';
import 'package:share_delivery/src/routes/route.dart';
import 'package:share_delivery/src/ui/community/community.dart';
import 'package:share_delivery/src/ui/home/home.dart';
import 'package:share_delivery/src/ui/my_delivery/my_delivery.dart';
import 'package:share_delivery/src/ui/profile/profile.dart';

class Root extends GetView<RootController> {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          shape: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: controller.rootPageIndex.value == 0
              ? TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.PICK_USER_LOCATION);
                  },
                  child: Text(
                    "위치 설정",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                )
              : SizedBox.shrink(),
          leadingWidth: 80,
          title: const Text(
            "딜리버리버리",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: IndexedStack(
          index: controller.rootPageIndex.value,
          children: const [
            Home(),
            MyDelivery(),
            Community(),
            Profile(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.rootPageIndex.value,
          onTap: controller.changeRootPageIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "홈",
              activeIcon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delivery_dining_outlined),
              label: "내 배달",
              activeIcon: Icon(Icons.delivery_dining),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.feed_outlined),
              label: "생활공유",
              activeIcon: Icon(Icons.feed),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: "프로필",
              activeIcon: Icon(Icons.person),
            ),
          ],
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12.0,
          unselectedFontSize: 12.0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
        floatingActionButton: controller.rootPageIndex.value == 0
            ? FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () {
                  Get.toNamed(Routes.DELIVERY_ROOM_REGISTER);
                  // Get.toNamed(Routes.DELIVERY_ROOM_REGISTER);
                },
                child: const Icon(Icons.add_rounded, size: 40),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
