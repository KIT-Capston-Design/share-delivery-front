import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:share_delivery/src/controller/notification_controller/notification_controller.dart';
import 'package:share_delivery/src/data/model/authentication/login_req_dto.dart';
import 'package:share_delivery/src/data/model/authentication/sign_up_req_dto.dart';
import 'package:share_delivery/src/data/model/user/user/user.dart';
import 'package:share_delivery/src/data/provider/authentication/authentication_api_client.dart';
import 'package:share_delivery/src/data/provider/authentication/authentication_local_client.dart';

class AuthenticationRepository {
  final AuthenticationApiClient apiClient;
  final AuthenticationLocalClient localClient;

  AuthenticationRepository({
    required this.apiClient,
    required this.localClient,
  });

  Future<String?> requestAuthSMS(String phoneNumber) async {
    String? returnVal;

    await apiClient.requestAuthSMS(phoneNumber).then((result) {
      // 인증 SMS 요청 성공
      Logger().i(result);
      returnVal = result["verificationType"];
    }).catchError((Object obj) {
      // 인증 SMS 요청 실패
      loggerErr(obj);
      final res = (obj as DioError).response;
      if (res == null) return;

      returnVal = res.data["verificationType"];
    });

    return returnVal;
  }

  Future<bool> signUp(String phoneNumber, String verificationCode) async {
    SignUpReqDTO signUpReqDTO = SignUpReqDTO(
      phoneNumber: phoneNumber,
      verificationCode: verificationCode,
    );

    await apiClient.signUp(signUpReqDTO).then((it) {
      // 회원가입 성공
      Logger().i(it);
      return true;
    }).catchError((Object obj) {
      // 회원가입 실패
      loggerErr(obj);
      return false;
    });

    // 실패가 아니라면 true 반환;
    return true;
  }

  Future<User?> login(String phoneNumber, String verificationCode) async {
    // Logger().i("login", NotificationController.to.fcmToken);
    LoginReqDTO loginReqDTO = LoginReqDTO(
      phoneNumber: phoneNumber,
      verificationCode: verificationCode,
      fcmToken: "NotificationController.to.fcmToken",
    );

    User? account;

    account = await apiClient.login(loginReqDTO).then((result) {
      // 로그인 성공
      Logger().i(result);
      // 1. 사용자 계정 로컬에 저장
      localClient.saveUser(result.account);

      // 2. access/refresh token 저장
      localClient.saveTokens(result.accessToken, result.refreshToken);

      return result.account;
    }).catchError((Object obj) {
      // 로그인 실패
      loggerErr(obj);
      // Logger().e(err);
      return null;
    });

    // 로그인 성공
    return account;
  }

  // 로그아웃
  void logout() {
    localClient.deleteUser();
  }

  // 로컬에 저장된 유저 객체 가져오기
  User? getSavedUser() {
    return localClient.getSavedUser();
  }
}

void loggerErr(Object obj) {
  switch (obj.runtimeType) {
    case DioError:
      final res = (obj as DioError).response;
      if (res == null) return;

      Logger().e("Got error : ${res.statusCode} -> ${res.data}");
      break;
    default:
      break;
  }
}
