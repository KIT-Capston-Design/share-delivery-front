import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_delivery/src/controller/community/community_controller.dart';
import 'package:share_delivery/src/data/model/community/post/post.dart';
import 'package:share_delivery/src/data/provider/community/community_repository.dart';
import 'package:share_delivery/src/data/provider/community/post/community_api_client.dart';
import 'package:share_delivery/src/data/provider/widgets/user_location_local_client.dart';
import 'package:share_delivery/src/routes/route.dart';
import 'package:share_delivery/src/ui/theme/button_theme.dart';
import 'package:share_delivery/src/ui/theme/container_theme.dart';
import 'package:share_delivery/src/ui/theme/text_theme.dart';
import 'package:share_delivery/src/utils/categories.dart';
import 'package:share_delivery/src/utils/dio_util.dart';
import 'package:share_delivery/src/utils/time_util.dart';

class Community extends GetView<CommunityController> {
  const Community({Key? key}) : super(key: key);

  static const double padding = 10;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(
      () => CommunityController(
        repository: CommunityRepository(
          apiClient: CommunityApiClient(DioUtil.getDio()),
          localClient: UserLocationLocalClient(),
        ),
      ),
    );

    return Obx(
      () => Scaffold(
        appBar: appBar(),
        body: Container(
          color: Colors.grey.shade200,
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            controller: controller.refresher.value,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            child: ListView.builder(
              itemCount: controller.posts.length + 1,
              itemBuilder: (context, index) {
                return index == 0 ? categoryTab() : post(index - 1);
              },
            ),
          ),
        ),
        floatingActionButton: fab(),
      ),
    );
  }

  Widget categoryTab() {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: postCategories.length,
        itemBuilder: (_, i) => category(postCategories[i]),
        separatorBuilder: (_, __) {
          return const SizedBox(width: padding);
        },
      ),
    );
  }

  Widget post(int index) {
    return Container(
      decoration: bottomBorderBox,
      margin: const EdgeInsets.only(bottom: 7),
      height: 180,
      child: Column(
        children: [
          postInfo(index),
          postAction(index),
        ],
      ),
    );
  }

  Widget postInfo(int index) {
    Post post = controller.posts[index];

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // TODO : POST_DETAIL 로 넘어갈 때, 게시글을 특정할 수 있는 정보(id...)가 필요함
          Get.toNamed(
            Routes.POST_DETAIL,
            arguments: post,
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    eachPostCategory(post.category),
                    Text(
                      post.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: postContentStyle,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(post.writer.nickname, style: postDetailStyle),
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.fiber_manual_record,
                          size: 3,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        post.writer.mannerScore.toString(),
                        style: postDetailStyle,
                      ),
                    ],
                  ),
                  Text(
                    TimeUtil.timeAgo(post.createdDateTime),
                    style: postDetailStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget postAction(int index) {
    Post post = controller.posts[index];

    return Container(
      height: 45,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 0.9),
        ),
      ),
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          action("공감하기", Icons.add_reaction_outlined, null),
          SizedBox(width: 20),
          action(
            "답변하기",
            Icons.mode_comment_outlined,
            () => Get.toNamed(
              Routes.POST_DETAIL,
              arguments: post,
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryOption() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.tune_rounded,
          size: 20,
        ),
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget category(String content) {
    return Obx(
      () => ElevatedButton(
        onPressed: () {
          print('Community.category - 카테고리 검색 ($content)');
          controller.setCategory(content);
        },
        child: Text(content),
        style: controller.category.value != content
            ? unselectedPostCategoryBtn
            : selectedPostCategoryBtn,
      ),
    );
  }

  Widget action(String content, IconData icon, var func) {
    return GestureDetector(
      onTap: func,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey.shade600,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(content, style: postActionStyle),
          ),
        ],
      ),
    );
  }

  // Widget dropAction(String content, IconData icon, var func) {
  //   return DropdownButton<Icon>(
  //     value: controller.drop,
  //     onChanged: () {},
  //     items: <Icon>[],
  //
  //   );
  // }

  Widget eachPostCategory(String category) {
    return Container(
      // alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Text(
        category,
        style:
            TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      shape: const Border(
        bottom: BorderSide(
          color: Colors.black26,
          width: 0.5,
        ),
      ),
      title: Text("생활 공유", style: appBarTitle),
      elevation: 0,
      backgroundColor: Colors.white,
      // titleSpacing: 0.0,
    );
  }

  Widget fab() {
    return FloatingActionButton(
      backgroundColor: Colors.orange,
      onPressed: () => Get.toNamed(Routes.POST_REGISTER),
      child: const Icon(Icons.edit, size: 30),
    );
  }
}
