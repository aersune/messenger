import 'package:flutter/material.dart';
import 'package:messenger/screens/chat_room_screen.dart';

import '../utils/colors.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,

      child: InkWell(
        splashColor: AppColors.dark2.withOpacity(.4),
        highlightColor: AppColors.light.withOpacity(.4),
        // highlightColor: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const ChatRoomScreen();
          }));
        },
        child: Ink(
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  const Text(
                    "Danny Hopkins",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.light,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "dannylove@gmail.com",
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
