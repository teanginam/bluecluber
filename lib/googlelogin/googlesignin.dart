import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tttttt/firebase_options.dart';

class AuthService {
  Future<UserCredential> signInWithGoogle() async {
    print("구글로그인");
    // Trigger the authentication flow
    // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn(); ------> 원래 이거였는데 ios 로그인 안되서 밑에처럼 바꿈
    final GoogleSignInAccount? googleUser = await GoogleSignIn(clientId: DefaultFirebaseOptions.currentPlatform.iosClientId).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
