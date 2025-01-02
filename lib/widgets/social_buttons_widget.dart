import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';




class SocialButtonsWidget extends StatelessWidget {
  final VoidCallback callback;
  const SocialButtonsWidget({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .7,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            socialButton(icon: Remix.google_fill, callback: () {callback();}),
            socialButton(icon: Icons.apple, callback: (){}),
            socialButton(icon: Icons.facebook, callback: (){}),

          ],
        ),
      ),
    );
  }
  Widget socialButton({required IconData icon, required VoidCallback callback,}) {
    return IconButton(
        onPressed: () {
          callback();
        },
        style: IconButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(.2)
        ),
        icon:  Icon(icon, color: Colors.white, size: 30,));
  }
}
