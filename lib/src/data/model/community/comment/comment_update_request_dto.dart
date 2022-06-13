import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_update_request_dto.freezed.dart';
part 'comment_update_request_dto.g.dart';

@Freezed()
class CommentUpdateRequestDTO with _$CommentUpdateRequestDTO {
  const factory CommentUpdateRequestDTO({
    required String content,
  }) = _CommentUpdateRequestDTO;

  factory CommentUpdateRequestDTO.fromJson(Map<String, dynamic> json) =>
      _$CommentUpdateRequestDTOFromJson(json);
}
