import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:logger/logger.dart';
import 'package:share_delivery/src/controller/community/post_detail_controller.dart';
import 'package:share_delivery/src/data/model/community/comment/comment.dart';
import 'package:share_delivery/src/routes/route.dart';
import 'package:share_delivery/src/ui/community/post_detail/post_detail.dart';
import 'package:share_delivery/src/ui/theme/button_theme.dart';
import 'package:share_delivery/src/ui/theme/container_theme.dart';
import 'package:share_delivery/src/ui/theme/text_theme.dart';
import 'package:share_delivery/src/utils/image_util.dart';
import 'package:share_delivery/src/utils/time_util.dart';

class WritingComment extends GetView<PostDetailController> {
  const WritingComment({Key? key}) : super(key: key);

  static const double normal = PostDetail.normal;
  static const double big = PostDetail.big;
  static const double parentAvatar = PostDetail.parentAvatar;
  static const double childAvatar = PostDetail.childAvatar;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: LoaderOverlay(
          child: Scaffold(
            appBar: appBar(),
            body: GestureDetector(
              onTap: () {
                if (MediaQuery.of(context).viewInsets.bottom != 0) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              child: Container(
                color: Colors.white,
                height: Get.height,
                width: Get.width,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          comments(),
                          const SizedBox(width: 30, height: 68),
                        ],
                      ),
                    ),
                    commentTextField(context),
                  ],
                ),
              ),
            ),
          ),
          overlayColor: Colors.transparent,
          useDefaultLoading: false,
          overlayWidget: const Center(
            child: SpinKitThreeBounce(
              size: 25,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget comments() {
    int parentId = controller.currentWritingCommentParentId.value;
    List<Comment> group = controller.getCommentGroup(parentId);
    print('WritingComment.comments - $parentId');

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: group.length,
      itemBuilder: (_, idx) => group[idx].id == group[idx].parentId
          ? parentComment(group[idx])
          : childComment(group[idx]),
    );
  }

  Widget parentComment(Comment comment) {
    String state = comment.state;

    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: big,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: state != "DELETED" ? () {} : null,
                child: Padding(
                  padding: EdgeInsets.only(right: normal),
                  child: CircleAvatar(
                    radius: parentAvatar,
                    backgroundImage: state != "DELETED"
                        ? comment.writer.profileImage == ''
                            ? randomProfileImage()
                            : customNetworkImage(comment.writer.profileImage)
                        : null,
                    child: state != "DELETED"
                        ? null
                        : Icon(Icons.block_rounded, color: Colors.black),
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        children: [
                          Text(
                            state != "DELETED"
                                ? comment.writer.nickname
                                : "알 수 없는 사용자",
                            style: postTitleStyle,
                          ),
                          const SizedBox(width: 5),
                          comment.writer.accountId == controller.currentUserId
                              ? const Text(
                                  " 작성자",
                                  style: writerBadge,
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Row(
                        children: [
                          Text(
                            "매너온도 ${comment.writer.mannerScore.toString()}",
                            style: postDetailStyle,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.fiber_manual_record,
                              size: 3,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            TimeUtil.timeAgo(comment.createdDateTime),
                            style: postDetailStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              state != "DELETED" ? commentMoreVert(comment) : SizedBox.shrink(),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(
              left: parentAvatar * 2 + normal,
              bottom: 6.0,
              right: normal,
              top: 6.0,
            ),
            child: Text(
              state != "DELETED" ? comment.content : "삭제된 댓글입니다.",
              style: commentStyle,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: parentAvatar * 2 + normal),
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                print("댓글 좋아요 기능");
                controller.toggleCommentLike(comment);
              },
              child: Text("좋아요 ${comment.likes.toString()}"),
              style: comment.isLiked ? likedCommentBtn : unlikedCommentBtn,
            ),
          ),
        ],
      ),
    );
  }

  Widget childComment(Comment comment) {
    String state = comment.state;

    return Padding(
      padding: EdgeInsets.only(
        top: normal,
        left: big + parentAvatar * 2 + normal,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: state != "DELETED" ? () {} : null,
                child: Padding(
                  padding: EdgeInsets.only(right: normal),
                  child: CircleAvatar(
                    radius: childAvatar,
                    backgroundImage: state != "DELETED"
                        ? comment.writer.profileImage == ''
                            ? randomProfileImage()
                            : customNetworkImage(comment.writer.profileImage)
                        : null,
                    child: state != "DELETED"
                        ? null
                        : Icon(Icons.block_rounded, color: Colors.black),
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        children: [
                          Text(
                            state != "DELETED"
                                ? comment.writer.nickname
                                : "알 수 없는 사용자",
                            style: postTitleStyle,
                          ),
                          const SizedBox(width: 5),
                          comment.writer.accountId == controller.currentUserId
                              ? const Text(
                                  " 작성자",
                                  style: writerBadge,
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        children: [
                          Text(
                            "매너온도 ${comment.writer.mannerScore.toString()}",
                            style: postDetailStyle,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.fiber_manual_record,
                              size: 3,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            TimeUtil.timeAgo(comment.createdDateTime),
                            style: postDetailStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              state != "DELETED" ? commentMoreVert(comment) : SizedBox.shrink(),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(
              left: childAvatar * 2 + normal,
              bottom: 6.0,
              right: normal,
            ),
            child: Text(
              state != "DELETED" ? comment.content : "삭제된 댓글입니다.",
              style: commentStyle,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: childAvatar * 2 + normal,
              right: normal,
            ),
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                print("댓글 좋아요 기능");
                controller.toggleCommentLike(comment);
              },
              child: Text("좋아요 ${comment.likes.toString()}"),
              style: comment.isLiked ? likedCommentBtn : unlikedCommentBtn,
            ),
          ),
        ],
      ),
    );
  }

  Widget commentMoreVert(Comment comment) {
    return IconButton(
      onPressed: () {
        // TODO : 댓글 메뉴 열기 - 작성자의 댓글이면 [수정, 삭제, 닫기], 작성자가 아니라면 [신고, 닫기]
        bool isWriter = controller.currentUserId == comment.writer.accountId;

        Get.bottomSheet(
          isWriter
              ? writerCommentActionSheet(comment)
              : readerCommentActionSheet(comment),
          barrierColor: Colors.black26,
        );
      },
      padding: const EdgeInsets.fromLTRB(normal, 0, normal, normal),
      constraints: BoxConstraints(),
      icon: Icon(Icons.more_vert),
    );
  }

  Widget writerCommentActionSheet(Comment comment) {
    double actionSize = 60;
    double actionFontSize = 20;

    return Container(
      height: actionSize * 3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          bottomSheetAction(
            func: () {
              if (Get.isBottomSheetOpen!) Get.back();
              Get.toNamed(Routes.EDIT_COMMENT);
              // TODO: 댓글 수정페이지
            },
            color: Colors.blue,
            content: "수정",
            fontSize: actionFontSize,
            height: actionSize,
          ),
          const Divider(height: 0, thickness: 1),
          bottomSheetAction(
            func: () {
              print('PostDetail.writerCommentActionSheet - 삭제');
              _confirmationDialog(
                content: "댓글을 삭제하시겠습니까?",
                isPost: false,
                commentId: comment.id,
              );
            },
            color: Colors.red,
            content: "삭제",
            fontSize: actionFontSize,
            height: actionSize,
          ),
          const Divider(height: 0, thickness: 1),
          bottomSheetAction(
            func: () {
              print('PostDetail.writerCommentActionSheet - 닫기');
              Get.back();
            },
            color: Colors.black,
            content: "닫기",
            fontSize: actionFontSize,
            height: actionSize,
          ),
        ],
      ),
    );
  }

  Widget readerCommentActionSheet(Comment comment) {
    double actionSize = 60;
    double actionFontSize = 20;

    return Container(
      height: actionSize * 2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          bottomSheetAction(
            func: () {
              print('PostDetail.readerCommentActionSheet - 신고');
              controller.reportComment(comment.id);
            },
            color: Colors.red,
            content: "신고",
            fontSize: actionFontSize,
            height: actionSize,
          ),
          const Divider(height: 0, thickness: 1),
          bottomSheetAction(
            func: () {
              print('PostDetail.readerCommentActionSheet - 닫기');
              Get.back();
            },
            color: Colors.black,
            content: "닫기",
            fontSize: actionFontSize,
            height: actionSize,
          ),
        ],
      ),
    );
  }

  Widget bottomSheetAction({
    required double height,
    required double fontSize,
    required String content,
    required Color color,
    required func,
  }) {
    return GestureDetector(
      onTap: func,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          content,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: color,
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
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back_rounded, color: Colors.black),
      ),
      title: Text(
        "댓글쓰기",
        style: appBarTitle,
      ),
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
                                int parentId = controller
                                    .currentWritingCommentParentId.value;
                                await controller.sendComment(parentId);
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

  void _confirmationDialog(
      {required String content, required bool isPost, int? commentId}) {
    Get.dialog(
      AlertDialog(
        content: Text(content),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            child: Text("  취소  "),
            style: cancelBtn,
          ),
          ElevatedButton(
            onPressed: () async {
              if (isPost) {
                await controller.deletePost();
              } else {
                if (commentId == null) {
                  Logger().e("댓글 삭제를 위해서는 댓글 ID를 파라미터에 넣어줘야함");
                  return;
                }

                await controller.deleteComment(commentId);
              }

              if (Get.isDialogOpen!) Get.back();
              if (Get.isBottomSheetOpen!) Get.back();
            },
            child: Text("  삭제  "),
            style: deleteBtn,
          ),
        ],
      ),
    );
  }
}
