import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClubInformationPage extends StatefulWidget {
  const ClubInformationPage({super.key});

  @override
  State<ClubInformationPage> createState() => _ClubInformationPageState();
}

class _ClubInformationPageState extends State<ClubInformationPage> {
  final club = Get.arguments;
  final _formKey = GlobalKey<FormState>();
  List<String> fixed_information = [];
  String? clubName;
  String? clubInfor;
  String? clubTag;
  String? clubIntro;
  bool isLoading = true;

  // 동아리 이름과 소개글 가져오기
  void fetchClubData() async {
    final clubData = await FirebaseFirestore.instance.doc(club['path']).get();
    clubName = clubData.data()!['name'];
    clubInfor = clubData.data()!['information'];
    clubTag = clubData.data()!['tag'];
    clubIntro = clubData.data()!['introduction'];

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchClubData();
    return Scaffold(
      body: isLoading
          ? const Center(
              child: Text("동아리 정보 불러오는 중 ....."),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Column(children: [
                  Text(
                    "$clubName 정보",
                    style: const TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Divider(
                            thickness: 2,
                          ),
                          // buildTextFormField(
                          //   information_section: '동아리 이름',
                          //   information: clubName,
                          //   onSaved: (value) {
                          //     fixed_information.add(value);
                          //   },
                          // ),
                          buildTextFormField(
                            information_section: '상세 정보',
                            information: clubInfor,
                            onSaved: (value) {
                              fixed_information.add(value);
                            },
                          ),
                          buildTextFormField(
                            information_section: '동아리 태그',
                            information: clubTag,
                            onSaved: (value) {
                              fixed_information.add(value);
                            },
                          ),
                          buildTextFormField(
                            information_section: '동아리 소개',
                            information: clubIntro,
                            onSaved: (value) {
                              fixed_information.add(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //취소하기 버튼
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 220, 74, 64),
                        ),
                        child: const Text(
                          "취소하기",
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      // 수정하기 버튼
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.defaultDialog(
                              title: '동아리 정보',
                              content: const Text("수정하시겠습니까?"),
                              textConfirm: '확인',
                              confirmTextColor: Colors.white,
                              onConfirm: () async {
                                _formKey.currentState!.save();
                                await FirebaseFirestore.instance
                                    .doc(club['path'])
                                    .update({
                                  // 'name': fixed_information[0],
                                  'information': fixed_information[0],
                                  'tag': fixed_information[1],
                                  'introduction': fixed_information[2],
                                });

                                Get.back();
                                Get.snackbar('동아리 정보', '수정이 완료 되었습니다');
                              },
                              textCancel: '취소',
                              onCancel: () {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                        ),
                        child: const Text(
                          "수정하기",
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
    );
  }
}

// 동아리 정보 섹션마다 텍스트폼 만들기
class buildTextFormField extends StatelessWidget {
  const buildTextFormField({
    super.key,
    this.information_section,
    this.information,
    this.onSaved,
  });
  final information_section;
  final information;
  final onSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: information, //텍스트필드에 미리 적혀있는 정보
          maxLines: information_section == '동아리 소개'
              ? 10
              : null, // 글자 수에 따라 자동으로 텍스트필드 커짐
          onSaved: onSaved,
          decoration: InputDecoration(
            labelText: information_section,
          ),
        ),
      ],
    );
  }
}
