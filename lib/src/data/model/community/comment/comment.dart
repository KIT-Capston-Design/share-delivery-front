import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:share_delivery/src/data/model/community/post/post.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

@Freezed()
class Comment with _$Comment {
  const factory Comment({
    required Writer writer,
    required int id,
    required int parentId,
    required String content,
    required int likes,
    required bool isLiked,
    required DateTime createdDateTime,
    required String state,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}
