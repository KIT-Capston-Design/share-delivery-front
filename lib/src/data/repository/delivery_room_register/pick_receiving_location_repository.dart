import 'dart:convert';

import 'package:share_delivery/src/data/model/delivery_room/delivery_room/delivery_room.dart';
import 'package:share_delivery/src/utils/shared_preferences_util.dart';

class PickReceivingLocationRepository {
  List<ReceivingLocation> find() {
    List<String>? locationList =
        SharedPrefsUtil.instance.getStringList("receivingLocations");

    print("receivingLocations : $locationList");
    if (locationList == null) return [];

    List<ReceivingLocation> result = <ReceivingLocation>[];

    for (int i = 0; i < locationList.length; i++) {
      final jsonMap = jsonDecode(locationList[i]);

      result.add(ReceivingLocation.fromJson(jsonMap));
    }

    print(
        'PickReceivingLocationRepository.findReceivingLocationHistory $result');
    return result;
  }

  void register(String description, double latitude, double longitude) {
    // NOTE : 집결지 정보 데이터를 로컬에 저장하는 함수
    Map<String, dynamic> jsonMap = {
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
    };
    String jsonString = jsonEncode(jsonMap);

    List<String>? locationList =
        SharedPrefsUtil.instance.getStringList("receivingLocations");
    locationList ??= [];

    bool isApplied = false;
    for (int i = 0; i < locationList.length; i++) {
      final existingLocation = jsonDecode(locationList[i]);

      if (existingLocation["description"] == jsonMap["description"]) {
        print('PickReceivingLocationRepository.register - 기존에 있던 집결지 정보를 수정');
        locationList[i] = jsonString;
        isApplied = true;
        return;
      }
    }

    if (!isApplied) {
      print('PickReceivingLocationRepository.register - ');
      locationList.insert(0, jsonString);
    }

    SharedPrefsUtil.instance.setStringList("receivingLocations", locationList);
  }
}
