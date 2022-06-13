import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:share_delivery/src/controller/root_controller.dart';
import 'package:share_delivery/src/data/repository/profile/app_setting/app_setting_repository.dart';
import 'package:share_delivery/src/routes/route.dart';
import 'package:share_delivery/src/ui/theme/button_theme.dart';
import 'package:share_delivery/src/utils/shared_preferences_util.dart';

class AppSettingController extends GetxController {
  AppSettingRepository repository;

  AppSettingController({required this.repository});

  // 로그아웃
  Future<void> logout() async {
    bool isConfirmed = await confirmMessage("정말 로그아웃 하시겠습니까?", "로그아웃");
    print("로그아웃 -  $isConfirmed");

    if (isConfirmed) {
      // repository.logout();
      SharedPrefsUtil.instance.clear();
      // TODO: Hive clear 와 관련해서 진우한테 물어보기

      Get.context!.loaderOverlay.show();
      await 0.5.delay();
      Get.context!.loaderOverlay.hide();
      Get.offAllNamed(Routes.LOGIN);
      RootController.to.isFirstOpenCommunity.value = true;
    }
  }

  // 회원 탈퇴
  Future<void> withdraw() async {
    bool isConfirmed =
        await confirmMessage("정말 탈퇴하시겠습니까?\n모든 이용 기록이 삭제됩니다.", "  탈퇴  ");
    print("회원탈퇴 - $isConfirmed");

    if (isConfirmed) {
      await repository.withdrawUser();
      SharedPrefsUtil.instance.clear();

      Get.context!.loaderOverlay.show();
      await 0.5.delay();
      Get.context!.loaderOverlay.hide();
      Get.offAllNamed(Routes.LOGIN);
      RootController.to.isFirstOpenCommunity.value = true;
    }
  }

  // 확인 메시지
  Future<bool> confirmMessage(String content, [String? confirmMessage]) async {
    late bool isConfirmed;

    await Get.dialog(
      AlertDialog(
        content: Text(content),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: Text("  취소  "),
            style: cancelBtn,
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: Text(confirmMessage ??= "  삭제  "),
            style: deleteBtn,
          ),
        ],
      ),
    ).then((value) => isConfirmed = value);

    return isConfirmed;
  }
}
