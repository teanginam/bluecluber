import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tttttt/models/notification.dart';

class NotificationProvider with ChangeNotifier {
  List<Noti> _notiList = [];
  List<Noti> get notiList => _notiList;

  // 공지 받아오기 메서드
  Future<void> fetchNotiList(String clubId) async {
  var db = FirebaseFirestore.instance;
  var querySnapshot = await db
      .collection("Notification")
      .where('clubId', isEqualTo: clubId) // Filter based on clubId
      .get();

  final List<Noti> result = querySnapshot.docs
      .map((e) => Noti.fromJson(e.data()))
      .toList();

  _notiList.clear();
  _notiList.addAll(result);
  notifyListeners();
}


  // 공지 업로드 메서드
  Future<void> upload(Noti noti) async {
    try {
      FirebaseFirestore.instance.collection('Notification').add({
        'title': noti.title,
        'content': noti.content,
        'datetime': DateTime.now(),
        'clubId': noti.clubId,
        'userId': noti.userId,
      });

      final newNoti = Noti(
        title: noti.title,
        content: noti.content,
        dateTime: DateTime.now(),
        clubId: noti.clubId,
        userId: noti.userId,
      );

      _notiList.add(newNoti);

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
