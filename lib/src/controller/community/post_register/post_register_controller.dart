import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:logger/logger.dart';
import 'package:share_delivery/src/controller/community/community_controller.dart';
import 'package:share_delivery/src/data/model/community/post/post.dart';
import 'package:share_delivery/src/data/model/community/post_detail/post_detail.dart';
import 'package:share_delivery/src/data/model/user/user_location/user_location.dart';
import 'package:share_delivery/src/data/repository/community/post_register/post_register_repository.dart';
import 'package:share_delivery/src/routes/route.dart';
import 'package:share_delivery/src/utils/get_snackbar.dart';

class PostRegisterController extends GetxController {
  PostRegisterRepository repository;

  PostRegisterController(
      {this.isRegisterPost = true, required this.repository});

  // 카테고리
  static const String initCategoryMsg = "글의 주제를 선택해주세요!";
  RxString category = initCategoryMsg.obs;

  // 글 내용
  Rx<TextEditingController> content = TextEditingController().obs;

  // 첨부 이미지
  var images = <String>[].obs;
  var prevImages = <String>[].obs;
  var deletedImages = <String>[];

  // UI 관련
  RxBool isAbleRegisterPost = false.obs;
  String appBarTitle = "생활 공유";
  bool isRegisterPost;

  @override
  onInit() {
    super.onInit();

    // 게시글 수정 모드
    if (!isRegisterPost) {
      appBarTitle = "글 수정하기";
    }
  }

  void setPostTopic(String category) {
    this.category.value = category;
    validateRegisterPost(content.value.text);
  }

  void validateRegisterPost(String text) {
    isAbleRegisterPost.value =
        text.trim().isNotEmpty && category.value != initCategoryMsg;
  }

  // 사진 선택
  Future<void> pickImage() async {
    if (images.length >= 10) {
      GetSnackbar.on("알림", "사진은 최대 10개까지 첨부할 수 있습니다!");
      return;
    }

    List<Media>? res = await ImagesPicker.pick(
      count: 10 - images.length,
      pickType: PickType.image,
    );

    if (res != null) {
      for (Media media in res) {
        images.add(media.path);
      }
    }

    Logger().i(images);
  }

  // 게시글 등록
  Future<void> registerPost() async {
    if (content.value.text.trim().isEmpty) {
      GetSnackbar.on("알림", "내용을 채워주세요.");
      return;
    }
    if (category.value.isEmpty || category.value == initCategoryMsg) {
      GetSnackbar.on("알림", "주제를 선택해주세요.");
      return;
    }
    UserLocation? userLocation = repository.getUserLocation();
    if (userLocation == null) {
      GetSnackbar.on("알림", "위치 설정을 먼저 해주세요!");
      return;
    }

    Post? post = await repository.registerPost(
      userLocation,
      content.value.text,
      category.value,
      images,
    );

    if (post == null) {
      GetSnackbar.err("오류", "다시 시도해주세요!");
    } else {
      CommunityController.to.addPost(post);
      Get.until((route) => Get.currentRoute == Routes.INITIAL);
      Get.toNamed(Routes.POST_DETAIL, arguments: post);
    }
  }

  // 게시글 수정
  Future<void> updatePost(int postId) async {
    Get.context!.loaderOverlay.show();
    print('PostRegisterController.updatePost - postId: $postId');

    if (content.value.text.trim().isEmpty) {
      GetSnackbar.on("알림", "내용을 채워주세요.");
      return;
    }
    if (category.value.isEmpty || category.value == initCategoryMsg) {
      GetSnackbar.on("알림", "주제를 선택해주세요.");
      return;
    }
    UserLocation? userLocation = repository.getUserLocation();
    if (userLocation == null) {
      GetSnackbar.on("알림", "위치 설정을 먼저 해주세요!");
      return;
    }

    Post? post = await repository.updatePost(
      postId,
      userLocation,
      content.value.text,
      category.value,
      deletedImages,
      images,
    );

    if (post == null) {
      Get.context!.loaderOverlay.hide();
      GetSnackbar.err("오류", "다시 시도해주세요!");
    } else {
      CommunityController.to.updatePost(post);

      await 0.5.delay();
      Get.context!.loaderOverlay.hide();
      Get.until((route) => Get.currentRoute == Routes.INITIAL);

      await 0.5.delay();
      Get.toNamed(Routes.POST_DETAIL, arguments: post);
    }
  }

  void deleteImage(String targetImageURL) {
    if (images.contains(targetImageURL)) {
      images.remove(targetImageURL);
      return;
    }

    prevImages.remove(targetImageURL);
    deletedImages.add(targetImageURL);
  }

  void loadPostAndPostDetail(Post post, PostDetail postDetail) {
    content.value.text = post.content;
    content.value.selection = TextSelection.fromPosition(
        TextPosition(offset: content.value.text.length));

    print('PostRegisterController.loadPostAndPostDetail');

    category.value = post.category;
    prevImages.value = postDetail.images.toList();
    // deletedImages = postDetail.images;

    validateRegisterPost(post.content);
    // sharePlace.value = postDetail.sharePlace
  }
}
