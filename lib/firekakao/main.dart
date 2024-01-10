import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:tttttt/%ED%99%88%20%EC%9C%84%EC%A0%AF/getcontrolluser.dart';
import 'package:tttttt/enter_information_page.dart';
import 'package:tttttt/notification/notification.dart';
import '../googlelogin/googlesignin.dart';
import '../홈 위젯/viewbottom.dart';
import 'kakao_login.dart';
import 'main_view_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final viewModel = MainViewModel(KakaoLogin());
  bool isLoading = false;

  final controller = Get.put(UserSettingsController());

  @override
  void initState() {
    FlutterLocalNotification.init();

    // 3초 후 권한 요청
    Future.delayed(const Duration(seconds: 3),
        FlutterLocalNotification.requestNotificationPermission());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Center(
          child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                // 로그인이 안되었을때 페이지 --------------------------
                if (!snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                            width: double.infinity,
                            child: Text(
                              "창원대학교 \n동아리",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 50,
                              ),
                            )),
                        // const Image(image: AssetImage('assets/images/logo.png')),
                        const SizedBox(
                          height: 80,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "- SNS 로그인 -",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        // 카카오 로그인 버튼 ---------------------------------
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await viewModel.login();
                            FlutterLocalNotification.showNotificationkakao();

                            setState(() {
                              isLoading = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 254, 229, 0)),
                          child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 15, 0, 15),
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/Shape2.png'),
                                              ),
                                            ),
                                            Text(
                                              '  카카오 로그인',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            ),
                                          ]),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // 구글로그인 버튼 ----------------------------------
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await AuthService().signInWithGoogle();
                            FlutterLocalNotification.showNotification();
                            setState(() {
                              isLoading = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 255, 255)),
                          child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/googlelogo.png'),
                                              ),
                                            ),
                                            Text(
                                              ' 구글 로그인',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            ),
                                          ]),
                              )),
                        ),
                      ],
                    ),
                  );
                }

                //만약에 파이어베이스에 유저 정보가 없다면 정보입력페이지로 이동
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.data == null || !snapshot.data!.exists) {
                        return EnterInformationPage(controller: controller);
                      }

                      // 로그인이 되었으면 이동하는 페이지
                      return const Center(child: buttomview());
                    });
              }),
        ),
      ),
    );
  }
}