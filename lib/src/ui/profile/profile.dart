import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_delivery/src/controller/login/authentication_controller.dart';
import 'package:share_delivery/src/controller/profile/profile_controller.dart';
import 'package:share_delivery/src/data/model/user/user/user.dart';
import 'package:share_delivery/src/routes/route.dart';
import 'package:share_delivery/src/ui/theme/profile_theme.dart';
import 'package:share_delivery/src/utils/image_util.dart';

class Profile extends GetView<ProfileController> {
  Profile({Key? key}) : super(key: key);

  User user = AuthenticationController.to.state.props.first as User;

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "프로필",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          child: Container(
            color: Colors.grey.shade300,
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(1.0),
        ),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.message, size: 30),
            onPressed: () => Get.toNamed(Routes.ALARM),
          ),
          IconButton(
            icon: Icon(Icons.settings, size: 30),
            onPressed: () => Get.toNamed(Routes.APP_SETTING),
          )
        ],
      ),
      body: SmartRefresher(
        controller: controller.refreshController,
        onRefresh: controller.onRefresh,
        enablePullDown: true,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.grey.shade200,
            child: Column(
              children: [
                _buildProfile(),
                _buildMenuList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      color: Colors.white,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Get.toNamed(
                    Routes.EXPANDED_IMAGE_PAGE,
                    arguments: {
                      "imagePath": user.profileImageUrl == ''
                          ? randomProfileImage()
                          : user.profileImageUrl,
                      "title": "프로필 사진"
                    },
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: user.profileImageUrl == ''
                        ? randomProfileImage()
                        : customNetworkImage(user.profileImageUrl),
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      user.nickname, // TODO: 닉네임
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                side: BorderSide(
                  color: Colors.grey.shade300,
                ),
                elevation: 0.0,
                minimumSize: Size.fromHeight(45.0),
              ),
              onPressed: () => Get.toNamed(Routes.MODIFY_PROFILE),
              child: Text(
                "프로필 수정",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "매너온도",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16.0,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: LinearPercentIndicator(
                    lineHeight: 18.0,
                    percent: user.mannerScore / 100,
                    center: Text(
                      "${user.mannerScore}°C",
                      style: TextStyle(fontSize: 12.0),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.mood,
                        size: 25,
                      ),
                    ),
                    backgroundColor: Colors.grey.shade300,
                    progressColor: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuListTile(String title, VoidCallback onTapCB) {
    return ListTile(
      onTap: onTapCB,
      tileColor: Colors.orangeAccent,
      selectedTileColor: Colors.brown,
      title: Text(
        title,
        style: profileTextStyle,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 20,
      ),
    );
  }

  Widget _buildMenuList() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.white,
      child: Column(
        children: [
          ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              buildMenuListTile(
                  "계좌 관리", () => Get.toNamed(Routes.ACCOUNT_MANAGE)),
              Divider(),
              buildMenuListTile("친구 관리", () => Get.toNamed(Routes.FRIEND)),
            ],
          ),
        ],
      ),
    );
  }
}
