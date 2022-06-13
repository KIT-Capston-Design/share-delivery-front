import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_delivery/src/controller/community/post_register/post_register_controller.dart';
import 'package:share_delivery/src/routes/route.dart';
import 'package:share_delivery/src/utils/image_util.dart';

class PostImage extends StatelessWidget {
  final int index;
  final List<String> imageURLs;
  final bool deleteButton;
  final double size;
  final double margin;

  const PostImage({
    Key? key,
    required this.index,
    required this.imageURLs,
    required this.deleteButton,
    required this.size,
    required this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('PostImage.build - $index');
    String imageURL = imageURLs[index];

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.EXPANDED_POST_IMAGE,
          arguments: {"imagesPath": imageURLs, "initPage": index},
        );
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(margin),
            width: size,
            height: size,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: imageURL.startsWith("/images")
                    ? NetworkImage(imagePathWithHost(imageURL))
                    : FileImage(File(imageURL)) as ImageProvider,
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Colors.grey,
            ),
          ),
          deleteButton
              ? Positioned(
                  right: -10,
                  top: -10,
                  child: IconButton(
                    onPressed: () {
                      Get.find<PostRegisterController>().deleteImage(imageURL);
                    },
                    icon: Icon(
                      Icons.cancel_rounded,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
