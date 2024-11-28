import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService extends ChangeNotifier{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  Future signInWithGoogle() async{
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential = await firebaseAuth.signInWithCredential(credential);
       _firestore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user!.uid,
        'name': userCredential.user!.displayName,
        'email': userCredential.user!.email,
         'isOnline': true,
      },  SetOptions(merge: false));
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch(e){
      if (kDebugMode) {
        print('exception: $e');
      }
    }
  }

  void setUserState(bool isOnline) async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'isOnline': isOnline,
      });
    }
  }
}