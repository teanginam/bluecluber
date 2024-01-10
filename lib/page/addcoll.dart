import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class addcol extends StatefulWidget {
  const addcol({super.key});

  @override
  State<addcol> createState() => addcolState();
}

class addcolState extends State<addcol> {
  // final CollectionReference clubsCollection =
  //     FirebaseFirestore.instance.collection('clubs');

  final CollectionReference clubsCollection =
      FirebaseFirestore.instance.collection('clubs');

  Future<void> cloneSubcollection(
      String sourceClubId, String targetClubId) async {
    try {
      // 소스 서브컬렉션의 문서 가져오기
      QuerySnapshot subcollectionSnapshot =
          await clubsCollection.doc(sourceClubId).collection('문화 2분과').get();

      // 각 문서를 복제하여 타겟 서브컬렉션에 추가
      for (QueryDocumentSnapshot docSnapshot in subcollectionSnapshot.docs) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        // 문서 ID 가져오기
        String docId = docSnapshot.id;

        // 각 문서를 타겟 서브컬렉션에 추가
        await clubsCollection
            .doc(targetClubId)
            .collection('학술분과')
            .doc(docId)
            .set(data);
      }

      print('Subcollection and documents cloned successfully.');
    } catch (e) {
      print('Error cloning subcollection: $e');
    }
  }

  void createSubcollection() async {
    try {
      // clubs 컬렉션에 새로운 서브컬렉션 추가
      await clubsCollection
          .doc('8VKWlkDX4wmGnrjAI4q9')
          .collection('members')
          .add({
        'name': 'John Doe',
        'email': 'johndoe@example.com',
      });

      print('Subcollection created successfully.');
    } catch (e) {
      print('Error creating subcollection: $e');
    }
  }

  void updateClubName() async {
    try {
      // clubs 컬렉션에서 이름이 '체육 1분과'인 문서 찾기
      QuerySnapshot querySnapshot =
          await clubsCollection.where('doc', isEqualTo: '체육 1분과').get();

      // 일치하는 문서가 있는지 확인
      if (querySnapshot.docs.isNotEmpty) {
        // 첫 번째 일치하는 문서의 참조 가져오기
        DocumentReference docRef = querySnapshot.docs[0].reference;

        // 이름 수정
        await docRef.update({'name': '체육 1'});
        print('Club name updated successfully.');
      } else {
        print('No club with the given name found.');
      }
    } catch (e) {
      print('Error updating club name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Subcollection Example'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            // 원본 클럽 문서의 ID와 타겟 클럽 문서의 ID를 전달하여 복제
            cloneSubcollection('8VKWlkDX4wmGnrjAI4q9', '8VKWlkDX4wmGnrjAI4q9');
          },
          child: const Text('Create Subcollection'),
        ),
      ),
    );
  }
}
