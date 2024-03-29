import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_delivery/src/data/model/delivery_room/delivery_room/delivery_room.dart';
import 'package:share_delivery/src/data/model/user/user_location/user_location.dart';
import 'package:share_delivery/src/data/repository/home/home_repository.dart';
import 'package:share_delivery/src/utils/get_snackbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final HomeRepository repository;

  HomeController({required this.repository});

  var deliveryRooms = <DeliveryRoom>[
    // DeliveryRoom(
    //   leader: Leader(nickname: "종달새 1호", mannerScore: 36.7, accountId: 2),
    //   content: "BBQ 드실분?",
    //   person: 1,
    //   limitPerson: 3,
    //   deliveryTip: 3000,
    //   storeLink: "www.baemin.com/stores?id=1524",
    //   platformType: "BAEMIN",
    //   status: "OPEN",
    //   createdDateTime: DateTime.now().subtract(Duration(minutes: 7)),
    //   receivingLocation: ReceivingLocation(
    //       description: "CU 편의점 앞",
    //       latitude: 35.820848788632226,
    //       longitude: 128.518205019348),
    //   roomId: 456,
    //   storeCategory: 'CHICKEN',
    // ),
  ].obs;

  // UI 관련
  RefreshController refresher = RefreshController(initialRefresh: true);
  RxInt idxCurInfo = (-1).obs;

  // 사용자 위치 관련
  final Location location = Location();
  Rx<LocationData> locationData = LocationData.fromMap({"isMock": true}).obs;
  final RxBool _serviceEnabled = false.obs;

  // 웹뷰 관련
  Rx<Completer<WebViewController>> webViewController =
      Completer<WebViewController>().obs;
  Rx<Completer<WebViewController>> webViewController2 =
      Completer<WebViewController>().obs;
  RxBool isPrepared = false.obs;
  RxBool showInfo = false.obs;

  // 모집글 상세 정보 관련
  int curSelectedIdx = -1;

  // 사용자 위치 불러오기
  Future<void> getUserLocation() async {
    UserLocation? userLocation = repository.findRecentUserLocation();

    if (userLocation != null) {
      locationData.value = LocationData.fromMap({
        "latitude": userLocation.latitude,
        "longitude": userLocation.longitude,
      });
    } else {
      bool isPermitted = await verifyLocationPermission();
      if (!isPermitted) {
        GetSnackbar.on("알림", "위치 정보를 허용해주세요.");
        return;
      }
    }

    LocationData curLocation = await location.getLocation();
    print('HomeController.getUserLocation $curLocation');

    locationData.value = curLocation;
    repository.saveUserLocation(
      "현재 위치",
      locationData.value.latitude!,
      locationData.value.longitude!,
    );

    isPrepared.value = true;
  }

  // 위치 정보 엑세스 권한 검증
  Future<bool> verifyLocationPermission() async {
    print('HomeController.verifyLocationPermission1');
    PermissionStatus _permissionGranted;
    _serviceEnabled.value = await location.serviceEnabled();

    print('HomeController.verifyLocationPermission2');
    if (!_serviceEnabled.value) {
      _serviceEnabled.value = await location.requestService();
      if (!_serviceEnabled.value) {
        return false;
      }
    }

    print('HomeController.verifyLocationPermission3');
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    print('HomeController.verifyLocationPermission4');
    return true;
  }

  // 모집글 새로고침
  Future<void> onRefresh() async {
    if (!isPrepared.value) {
      await getUserLocation();
      if (!isPrepared.value) {
        refresher.refreshFailed();
        GetSnackbar.on("알림", "위치 설정을 먼저 해주세요!");
        return;
      }
    }

    try {
      double? latitude = locationData.value.latitude;
      double? longitude = locationData.value.longitude;
      int radius = 5;

      List<DeliveryRoom> result =
          await repository.findDeliveryRooms(latitude!, longitude!, radius);

      if (result.isEmpty) {
        refresher.refreshFailed();
        GetSnackbar.on("알림", "검색된 모집글이 없습니다!");
        return;
      }

      deliveryRooms.value = result;

      refresher.resetNoData();
      refresher.refreshCompleted();
    } catch (e) {
      print(e);
      refresher.refreshFailed();
    }
  }

  // 모집글 불러오기
  Future<void> onLoading() async {
    await getUserLocation();

    if (!isPrepared.value) {
      refresher.loadFailed();
      GetSnackbar.on("알림", "위치 설정을 먼저 해주세요!");
      return;
    }

    try {
      var result = [];
      // TODO : 임시로 해둠 = 삭제할 것
      // TODO : 테스트할 때 키기
      // List<Post> result = await repository.loadingPost(
      //     userLocation!, posts.last.createdDateTime);

      if (result.isEmpty) {
        refresher.loadNoData();
        GetSnackbar.on("알림", "검색된 모집글이 없습니다!");
        return;
      }

      refresher.loadComplete();
    } catch (e) {
      print(e);
      refresher.loadFailed();
    }
  }

  // Future<List<DeliveryRoom>> findDeliveryRooms() async {
  //
  //   return result;
  // }

  // 카카오 지도 JS API 로 지도 띄우기
  String getHTML() {
    return Uri.dataFromString('''
      <html>
      <head>
        <meta name='viewport' content='width=device-width, initial-scale=1.0, user-scalable=yes\'>
        <script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?autoload=true&appkey=${dotenv.env['KAKAO_MAP_KEY']!}&libraries=services"></script>
      </head>
      <body style="padding:0; margin:0;">
        <div id="map" style="width:100%;height:100%;"></div>
        <script>

          var container = document.getElementById('map'); // map for div

          var options = {
            center: new kakao.maps.LatLng(${locationData.value.latitude}, ${locationData.value.longitude}), // center of map (current position)
            level: 3 // level of map
          };

          // create map
          var map = new kakao.maps.Map(container, options);
          
          // create marker
          var markerPosition  = new kakao.maps.LatLng(${locationData.value.latitude}, ${locationData.value.longitude});
          var marker = new kakao.maps.Marker({
              position: markerPosition
          });
          
          marker.setMap(map);
          
          ${getDeliveryRoomHTML()}
          
          kakao.maps.event.addListener(map, 'idle', function() {
                        
              var latlng = map.getCenter();
              
              var centerLatLng = {
                lat: latlng.getLat(),
                lng: latlng.getLng()
              }
              
              onIdle.postMessage(JSON.stringify(centerLatLng));
          });

          function onClickListener(i) {
          
              var markerInfo = {
                // lat: latlng.getLat(),
                // lng: latlng.getLng(),
                index: i
              }
              
              onClick.postMessage(JSON.stringify(markerInfo));
          }

        </script>
      </body>
      </html>
    ''', mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();
  }

  // 모집글 마커 표시하기 위한 JS API
  String getDeliveryRoomHTML() {
    String positions = "";
    for (DeliveryRoom room in deliveryRooms) {
      positions +=
          "new kakao.maps.LatLng(${room.receivingLocation.latitude}, ${room.receivingLocation.longitude}),";
    }

    return '''
        var positions = [
          $positions
        ];
    
        var imageSrc = "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png"; 
            
        for (let i = 0; i < positions.length; i++) {
            
            var imageSize = new kakao.maps.Size(29, 40); 
            
            var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); 
            
            var marker = new kakao.maps.Marker({
                map: map,
                position: positions[i],
                clickable: true,
                image : markerImage
            });
            let index = i;
            // kakao.maps.event.addListener(marker, 'click', onClickListener(i));
            kakao.maps.event.addListener(marker, 'click', function() {
              onClick.postMessage(index);
            });
        }
    ''';
  }

  // WebView JS Listener
  Set<JavascriptChannel>? get getChannels {
    Set<JavascriptChannel>? channels = {};

    channels.add(JavascriptChannel(
        name: 'onIdle',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        }));

    channels.add(JavascriptChannel(
        name: 'onClick',
        onMessageReceived: (JavascriptMessage message) {
          print("onClick");
          showInfo.value = true;
          idxCurInfo.value = int.parse(message.message);
          print("showinfo $showInfo");
          print(message.message);
        }));

    if (channels.isEmpty) {
      return null;
    } else {
      return channels;
    }
  }

  void setWebViewController(WebViewController webViewController) {
    this.webViewController.value.complete(webViewController);
  }

  void setWebViewController2(WebViewController webViewController2) {
    this.webViewController2.value.complete(webViewController2);
  }

  void reloadWebView() {
    webViewController.value.future.then((value) async {
      await getUserLocation();
      value.loadUrl(getHTML());
    });
  }

  void hideInfo() {
    showInfo.value = false;
  }

  void setCurSelectedIdx(int index) {
    curSelectedIdx = index;
  }

  DeliveryRoom getDeliveryRoomInfo() {
    if (curSelectedIdx == -1) throw Exception("out of range");

    return deliveryRooms[curSelectedIdx];
  }

  int distanceBetween(ReceivingLocation receivingLocation) {
    if (locationData.value.latitude == null ||
        locationData.value.latitude == null) return -1;

    return Geolocator.distanceBetween(
      locationData.value.latitude!,
      locationData.value.longitude!,
      receivingLocation.latitude,
      receivingLocation.longitude,
    ).round();
  }
}
