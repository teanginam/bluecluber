// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tttttt/club_information_page.dart';
import 'package:tttttt/current_user.dart';

import '../../pages/board_page.dart';

class ClubPage extends StatefulWidget {
  const ClubPage({super.key});

  @override
  State<ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  final club = Get.arguments;
  List<Map> applicationUserData = []; //신청 유저 데이터
  bool isJoinPeriod = false;
  DateTime? applicationPeriodStart;
  DateTime? applicationPeriodEnd;
  String startDateText = ''; // 시작일 텍스트
  String endDateText = ''; // 종료일 텍스트
  DateTime now = DateTime.now();
  String? clubName;
  String? clubIntro;
  String? clubMembers;
  bool? isPresident;
  bool isLoading = true;

  late Widget periodWidget; // 필드로 Widget을 선언합니다.

  @override
  void initState() {
    _updateDateTexts();
    super.initState();

    _checkJoinPeriod();
    periodWidget =
        _buildPeriodWidget(); // _buildPeriodWidget() 메서드를 호출하여 periodWidget 초기화
    _checkJoinPeriod(); // 기간 확인 메서드 호출
    _updateDateTexts(); // 시작일과 종료일 텍스트 업데이트// 기간 확인 메서드 호출
  }

  Stream<DateTime> _getApplicationStartDateStream() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1)); // 일정 시간마다 데이터 업데이트

      final randomDate = DateTime.now(); // 실제 데이터를 가져오는 대신 임의의 날짜 생성
      yield randomDate; // 스트림에 데이터를 보냄
    }
  }

//동아리 멤버만 보드페이지로 넘어감
  void onlyPossibleMember() {
    bool isMember = false; // 기본적으로 회원이 아님

    club['members'].forEach((userData) {
      if (userData['uid'] == CurrentUser.getUid()) {
        isMember = true;
      }
    });

    if (isMember) {
      Get.to(
          const BoardPage(
            id: '',
          ),
          arguments: club);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('알림'),
            content: const Text('동아리 회원만 입장하실 수 있습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }

  // 갤러리에서 이미지 고르고 firebase에 업로드
  Future<void> _pickImage() async {
    await Permission.photosAddOnly.request();

    ImagePicker picker = ImagePicker();
    XFile? pick = await picker.pickImage(source: ImageSource.gallery);
    if (pick != null) {
      File file = File(pick.path);
      // firestorage에 올리고
      await FirebaseStorage.instance
          .ref('clubs/${club['category']}/$clubName.jpg')
          .putFile(file);
      // downloadUrl을 얻은다음에
      String imageUrl = await FirebaseStorage.instance
          .ref('clubs/${club['category']}/$clubName.jpg')
          .getDownloadURL();
      // firestore에 저장
      await FirebaseFirestore.instance
          .doc(club['path'])
          .update({'imgUrl': imageUrl});
    }
  }

  // 파이어베이스 이미지 삭제
  deleteFireImage() async {
    Get.defaultDialog(
      title: '삭제',
      content: const Text("이미지를 삭제하시겠습니까?"),
      onCancel: () {},
      onConfirm: () async {
        try {
          await FirebaseStorage.instance
              .ref('clubs/${club['category']}/$clubName.jpg')
              .delete();
          await FirebaseFirestore.instance
              .doc(club['path'])
              .update({'imgUrl': FieldValue.delete()});
        } catch (e) {
          print(e);
        }

        Get.back();
        Get.back();
      },
      textConfirm: '확인',
      textCancel: '취소',
      confirmTextColor: Colors.white,
    );
  }

  void openModalBottomSheet() {
    Get.bottomSheet(
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  _pickImage();
                  Get.back();
                },
                child: const SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        '앨범에서 사진 선택',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              InkWell(
                onTap: () {
                  deleteFireImage();
                },
                child: const SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        '이미지 삭제',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        backgroundColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    if (isPresident == true) {
      return Stack(
        alignment: Alignment.center,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          AlertDialog(
            title: const Text('알림'),
            content: const Text('회장이 입장하지 않은 동아리 입니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
        ],
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue[700],
        ),
        body: FutureBuilder(
            future: FirebaseFirestore.instance.doc(club['path']).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // 데이터를 기다리는 동안에 보여줄 UI
                return const SizedBox();
              }
              final clubData = snapshot.data!.data();
              clubName = clubData!['name'];
              clubIntro = clubData['introduction'];
              clubMembers = clubData['members'].length.toString();
              isPresident = clubData['members'][0]['user'] ==
                  'uid'; // 'uid' 대신 실제 회장의 UID 사용
              DateTime now = DateTime.now();

              applicationPeriodStart =
                  clubData['applicationPeriodStart']?.toDate() ??
                      now.subtract(const Duration(days: 1));

              applicationPeriodEnd =
                  clubData['applicationPeriodEnd']?.toDate() ??
                      now.add(const Duration(days: 1));

              isJoinPeriod = now.isAfter(applicationPeriodStart!) &&
                  now.isBefore(applicationPeriodEnd!);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 180,
                        color: Colors.blue[700],
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
                        child: Row(
                          children: [
                            //동아리 이미지

                            InkWell(
                              onTap: () {
                                // 회장만 이미지 변경 가능하게
                                openModalBottomSheet();
                              },
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .doc(club['path'])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: Text("이미지를 불러오는중..."),
                                      );
                                    }

                                    final imgUrl =
                                        snapshot.data!.data()!['imgUrl'];
                                    print(imgUrl);
                                    return Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          color: Colors.white),
                                      child: Center(
                                          child: imgUrl == null
                                              ? const Text("이미지가 없습니다.")
                                              : Container(
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                      color: Colors.white),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    key: UniqueKey(),
                                                    imageUrl: imgUrl,
                                                    placeholder:
                                                        (context, url) =>
                                                            const SizedBox(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                )),
                                    );
                                  }),
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            // 동아리명, 멤버수, 가입신청버튼
                            SizedBox(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        clubName!,
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        "멤버수: $clubMembers명",
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '가입 신청 기간\n${startDateText != null ? '$startDateText\n$endDateText' : '상시가입'} ',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      )
                                    ],
                                  ),
                                  // 가입신청버튼
                                  StreamBuilder(
                                      stream:
                                          CurrentUser.getDocRef().snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const SizedBox();
                                        }

                                        final userData = snapshot.data!.data();

                                        bool isApplied =
                                            (userData!['membership']
                                                        as List<dynamic>?)
                                                    ?.any((element) =>
                                                        element['name'] ==
                                                            club['name'] &&
                                                        element['state'] ==
                                                            '신청완료') ??
                                                false;

                                        bool isJoined = (userData['membership']
                                                    as List<dynamic>?)
                                                ?.any((element) =>
                                                    element['name'] ==
                                                        club['name'] &&
                                                    element['state'] ==
                                                        '가입완료') ??
                                            false;

                                        // 회장이라면 신청목록 버튼이 뜨게 -----------------------------------------
                                        if (club['members'].any((member) =>
                                            member['uid'] ==
                                                    CurrentUser.getUid() &&
                                                member['position'] == '회장' ||
                                            member['uid'] ==
                                                    CurrentUser.getUid() &&
                                                member['position'] == '부회장')) {
                                          return Row(
                                            children: [
                                              buildApplicationListButton(),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Get.to(
                                                        const ClubInformationPage(),
                                                        arguments: club);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blue[900],
                                                    textStyle: const TextStyle(
                                                        fontSize: 12),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                  ),
                                                  child: const Text(
                                                    "동아리 관리",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))
                                            ],
                                          );
                                        }

                                        // 회장이 아니라면 가입신청 버튼----------------------------------------------------
                                        return buildJoinButton(
                                            isApplied, isJoined);
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  //소개글
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "소개글",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    color: Colors.grey[300],
                                  ),
                                  child: Text(clubIntro!),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                //공지
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '공지',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          onlyPossibleMember();
                                        },
                                        child: Text(
                                          "더보기 >",
                                          style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 12.0),
                                        ))
                                  ],
                                ),

                                Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    color: Colors.grey[300],
                                  ),
                                  child: FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .doc(club['path'])
                                          .collection('notifications')
                                          .orderBy('time', descending: true)
                                          .get(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData ||
                                            snapshot.data!.docs.isEmpty) {
                                          return const Text(
                                              '공지가 없습니다.'); // 데이터가 없을 때 표시할 위젯
                                        }
                                        final notifications =
                                            snapshot.data!.docs;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notifications[0]['title'],
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              notifications[0]['content'],
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ),

                                //행사
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "행사",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Get.to(
                                              const BoardPage(
                                                id: '',
                                              ),
                                              arguments: club);
                                        },
                                        child: Text(
                                          "더보기 >",
                                          style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 12.0),
                                        ))
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    color: Colors.grey[300],
                                  ),
                                  child: FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .doc(club['path'])
                                          .collection('events')
                                          .orderBy('time', descending: true)
                                          .get(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData ||
                                            snapshot.data!.docs.isEmpty) {
                                          return const Text(
                                              '행사가 없습니다.'); // 데이터가 없을 때 표시할 위젯
                                        }
                                        final notifications =
                                            snapshot.data!.docs;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notifications[0]['title'],
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              notifications[0]['content'],
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
      );
    }
  }

//----------------------------------------------------------------------------
  // 가입신청버튼
  Widget buildJoinButton(bool isApplied, bool isJoined) {
    // _checkJoinPeriod();

    if (isJoinPeriod) {
      return GestureDetector(
        onTap: () {
          // 가입신청 안했을때 다이얼로그 뜨게(신청완료와 가입완료가 아닐때)
          if (!isApplied && !isJoined) {
            Get.defaultDialog(
              radius: 8,
              title: '가입신청',
              titlePadding: const EdgeInsets.all(20),
              contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              content: Column(
                children: [
                  const Text('동아리 가입신청을 하시겠습니까?\n'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text("취소하기")),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              final userRef = CurrentUser.getDocRef();

                              // Update user's membership data
                              await userRef.update({
                                'membership': FieldValue.arrayUnion([
                                  {'name': club['name'], 'state': '신청완료'}
                                ])
                              });
                              final userData =
                                  await CurrentUser.getDocRef().get();

                              // firebase -> 신청목록에 유저이름, uid 업데이트
                              await FirebaseFirestore.instance
                                  .doc(club['path'])
                                  .update({
                                'applicationList': FieldValue.arrayUnion([
                                  {
                                    'uid':
                                        FirebaseAuth.instance.currentUser!.uid,
                                    'name': userData.data()!['name'],
                                    'phoneNumber':
                                        userData.data()!['phoneNumber']
                                  }
                                ])
                              });

                              Get.back();
                            },
                            child: const Text("가입하기")),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            // 가입신청 안했을때 다이얼로그 뜨게(신청완료와 가입완료가 아닐때)
            Get.defaultDialog(
              radius: 8,
              title: '신청취소',
              titlePadding: const EdgeInsets.all(20),
              contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              content: Column(
                children: [
                  const Text('동아리 가입신청을 취소 하시겠습니까?\n'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text("취소하기")),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              applicationUserData.removeWhere((data) =>
                                  data['uid'] == CurrentUser.getUid());
                              await FirebaseFirestore.instance
                                  .doc(club['path'])
                                  .update({
                                'applicationList': applicationUserData,
                              });

                              // 신청완료 없앰
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(CurrentUser.getUid())
                                  .update({
                                'membership': FieldValue.arrayRemove([
                                  {'name': club['name'], 'state': '신청완료'}
                                ]),
                              });
                              Get.back();
                            },
                            child: const Text("가입취소")),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          decoration: BoxDecoration(
              color: isApplied || isJoined ? Colors.grey[600] : Colors.blue,
              borderRadius: BorderRadius.circular(6.0)),
          child: Center(
            child: Text(
              isApplied
                  ? "신청취소"
                  : isJoined
                      ? "가입완료"
                      : "가입신청",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        decoration: BoxDecoration(
            color: Colors.grey[600], borderRadius: BorderRadius.circular(6.0)),
        child: const Center(
          child: Text(
            "가입신청 기간 종료",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  void openApplicationManagementBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Add the periodWidget here
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: Column(
                    children: [
                      const Text('모집 기간 선택'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: periodWidget,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                applicationUserData.isEmpty
                    ? const Center(child: Text("신청 대기자가 없습니다"))
                    : SizedBox(
                        width: 400,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: ListView.builder(
                          itemCount: applicationUserData.length,
                          itemBuilder: (context, index) {
                            final userName = applicationUserData[index]['name'];
                            final userUid = applicationUserData[index]['uid'];
                            final userPhoneNumber =
                                applicationUserData[index]['phoneNumber'];

                            return Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text('$userName'),
                                        Text('$userPhoneNumber')
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            // 신청목록에 유저 없애기, members에 유저 추가
                                            applicationUserData.removeAt(index);
                                            FirebaseFirestore.instance
                                                .doc(club['path'])
                                                .update({
                                              'members': FieldValue.arrayUnion([
                                                {
                                                  "name": userName,
                                                  'uid': userUid,
                                                  'position': '회원'
                                                }
                                              ]),
                                              'applicationList':
                                                  applicationUserData,
                                            });

                                            //신청완료 없애기
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(userUid)
                                                .update({
                                              'membership':
                                                  FieldValue.arrayRemove([
                                                {
                                                  'name': club['name'],
                                                  'state': '신청완료'
                                                }
                                              ]),
                                            });

                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(userUid)
                                                .update({
                                              'membership':
                                                  FieldValue.arrayUnion([
                                                {
                                                  'name': club['name'],
                                                  'state': '가입완료',
                                                  'setdate': Timestamp.now()
                                                }
                                              ]),
                                            });
                                            setState(() {
                                              fetchApplicationList();
                                            });

                                            Get.back();
                                          },
                                          child: const Text("승인"),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            applicationUserData.removeAt(index);
                                            await FirebaseFirestore.instance
                                                .doc(club['path'])
                                                .update({
                                              'applicationList':
                                                  applicationUserData,
                                            });

                                            // 신청완료 없앰
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(userUid)
                                                .update({
                                              'membership':
                                                  FieldValue.arrayRemove([
                                                {
                                                  'name': club['name'],
                                                  'state': '신청완료'
                                                }
                                              ]),
                                            });
                                            Get.back();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          child: const Text("거절"),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                ElevatedButton(
                  onPressed: () {
                    applicationUserData.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("닫기"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//신청관리 버튼(회장용)--------------------------------------------------------
  Widget buildApplicationListButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blue[700],
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 13),
      ),
      child: const Center(
          child: Text(
        "신청관리",
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      onPressed: () async {
        await fetchApplicationList(); //신청목록 가져오기
        // 신청목록 다이얼로그
        openApplicationManagementBottomSheet();
      },
    );
  }

  // 신청목록 가져오기
  Future fetchApplicationList() async {
    final clubData = await FirebaseFirestore.instance.doc(club['path']).get();
    List applicationList = clubData.data()!['applicationList'];
    applicationUserData = [];
    print("$applicationList 여긴 왜 프린트 안해줘?");
    if (applicationList.isNotEmpty) {
      print('gownj');
      for (int i = 0; i != applicationList.length; i++) {
        print('object');
        final user = await FirebaseFirestore.instance
            .collection('users')
            .doc(applicationList[i]['uid'])
            .get();
        applicationUserData.add({
          'name': user['name'],
          'uid': applicationList[i]['uid'],
          'phoneNumber': user['phoneNumber'],
        });
      }
    }

    print("ob????");
  }

  Future<void> _updateDateTexts() async {
    final startDate = await _getApplicationStartDate();
    final endDate = await _getApplicationEndDate();

    setState(() {
      startDateText = startDate != null ? _formatDateTime(startDate) : '';
      endDateText = endDate != null ? _formatDateTime(endDate) : '';
    });
  }

  void _checkJoinPeriod() {
    FutureBuilder(
      future: _getApplicationStartDate(),
      builder: (context, startDateSnapshot) {
        if (startDateSnapshot.connectionState == ConnectionState.waiting) {
          return const Text("시작일 로딩 중...");
        }
        if (startDateSnapshot.hasError) {
          return Text("에러 발생: ${startDateSnapshot.error}");
        }
        if (startDateSnapshot.hasData) {
          final startDate = startDateSnapshot.data as DateTime;
          FutureBuilder(
            future: _getApplicationEndDate(),
            builder: (context, endDateSnapshot) {
              if (endDateSnapshot.connectionState == ConnectionState.waiting) {
                return const Text("종료일 로딩 중...");
              }
              if (endDateSnapshot.hasError) {
                return Text("에러 발생: ${endDateSnapshot.error}");
              }
              if (endDateSnapshot.hasData) {
                final endDate = endDateSnapshot.data as DateTime;
                final now = DateTime.now();
                isJoinPeriod = now.isAfter(startDate) && now.isBefore(endDate);
                return const SizedBox(); // 빈 위젯 리턴
              }
              return const SizedBox();
            },
          );
          return const SizedBox(); // 빈 위젯 리턴
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildPeriodWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _showStartApplicationPeriodPicker,
                child: const Text("시작일 선택"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: _showEndApplicationPeriodPicker,
                child: const Text("종료일 선택"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      final snapshot =
                          FirebaseFirestore.instance.doc(club['path']).get();

                      // 파이어스토어에서 데이터 지우는 코드 추가
                      FirebaseFirestore.instance.doc(club['path']).update({
                        'applicationPeriodStart': FieldValue.delete(),
                      });
                      FirebaseFirestore.instance.doc(club['path']).update({
                        'applicationPeriodEnd': FieldValue.delete(),
                      });
                      Get.snackbar(
                        '알림',
                        '상시 모집으로 변경되었습니다.',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 3),
                        snackPosition: SnackPosition.BOTTOM,
                      );

                      Get.back();
                    },
                    child: const Text('상시모집'))),
          ],
        ),
        FutureBuilder(
          future: _getApplicationStartDate(), // Firestore에서 데이터 가져오기
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("시작일 로딩 중...");
            }
            if (snapshot.hasError) {
              return Text("에러 발생: ${snapshot.error}");
            }
            if (snapshot.hasData) {
              String startDateText = _formatDateTime(snapshot.data as DateTime);

              return Text("시작일: $startDateText");
            }
            return const SizedBox(); // 데이터가 없는 경우 아무것도 표시하지 않음
          },
        ),
        FutureBuilder(
          future: _getApplicationEndDate(), // Firestore에서 데이터 가져오기
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("종료일 로딩 중...");
            }
            if (snapshot.hasError) {
              return Text("에러 발생: ${snapshot.error}");
            }
            if (snapshot.hasData) {
              String endDateText = _formatDateTime(snapshot.data as DateTime);
              return Text("종료일: $endDateText");
            }
            return const SizedBox(); // 데이터가 없는 경우 아무것도 표시하지 않음
          },
        ),
      ],
    );
  }

  Future<DateTime?> _getApplicationStartDate() async {
    // Firestore에서 applicationPeriodStart 값 가져오기
    // 예를 들어:
    final snapshot = await FirebaseFirestore.instance.doc(club['path']).get();
    final startTimestamp = snapshot.data()?['applicationPeriodStart'];
    return startTimestamp?.toDate();
  }

  Future<DateTime?> _getApplicationEndDate() async {
    final snapshot = await FirebaseFirestore.instance.doc(club['path']).get();
    final endTimestamp = snapshot.data()?['applicationPeriodEnd'];
    return endTimestamp?.toDate();
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일 ${dateTime.hour}시 ${dateTime.minute}분";
  }

  void _showStartApplicationPeriodPicker() async {
    final selectedStartDate = await DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      onChanged: (date) {
        setState(() {
          applicationPeriodStart = date;
        });
      },
      onConfirm: (date) {
        setState(() {
          applicationPeriodStart = date;
        });
        _updateFirestoreWithApplicationStartDate(applicationPeriodStart!);

        // Calculate end date as 1 week from the selected start date
        final applicationPeriodEnd =
            applicationPeriodStart!.add(const Duration(days: 7));
        _updateFirestoreWithApplicationEndDate(applicationPeriodEnd);
        _updateUI();
      },
      currentTime: applicationPeriodStart ?? DateTime.now(),
    );

    // 선택된 시작일이 있을 때 Firestore 업데이트
    if (selectedStartDate != null) {
      _updateFirestoreWithApplicationStartDate(selectedStartDate);

      // Calculate end date as 1 week from the selected start date
      final applicationPeriodEnd =
          selectedStartDate.add(const Duration(days: 7));
      _updateFirestoreWithApplicationEndDate(applicationPeriodEnd);

      _updateUI();
    }
  }

  void _showEndApplicationPeriodPicker() async {
    final selectedDate = await DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      onChanged: (date) {
        setState(() {
          applicationPeriodEnd = date;
        });
      },
      onConfirm: (date) {
        setState(() {
          applicationPeriodEnd = date;
        });
        _updateFirestoreWithApplicationEndDate(applicationPeriodEnd!);
      },
      currentTime: applicationPeriodEnd ?? DateTime.now(),
    );

    // 선택된 날짜가 있을 때 Firestore 업데이트
    if (selectedDate != null) {
      _updateFirestoreWithApplicationEndDate(selectedDate);
      _updateUI();
    }
  }

  void _updateUI() {
    setState(() {
      periodWidget = _buildPeriodWidget();
      _checkJoinPeriod();
      fetchApplicationList(); //신청목록 가져오기

      buildApplicationListButton();
      _buildPeriodWidget();
    });
  }

  void _updateFirestoreWithApplicationStartDate(DateTime start) async {
    try {
      final clubDocRef = FirebaseFirestore.instance.doc(club['path']);

      final clubDocSnapshot = await clubDocRef.get();
      if (!clubDocSnapshot.exists) {
        print("Club document not found in Firestore");
        return;
      }

      final clubData = clubDocSnapshot.data() as Map<String, dynamic>;

      // applicationPeriodStart와 applicationPeriodEnd가 없는 경우 기간 전체를 설정
      if (!clubData.containsKey('applicationPeriodStart') ||
          !clubData.containsKey('applicationPeriodEnd')) {
        // 기간 전체를 설정하려면 어떤 방식으로든 시작과 끝을 설정해야 합니다.
        // 아래의 예시는 현재 날짜와 한 달 후의 날짜로 설정한 예시입니다.
        final now = DateTime.now();
        final oneMonthLater = now.add(const Duration(days: 30));

        await clubDocRef.update({
          'applicationPeriodStart': start,
          'applicationPeriodEnd': oneMonthLater,
        });
      } else {
        // 이미 applicationPeriodStart와 applicationPeriodEnd가 있는 경우
        await clubDocRef.update({
          'applicationPeriodStart': start,
        });
      }

      // Get.back(); // 닫기
      _updateUI();
    } catch (e) {
      print("Error updating Firestore with application start date: $e");
    }
  }

  void _updateFirestoreWithApplicationEndDate(DateTime end) async {
    try {
      final clubDocRef = FirebaseFirestore.instance.doc(club['path']);

      final clubDocSnapshot = await clubDocRef.get();
      if (!clubDocSnapshot.exists) {
        print("Club document not found in Firestore");
        return;
      }

      final clubData = clubDocSnapshot.data() as Map<String, dynamic>;

      // applicationPeriodStart와 applicationPeriodEnd가 없는 경우 기간 전체를 설정
      if (!clubData.containsKey('applicationPeriodStart') ||
          !clubData.containsKey('applicationPeriodEnd')) {
        await clubDocRef.update({
          'applicationPeriodStart': now,
          'applicationPeriodEnd': end,
        });
      } else {
        // 이미 applicationPeriodStart와 applicationPeriodEnd가 있는 경우
        await clubDocRef.update({
          'applicationPeriodEnd': end,
        });
      }

      // Get.back(); // 닫기
      _updateUI();
    } catch (e) {
      print("Error updating Firestore with application end date: $e");
    }
  }
}
