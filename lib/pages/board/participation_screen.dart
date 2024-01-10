import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../current_user.dart';

class ParticipationScreen extends StatefulWidget {
  ParticipationScreen({super.key, });

  @override
  State<ParticipationScreen> createState() => _ParticipationScreenState();
}

class _ParticipationScreenState extends State<ParticipationScreen> {
  bool? isAttend;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("d"),
      // body: StreamBuilder(
      //     stream: FirebaseFirestore.instance
      //         .doc(widget.club['path'])
      //         .collection('participation')
      //         .orderBy('date', descending: true)
      //         .snapshots(),
      //     builder: (context, snapshot) {
      //       if (!snapshot.hasData) {
      //         return const SizedBox();
      //       }
      //       final pariticipationData = snapshot.data!.docs;

      //       return Padding(
      //         padding: const EdgeInsets.all(12.0),
      //         child: ListView.builder(
      //             itemCount: pariticipationData.length,
      //             itemBuilder: (context, index) {
      //               final date = pariticipationData[index]['date'];
      //               final finishTime = pariticipationData[index]['finishTime'];
      //               final title = pariticipationData[index]['title'];
      //               final location = pariticipationData[index]['location'];
      //               final listId = pariticipationData[index].id;
      //               final attendList = pariticipationData[index]
      //                       .data()
      //                       .containsKey('attendList')
      //                   ? pariticipationData[index]['attendList']
      //                   : [];
      //               bool? isAttend;
      //                   // 유저가 투표참여했으면 bool값주고 투표안했으면 null값
      //                   for(var userData in attendList) {
      //                     if(userData['uid'] == CurrentUser.getUid()) {
      //                       userData['attend'] ? isAttend = true : isAttend = false;
      //                     }
      //                     else {
      //                       isAttend == null;
      //                     }
      //                   }
      //                   // 투표 종료시간인지 
      //               bool isFinish = finishTime.toDate().isBefore(DateTime.now());
      //               // Duration remainingTime = finishTime.toDate().difference(DateTime.now());
                    

      //               return Column(
      //                 children: [
      //                   Container(
      //                     width: double.infinity,
      //                     padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(8.0),
      //                       color: Colors.grey[400],
      //                     ),
      //                     child: Column(
      //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         // 행사제목
      //                         Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //                             Row(
      //                               mainAxisAlignment:
      //                                   MainAxisAlignment.spaceBetween,
      //                               children: [
      //                                 Text(
      //                                   title,
      //                                   style: const TextStyle(
      //                                       fontSize: 20,
      //                                       fontWeight: FontWeight.bold),
      //                                 ),
      //                                 TextButton(
      //                                   onPressed: (() {
      //                                     getParticipationMemberList(
      //                                         attendList);
      //                                   }),
      //                                   child: Text(
                                          
      //                                     "${attendList.length}명 참여 >",
      //                                     style: TextStyle(color: Colors.black),
      //                                   ),
      //                                 )
      //                               ],
      //                             ),
      //                             // 행사 날짜
      //                             Text(
      //                                 '일시 : ${DateFormat('yyyy.MM.dd').format(date.toDate())}'),
      //                             Row(
      //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                               children: [
      //                                 Text("장소 : $location"),
      //                                 // Text("$remainingTime 남음")
      //                               ],
      //                             ),
      //                           ],
      //                         ),
      //                         SizedBox(
      //                           height: 10,
      //                         ),
      //                         // 투표 종료시간일떄
      //                         if(isFinish) 
      //                         SizedBox(
      //                           width: double.infinity,
      //                           child: ElevatedButton(onPressed: null, child: Text("투표 종료"))),
      //                         if(!isFinish)
      //                         // 참가 or 불참 버튼
      //                         Row(
      //                           mainAxisAlignment:
      //                               MainAxisAlignment.spaceBetween,
      //                           children: [
      //                             // 참가 버튼
      //                             Expanded(
      //                                 child: ElevatedButton(
      //                                     onPressed: () async {
      //                                       setState(() {
      //                                         isAttend = true;
      //                                       });
      //                                       attend(listId, isAttend!);
      //                                     },
      //                                     style: ElevatedButton.styleFrom(
      //                                       primary: isAttend == true ? Colors.grey : Colors.blue,
      //                                     ),
      //                                     child: Text(isAttend== true? "참가완료" : "참가"))),
      //                             SizedBox(
      //                               width: 10,
      //                             ),
      //                             // 불참 버튼
      //                             Expanded(
      //                                 child: ElevatedButton(
      //                                     onPressed: () async {
      //                                       setState(() {
      //                                         isAttend = false;
      //                                       });
      //                                       attend(listId, isAttend!);
      //                                     },
      //                                     style: ElevatedButton.styleFrom(
      //                                       primary: isAttend == false ? Colors.grey : Colors.blue,
      //                                     ),
      //                                     child: Text(isAttend== false? "불참완료" : "불참"))),
      //                           ],
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                   const SizedBox(
      //                     height: 10,
      //                   ),
      //                 ],
      //               );
      //             }),
      //       );
      //     }),
    );
  }

  // 참여자 목록 가져오기
  void getParticipationMemberList(var attendList) {
    List attendUserNames = [];
    for (var userData in attendList) {
      if (userData.containsKey('userName')) {
        // 투표 '참가'인 유저만 나타내기
        if(userData['attend'] == true)
        {attendUserNames.add(userData['userName']);}
      }
    }
    Get.defaultDialog(
      title: '참여자 목록',
      content: Column(
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: ListView.builder(
              itemCount: attendUserNames.length,
              itemBuilder: (context, index) {
                return Text(attendUserNames[index]);
              },
            ),
          ),
        ],
      ),
      onCancel: () {},
      textCancel: '닫기',
    );
  }

  // // 참가 or 불참하기 기능
  // void attend(String listId, bool isAttend) async {
  //   final userData = await CurrentUser.getDocRef().get();
  //   //파이어스토어에 신청멤버 이름, uid 추가
  //   await FirebaseFirestore.instance
  //       .doc(widget.club['path'])
  //       .collection('participation')
  //       .doc(listId)
  //       .update({
  //     'attendList': [
  //       {
  //         'userName': userData.data()!['name'],
  //         'uid': CurrentUser.getUid(),
  //         'attend': isAttend
  //       }
  //     ]
  //   });
  // }
}
