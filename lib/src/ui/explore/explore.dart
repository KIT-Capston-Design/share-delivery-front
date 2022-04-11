import 'package:flutter/material.dart';
import 'package:share_delivery/src/controller/root_controller.dart';
import 'package:share_delivery/src/ui/explore/explore_detail_page.dart';

class Explore extends StatelessWidget {
  const Explore({Key? key}) : super(key: key);

  Widget _categoryMenu(BuildContext context) {
    return Wrap(
      children: [
        GestureDetector(
          onTap: () {
            RootController.to.setCategoryPage(true);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ExploreDetailPage(),
              ),
            );
          },
          child: Container(
            height: 30,
            width: 70,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.grey),
          ),
        ),
        Container(
          height: 30,
          width: 70,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.grey),
        ),
        Container(
          height: 30,
          width: 70,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.grey),
        ),
        Container(
          height: 30,
          width: 70,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.grey),
        ),
        Container(
          height: 30,
          width: 70,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.grey),
        ),
        Container(
          height: 30,
          width: 70,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.grey),
        ),
      ],
    );
  }

  Widget _list() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
            20,
            (index) => Container(
              height: 200,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _categoryMenu(context),
        Expanded(child: _list()),
      ],
    );
  }
}
