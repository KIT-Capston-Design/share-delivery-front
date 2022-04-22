import 'package:flutter/material.dart';

class DeliveryHistory extends StatelessWidget {
  const DeliveryHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.separated(
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {},
          child: DeliveryHistoryPost(),
        ),
        separatorBuilder: (_, index) => Divider(
          endIndent: 20,
          indent: 20,
          color: Colors.grey.shade300,
          height: 0.5,
          thickness: 1,
        ),
        itemCount: 20,
      ),
    );
  }
}

class DeliveryHistoryPost extends StatelessWidget {
  const DeliveryHistoryPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://cdn.pixabay.com/photo/2016/01/22/02/13/meat-1155132__340.jpg')),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Colors.grey,
                ),
              ),
              Center(
                child: Container(
                  width: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                  ),
                  child: Text("인원 모집중"),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              // color: Colors.yellow,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "제목(내용)",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    children: [
                      Text("수령장소"),
                      SizedBox(
                        height: 10,
                        child:
                            VerticalDivider(thickness: 1, color: Colors.grey),
                      ),
                      Text("5분전"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("메뉴 이름"),
                  Text("메뉴 가격"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.people,
                      ),
                      Text("4 / 4")
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
