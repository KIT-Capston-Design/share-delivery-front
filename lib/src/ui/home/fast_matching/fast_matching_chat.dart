import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_delivery/src/ui/home/fast_matching/fast_matching_chat_controller.dart';

class FastMatchingChat extends GetView<FastMatchingChatController> {
  const FastMatchingChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(FastMatchingChatController());

    return SafeArea(child: Scaffold());
  }
}
