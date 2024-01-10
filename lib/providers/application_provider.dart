import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tttttt/models/user.dart';
import 'package:tttttt/providers/club_provider.dart';
import 'package:tttttt/providers/user_provider.dart';

//ApplyProvider로 바꿔도될듯
class ApplicationProvider with ChangeNotifier {
  //신청한 유저 리스트
  final List<Users> _appliedUserList = [];
  List<Users> get appliedUserList => _appliedUserList;

// 신청한 유저들만 일괄 조회
  Future<void> findApplyUser(List<String> uidList) async {
    if (uidList.isEmpty) {
      // uidList가 비어 있으면 아무 작업도 수행하지 않습니다.
      return;
    }
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: uidList)
        .get();

    final List<Users> result =
        querySnapshot.docs.map((e) => Users.fromJson(e.data(), e.id)).toList();

    _appliedUserList.clear();
    _appliedUserList.addAll(result);
    notifyListeners();
  }

  // 신청 수락
  Future<void> accept(BuildContext context, String id, String uid) async {
    final club = Provider.of<ClubProvider>(context, listen: false)
        .clubList
        .firstWhere((club) => club.id == id);
    final user = Provider.of<UserProvider>(context, listen: false).user;
    var db = FirebaseFirestore.instance;
    await db.collection('Club').doc(id).update({
      'member': FieldValue.arrayUnion([uid]),
      'applicationList': FieldValue.arrayRemove([uid])
    });

    await db.collection('users').doc(uid).update({
      'applicationList': FieldValue.arrayRemove([id])
    });

    //신청리스트에서 제거
    club.applicationList.remove(uid);
    user!.applicationList.remove(id);
    _appliedUserList.removeWhere((user) => user.uid == uid);
    notifyListeners();
  }

  //신청 거절
   Future<void> refuse(BuildContext context, String id, String uid) async {
    final club = Provider.of<ClubProvider>(context, listen: false)
        .clubList
        .firstWhere((club) => club.id == id);
    final user = Provider.of<UserProvider>(context, listen: false).user;
    var db = FirebaseFirestore.instance;
    await db.collection('Club').doc(id).update({
      'applicationList': FieldValue.arrayRemove([uid])
    });

    await db.collection('users').doc(uid).update({
      'applicationList': FieldValue.arrayRemove([id])
    });

    //신청리스트에서 제거
    club.applicationList.remove(uid);
    user!.applicationList.remove(id);
    _appliedUserList.removeWhere((user) => user.uid == uid);
    notifyListeners();
   }

  //신청 기간 선정
  Future<void> selectedApplicationPeriod(
      BuildContext context, DateTime selectedDate, String id, bool start) async {
         final club = Provider.of<ClubProvider>(context, listen: false)
        .clubList
        .firstWhere((club) => club.id == id);
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 380.0,
          color: Colors.white,
          child: Column(
            children: [
              // 날짜고르기
              SizedBox( 
                height: 300,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  onDateTimeChanged: (DateTime newDate) async {
                    selectedDate = newDate;
                  },
                ),
              ),
              // 확인버튼
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: CupertinoButton.filled(
                  child: Text('확인'),
                  onPressed: () async {
                    if(start) //만약 시작시간이면
                    {await FirebaseFirestore.instance
                        .collection('Club')
                        .doc(id)
                        .update({'applicationPeriodStart': 
                        selectedDate});
                        club.applicationPeriodStart = selectedDate; 
                        }
                    else //만약 종료시간이몀ㄴ
                    {await FirebaseFirestore.instance
                        .collection('Club')
                        .doc(id)
                        .update({'applicationPeriodEnd': 
                        selectedDate});
                        club.applicationPeriodEnd = selectedDate; 
                        }
                    

                    notifyListeners();
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
