import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
// 현재 유저의 UID를 가져오는 함수
  static String getUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

// 현재 유저의 문서 레퍼런스 가져오는 함수
  static DocumentReference<Map<String, dynamic>> getDocRef() {
    return FirebaseFirestore.instance.collection('users').doc(getUid());
  }
}
