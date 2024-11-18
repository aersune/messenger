import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/provider/auth_servive.dart';
import 'package:messenger/screens/auth/login_screen.dart';
import 'package:messenger/screens/home_screen.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  ValueNotifier userCredential = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<AuthService>(context,listen:  false);
    final user = FirebaseAuth.instance.currentUser;
    userCredential.value = user?.email;
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: userCredential,
          builder: (context, value, child) {

            return (user == null || userCredential.value == '' || userCredential.value == null)
                ?  LoginScreen(onSignIn: () async{
                  userCredential.value = await prov.signInWithGoogle();
                  if(userCredential.value != null){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                  }
            })
                : const HomeScreen();
          }),
    );
  }



}
