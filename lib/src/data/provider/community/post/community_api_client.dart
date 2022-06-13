import 'dart:convert';
import 'dart:io';

import "package:dio/dio.dart";
import "package:retrofit/retrofit.dart";
import 'package:share_delivery/src/data/model/community/comment/comment.dart';
import 'package:share_delivery/src/data/model/community/comment/comment_update_request_dto.dart';
import 'package:share_delivery/src/data/model/community/comment_register_request_dto/comment_register_request_dto.dart';
import 'package:share_delivery/src/data/model/community/post/post.dart';
import 'package:share_delivery/src/data/model/community/post_detail/post_detail.dart';
import 'package:share_delivery/src/data/model/community/post_register_request_dto/post_register_request_dto.dart';
import 'package:share_delivery/src/data/model/community/post_update_request_dto/post_update_request_dto.dart';
import 'package:share_delivery/src/data/model/community/toggle_like_response_dto/toggle_like_response_dto.dart';

part 'community_api_client.g.dart';

@RestApi(baseUrl: "http://kitcapstone.iptime.org:8080")
abstract class CommunityApiClient {
  factory CommunityApiClient(Dio dio, {String baseUrl}) = _CommunityApiClient;

  // 게시글 등록
  @POST("/api/posts")
  @MultiPart()
  Future<Post> registerPost(
    @Part(name: "post") PostRegisterRequestDTO postRegisterRequestDTO,
    @Part(name: "postImages") List<File> postImages,
  );

  // 게시글 조회
  @GET("/api/posts")
  Future<List<Post>> findPost(@Query("latitude") double latitude,
      @Query("longitude") double longitude, @Query("radius") int radius,
      [@Query("lastCreatedDate") String? lastCreatedDate]);

  // 주제로 게시글 조회
  @GET("/api/posts")
  Future<List<Post>> findPostByCategory(
      @Query("latitude") double latitude,
      @Query("longitude") double longitude,
      @Query("radius") int radius,
      @Query("category") String category,
      [@Query("lastCreatedDate") String? lastCreatedDate]);

  // 게시글 상세정보 조회
  @GET("/api/posts/{postId}")
  Future<PostDetail> findPostDetailById(
    @Path() int postId,
  );

  // 게시글 수정
  @PATCH("/api/posts/{postId}")
  @MultiPart()
  Future<Post> updatePost(
    @Path() int postId,
    @Part(name: "post") PostUpdateRequestDTO postUpdateRequestDTO,
    @Part(name: "postImages") List<File> postImages,
  );

  // 게시글 삭제
  @DELETE("/api/posts/{postId}")
  Future<void> deletePost(
    @Path() int postId,
  );

  // 게시글 좋아요
  @POST("/api/posts/{postId}/toggle-likes")
  Future<PostLikeResponseDTO> togglePostLike(
    @Path() int postId,
  );

  // 댓글 등록
  @POST("/api/comments")
  Future<Comment> registerComment(
    @Body() CommentRegisterRequestDTO comment,
  );

  // 댓글 조회
  @GET("/api/comments/{postId}")
  Future<List<Comment>> findComment(
    @Path() int postId,
  );

  // 댓글 수정
  @PATCH("/api/comments/{commentId}")
  Future<Comment> updateComment(
    @Path() int commentId,
    @Body() CommentUpdateRequestDTO comment,
  );

  // 댓글 삭제
  @DELETE("/api/comments/{commentId}")
  Future<void> deleteComment(
    @Path() int commentId,
  );

  // 댓글 좋아요
  @POST("/api/comments/{commentId}/toggle-likes")
  Future<CommentLikeResponseDTO> toggleCommentLike(
    @Path() int commentId,
  );
}
