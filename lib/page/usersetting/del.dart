import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountManagementPage extends StatelessWidget {
  const AccountManagementPage({super.key});

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('계정 탈퇴'),
          content: const Text('정말 계정을 탈퇴하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteAccount();
                Navigator.of(context).pop(); // Close the confirmation dialog
                Navigator.of(context)
                    .pop(); // Close the account management page
              },
              child: const Text('탈퇴'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      print('계정 삭제 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계정 관리'),
      ),
      body: ListView(
        children: [
          const Divider(),
          ListTile(
            title: const Text('계정 탈퇴'),
            onTap: () {
              _showDeleteConfirmation(context);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
