import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:share_delivery/src/controller/login/authentication_controller.dart';
import 'package:share_delivery/src/routes/route.dart';
import 'package:share_delivery/src/ui/login/state/authentication_state.dart';
import 'package:share_delivery/src/ui/login/state/login_state.dart';
import 'package:share_delivery/src/utils/GetSnackbar.dart';

class LoginController extends GetxController {
  final AuthenticationController _authenticationController = Get.find();

  final _loginStateStream = LoginState().obs;

  LoginState get state => _loginStateStream.value;

  String phoneNumber = "";
  String authNumber = "";
  RxBool isEnabledSendRequest = true.obs;
  RxBool isEnabledRequestSMSButton = false.obs;
  RxBool isEnabledVerifyButton = false.obs;
  RxBool onTextFieldSMS = false.obs;
  bool isNewUser = false;

  Rx<ScrollController> scrollController = ScrollController().obs;

  void requestAuthSMS() {
    if (isEnabledSendRequest.value) {
      isEnabledSendRequest.value = false;

      GetSnackbar.on("요청 성공", "인증번호가 문자로 전송됐습니다.");
      requestAuthSMS2Controller();
      changeToAuthUI();
    } else {
      GetSnackbar.err("요청 실패", "10초 이내에는 인증번호를 요청할 수 없습니다.");
    }

    FocusManager.instance.primaryFocus?.unfocus();
  }

  // 인증 SMS 요청하기
  void requestAuthSMS2Controller() async {
    onTextFieldSMS.value = true;

    String result = await _authenticationController.requestAuthSMS(phoneNumber);

    if (result == "ERROR") {
      print("ERROR");
      GetSnackbar.err("요청 에러", "다시 클릭해주세요.");
    } else {
      if (result == "SIGNUP") {
        isNewUser = true;
      } else if (result == "LOGIN") {
        isNewUser = false;
      }

      onTextFieldSMS.value = true;
    }
  }

  void changeToAuthUI() {
    scrollController.value.animateTo(
      Get.height * 0.23,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    Timer(Duration(seconds: 10), () {
      try {
        isEnabledSendRequest.value = true;
      } catch (e) {
        print("NOT FOUND CONTROLLER");
      }
    });
  }

  Future<void> authenticate() async {
    await Future.delayed(Duration(milliseconds: 500));

    if (isNewUser) {
      print("is new user");
      await signUp();
    }

    await login();

    // 로그인 결과
    Type loginStatus = state.runtimeType;

    if (loginStatus == LoginFailure) {
      GetSnackbar.err("인증 실패!", "다시 시도해주세요.");
      print(state.props);
    } else if (loginStatus == LoginSuccess) {
      print("Login Success");
      Get.offAllNamed(Routes.INITIAL);
    }
  }

  // 사용자가 작성한 이메일 패스워드로 회원 가입 시도
  Future<void> signUp() async {
    try {
      await _authenticationController.signUp(phoneNumber, authNumber);
    } catch (e) {
      print(e);
    }
  }

  // 사용자가 작성한 전화번호 + 인증번호로 로그인 시도
  Future<void> login() async {
    _loginStateStream.value = LoginLoading();

    // AuthenticationController 에서 로그인을 시도하고 login 성공/실패로 갈림
    try {
      await _authenticationController.signIn(phoneNumber, authNumber);

      if (_authenticationController.state.runtimeType == Authenticated) {
        _loginStateStream.value = LoginSuccess();
      } else {
        throw Exception("로그인을 실패하였습니다 - 인증 번호 틀림!");
      }
    } catch (e) {
      _loginStateStream.value = LoginFailure(error: e.toString());
    }
  }

  void setIsEnabledRequestSMSButton(bool value) {
    isEnabledRequestSMSButton.value = value;
  }

  void setIsEnabledVerifyButton(bool value) {
    isEnabledVerifyButton.value = value;
  }

  void setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  void setAuthNumber(String authNumber) {
    this.authNumber = authNumber;
  }
}
