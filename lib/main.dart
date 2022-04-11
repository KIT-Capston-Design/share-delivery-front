import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_delivery/src/controller/root_controller.dart';
import 'package:share_delivery/src/root.dart';
import 'package:share_delivery/src/ui/explore/explore_detail_page.dart';
import 'package:share_delivery/src/ui/home/delivery_room_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialBinding: BindingsBuilder(() {
        Get.put(RootController());
      }),
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(231, 129, 17, 1),
        ),
      ),
      home: const Root(),
      getPages: [
        GetPage(
          name: '/deliveryRoomDetail',
          page: () => const DeliveryRoomDetail(),
        ),
        GetPage(
          name: '/exploreDetailPage',
          page: () => const ExploreDetailPage(),
        ),
      ],
    );
  }
}
