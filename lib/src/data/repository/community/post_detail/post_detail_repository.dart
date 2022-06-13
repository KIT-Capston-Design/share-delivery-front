import 'package:share_delivery/src/data/model/community/comment/comment.dart';
import 'package:share_delivery/src/data/model/community/comment/comment_update_request_dto.dart';
import 'package:share_delivery/src/data/model/community/comment_register_request_dto/comment_register_request_dto.dart';
import 'package:share_delivery/src/data/model/community/post_detail/post_detail.dart';
import 'package:share_delivery/src/data/model/community/toggle_like_response_dto/toggle_like_response_dto.dart';
import 'package:share_delivery/src/data/provider/community/post/community_api_client.dart';

class PostDetailRepository {
  CommunityApiClient apiClient;

  PostDetailRepository({required this.apiClient});

  // 게시글 상세정보 조회
  Future<PostDetail> findDetailById(int postId) async {
    PostDetail postDetail = await apiClient.findPostDetailById(postId);
    print('PostDetailRepository.findDetailById - $postDetail');
    return postDetail;
  }

  // 게시글 댓글 조회
  Future<List<Comment>> findCommentById(int postId) async {
    return await apiClient.findComment(postId);
  }

  // 게시글 삭제
  Future<void> deletePost(int postId) async {
    print('PostDetailRepository.deletePost');
    await apiClient.deletePost(postId);
  }

  // 게시글 좋아요
  Future<PostLikeResponseDTO> togglePostLike(int postId) async {
    return await apiClient.togglePostLike(postId);
  }

  // 댓글 등록
  Future<Comment> sendComment(int postId, String content,
      [int? parentId]) async {
    CommentRegisterRequestDTO commentRegisterRequestDTO =
        CommentRegisterRequestDTO(
      postId: postId,
      parentId: parentId,
      content: content,
    );

    return await apiClient.registerComment(commentRegisterRequestDTO);
  }

  // 댓글 수정
  Future<void> updateComment(int commentId, String content) async {
    await apiClient.updateComment(
      commentId,
      CommentUpdateRequestDTO(content: content),
    );
  }

  // 댓글 삭제
  Future<void> deleteComment(int commentId) async {
    print('PostDetailRepository.deleteComment');
    await apiClient.deleteComment(commentId);
  }

  // 댓글 좋아요
  Future<CommentLikeResponseDTO> toggleCommentLike(int commentId) async {
    return await apiClient.toggleCommentLike(commentId);
  }

  // 게시글 신고
  void reportPost(int postId) {
    // TODO: 게시글 신고 로직
  }

  // 댓글 신고
  void reportComment(int commentId) {
    // TODO: 댓글 신고 로직
  }

  // // 대댓글 등록
  // Future<Comment> sendChildComment(String content, int parentId) async {
  //   CommentRegisterRequestDTO commentRegisterRequestDTO =
  //       CommentRegisterRequestDTO(parentId: parentId, content: content);
  //
  //   return await apiClient.registerComment(commentRegisterRequestDTO);
  // }
}
