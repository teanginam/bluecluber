import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tttttt/models/user.dart';
import 'package:tttttt/providers/club_provider.dart';

class UserProvider with ChangeNotifier {
  Users? _user;
  Users? get user => _user;

  User? _currentUser = FirebaseAuth.instance.currentUser;
  User? get currentUser  => _currentUser;

  //현재유저 데이터 받아오는 메서드
  Future<void> getCurrentUserData() async {
    if (_currentUser != null) {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_currentUser!.uid)
              .get();
      
      _user = Users.fromJson(snapshot.data() as Map<String, dynamic>, _currentUser!.uid);
      notifyListeners();
    }
  }
  //동아리 가입 신청 메서드
  Future<void> apply(BuildContext context, String id, String uid) async {
    final club = Provider.of<ClubProvider>(context, listen: false)
        .clubList
        .firstWhere((club) => club.id == id);
    //Club에 파이어베이스 추가
    await FirebaseFirestore.instance.collection('Club').doc(id).update({'applicationList' : FieldValue.arrayUnion([uid])});
    club.applicationList.add(uid);

    //User에 파이어베이스 추가
    await FirebaseFirestore.instance.collection('users').doc(uid).update({'applicationList' : FieldValue.arrayUnion([id])});
    _user!.applicationList.add(id);
    
    notifyListeners();
    print(_user!.applicationList);

  }

  //동아리 가입 취소 메서드
  Future<void> applyCancle(BuildContext context, String id, String uid) async {
  final club = Provider.of<ClubProvider>(context, listen: false)
      .clubList
      .firstWhere((club) => club.id == id);

  // Club에서 파이어베이스에서 제거
  await FirebaseFirestore.instance.collection('Club').doc(id).update({'applicationList' : FieldValue.arrayRemove([uid])});
  club.applicationList.remove(uid);

  // User에서 파이어베이스에서 제거
  await FirebaseFirestore.instance.collection('users').doc(uid).update({'applicationList' : FieldValue.arrayRemove([id])});
  _user!.applicationList.remove(id);

  notifyListeners();
  print(_user!.applicationList);
}


}
