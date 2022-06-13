import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_delivery/src/controller/report/report_controller.dart';
import 'package:share_delivery/src/ui/theme/text_theme.dart';
import 'package:share_delivery/src/utils/categories.dart';

class Report extends GetView<ReportController> {
  const Report({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: appBar(),
      body: reportList(),
    );
  }

  Widget reportList() {
    return ListView.separated(
      itemCount: reportCategories.length + 1,
      itemBuilder: (context, i) => i == 0
          ? reportExplanation("신고하는 이유를 선택해주세요")
          : reportTile(reportCategories[i - 1], i - 1),
      separatorBuilder: (_, __) => const Divider(height: 0),
    );
  }

  Widget reportExplanation(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        hoverColor: Colors.orangeAccent,
        selectedTileColor: Colors.orangeAccent,
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
      ),
    );
  }

  Widget reportTile(String title, int i) {
    return Obx(
      () => ListTile(
        onTap: () {
          controller.selectedIndex.value = i;
        },
        selected: i == controller.selectedIndex.value,
        selectedTileColor: Colors.orange[400],
        selectedColor: Colors.white,
        tileColor: Colors.white,
        textColor: Colors.black,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const Border(bottom: BorderSide(color: Colors.black12, width: 1)),
      title: Text("유저 신고", style: appBarTitle),
      actions: [
        TextButton(
          onPressed: ()async {
            await controller.createReport();
            Get.back();
          },
          child: Text("완료"),
          style: TextButton.styleFrom(
            primary: Colors.black,
            textStyle: appBarAction,
          ),
        ),
      ],
    );
  }
}
