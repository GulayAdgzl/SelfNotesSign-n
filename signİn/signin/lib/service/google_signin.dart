import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Model/firebase_user.dart';

class GoogleSignHelper {
  static GoogleSignHelper _instance = GoogleSignHelper._private();
  GoogleSignHelper._private();
  static GoogleSignHelper get instance => _instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //1.yöntem
  Future<GoogleSignInAccount?> signIn() async {
    final user = await _googleSignIn.signIn();
    if (user != null) {
      print(user.email);
      return user;
    }
    return null;
  }

  //2.yöntem
  Future<GoogleSignInAuthentication?> googleAuthtencite() async {
    if (await _googleSignIn.isSignedIn()) {
      final user = await _googleSignIn.currentUser;
      final userData = await user?.authentication;
      //print(userData?.accessToken);
      return userData;
    }
    return null;
  }

  //SigOut
  Future<GoogleSignInAccount?> signOut() async {
    final user = await _googleSignIn.signOut();
    if (user != null) {
      print(user.email);
      return user;
    }
    return null;
  }

  Future<FirebaseUser?> firebaseSignin() async {
    final GoogleSignInAuthentication? googleAuth = await googleAuthtencite();

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user as FirebaseUser;
    //print("signed in " + user.displayName);
  }
}
