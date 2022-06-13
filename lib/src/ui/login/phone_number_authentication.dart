import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:share_delivery/src/controller/login/login_controller.dart';
import 'package:share_delivery/src/ui/login/phone_number_text_field.dart';
import 'package:share_delivery/src/ui/widgets/loader_overlay.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneNumberAuthentication extends GetView<LoginController> {
  const PhoneNumberAuthentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: MyLoaderOverlay(
          appBar: appBar(),
          body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
              controller: controller.scrollController.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.lock_outlined, size: 100),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "휴대폰 가입으로 이용해주세요.\n번호는 물론 안전하게 보관 됩니다.",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PhoneNumberTextField(),
                  ElevatedButton(
                    child: Text(
                      controller.onTextFieldSMS.value
                          ? "인증문자 다시 받기"
                          : "인증문자 받기",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      textStyle: const TextStyle(fontSize: 20),
                      elevation: 0,
                      fixedSize: Size(Get.width * 0.9, Get.height * 0.06),
                    ),
                    onPressed: controller.isEnabledRequestSMSButton.value
                        ? () => controller.requestAuthSMS()
                        : null,
                  ),
                  controller.onTextFieldSMS.value
                      ? authInputForm(context)
                      : SizedBox.shrink(),
                  SizedBox(height: Get.height < 700 ? 400 : 500),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget authInputForm(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            width: Get.width * 0.9,
            height: Get.height * 0.07,
            child: TextFieldPinAutoFill(
              currentCode: controller.authNumber,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 15.0),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
                hintText: "인증번호 입력",
                counterText: "",
              ),
              onCodeChanged: (code) {
                controller.setIsEnabledVerifyButton(code.isNotEmpty);
                controller.setAuthNumber(code);
              },
            ),
          ),
          ElevatedButton(
            child: Text(
              "인증번호 확인",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              textStyle: const TextStyle(fontSize: 20),
              elevation: 0,
              fixedSize: Size(Get.width * 0.9, Get.height * 0.06),
            ),
            onPressed: controller.isEnabledVerifyButton.value
                ? () async {
                    context.loaderOverlay.show();
                    await controller.authenticate();
                    context.loaderOverlay.hide();
                  }
                : null,
          )
        ],
      ),
    );
  }

  Widget findAccountUsingEmail() {
    return Container(
      padding: const EdgeInsets.all(10),
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "이미 계정이 있나요? ",
            style: TextStyle(color: Colors.black87),
          ),
          TextButton(
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text("추가 예정입니다."),
                  actions: [
                    TextButton(
                      child: const Text("닫기"),
                      onPressed: () => Get.back(),
                    )
                  ],
                ),
              );
            },
            child: const Text(
              "이메일로 계정 찾기",
              style:
                  TextStyle(fontWeight: FontWeight.w800, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      shape: const Border(
        bottom: BorderSide(color: Colors.black12, width: 1),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      title: const Text("휴대폰 번호 인증", style: TextStyle(color: Colors.black)),
    );
  }
}
