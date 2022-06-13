import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@Freezed()
class Post with _$Post {
  const factory Post({
    required int postId,
    required Writer writer,
    required String content,
    required String category,
    required DateTime createdDateTime,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}

@Freezed()
class Writer with _$Writer {
  const factory Writer({
    required int accountId,
    required String nickname,
    required double mannerScore,
    @Default("") String profileImage,
  }) = _Writer;

  factory Writer.fromJson(Map<String, dynamic> json) => _$WriterFromJson(json);
}
