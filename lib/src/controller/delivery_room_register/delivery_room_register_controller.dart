import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_delivery/src/controller/delivery_room_register/writing_menu_controller.dart';
import 'package:share_delivery/src/controller/root_controller.dart';
import 'package:share_delivery/src/data/model/delivery_room/delivery_room/delivery_room.dart';
import 'package:share_delivery/src/data/repository/delivery_room_register/delivery_room_register_repository.dart';
import 'package:share_delivery/src/routes/route.dart';
import 'package:share_delivery/src/utils/get_snackbar.dart';
import 'package:share_delivery/src/utils/store_categories.dart';

class DeliveryRoomRegisterController extends GetxController {
  final DeliveryRoomRegisterRepository repository;
  final WritingMenuController writingMenuController;

  DeliveryRoomRegisterController(
      {required this.writingMenuController, required this.repository});

  // 모집글 등록 정보
  final TextEditingController content = TextEditingController();
  final TextEditingController storeLink = TextEditingController();
  final TextEditingController storeName = TextEditingController();
  final TextEditingController deliveryAppTypeOfStoreLink =
      TextEditingController();

  int limitPerson = -1;
  RxInt deliveryTip = 2000.obs;
  RxInt pickedStoreCategory = (-1).obs;
  ReceivingLocation? receivingLocation;

  // 모집글 등록을 위한 상세 정보
  final RxList<bool> numOfPeopleSelections = <bool>[true, false, false].obs;

  void selectNumOfPeopleSelections(int index) {
    limitPerson = index + 2;

    for (int i = 0; i < numOfPeopleSelections.length; i++) {
      if (i == index) {
        numOfPeopleSelections[i] = true;
      } else {
        numOfPeopleSelections[i] = false;
      }
    }
  }

  bool validateDeliveryRoom() {
    return content.text.trim().isNotEmpty &&
        storeLink.text.trim().isNotEmpty &&
        storeName.text.trim().isNotEmpty &&
        deliveryAppTypeOfStoreLink.text.trim().isNotEmpty &&
        pickedStoreCategory.value != -1 &&
        receivingLocation != null;
  }

  Future<void> registerDeliveryRoom() async {
    print('DeliveryRoomRegisterController.registerDeliveryRoom');

    try {
      Map<String, dynamic> deliveryRoomInfo = _getDeliveryRoomInfo();
      print(deliveryRoomInfo);

      int? deliveryRoomId =
          await repository.registerDeliveryRoom(deliveryRoomInfo);
      if (deliveryRoomId != null) {
        print("   모집글 등록 성공");
        Get.until((route) => Get.currentRoute == Routes.INITIAL);
        Get.find<RootController>().changeRootPageIndex(1);
        Get.toNamed(Routes.DELIVERY_HISTORY_DETAIL, arguments: deliveryRoomId);
      } else {
        print("   모집글 등록 실패");
        throw Exception("등록 실패");
      }
    } catch (e) {
      print(e);
      GetSnackbar.on("실패", "[TODO: 에러메시지로 대체 필요]]");
    }
  }

  Map<String, dynamic> _getDeliveryRoomInfo() {
    Map<String, dynamic> deliveryRoomInfo = {};

    deliveryRoomInfo["content"] = content.text;
    deliveryRoomInfo["receivingLocation"] = {
      "description": receivingLocation?.description,
      "lat": receivingLocation?.lat,
      "lng": receivingLocation?.lng,
    };
    deliveryRoomInfo["limitPerson"] = limitPerson;
    deliveryRoomInfo["storeCategory"] =
        foodCategories[pickedStoreCategory.value].values.first;
    deliveryRoomInfo["shareStore"] = {
      "link": storeLink.text,
      "name": storeName.text,
      "type": _getLinkPlatformType(deliveryAppTypeOfStoreLink.text),
    };

    deliveryRoomInfo["deliveryTip"] = deliveryTip.value;
    deliveryRoomInfo["menuList"] =
        writingMenuController.convertMenuInfoToMenu();

    print(
        'DeliveryRoomRegisterController._getDeliveryRoomInfo $deliveryRoomInfo');
    return deliveryRoomInfo;
  }

  String _getLinkPlatformType(String type) {
    return type == "배달의민족" ? "BAEMIN" : "YOGIYO";
  }

  void parsingStoreLink(ClipboardData? data) {
    if (data == null) {
      GetSnackbar.on("알림", "클립보드에 저장된 내용이 없습니다.");
      return;
    }
    String? clip = data.text;

    if (clip == null) {
      GetSnackbar.on("알림", "클립보드에 저장된 내용이 없습니다.");
      return;
    }

    late String appType;
    if (clip.contains("배달의민족")) {
      appType = "배달의민족";
    } else {
      appType = "요기요";
    }

    String storeName =
        clip.substring(clip.indexOf("'") + 1, clip.lastIndexOf("'"));

    late String storeLink;
    if (appType == "배달의민족") {
      storeLink = "https://dummyURL";
    } else {
      storeLink = clip.substring(clip.indexOf("http"));
    }

    this.storeLink.text = storeLink;
    this.storeName.text = storeName;
    deliveryAppTypeOfStoreLink.text = appType;
  }

  void setDeliveryTip(int deliveryTip) {
    this.deliveryTip.value = deliveryTip;
  }

  void setReceivingLocation(String description, double lat, double lng) {
    receivingLocation =
        ReceivingLocation(description: description, lat: lat, lng: lng);
    print(
        'DeliveryRoomRegisterController.setReceivingLocation $receivingLocation');
  }

  void setPickedStoreCategory(int index) {
    pickedStoreCategory.value = index;
  }

  String getPickedStoreCategory() {
    return pickedStoreCategory.value != -1
        ? foodCategories[pickedStoreCategory.value].keys.first
        : "";
  }
}
