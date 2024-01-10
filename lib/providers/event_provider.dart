import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tttttt/models/event.dart';

class EventProvider with ChangeNotifier {
  List<Event> _eventList = [];
  List<Event> get eventList => _eventList;


  // 행사 받아오기 메서드
  Future<void> fetchEventList(String clubId) async {
    var db = FirebaseFirestore.instance;
    var querySnapshot = await db
        .collection("Event")
        .where('clubId', isEqualTo: clubId) // Filter based on clubId
        .get();

    final List<Event> result =
        querySnapshot.docs.map((e) => Event.fromJson(e.data(), e.id)).toList();

    _eventList.clear();
    _eventList.addAll(result);
    notifyListeners();
  }

  // 공지 업로드 메서드
  Future<void> upload(Event event, XFile pickedImage) async {
    try {
      File file = File(pickedImage.path);
      // firestorage에 올리고
      await FirebaseStorage.instance
          .ref('Event/${event.dateTime}.jpg')
          .putFile(file);
      // downloadUrl을 얻은다음에
      final imageUrl = await FirebaseStorage.instance
          .ref('Event/${event.dateTime}.jpg')
          .getDownloadURL();

      FirebaseFirestore.instance.collection('Event').add({
        'title': event.title,
        'content': event.content,
        'datetime': DateTime.now(),
        'clubId': event.clubId,
        'userId': event.userId,
        'imageUrl': imageUrl,
      });

      final newEvent = Event(
        title: event.title,
        content: event.content,
        dateTime: DateTime.now(),
        clubId: event.clubId,
        userId: event.userId,
        imageUrl: event.imageUrl,
      );

      _eventList.add(newEvent);

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
