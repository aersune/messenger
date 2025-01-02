import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();


  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final isweb = kIsWeb;

  Future signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      UserCredential userCredential = await firebaseAuth.signInWithPopup(googleProvider);
      final user = userCredential.user;
      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': user.displayName,
            'email': user.email,
            'isOnline': true,
            'photoUrl': user.photoURL,
          });
        }
      }

    }else{
    try {

        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        final userCredential = await firebaseAuth.signInWithCredential(credential);

        final userDoc = await _firestore.collection('users').doc(userCredential.user?.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(userCredential.user?.uid).set({
            'uid': userCredential.user!.uid,
            'name': userCredential.user!.displayName,
            'email': userCredential.user!.email,
            'isOnline': true,
            'photoUrl': userCredential.user!.photoURL,
          }, SetOptions(merge: false));
        }
        return await FirebaseAuth.instance.signInWithCredential(credential);



    } on Exception catch (e) {
      if (kDebugMode) {
        print('exception: $e');
      }
    }}
  }
}
