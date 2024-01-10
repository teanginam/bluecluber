import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';

import 'package:tttttt/club_information_page.dart';
import 'package:tttttt/current_user.dart';
import 'package:tttttt/pages/board/participation_screen.dart';
import 'package:tttttt/pages/board/writing_page.dart';
import 'package:tttttt/president/club_member_page.dart';

import 'board/event_screen.dart';
import 'board/notification_screen.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key, required this.id});

  @override
  State<BoardPage> createState() => _BoardPageState();

  final String id;
}

class _BoardPageState extends State<BoardPage> {
  // final club = Get.arguments;
  final _formKey = GlobalKey<FormState>();
  String? eventTitle; //행사 투표 제목
  String? eventLocation; //장소
  DateTime? selectedDate;
  DateTime? selectedFinishTime;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3, // 탭의 개수 설정
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[700],
            centerTitle: true,
            title: const Text(
              '동아리 게시판',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            bottom: const TabBar(
              // TabBar 추가
              tabs: [
                Tab(
                  child: Text(
                    "공지",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                Tab(
                  child: Text(
                    "행사",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                Tab(
                  child: Text(
                    "참여",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            // TabBarView 추가
            children: [
              //공지 스크린 ---------------------------------
              NotificationScreen(clubId: widget.id,),

              // 행사 스크린-----------------------------------
              EventScreen(clubId: widget.id,),
              ParticipationScreen(
              ),
            ],
          ),
          // 플로팅 액션 버튼 (회장용)--------------------------------

          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: ExpandableFab(
                  distance: 70.0,
                  type: ExpandableFabType.up,
                  children: [
                    // 공지, 행사 글쓰기
                    FloatingActionButton(
                      heroTag: null,
                      child: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WritingPage(id: widget.id)));
                      },
                    ),
                    // 동아리 회원명부
                    FloatingActionButton(
                      heroTag: null,
                      child: const Icon(Icons.people),
                      onPressed: () {
                        // Get.to(const ClubMemberPage(), arguments: club);
                      },
                    ),
                    // 동아리 정보 수정
                    FloatingActionButton(
                      heroTag: null,
                      child: const Icon(Icons.info),
                      onPressed: () {
                        // Get.to(const ClubInformationPage(), arguments: club);
                      },
                    ),
                    // 참여 투표 기능
                    FloatingActionButton(
                      heroTag: null,
                      child: const Icon(Icons.calendar_month_outlined),
                      onPressed: () {
                        // buildVote();
                      },
                    ),
                  ],
                )
              ),
        );
  }

//   // 행사 투표 만들기 다이얼로그
//   void buildVote() {
//     Get.defaultDialog(
//       title: '행사 투표 만들기',
//       content: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//             Expanded(child: ElevatedButton(onPressed: () {
//               selectDate();
//             }, child: Text("행사 날짜"))),
//             SizedBox(width: 10,),
//             Expanded(child: ElevatedButton(onPressed: () {
//               selectFinishTime();
//             }, child: Text("투표 종료 시간")))
//           ],),
//           Text("* 투표 종료시간을 설정하지 않으면 2일후에 종료됩니다.",
//           style: TextStyle(
//             fontSize: 12
//           ),),
//           Form(
//             key: _formKey,
//             child: Column(
//           children: [
//             TextFormField(
//               validator: (value) {
//                 if (value!.isEmpty) return '제목을 입력하세요';
//                 return null;
//               },
//               onChanged: (value) {
//                 eventTitle = value;
//               },
//               decoration: const InputDecoration(
//                 hintText: '행사 제목',
//               ),
//             ),
//             TextFormField(
//               validator: (value) {
//                 if (value!.isEmpty) return '장소를 입력하세요';
//                 return null;
//               },
//               onChanged: (value) {
//                 eventLocation = value;
//               },
//               decoration: const InputDecoration(
//                 hintText: '장소',
//               ),
//             ),
//           ],
//             ),
//           ),
//         ],
//       ),
//       onConfirm: () async {
        
//         if (_formKey.currentState!.validate()) {
//           selectedDate ??= DateTime.now();
//           selectedFinishTime ??= DateTime.now().add(Duration(days: 2)); 
//           //firebase에 참여콜렉션에 행사제목, 날짜 추가
//           await FirebaseFirestore.instance
//               .doc(club['path'])
//               .collection('participation')
//               .add({
//             'title': eventTitle,
//             'location' : eventLocation,
//             'date': selectedDate,
//             'finishTime' : selectedFinishTime,
//           });
//           selectedDate = null;
//           selectedFinishTime = null;
//           Get.back();
//         }
//       },
//       textConfirm: '생성',
//       confirmTextColor: Colors.white,
//       onCancel: () {},
//       textCancel: '취소',
//     );
//   }

//   // 날짜 정하기
//   void selectDate() {
//     DatePicker.showDateTimePicker(context,
//         showTitleActions: true,
//         onConfirm: (date) {
//       selectedDate = date;
//     }, 
//     currentTime: DateTime.now(),
//     locale: LocaleType.ko);
//   }

//   // 투표종료시간 정하기
//   void selectFinishTime() {
//     DatePicker.showDateTimePicker(context,
//         showTitleActions: true,
//         onConfirm: (date) {
//         selectedFinishTime = date;
//     }, 
//     currentTime: DateTime.now(),
//     locale: LocaleType.ko);
//   }
// }
}