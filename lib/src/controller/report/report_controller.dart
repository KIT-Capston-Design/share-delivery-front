import 'package:get/get.dart';
import 'package:share_delivery/src/controller/evaluate_and_report/evaluate_and_report_controller.dart';
import 'package:share_delivery/src/data/repository/report/report_repository.dart';
import 'package:share_delivery/src/utils/categories.dart';

class ReportController extends GetxController {
  static ReportController get to => Get.find();

  final ReportRepository repository;

  ReportController({required this.repository});

  final selectedIndex = 0.obs;

  Future<void> createReport() async {
    int reportedAccountId = Get.arguments["reportedAccountId"];
    print('ReportController.createReport - $reportedAccountId');

    print(
        "$reportedAccountId 번 유저를 신고합니다 - 죄목 : ${reportCategories[selectedIndex.value]}");

    await repository.createReport(
      reportedAccountId,
      reportCategories[selectedIndex.value],
      "DELIVERY_ROOM",
    );

    EvaluateAndReportController.to.doneReportByAccountId(reportedAccountId);
  }
}
