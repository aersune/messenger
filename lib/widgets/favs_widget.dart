import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/widgets/card_subtitle.dart';
import 'package:provider/provider.dart';
import '../provider/chat_service.dart';
import '../provider/theme_provider.dart';
import '../utils/colors.dart';

class FavoritesWidget extends StatelessWidget {
  final VoidCallback callback;

  const FavoritesWidget({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = context.watch<ThemeProvider>();
    final chatProvider = Provider.of<ChatService>(context, listen: false);
    final FirebaseAuth auth = FirebaseAuth.instance;

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
          decoration: BoxDecoration(
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
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/favs.png',
                    color: Colors.white,
                    // fit: BoxFit.cover,
                    scale: 20,
                  )),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: size.width * .65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Favorites",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.light,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    CardSubtitle(stream: chatProvider.getMessages(auth.currentUser!.uid, auth.currentUser!.uid))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
