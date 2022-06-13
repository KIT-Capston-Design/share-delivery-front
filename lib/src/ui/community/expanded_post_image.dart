import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_delivery/src/utils/image_util.dart';

class ExpandedPostImage extends StatefulWidget {
  const ExpandedPostImage({Key? key}) : super(key: key);

  @override
  State<ExpandedPostImage> createState() => _ExpandedPostImageState();
}

class _ExpandedPostImageState extends State<ExpandedPostImage> {
  late final PageController pageController;
  List<String> imagesURL = [];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: Get.arguments['initPage']);
    imagesURL = Get.arguments['imagesPath'];
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: imagesURL.length,
      itemBuilder: (context, i) => expandedImage(i),
    );
  }

  Widget expandedImage(int i) {
    String imageURL = imagesURL[i];

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: imageURL.startsWith("/images")
              ? NetworkImage(imagePathWithHost(imageURL))
              : FileImage(File(imageURL)) as ImageProvider, // 배경 이미지
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 35,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
    );
  }
}
