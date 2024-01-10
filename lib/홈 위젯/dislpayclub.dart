import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tttttt/current_user.dart';
import 'package:tttttt/datalist/club.dart' as datalist;
import 'package:tttttt/datalist/userData.dart';
import 'package:tttttt/pages/club_page.dart';
import 'package:tttttt/pages/list_page.dart';

class DisplayClub extends StatelessWidget {
  final List<dynamic> clubnames;
  String? hasclub;
  String? clubname;
  userData userdata;
  // final userData = snapshot.data!.data() as Map<String, dynamic>;

  DisplayClub({Key? key, required this.clubnames, required this.userdata})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.225,
      child: PageView.builder(
        controller: PageController(),
        itemCount: clubnames.length,
        itemBuilder: (context, index) {
          if (clubnames[index]['state'].toString().contains("신청완료")) {
            clubname = clubnames[index]['name'];
            // clubname = hasclub!.substring(1, hasclub!.indexOf(':'));
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: StandbyClub(clubname: clubname!),
            );
          } else {
            clubname = clubnames[index]['name'];
            // clubname = hasclub!.substring(1, hasclub!.indexOf(':'));
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.225,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                    child: HurricaneClubDisplayWidget(
                        clubname: clubname!, username: userdata, index: index)),
              ),
            );
          }
        },
      ),
    );
  }
}

class StandbyClub extends StatelessWidget {
  final String clubname;

  const StandbyClub({Key? key, required this.clubname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(const ListPage(0));
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.225,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            '$clubname 동아리에서 가입신청 대기중입니다 \n \n 더 많은 동아리 둘러보기',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class HurricaneClubDisplayWidget extends StatelessWidget {
  final String clubname;
  userData username;
  int index;
  var dataclub;
  String? king;
  String? position;

  HurricaneClubDisplayWidget(
      {Key? key,
      required this.clubname,
      required this.username,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime settime = username.membership?[index]['setdate'].toDate();
    String formattedDate = DateFormat('yy-MM-dd').format(settime);
    return FutureBuilder<Map<String, dynamic>?>(
      future: findAndDisplayHurricaneClubs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data != null) {
          final clubData = snapshot.data!;
          dataclub = clubData;
          for (int i = 0; i < dataclub['members'].length; i++) {
            if (dataclub['members'][i]['position'] == '회장') {
              king = dataclub['members'][i]['name'];
              print(king);
              if (king == username.name) {
                position = "회장";
                print('$king + $i');
                break;
              }
            } else if (dataclub['members'][i]['uid'] == CurrentUser.getUid()) {
              position = clubData['members'][i]['position'];
              print('아냐아냐 $i');
              print(position);
            }
          }
          return InkWell(
            onTap: () {
              Get.to(
                const ClubPage(),
                arguments: clubData,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 9,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 100,
                            color: Colors.white,
                            child: FittedBox(
                              child: Text(
                                '${clubData['name'] ?? "없음"}',
                                style: const TextStyle(
                                    // fontSize: maxfonts,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Pretendard'),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 12,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          username.name,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Pretendard'),
                                        ),
                                        Text(
                                          position ?? '',
                                          textAlign: TextAlign.end,
                                        ),
                                        SizedBox(
                                          child: Text(
                                            '가입일 : $formattedDate',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // const SizedBox(width: 2,),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                  height: double.infinity,
                                  width: 1, // 선의 너비 설정
                                  color: Colors.grey,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "회장 :$king",
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        // const Text('허리케인 동아리를 찾아서 표시했습니다'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Text('동아리를 찾지 못했습니다');
        }
      },
    );
  }

  Future<Map<String, dynamic>?> findAndDisplayHurricaneClubs() async {
    try {
      final CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('clubs');
      DocumentReference documentRef = collectionRef.doc('8VKWlkDX4wmGnrjAI4q9');

      // 메인 문서의 서브컬렉션에 대한 참조를 가져옵니다
      List<String> subcollectionNames = datalist.categories;

      for (final subcollectionName in subcollectionNames) {
        // 서브컬렉션에 대한 참조를 가져옵니다
        CollectionReference subcollectionRef =
            documentRef.collection(subcollectionName);

        // 서브컬렉션의 문서들을 가져옵니다
        QuerySnapshot subcollectionSnapshot = await subcollectionRef.get();

        for (final subcollectionDoc in subcollectionSnapshot.docs) {
          final subcollectionDocData =
              subcollectionDoc.data() as Map<String, dynamic>;

          // 데이터에 접근하기 전에 널 체크를 수행합니다
          if (subcollectionDocData['name'] == clubname) {
            // 경로를 가져옵니다
            String path = subcollectionDoc.reference.path;

            // 경로를 clubData 맵에 추가합니다
            subcollectionDocData['path'] = path;

            return subcollectionDocData;
          }
        }
      }

      return null;
    } catch (e) {
      print('오류: $e');
      return null;
    }
  }
}