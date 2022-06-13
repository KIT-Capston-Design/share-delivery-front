import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_delivery/src/controller/evaluate_and_report/evaluate_and_report_controller.dart';
import 'package:share_delivery/src/routes/route.dart';
import 'package:share_delivery/src/ui/theme/container_theme.dart';
import 'package:share_delivery/src/ui/theme/text_theme.dart';

class EvaluateUser extends GetView<EvaluateAndReportController> {
  const EvaluateUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: appBar(),
        body: Obx(
          () => Stack(
            children: [
              SizedBox(
                width: Get.width,
                height: Get.height,
                child: userList(),
              ),
              controller.alreadyEvaluatingDone.value
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black26,
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
        bottomSheet: actionBottomSheet(),
      ),
    );
  }

  Widget userList() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: ListView.builder(
        itemCount: controller.users.length,
        itemBuilder: (context, index) => eachUser(index),
      ),
    );
  }

  Widget eachUser(int i) {
    print('EvaluateUser.eachUser ${controller.reportDoneList[i]}');

    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: bottomBorderBox,
        margin: const EdgeInsets.only(bottom: 7),
        // color: Colors.white,
        height: 190,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(backgroundColor: Colors.grey),
                      const SizedBox(width: 10),
                      Text(
                        controller.users[i].nickname,
                        overflow: TextOverflow.ellipsis,
                        style: postTitleStyle,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: controller.reportDoneList[i]
                        ? null
                        : () {
                            print("신고하기");
                            Get.toNamed(
                              Routes.REPORT,
                              arguments: {
                                "reportedAccountId":
                                    controller.users[i].accountId
                              },
                            );
                          },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
                      child: Row(
                        children: [
                          Text(
                            "신고",
                            style: TextStyle(
                              color: controller.reportDoneList[i]
                                  ? Colors.grey
                                  : Colors.red,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                            color: controller.reportDoneList[i]
                                ? Colors.grey
                                : Colors.red,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 0, thickness: 1),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  evaluationCriteria(
                    "시간 약속을 잘 지켜요",
                    Icons.timer_outlined,
                    i,
                    0,
                  ),
                  VerticalDivider(width: 0, thickness: 1),
                  evaluationCriteria(
                    "친절해요",
                    Icons.mood_rounded,
                    i,
                    1,
                  ),
                  VerticalDivider(width: 0, thickness: 1),
                  evaluationCriteria(
                    "응답이 빨라요",
                    Icons.bolt_outlined,
                    i,
                    2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget evaluationCriteria(
    String content,
    IconData icon,
    int i,
    int selectedIdx,
  ) {
    return Expanded(
      child: Obx(
        () => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            controller.pickEvaluationCategoryEachUser(i, selectedIdx);
          },
          child: Container(
            color: controller.evaluateList[i].selected[selectedIdx]
                ? Colors.deepOrangeAccent
                : Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Icon(
                    icon,
                    size: 50,
                    color: controller.evaluateList[i].selected[selectedIdx]
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        content,
                        style: controller.evaluateList[i].selected[selectedIdx]
                            ? selectedEvaluation
                            : unselectedEvaluation,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      shape: const Border(bottom: BorderSide(color: Colors.black12, width: 1)),
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text("매너 평가", style: appBarTitle),
    );
  }

  Widget actionBottomSheet() {
    return Obx(
      () => Container(
        color: Colors.white,
        height: 60,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  color: Colors.grey.shade600,
                  child: Center(
                    child: Text("취소", style: ratingActionBtn),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: controller.alreadyEvaluatingDone.value
                    ? null
                    : () async {
                        print("평가 제출하기");
                        await controller.evaluateUser();
                      },
                child: Container(
                  color: controller.alreadyEvaluatingDone.value
                      ? Colors.grey
                      : Colors.orangeAccent,
                  child: Center(
                    child: Text("제출하기", style: ratingActionBtn),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
