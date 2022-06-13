import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:share_delivery/src/controller/community/post_detail_controller.dart';
import 'package:share_delivery/src/data/model/community/comment/comment.dart';
import 'package:share_delivery/src/data/model/community/post/post.dart';
import 'package:share_delivery/src/routes/route.dart';
import 'package:share_delivery/src/ui/community/post_register/post_image.dart';
import 'package:share_delivery/src/ui/community/post_register/post_register.dart';
import 'package:share_delivery/src/ui/theme/button_theme.dart';
import 'package:share_delivery/src/ui/theme/container_theme.dart';
import 'package:share_delivery/src/ui/theme/text_theme.dart';
import 'package:share_delivery/src/utils/image_util.dart';
import 'package:share_delivery/src/utils/time_util.dart';

class PostDetail extends GetView<PostDetailController> {
  const PostDetail({Key? key}) : super(key: key);

  static const double normal = 10.0;
  static const double big = 20.0;
  static const double parentAvatar = 16.0;
  static const double childAvatar = 14.0;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoad.value == false
          ? SafeArea(
              child: Scaffold(
                appBar: appBar(context),
                bottomSheet: commentTextField(context),
              ),
            )
          : SafeArea(
              maintainBottomViewPadding: true,
              child: Scaffold(
                appBar: appBar(context),
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
                              profile(controller.postInfo.value.post!),
                              content(controller.postInfo.value.post!),
                              postImages(),
                              const Divider(
                                color: Colors.black12,
                                thickness: 1,
                                height: 0,
                              ),
                              controller.comments.isEmpty
                                  ? noComments()
                                  : comments(),
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
            ),
    );
  }

  Widget profile(Post post) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              postTopic(post.category),
              Padding(
                padding: EdgeInsets.only(right: normal),
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.togglePostLike(post.postId);
                  },
                  icon: Icon(
                    Icons.thumb_up_alt_rounded,
                    size: 20,
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Colors.transparent,
                    onPrimary: controller.isLikedPost.value
                        ? Colors.orange
                        : Colors.grey.shade700,
                    splashFactory: NoSplash.splashFactory,
                    textStyle: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  label: Text(
                    controller.postInfo.value.postDetail!.likes.toString(),
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: bottomBorderBox,
            margin: const EdgeInsets.only(left: big, right: big),
            padding: const EdgeInsets.only(bottom: big),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.OTHER_USER_PROFILE, arguments: {
                      "accountId":
                          controller.postInfo.value.post!.writer.accountId
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: normal),
                    child: CircleAvatar(
                      //TODO: profile

                      radius: parentAvatar,
                      backgroundImage: post.writer.profileImage == ''
                          ? randomProfileImage()
                          : customNetworkImage(post.writer.profileImage),
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.writer.nickname, style: postTitleStyle),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "매너온도 ${post.writer.mannerScore}",
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
                            TimeUtil.timeAgo(post.createdDateTime),
                            style: postDetailStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget content(Post post) {
    return Container(
      padding: const EdgeInsets.all(big),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.content,
            style: detailContentStyle,
          ),
        ],
      ),
    );
  }

  Widget postImages() {
    double imageSize = Get.width < 400 ? 70.0 : 90.0;
    double imageMargin = Get.width < 400 ? 10.0 : 12.0;

    return Obx(
      () {
        if (controller.postInfo.value.isNotEmpty() &&
            controller.postInfo.value.postDetail!.images.isNotEmpty) {
          // List<String> hostImageUrls = [];
          // for (int i = 0;
          //     i < controller.postInfo.value.postDetail!.images.length;
          //     i++) {
          //   hostImageUrls.add(imagePathWithHost(
          //       controller.postInfo.value.postDetail!.images[i]));
          //   print(imagePathWithHost(
          //       controller.postInfo.value.postDetail!.images[i]));
          // }

          return Container(
            height: imageSize + imageMargin * 2,
            padding: EdgeInsets.symmetric(horizontal: normal),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.postInfo.value.postDetail!.images.length,
              itemBuilder: (_, i) {
                return PostImage(
                  index: i,
                  imageURLs: controller.postInfo.value.postDetail!.images,
                  deleteButton: false,
                  size: imageSize,
                  margin: imageMargin,
                );
              },
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget noComments() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Column(
        children: const [
          Icon(Icons.sms, size: 80, color: Colors.black12),
          SizedBox(height: 10),
          Text(
            "댓글이 없습니다.",
            style: TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "처음으로 의견을 공유해주세요!",
            style: TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget comments() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.comments.length,
      itemBuilder: (_, idx) => controller.isParentComment(idx)
          ? parentComment(idx)
          : childComment(idx),
    );
  }

  Widget parentComment(int idx) {
    Comment comment = controller.comments[idx];
    String state = comment.state;

    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        bottom: controller.isLastComment(idx) ? 30 : 0,
        left: big,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: state != "DELETED"
                    ? () {
                        Get.toNamed(Routes.OTHER_USER_PROFILE,
                            arguments: {"accountId": comment.writer.accountId});
                      }
                    : null,
                child: Padding(
                  padding: EdgeInsets.only(right: normal),
                  child: CircleAvatar(
                    radius: parentAvatar,
                    backgroundImage: state == "DELETED"
                        ? null
                        : comment.writer.profileImage == ''
                            ? randomProfileImage()
                            : customNetworkImage(comment.writer.profileImage),
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
            child: Row(
              children: [
                Obx(
                  () => TextButton(
                    onPressed: () {
                      print("댓글 좋아요 기능");
                      controller.toggleCommentLike(comment);
                    },
                    child: Text(
                        "좋아요 ${controller.comments[idx].likes.toString()}"),
                    style: controller.comments[idx].isLiked
                        ? likedCommentBtn
                        : unlikedCommentBtn,
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    controller.currentWritingCommentParentId.value =
                        comment.parentId;
                    Get.toNamed(Routes.WRITING_COMMENT);
                  },
                  child: Text("댓글쓰기"),
                  style: commentBtn,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget childComment(int idx) {
    Comment comment = controller.comments[idx];
    String state = comment.state;

    return Padding(
      padding: EdgeInsets.only(
        top: normal,
        bottom: controller.isLastComment(idx) ? 30 : 0,
        left: big + parentAvatar * 2 + normal,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: state != "DELETED"
                    ? () {
                        Get.toNamed(Routes.OTHER_USER_PROFILE,
                            arguments: {"accountId": comment.writer.accountId});
                      }
                    : null,
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
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  print("댓글 좋아요 기능");
                  controller.toggleCommentLike(comment);
                },
                child: Text("좋아요 ${comment.likes.toString()}"),
                style: controller.comments[idx].isLiked
                    ? likedCommentBtn
                    : unlikedCommentBtn,
              ),
            ),
          ),
          controller.onWriteCommentBar(comment)
              ? writeCommentBar(comment.parentId)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget commentMoreVert(Comment comment) {
    return IconButton(
      onPressed: () {
        // TODO : 댓글 메뉴 열기 - 작성자의 댓글이면 [수정, 삭제, 닫기], 작성자가 아니라면 [신고, 닫기]
        bool isWriter = (controller.currentUserId == comment.writer.accountId);

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
              // 수정할 댓글을 선택
              controller.setCurrentEditComment(comment);

              if (Get.isBottomSheetOpen!) Get.back();
              Get.toNamed(Routes.EDIT_COMMENT);
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

  Widget writeCommentBar(int parentId) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          controller.currentWritingCommentParentId.value = parentId;
          Get.toNamed(Routes.WRITING_COMMENT);
        },
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: normal),
              child: CircleAvatar(
                radius: childAvatar,
                backgroundColor: Colors.grey.shade300,
                child:
                    Icon(Icons.person_outline_rounded, color: Colors.black54),
              ),
            ),
            Expanded(
              child: Container(
                height: childAvatar * 2,
                padding: const EdgeInsets.only(left: normal),
                margin: const EdgeInsets.only(right: big),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1.1,
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "댓글을 입력해주세요.",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget postTopic(String category) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.all(big),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Text(
        category,
        style:
            TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600),
      ),
    );
  }

  PreferredSizeWidget appBar(BuildContext ctx) {
    return AppBar(
      shape: const Border(bottom: BorderSide(color: Colors.black12, width: 1)),
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back_rounded, color: Colors.black),
      ),
      actions: [
        // IconButton(
        //   onPressed: () {
        //     print("click notifications_rounded");
        //   },
        //   icon: Icon(Icons.notifications_rounded, color: Colors.black),
        // ),
        // IconButton(
        //   onPressed: () {
        //     print("click ios_share");
        //   },
        //   icon: Icon(Icons.ios_share, color: Colors.black),
        // ),
        IconButton(
          onPressed: () {
            print('PostDetail.appBar');
            bool isWriter = controller.uiType == PostDetailUI.writer;
            Get.bottomSheet(
              isWriter ? writerPostActionSheet() : readerPostActionSheet(),
              barrierColor: Colors.black26,
            );
          },
          icon: Icon(Icons.more_vert, color: Colors.black),
        ),
      ],
    );
  }

  Widget writerPostActionSheet() {
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
              print('PostDetail.writerPostActionSheet - 게시글 수정');
              Get.bottomSheet(
                PostRegister(
                  post: controller.postInfo.value.post,
                  postDetail: controller.postInfo.value.postDetail,
                ),
                isScrollControlled: true,
                ignoreSafeArea: false,
              );
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
              _confirmationDialog(content: "글을 삭제하시겠습니까?", isPost: true);
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

  Widget readerPostActionSheet() {
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
              print('PostDetail.readerPostActionSheet - 게시글 신고');
              controller.reportPost();
            },
            color: Colors.red,
            content: "신고",
            fontSize: actionFontSize,
            height: actionSize,
          ),
          const Divider(height: 0, thickness: 1),
          bottomSheetAction(
            func: () {
              print('PostDetail.readerPostActionSheet - 게시글 닫기');
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
