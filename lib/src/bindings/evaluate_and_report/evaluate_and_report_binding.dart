import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:share_delivery/src/controller/evaluate_and_report/evaluate_and_report_controller.dart';
import 'package:share_delivery/src/data/provider/evaluate_and_report/evaluate_and_report_api_client.dart';
import 'package:share_delivery/src/data/provider/profile/profile_api_client.dart';
import 'package:share_delivery/src/data/repository/evaluate_and_report/evaluate_and_report_repository.dart';
import 'package:share_delivery/src/utils/dio_util.dart';

class EvaluateAndReportBinding extends Bindings {
  @override
  void dependencies() {
    Dio dio = DioUtil.getDio();
    final String host = dotenv.get('SERVER_HOST');

    Get.put(
      EvaluateAndReportController(
        repository: EvaluateAndReportRepository(
          apiClient: EvaluateAndReportApiClient(dio, baseUrl: host),
          profileApiClient: ProfileApiClient(dio, baseUrl: host),
        ),
      ),
    );
  }
}
