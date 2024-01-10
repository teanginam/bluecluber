import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tttttt/current_user.dart';
import 'package:tttttt/enter_information_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tttttt/page/usersetting/NotificationSettingsPage.dart';
import 'package:tttttt/page/usersetting/del.dart';
import 'package:tttttt/page/usersetting/setmembership.dart';

import '../홈 위젯/getcontrolluser.dart'; // 경로 수정

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  final controller = Get.put(UserSettingsController());

  void _signOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃 확인'),
          content: const Text('로그아웃하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 알림 창 닫기
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                // FirebaseAuth를 사용하여 로그아웃
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop(); // 알림 창 닫기
                // 로그아웃 후에 필요한 작업 수행
              },
              child: const Text('로그아웃'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshUserData() async {
    await controller.fetchUserInfo();
    setState(() {}); // 화면 리로드
  }

  @override
  void initState() {
    super.initState();
    _refreshUserData(); // 초기 데이터 로딩
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사용자 설정'),
        backgroundColor: Colors.blue[700],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(controller.userProfile.url),
                  ),
                  title: Text(controller.userProfile.username),
                  subtitle: Text(controller.userProfile.email),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    Get.to(EnterInformationPage(
                      controller: controller,
                    ));
                    _refreshUserData();
                  },
                ),
                const Divider(),
                _buildSettingItem('알림 설정', () {
                  Get.to(const NotificationSettingsPage());
                }),
                const Divider(),
                _buildSettingItem('계정 관리', () {
                  Get.to(const AccountManagementPage());
                }),
                _buildSettingItem('동아리 순서 설정', () {
                  Get.to(MembershipPage(userId: CurrentUser.getUid()));
                }),
                const Divider(),
                _buildSettingItem('로그아웃', () {
                  _signOut(context); // 수정된 부분
                }),
                const Divider(),
                const ListTile(
                  title: Text('앱 버전'),
                  subtitle: Text('1.0.0'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: onTap,
    );
  }
}