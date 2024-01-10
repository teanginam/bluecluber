import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tttttt/%ED%85%8C%EC%8A%A4%ED%8A%B8%EC%9A%A9/testscreen.dart';

class ClubDetailPage extends StatelessWidget {
  const ClubDetailPage({super.key, required this.id});
  final String id;
  
  @override
  Widget build(BuildContext context) {
        final post =
        Provider.of<ClubProvider>(context).clubList.firstWhere((post) => post.id == id);
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Column(
        children: [
          Text(post.category),
          Text(post.id),
          Text(post.information),
          Text(post.introduction),
          Text(post.name),
          Text(post.tag),
        ],
      )),
    );
  }
}