import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClubMemberPage extends StatefulWidget {
  const ClubMemberPage({super.key});

  @override
  State<ClubMemberPage> createState() => _ClubMemberPageState();
}

class _ClubMemberPageState extends State<ClubMemberPage> {
  var club = Get.arguments;
  List<Map> membersDataList = [];
  bool isDataLoading = true;

  @override
  void initState() {
    super.initState();
    getMembersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("동아리 명부"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "동아리 명부",
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: FutureBuilder<void>(
                future: Future.delayed(const Duration(seconds: 1), () => null),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (isDataLoading) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                      itemCount: membersDataList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              '${membersDataList[index]['name']} (${membersDataList[index]['studentID']})'),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(membersDataList[index]['department']),
                              Row(
                                children: [
                                  Text(membersDataList[index]['position']),
                                  TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          String selectedPosition = '';

                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    RadioListTile<String>(
                                                      title: const Text('회장'),
                                                      value: '회장',
                                                      groupValue:
                                                          selectedPosition,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedPosition =
                                                              value!;
                                                        });
                                                      },
                                                    ),
                                                    RadioListTile<String>(
                                                      title: const Text('부회장'),
                                                      value: '부회장',
                                                      groupValue:
                                                          selectedPosition,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedPosition =
                                                              value!;
                                                        });
                                                      },
                                                    ),
                                                    RadioListTile<String>(
                                                      title: const Text('총무'),
                                                      value: '총무',
                                                      groupValue:
                                                          selectedPosition,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedPosition =
                                                              value!;
                                                        });
                                                      },
                                                    ),
                                                    RadioListTile<String>(
                                                      title: const Text('회원'),
                                                      value: '회원',
                                                      groupValue:
                                                          selectedPosition,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedPosition =
                                                              value!;
                                                        });
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        await updateMemberPermission(
                                                            index,
                                                            selectedPosition);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('확인'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: const Text('권한 설정'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('멤버 탈퇴'),
                                            content:
                                                const Text('정말로 탈퇴하시겠습니까?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('취소'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(
                                                          membersDataList[index]
                                                              ['uid'])
                                                      .update({
                                                    'membership':
                                                        FieldValue.arrayRemove([
                                                      {
                                                        'name': club['name'],
                                                        'state': '가입완료',
                                                        'setdate':
                                                            membersDataList[
                                                                    index]
                                                                ['setdate']
                                                      }
                                                    ]),
                                                  });
                                                  // final snapshot = await FirebaseFirestore.instance.collection('user').doc(membersDataList[index]['uid']).get();
                                                  // snapshot['membership']
                                                  await removeMember(index);

                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('탈퇴'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text('탈퇴'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getMembersData() async {
    final snapshot = await FirebaseFirestore.instance.doc(club['path']).get();
    final meme = snapshot.data()?['members'];
    club['members'] = meme;
    membersDataList = [];
    for (int i = 0; i < meme.length; i++) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(meme[i]['uid'])
          .get();
      Map<String, dynamic> memberData = {
        'name': userData.data()!['name'],
        'studentID': userData.data()!['studentID'],
        'department': userData.data()!['department'],
        'position': meme[i]['position'],
        'uid': meme[i]['uid'],
      };

      for (int j = 0; j < userData.data()!['membership'].length; j++) {
        if (userData.data()!['membership'][j]['name'] == club['name']) {
          memberData['setdate'] = userData.data()!['membership'][j]['setdate'];
          print('${memberData['setdate']} 입니다 ');
          break;
        }
      }

      membersDataList.add(memberData);
    }

    setState(() {
      isDataLoading = false;
    });
  }

  Future<void> updateMemberPermission(
      int index, String selectedPosition) async {
    club['members'][index]['position'] = selectedPosition;
    // Firestore 문서에서 'members' 필드 업데이트
    await FirebaseFirestore.instance.doc(club['path']).update({
      'members': club['members'],
    });
    // 화면 새로 고침
    setState(() {
      getMembersData();
    });
  }

  Future<void> removeMember(int index) async {
    club['members'].removeAt(index);
    // Firestore 문서에서 'members' 필드 업데이트
    await FirebaseFirestore.instance.doc(club['path']).update({
      'members': club['members'],
    });

    setState(() {
      getMembersData();
    });
  }
}