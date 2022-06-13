import 'dart:io';

import 'package:logger/logger.dart';
import 'package:share_delivery/src/data/model/community/post/post.dart';
import 'package:share_delivery/src/data/model/community/post_register_request_dto/post_register_request_dto.dart';
import 'package:share_delivery/src/data/model/community/post_update_request_dto/post_update_request_dto.dart';
import 'package:share_delivery/src/data/model/user/user_location/user_location.dart';
import 'package:share_delivery/src/data/provider/community/post/community_api_client.dart';
import 'package:share_delivery/src/data/provider/widgets/user_location_local_client.dart';
import 'package:share_delivery/src/utils/image_util.dart';

class PostRegisterRepository {
  CommunityApiClient apiClient;
  UserLocationLocalClient userLocationLocalClient;

  PostRegisterRepository({
    required this.apiClient,
    required this.userLocationLocalClient,
  });

  Future<Post?> registerPost(
    UserLocation userLocation,
    String content,
    String category,
    List<String> images,
  ) async {
    // TODO: 위치 공유 넣기

    // 글 작성 위치 == 사용자 위치
    PostLocation coordinate = PostLocation(
      latitude: userLocation.latitude,
      longitude: userLocation.longitude,
    );

    // 작성할 글
    PostRegisterRequestDTO post = PostRegisterRequestDTO(
      coordinate: coordinate,
      content: content,
      category: category,
    );

    Logger().i(post);

    // 이미지
    List<File> postImages = [];
    for (int i = 0; i < images.length; i++) {
      postImages.add(File(images[i]));
      print(
          'PostRegisterRepository.registerPost - image file - ${File(images[i])}');
    }

    // 글 작성 요청
    Post? result = await apiClient.registerPost(post, postImages).then((value) {
      Logger().i(value);
      return value;
    }).catchError((err) {
      Logger().e(err);
      return null;
    });

    return result;
  }

  // 게시글 수정
  Future<Post?> updatePost(
    int postId,
    UserLocation userLocation,
    String content,
    String category,
    List<String> deletedImages,
    List<String> images,
  ) async {
    // TODO: 위치 공유 넣기

    // 글 작성 위치 == 사용자 위치
    PostLocation coordinate = PostLocation(
      latitude: userLocation.latitude,
      longitude: userLocation.longitude,
    );

    // 작성할 글
    PostUpdateRequestDTO post = PostUpdateRequestDTO(
      coordinate: coordinate,
      category: category,
      content: content,
      deletedImages: deletedImages,
    );

    // 이미지
    Logger().i(images);

    List<File> postImages = [];
    for (int i = 0; i < images.length; i++) {
      String imageURL = images[i];
      if (imageURL.startsWith("/images")) {
        File remoteImage = File(imagePathWithHost(images[i]));
        remoteImage.renameSync(images[i]);
        postImages.add(remoteImage);
      } else {
        postImages.add(File(images[i]));
      }
    }

    Logger().i(postImages);

    print('PostRegisterRepository.updatePost - $post');

    // 글 수정 요청
    Post? result =
        await apiClient.updatePost(postId, post, postImages).then((value) {
      Logger().i(value);
      return value;
    }).catchError((err) {
      Logger().e(err);
      return null;
    });

    return result;
  }

  UserLocation? getUserLocation() {
    return userLocationLocalClient.findOne();
  }
}
