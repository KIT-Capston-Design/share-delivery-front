import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_delivery/src/controller/community/post_detail_controller.dart';
import 'package:share_delivery/src/ui/theme/container_theme.dart';
import 'package:share_delivery/src/ui/theme/text_theme.dart';

class EditComment extends GetView<PostDetailController> {
  const EditComment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: Container(
          width: Get.width,
          height: Get.height,
          color: Colors.white,
          child: commentContent(),
        ),
      ),
    );
  }

  Widget commentContent() {
    return Container(
      margin: const EdgeInsets.all(15),
      child: TextField(
        controller: controller.commentEditController.value,
        minLines: 6,
        maxLines: 6,
        onChanged: (text) => controller.validateEditComment(text),
        style: defaultPostCategory,
        decoration: InputDecoration(
          hintText: "댓글을 작성해주세요!",
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      shape: const Border(bottom: BorderSide(color: Colors.black12, width: 1)),
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(
          Icons.close,
          color: Colors.black,
        ),
      ),
      title: const Text("댓글 수정하기", style: appBarTitle),
      actions: [
        Obx(
          () => TextButton(
            onPressed: controller.isAbleEditComment.value
                ? () {
                    print("댓글 수정하기");
                    controller.updateComment();
                  }
                : null,
            child: Text("완료"),
            style: TextButton.styleFrom(
              primary: Colors.black,
              textStyle: appBarAction,
            ),
          ),
        ),
      ],
    );
  }

  Widget commentTextField(BuildContext context) {
    const double iconSize = 27.0;

    return Obx(
      () => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: topBorderBox,
          child: Row(
            children: [
              // IconButton(
              //   onPressed: () {},
              //   padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
              //   // padding: EdgeInsets.zero,
              //   constraints: BoxConstraints(),
              //   icon: Icon(
              //     Icons.location_on_outlined,
              //     size: iconSize,
              //     color: Colors.grey[600],
              //   ),
              // ),
              // IconButton(
              //   onPressed: () {},
              //   // padding: EdgeInsets.zero,
              //   padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
              //   constraints: BoxConstraints(),
              //   icon: Icon(
              //     Icons.image_outlined,
              //     size: iconSize,
              //     color: Colors.grey[600],
              //   ),
              // ),
              SizedBox(
                width: Get.width,
                child: Card(
                  elevation: 0,
                  color: Colors.grey[100],
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: TextFormField(
                    controller: controller.commentTextField,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    minLines: 1,
                    onChanged: (text) =>
                        controller.setOnSendComment(text.isNotEmpty),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintText: "댓글을 입력해주세요.",
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: Get.width < 400 ? 16 : 17,
                      ),
                      prefix: const SizedBox(width: 20),
                      suffixIcon: controller.onSendComment.value
                          ? IconButton(
                              onPressed: () async {
                                await controller.sendComment();
                              },
                              color: Colors.orange,
                              icon: Icon(Icons.send_rounded),
                            )
                          : SizedBox.shrink(),
                      // contentPadding: EdgeInsets.only(left: 5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
