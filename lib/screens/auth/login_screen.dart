import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messenger/utils/colors.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onSignIn});
  final VoidCallback onSignIn ;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            // opacity: 0.9,
            fit: BoxFit.cover,
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width * 0.8,
                height: size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: size.width * 0.5,
                      child: Image.asset("assets/chat.png"),
                    ),

                     Text(
                      "Login to your account",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        color: AppColors.light,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      )
                    ),
                    loginButton(size.width,widget.onSignIn ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButton(double width, Function onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        elevation: 1,
        shadowColor: AppColors.light,
      ),
      icon: SizedBox(
          height: width * 0.05,
          child: Image.asset('assets/google_icon.png')),
      onPressed: () {
        onPressed();
      },
          label: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Sign in from ',
                  style: TextStyle(fontSize: 18, color: AppColors.light),
                ),
                TextSpan(
                  text: 'Google',
                  style: TextStyle(fontSize: 18, color: AppColors.light, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),    );
  }
}
