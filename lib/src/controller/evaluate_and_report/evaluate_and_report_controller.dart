import 'package:get/get.dart';
import 'package:share_delivery/src/data/model/profile/profile.dart';
import 'package:share_delivery/src/data/repository/evaluate_and_report/evaluate_and_report_repository.dart';

class EvaluateAndReportController extends GetxController {
  static EvaluateAndReportController get to => Get.find();

  EvaluateAndReportRepository repository;

  EvaluateAndReportController({required this.repository});

  RxBool alreadyEvaluatingDone = false.obs;
  RxBool alreadyReportingDone = false.obs;
  RxBool isLoading = false.obs;

  var users = <ProfileModel>[].obs;
  var evaluateList = <Evaluation>[].obs;
  var reportDoneList = <bool>[].obs;

  @override
  void onInit() async {
    super.onInit();

    if (Get.arguments == null) {
      return;
    }

    List<int> list = Get.arguments;
    users.value = await repository.getUserInfo(list);

    for (int i = 0; i < users.length; i++) {
      evaluateList.add(Evaluation(users[i].accountId, ""));
    }

    reportDoneList = RxList<bool>.filled(evaluateList.length, false);

    isLoading.value = true;
  }

  // 평가 선택하기
  void pickEvaluationCategoryEachUser(int idx, int selectedIdx) {
    int prev = -1;
    for (int i = 0; i < evaluateList[idx].selected.length; i++) {
      if (evaluateList[idx].selected[i]) {
        prev = i;
      }
    }

    if (prev == selectedIdx) {
      // 기존에 택한 것을 또 선택 => 선택 취소
      evaluateList[idx].content = "";
      evaluateList[idx].selected[prev] = false;
    } else {
      // 기존에 택하지 않은 걸 선택 => 선택 변경
      evaluateList[idx].content = evaluationCategory[selectedIdx];
      evaluateList[idx].selected[selectedIdx] = true;
      if (prev != -1) evaluateList[idx].selected[prev] = false;
    }
  }

  // 평가하기
  Future<void> evaluateUser() async {
    for (int i = 0; i < evaluateList.length; i++) {
      if (evaluateList[i].content == "") continue;

      Evaluation evaluation = evaluateList[i];
      print("${evaluation.accountId}, ${evaluation.content}");
      await repository.evaluateUser(evaluation.accountId, evaluation.content);
    }

    alreadyEvaluatingDone.value = true;
    update();
  }

  // 신고하기
  void reportUser(int accountId, String content) {
    repository.reportUser(accountId, content);
    alreadyReportingDone.value = true;
  }

  void doneReportByAccountId(int id) {
    for (int i = 0; i < evaluateList.length; i++) {
      print(evaluateList[i].accountId);
      print(id);

      if (evaluateList[i].accountId == id) {
        reportDoneList[i] = true;
      }
    }
  }
}

const evaluationCategory = <String>[
  "시간 약속을 잘 지켜요",
  "친절해요",
  "응답이 빨라요",
];

class Evaluation {
  int accountId;
  String content;
  RxList<bool> selected = <bool>[false, false, false].obs;

  Evaluation(this.accountId, this.content);
}
