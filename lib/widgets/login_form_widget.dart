import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import '../provider/auth_servive.dart';
import '../utils/colors.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  bool isRegister = false;
  bool showPass = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authServiceProv = context.read<AuthService>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isRegister ? "If you already have an account" : "If you don't have an account:",
              style: const TextStyle(fontSize: 12, color: AppColors.light),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    isRegister = !isRegister;
                  });
                },
                child: Text(
                  isRegister ? 'Login...' : 'Register...',
                  style: const TextStyle(fontSize: 14, color: AppColors.deepGreen),
                )),
          ],
        ),
        const SizedBox(height: 10),
        buildTextField(size: size, isPassword: false, controller: authServiceProv.emailController, hintText: 'Email'),
        const SizedBox(height: 10),
        buildTextField(
            size: size,
            isPassword: true,
            controller: authServiceProv.passwordController,
            hintText: isRegister ? 'Create password' : 'Password'),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          // height: isRegister ? size.height * .1 : 20,
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: isRegister ? 1 : 0,
            child: Visibility(
              visible: isRegister,
              maintainSize: false,
              maintainAnimation: true,
              maintainState: true,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  buildTextField(
                      size: size,
                      isPassword: true,
                      controller: authServiceProv.confirmPassword,
                      hintText: 'Confirm Password'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        loginButton(size.width, () {}, isRegister),
      ],
    );
  }

  Widget buildTextField(
      {required Size size,
      required bool isPassword,
      required TextEditingController controller,
      required String hintText}) {
    return Container(
      width: size.width * 0.7,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        textInputAction: TextInputAction.next,
        controller: controller,
        obscureText: (isPassword && !showPass) ? true : false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(isPassword ? Icons.key : Icons.email, color: Colors.white),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPass = !showPass;
                    });
                  },
                  icon: Icon(!showPass ? Icons.visibility : Icons.visibility_off),
                  color: AppColors.light,
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(.8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget loginButton(double width, Function onPressed, bool isRegister) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      elevation: 5,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: (){
          onPressed();
        },
        child: Ink(
          width: width * .7,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.light,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isRegister ? Remix.login_box_fill : Remix.login_box_line,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Sign ${isRegister ? 'UP' : 'In'}'.toUpperCase(),
                style: const TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
