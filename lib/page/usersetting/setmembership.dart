import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class MembershipPage extends StatefulWidget {
  final String userId;

  const MembershipPage({super.key, required this.userId});

  @override
  _MembershipPageState createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  late List<dynamic> _memberships = []; // 초기화된 빈 목록
  List hasList = [];

  Future<void> _fetchMembership() async {
    try {
      final userDocSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      final userData = userDocSnapshot.data() as Map<String, dynamic>;
      final membershipList = userData['membership'] as List<dynamic>;
      _memberships = membershipList.toList();

      setState(() {
        for (int i = 0; i < _memberships.length; i++) {
          hasList.add(_memberships[i]);
        }
      });
    } catch (e) {
      print('Error fetching membership: $e');
    }
  }

  Future<void> _refreshUserData() async {
    await _fetchMembership();
    setState(() {}); // 화면 리로드
  }

  @override
  void initState() {
    super.initState();
    _refreshUserData(); // 초기 데이터 로딩
  }

  Future<void> Membershipremove() async {
    // Firestore 문서에서 'members' 필드 업데이트
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .update({
      'membership': hasList,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue[700],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('동아리 순서 설정'),
              TextButton(
                  onPressed: () {
                    Membershipremove();
                    Get.back();
                  },
                  child: const Text('저장',
                      style: TextStyle(color: Colors.white, fontSize: 16)))
            ],
          )),
      body: Container(
        color: const Color.fromARGB(255, 246, 246, 246),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ReorderableListView.builder(
            itemCount: hasList.length,
            itemBuilder: (context, index) {
              return ListTile(
                key: ValueKey(index), // 각 항목의 값을 키로 사용
                title: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        '동아리 이름 : ${hasList[index]['name']}\n상태 ${hasList[index]['state']}',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            },
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = hasList.removeAt(oldIndex);
                hasList.insert(newIndex, item);
              });
            },
          ),
        ),
      ),
    );
  }
}