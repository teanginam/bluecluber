import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tttttt/%ED%85%8C%EC%8A%A4%ED%8A%B8%EC%9A%A9/clubDetailPage.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("List Page"),
        ),
        body: FutureBuilder(
            future: Provider.of<ClubProvider>(context, listen: false).fetchClubList(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<ClubProvider>(
                      builder: (context, provider, _) => ListView.builder(
                          itemCount: provider.clubList.length,
                          itemBuilder: ((_, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ClubDetailPage(
                                          id: provider.clubList[index].id)),
                                );
                              },
                              child: SizedBox(
                                  height: 100,
                                  child: Card(
                                      child: Center(
                                          child: Text(
                                              provider.clubList[index].name)))),
                            );
                          })));
            }));
  }
}

//-----------------------class----------------------
class Club {
  final String id;
  final String category;
  final String name;
  final String information;
  final String introduction;
  final String tag;

  Club({
    required this.id,
    required this.category,
    required this.name,
    required this.information,
    required this.introduction,
    required this.tag,
  });

  factory Club.fromJson(Map<String, dynamic> json, String id) {
    return Club(
      id : id,
      category: json['category'] ?? '',
      name: json['name'] ?? '',
      information: json['information'] ?? '',
      introduction: json['introduction'] ?? '',
      tag: json['tag'] ?? '',
    );
  }
}

//-----------------------Provider----------------------
class ClubProvider with ChangeNotifier {
  final List<Club> _clubList = [];
  List<Club> get clubList => _clubList;

  //동아리 데이터 받아오는 메서드
  Future<void> fetchClubList() async {
    var db = FirebaseFirestore.instance;
    var querySnapshot = await db.collection("Club").get();
    final List<Club> result =
        querySnapshot.docs.map((e) => Club.fromJson(e.data(), e.id)).toList();
    
    _clubList.clear();
    _clubList.addAll(result);
    notifyListeners();
  }
}
