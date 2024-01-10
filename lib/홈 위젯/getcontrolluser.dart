
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tttttt/current_user.dart'; // CurrentUser 가져오기

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class UserProfile {
  String username;
  String userdepartment;
  String email;
  String url;
  String studentID;
  String userphoneNumber;

  UserProfile({
    required this.username,
    required this.userdepartment,
    required this.url,
    required this.email,
    required this.studentID,
    required this.userphoneNumber,
  });
} // UserProfile 클래스 뒤에 세미콜론 추가

class UserSettingsController extends GetxController {
  UserProfile userProfile = UserProfile(
    username: '새로고침 해주세요',
    userphoneNumber: '',
    userdepartment: '',
    email: '',
    studentID: '',
    url: 'https://picsum.photos/id/870/200/300?grayscale&blur=2',
  );

  // 파이어스토어에서 userProfile 정보 가져오는 함수
  Future<void> fetchUserInfo() async {
    try {
      final userDocSnapshot = await CurrentUser.getDocRef().get();
      final userData = userDocSnapshot.data() as Map<String, dynamic>;
      userProfile.username = userData['name'];
      userProfile.userdepartment = userData['department'];
      userProfile.studentID = userData['studentID'];
      userProfile.userphoneNumber = userData['phoneNumber'];
      // userProfile.url = 'https://picsum.photos/id/870/200/300?grayscale&blur=2';
      update();
    } catch (e) {
      print('userProfile 정보 가져오기 오류: $e');
    }
    try {
      // 현재 로그인된 사용자의 UID 가져오기
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        userProfile.email = user.email!;
        userProfile.url = user.photoURL!;
        print(userProfile.email);
      } else {
        print('로그인되지 않았습니다.');
      }
    } catch (e) {
      print('사용자 정보 가져오기 오류: $e');
    }
  }
}