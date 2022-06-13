import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:share_delivery/src/controller/community/community_controller.dart';
import 'package:share_delivery/src/controller/login/authentication_controller.dart';
import 'package:share_delivery/src/data/model/community/comment/comment.dart';
import 'package:share_delivery/src/data/model/community/post/post.dart';
import 'package:share_delivery/src/data/model/community/post_detail/post_detail.dart';
import 'package:share_delivery/src/data/model/community/toggle_like_response_dto/toggle_like_response_dto.dart';
import 'package:share_delivery/src/data/model/user/user/user.dart';
import 'package:share_delivery/src/data/repository/community/post_detail/post_detail_repository.dart';
import 'package:share_delivery/src/routes/route.dart';
import 'package:share_delivery/src/utils/get_snackbar.dart';

enum PostDetailUI {
  undecided,
  writer,
  reader,
}

enum LoadingStatus {
  none,
  loading,
  complete,
  error,
}

class PostDetailController extends GetxController {
  PostDetailRepository repository;

  PostDetailController({required this.repository});

  final isLoad = false.obs;

  @override
  void onInit() async {
    super.onInit();
    postInfo.value.post = Get.arguments;

    loadingStatus.value = LoadingStatus.loading;

    await findPostDetail();
    await findComment();
    initUiType();
    isLoad.value = true;
    loadingStatus.value = LoadingStatus.complete;
  }

  // UI 관련
  PostDetailUI uiType = PostDetailUI.undecided;
  Rx<LoadingStatus> loadingStatus = LoadingStatus.none.obs;
  int currentUserId = -1;
  RxBool onSendComment = false.obs;
  RxBool isLikedPost = false.obs;
  RxInt currentWritingCommentParentId = (-1).obs;

  // late final Post post;
  // PostDetail? postDetail;

  var postInfo = PostInfo().obs;

  var comments = <Comment>[].obs;

  TextEditingController commentTextField = TextEditingController();

  // 작성자/읽는이 UI 다르게 만들기
  void initUiType() {
    print('PostDetailController.findPostDetail');

    try {
      User user = AuthenticationController.to.state.props.first as User;

      print("게시글 상세조회 UI 타입 변경 - User : $user");

      if (user.accountId == postInfo.value.post!.writer.accountId) {
        // 글쓴이 == 사용자  --->  작성자 UI
        uiType = PostDetailUI.writer;
      } else {
        // 글쓴이 != 사용자  --->  읽는이 UI
        uiType = PostDetailUI.reader;
      }

      // 댓글의 사용자 여부 확인을 위해서 현재 유저 id 저장
      currentUserId = postInfo.value.post!.writer.accountId;
    } catch (e) {
      print("게시글 상세조회 UI 타입 변경 에러  -  $e");
    }
  }

  // 게시글 상세정보 가져오기
  Future<void> findPostDetail() async {
    postInfo.value.postDetail =
        await repository.findDetailById(postInfo.value.post!.postId);
    Logger().v(postInfo.value.postDetail);
    isLikedPost.value = postInfo.value.postDetail!.isLiked;
  }

  // 게시글의 댓글 가져오기
  Future<void> findComment() async {
    Map<int, List<Comment>> mp = {};

    List<Comment> list =
        await repository.findCommentById(postInfo.value.post!.postId);

    list.sort((a, b) => a.createdDateTime.isBefore(b.createdDateTime) ? -1 : 1);

    for (int i = 0; i < list.length; i++) {
      if (!mp.containsKey(list[i].parentId)) {
        mp[list[i].parentId] = <Comment>[];
      }

      mp[list[i].parentId]!.add(list[i]);
    }

    List<List<Comment>> mpList = <List<Comment>>[];
    mp.forEach((k, e) => mpList.add(e));
    mpList.sort((a, b) =>
        a.first.createdDateTime.isBefore(b.first.createdDateTime) ? -1 : 1);

    comments.value = mpList.expand((x) => x).toList();
  }

  // 게시글 삭제
  Future<void> deletePost() async {
    // TODO : 게시글 삭제되면 화면을 커뮤니티로 이동해야함
    await repository.deletePost(postInfo.value.post!.postId);

    // 게시글 삭제되면 커뮤니티 화면으로 이동
    await CommunityController.to.onRefresh();

    Get.until((route) => Get.currentRoute == Routes.INITIAL);
  }

  // 게시글 좋아요
  Future<void> togglePostLike(int postId) async {
    PostLikeResponseDTO postLikeResponseDTO =
        await repository.togglePostLike(postId);

    if (postInfo.value.isEmpty()) {
      await findPostDetail();
    }

    postInfo.value.postDetail = postInfo.value.postDetail!.copyWith(
      likes: postLikeResponseDTO.likes,
      isLiked: postLikeResponseDTO.isLiked,
    );

    isLikedPost.value = postLikeResponseDTO.isLiked;
  }

  // 게시글 신고
  Future<void> reportPost() async {
    print('PostDetailController.reportPost - 게시글 신고');
    repository.reportPost(postInfo.value.post!.postId);
  }

  // 댓글 작성
  Future<void> sendComment([int? parentId]) async {
    if (commentTextField.text.trim().isEmpty) {
      GetSnackbar.on("알림", "공백은 댓글로 입력할 수 없습니다.");
      return;
    }

    String text = commentTextField.text;
    commentTextField.clear();
    setOnSendComment(commentTextField.text.isNotEmpty);
    FocusManager.instance.primaryFocus?.unfocus();

    Comment? comment = await repository.sendComment(
      postInfo.value.post!.postId,
      text,
      parentId,
    );

    await findComment();
    await 0.3.delay();
  }

  // 댓글 삭제
  Future<void> deleteComment(int commentId) async {
    print('PostDetailController.deleteComment');
    await repository.deleteComment(commentId);
    findComment();
  }

  // 댓글 좋아요
  Future<void> toggleCommentLike(Comment comment) async {
    CommentLikeResponseDTO commentLikeResponseDTO =
        await repository.toggleCommentLike(comment.id);

    if (postInfo.value.isEmpty()) {
      await findPostDetail();
    }

    print('PostDetailController.toggleCommentLike');
    comment = comment.copyWith(
      likes: commentLikeResponseDTO.likes,
      isLiked: commentLikeResponseDTO.isLiked,
    );

    changeCommentStatus(comment);
  }

  // 댓글 신고
  Future<void> reportComment(int commentId) async {
    print('PostDetailController.reportComment - 댓글 신고');
    repository.reportComment(commentId);
  }

  bool isParentComment(int idx) {
    return comments[idx].parentId == comments[idx].id;
  }

  bool isLastComment(int idx) {
    return comments.length - 1 == idx;
  }

  bool onWriteCommentBar(Comment cur) {
    // Comment cur = comments[idx];

    if (cur.id == cur.parentId) return false;

    int? parentId = cur.parentId;

    for (Comment comment in comments) {
      if (comment.parentId != parentId || comment.id == cur.id) continue;

      if (comment.createdDateTime.isAfter(cur.createdDateTime)) return false;
    }

    return true;
  }

  void setOnSendComment(bool onSendComment) {
    this.onSendComment.value = onSendComment;
  }

  List<Comment> getCommentGroup(int parentId) {
    List<Comment> list = [];

    for (Comment comment in comments) {
      if (comment.parentId == parentId) {
        list.add(comment);
      }
    }

    return list;
  }

  void changeCommentStatus(Comment comment) {
    for (int i = 0; i < comments.length; i++) {
      if (comment.id == comments[i].id) {
        comments[i] = comment.copyWith();
        return;
      }
    }
  }

  // 현재 수정 중인 댓글
  Comment? currentEditComment;
  Rx<TextEditingController> commentEditController = TextEditingController().obs;
  RxBool isAbleEditComment = true.obs;

  // 현재 수정 중인 댓글 변경
  void setCurrentEditComment(Comment comment) {
    currentEditComment = comment;
    commentEditController.value.clear();
    commentEditController.value.text = currentEditComment!.content;
  }

  // 댓글 수정을 위한 검증 (공백 X)
  void validateEditComment(String text) {
    isAbleEditComment.value = text.trim().isNotEmpty;
  }

  // 댓글 수정
  Future<void> updateComment() async {
    if (currentEditComment == null) return;

    await repository.updateComment(
      currentEditComment!.id,
      commentEditController.value.text,
    );

    currentEditComment = null;

    // 댓글 수정이 끝나면 다시 post_detail 화면으로 이동
    findComment();
    Get.back();
  }
}

class PostInfo {
  Post? post;
  PostDetail? postDetail;

  PostInfo({this.post, this.postDetail});

  bool isEmpty() {
    return post == null || postDetail == null;
  }

  bool isNotEmpty() {
    return !isEmpty();
  }
}
