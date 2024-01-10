import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '홈 위젯/getcontrolluser.dart';

class EnterInformationPage extends StatefulWidget {
  final UserSettingsController controller;

  const EnterInformationPage({super.key, required this.controller});

  @override
  State<EnterInformationPage> createState() => _EnterInformationPageState();
}

class _EnterInformationPageState extends State<EnterInformationPage> {
  late UserSettingsController controller;
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? phoneNumber;
  String? studentID;
  String? department;
  List<String> departments = [
    '국어국문학과',
    '영어영문학과',
    '독어독문학과',
    '불어불문학과',
    '일어일문학과',
    '사학과',
    '철학과',
    '유아교육과',
    '특수교육과',
    '법학과',
    '행정학과(주)',
    '행정학과(야)',
    '국제관계학과',
    '중국학과',
    '사회학과',
    '신문방송학과',
    '사회복지학과',
    '글로벌비즈니스학부',
    '국제무역학과',
    '경영학과',
    '회계학과',
    '세무학과',
    '국제무역학과(야)',
    '수학과',
    '물리학과',
    '생물학화학융합학부',
    '통계학과',
    '의류학과',
    '식품영양학과',
    '체육학과',
    '간호학과',
    '생명보건학부',
    '산업시스템공학과',
    '조선해양공학과',
    '스마트그린공학부',
    '스마트그린공학부 환경에너지공학전공',
    '스마트그린공학부 화학공학전공',
    '스마트그린공학부 건설시스템공학전공',
    '건축학전공',
    '건축공학전공',
    '컴퓨터공학과',
    '정보통신공학과',
    '스마트오션모빌리티공학과',
    '기계공학부',
    '스마트제조융합전공',
    '전기공학전공',
    '전자공학전공',
    '로봇제어계측공학전공',
    '신소재공학부',
    '음악과',
    '미술학과',
    '산업디자인학과',
    '무용학과',
    '신산업융합경영학과',
    '메카융합공학과',
    '창업자산융합학부',
    '항노화헬스케어학과',
    '문화테크노학과',
    '에너지융합공학과',
  ];

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    widget.controller.fetchUserInfo();
    controller.userProfile.userdepartment = departments[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "정보를 입력해주세요!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildTextFormField(
                            initialValue: controller.userProfile.username,
                            onSaved: (value) {
                              name = value;
                            },
                            labelText: '이름',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '이름을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          buildTextFormField(
                            initialValue:
                                controller.userProfile.userphoneNumber,
                            onSaved: (value) {
                              phoneNumber = value;
                            },
                            labelText: '전화번호',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '전화번호를 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          buildTextFormField(
                            initialValue: controller.userProfile.studentID,
                            onSaved: (value) {
                              studentID = value;
                            },
                            labelText: '학번',
                            validator: (value) {
                              if (value!.length != 8) {
                                return '학번을 올바로 입력해주세요';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          buildDropdownFormField(),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set({
                        'name': name,
                        'phoneNumber': phoneNumber,
                        'studentID': studentID,
                        'department': department,
                      });
                    }
                    Get.back();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(16.0)),
                    child: const Center(
                      child: Text(
                        "확인",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField({
    required String? initialValue,
    required void Function(String?)? onSaved,
    String? labelText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool readOnly = false,
    void Function()? onTap,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onSaved: onSaved,
      validator: validator,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget buildDropdownFormField() {
    return DropdownButtonFormField<String>(
      value: null,
      onChanged: (newValue) {
        setState(() {
          department = newValue!;
        });
      },
      items: departments.map((department) {
        return DropdownMenuItem<String>(
          value: department,
          child: Text(department),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: '학과',
        border: OutlineInputBorder(),
      ),
    );
  }
}
