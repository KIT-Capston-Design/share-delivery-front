import 'package:get/get.dart';
import 'package:share_delivery/src/data/model/User.dart';
import 'package:share_delivery/src/data/repository/authentication_repo.dart';
import 'package:share_delivery/src/ui/login/state/authentication_state.dart';

class AuthenticationController extends GetxController {
  final AuthenticationRepo _authRepo;
  final _authenticationStateStream = const AuthenticationState().obs;

  AuthenticationState get state => _authenticationStateStream.value;

  AuthenticationController(this._authRepo);

  // 컨트롤러가 메모리에 할당된 후에 즉시 실행
  @override
  void onInit() {
    _getAuthenticatedUser();
    super.onInit();
  }

  // 파라미터에 사용자 인증 정보 넣기 -> 우리 앱은 전화번호
  Future<void> signIn(String email, String password) async {
    final user = await _authRepo.signInWithEmailAndPassword(email, password);
    _authenticationStateStream.value = Authenticated(user: user);
  }

  void signOut() async {
    await _authRepo.signOut();
    _authenticationStateStream.value = UnAuthenticated();
  }

  void _getAuthenticatedUser() async {
    _authenticationStateStream.value = AuthenticationLoading();

    final User? user = await _authRepo.getCurrentUser();

    // 바로 홈화면으로 가고싶으면 아래 두 줄 주석 해제하시고 아래 if,else 문 전부 주석하세요
    _authenticationStateStream.value =
        Authenticated(user: User(name: "test", phoneNumber: "1234"));

    // if (user == null) {
    //   print("user == null");
    //   _authenticationStateStream.value = UnAuthenticated();
    // } else {
    //   print("user != null");
    //   _authenticationStateStream.value = Authenticated(user: user);
    // }
  }
}