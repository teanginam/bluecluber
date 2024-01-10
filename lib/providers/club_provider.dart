import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tttttt/models/club.dart';

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

  //동아리 이미지 변경 메서드
  Future<void> changeClubProfile(String id) async {
    final club = _clubList.firstWhere((club) => club.id == id);

    // 갤러리에서 이미지 고르고 firebase에 업로드
    await Permission.photosAddOnly.request();
    ImagePicker picker = ImagePicker();
    XFile? pick = await picker.pickImage(source: ImageSource.gallery);
    if (pick != null) {
      File file = File(pick.path);
      // firestorage에 올리고
      await FirebaseStorage.instance.ref('Club/$id.jpg').putFile(file);
      // downloadUrl을 얻은다음에
      String imageUrl =
          await FirebaseStorage.instance.ref('Club/$id.jpg').getDownloadURL();
      // firestore에 저장
      await FirebaseFirestore.instance
          .collection('Club')
          .doc(id)
          .update({'imgUrl': imageUrl});
      //club클래스에 imgUrl 바뀐걸 알려줌
      club.imgUrl = imageUrl;
    }
    notifyListeners();
  }

  //동아리 사진 삭제 메서드
  Future<void> deleteClubProfile(String id) async {
    final club = _clubList.firstWhere((club) => club.id == id);

    try {
      await FirebaseStorage.instance.ref('Club/${club.id}.jpg').delete();
      await FirebaseFirestore.instance
          .collection('Club')
          .doc(club.id)
          .update({'imgUrl': FieldValue.delete()});
    } catch (e) {
      print(e);
    }

    club.imgUrl = '';
    notifyListeners();
  }

   
}
