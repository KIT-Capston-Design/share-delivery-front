import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_delivery/src/utils/image_util.dart';

class ExpandedImagePage extends StatelessWidget {
  const ExpandedImagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageURL = Get.arguments['imagePath'];
    String title = Get.arguments['title'];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.grey.shade300,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.grey,
            image: DecorationImage(
                fit: BoxFit.cover, image: customNetworkImage(imageURL)),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }
}
