import 'package:flutter/material.dart';
import 'package:messenger/screens/chat_room_screen.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';
import '../utils/colors.dart';

class UserCard extends StatelessWidget {
  final String name;
  // final String imageUrl;
  final String email;
  final VoidCallback callback;
  const UserCard({super.key, required this.name,  required this.email, required this.callback});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = context.watch<ThemeProvider>();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: AppColors.dark2.withOpacity(.4),
        highlightColor: AppColors.light.withOpacity(.4),
        // highlightColor: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        onTap: () {
          callback();
        },
        child: Ink(
          decoration:  BoxDecoration(
            color: theme.isDark ? AppColors.dark.withOpacity(.8) : AppColors.light.withOpacity(.3),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          height: size.height * 0.1,
          width: size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 20,
              ),
              Container(
                height: size.height * 0.08,
                width: size.width * 0.15,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage("https://picsum.photos/200"),
                      fit: BoxFit.cover,
                    )),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      color: AppColors.light,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.light.withOpacity(.7),
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
              const Spacer(),
              Text(
                'Tue',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.light.withOpacity(.7)),
              ),
              const SizedBox(
                width: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
