import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_delivery/src/data/model/community/post/post.dart';
import 'package:share_delivery/src/data/model/user/user_location/user_location.dart';
import 'package:share_delivery/src/data/provider/community/community_repository.dart';
import 'package:share_delivery/src/utils/categories.dart';
import 'package:share_delivery/src/utils/get_snackbar.dart';

class CommunityController extends GetxController {
  static CommunityController get to => Get.find();

  CommunityRepository repository;

  CommunityController({required this.repository});

  // UI 관련
  Rx<RefreshController> refresher = RefreshController(initialRefresh: true).obs;

  // 게시글 관련
  RxString category = postCategories[0].obs;
  var posts = <Post>[
    Post(
      category: postCategories[2],
      content: '매운간장 먹고싶습니다',
      writer: Writer(
          nickname: '아구몬', accountId: 123, mannerScore: 36.5, profileImage: ''),
      createdDateTime: DateTime.now(),
      postId: 13,
    ),
  ].obs;
  UserLocation? userLocation;

  Future<void> onRefresh() async {
    print('CommunityController.onRefresh - 1');
    if (!isExistUserLocation()) {
      refresher.value.refreshFailed();
      return;
    }

    try {
      List<Post> result = [];
      if (category.value == postCategories[0]) {
        result = await repository.refreshPost(userLocation!);
      } else {
        result = await repository.refreshPostByCategory(
            userLocation!, category.value);
      }

      // TODO : 임시로 해둠 = 삭제할 것
      await Future.delayed(Duration(milliseconds: 500));
      print('CommunityController.onRefresh - 3');
      posts.value = result;

      if (posts.value.isEmpty) {
        // GetSnackbar.on("알림", "검색된 게시글이 없습니다!");
        refresher.value.loadNoData();
        refresher.value.refreshFailed();
        return;
      }

      // TODO : 아래 코드 삭제할 것
      // posts.add(Post(
      //   category: '',
      //   content: '',
      //   writer: Writer(accountId: 123, nickname: '', mannerScore: 13),
      //   createdDateTime: DateTime.now(),
      //   postId: 123,
      // ));

      refresher.value.resetNoData();
      refresher.value.refreshCompleted();
    } catch (e) {
      print(e);
      refresher.value.refreshFailed();
    }
  }

  void onLoading() async {
    print('CommunityController.onLoading');
    if (!isExistUserLocation()) {
      refresher.value.loadFailed();
      return;
    }

    if (posts.isEmpty) {
      onRefresh();
      return;
    }

    try {
      List<Post> result = [];
      if (category.value == postCategories[0]) {
        result = await repository.loadingPost(
            userLocation!, posts.last.createdDateTime);
      } else {
        result = await repository.loadingPostByCategory(
            userLocation!, category.value, posts.last.createdDateTime);
      }

      // TODO : 임시로 해둠 = 삭제할 것
      await Future.delayed(Duration(milliseconds: 500));

      if (result.isEmpty) {
        // GetSnackbar.on("알림", "검색된 게시글이 없습니다!");
        refresher.value.loadNoData();
        return;
      }

      posts.value = result;
      posts.add(Post(
        category: '',
        content: '',
        writer: Writer(
            accountId: 123, nickname: '', mannerScore: 13, profileImage: ''),
        createdDateTime: DateTime.now(),
        postId: 123,
      ));

      refresher.value.loadComplete();
    } catch (e) {
      print(e);
      refresher.value.loadFailed();
    }
  }

  void setCategory(String category) {
    this.category.value =
        this.category.value != category ? category : postCategories[0];
    onRefresh();
  }

  bool isExistUserLocation() {
    userLocation ??= repository.getCurrentUserLocation();
    Logger().i(userLocation);

    if (userLocation == null) {
      GetSnackbar.on("알림", "위치 설정을 먼저 해주세요!");
      return false;
    }

    return true;
  }

  void addPost(Post post) {
    posts.insert(0, post);
  }

  void updatePost(Post post) {
    for (int i = 0; i < posts.length; i++) {
      if (posts[i].postId == post.postId) {
        posts[i] = post;

        return;
      }
    }
  }
}
