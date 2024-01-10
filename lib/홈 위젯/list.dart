import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tttttt/datalist/club.dart' as datalist;

import '../pages/list_page.dart';

class MyCircle extends StatelessWidget {
  final int setnum;
  const MyCircle(this.setnum, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> categories = datalist.categories;
    int returnindex = setnum;
    String categoriesname = categories[setnum].toString();
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 15),
      child: GestureDetector(
        onTap: () async {
          Get.to(ListPage(returnindex));
        },
        child: Column(children: [
          Container(
            width: 70,
            height: 70,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blue[900]),
            child: Center(
                child: Text(
              categoriesname.substring(0, 2),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            )),
          ),
          const SizedBox(
            height: 11,
          ),
          Text(
            categories[setnum],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          )
        ]),
      ),
    );
  }
}