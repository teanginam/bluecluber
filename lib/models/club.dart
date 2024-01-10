import 'package:cloud_firestore/cloud_firestore.dart';

class Club {
  final String id;
  final String category;
  final String name;
  final String information;
  final String introduction;
  final String tag;
  String imgUrl;
  List<String> member;
  List<String> applicationList;
  DateTime applicationPeriodStart;
  DateTime applicationPeriodEnd;

  Club(
      {required this.id,
      required this.category,
      required this.name,
      required this.information,
      required this.introduction,
      required this.tag,
      required this.imgUrl,
      required this.member,
      required this.applicationList,
      required this.applicationPeriodStart,
      required this.applicationPeriodEnd});

  factory Club.fromJson(Map<String, dynamic> json, String id) {
    return Club(
        id: id,
        category: json['category'] ?? '',
        name: json['name'] ?? '',
        information: json['information'] ?? '',
        introduction: json['introduction'] ?? '',
        tag: json['tag'] ?? '',
        imgUrl: json['imgUrl'] ?? '',
        member: List<String>.from(json['member'] ?? []),
        applicationList: List<String>.from(json['applicationList'] ?? []),
        applicationPeriodStart: json['applicationPeriodStart'] != null
            ? (json['applicationPeriodStart'] as Timestamp).toDate()
            : DateTime.now(),
        applicationPeriodEnd: json['applicationPeriodEnd'] != null
            ? (json['applicationPeriodEnd'] as Timestamp).toDate()
            : DateTime.now().add(const Duration(days: 30)));
  }
}
