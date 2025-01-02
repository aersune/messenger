import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messenger/utils/colors.dart';
import 'package:messenger/widgets/social_buttons_widget.dart';

import '../../widgets/login_form_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: const AssetImage("assets/bg.jpg"),
            colorFilter: ColorFilter.mode(Colors.greenAccent.withOpacity(.4), BlendMode.srcOver),
            // opacity: 0.9,
            fit: BoxFit.cover,
          )),
          child: SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 8.0,
                    sigmaY: 9.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width * 0.8,
                        // height: size.height * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(height: 30,),
                            SizedBox(
                              width: size.width * 0.3,
                              child: Image.asset(
                                "assets/chat.png",
                                color: Colors.white,
                              ),
                            ),
                            Text("Login to your account",
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 20,
                                  color: AppColors.light,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                )),
                            const LoginFormWidget(),
                            SocialButtonsWidget(callback: widget.onSignIn),
                            // loginButton(size.width, widget.onSignIn),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


}
