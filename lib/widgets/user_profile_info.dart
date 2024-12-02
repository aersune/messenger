import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messenger/model/user.dart';

import '../utils/colors.dart';

class UserProfileInfo extends StatelessWidget {
  final UserData userData;

  const UserProfileInfo({super.key, required this.userData});

  void showImagePopup(BuildContext context, String imageUrl) {
    final size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: size.width * 0.8,
            height: size.width * 0.6,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
              )
            ),
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage(
              "assets/bg.jpg",
            ),
            colorFilter: ColorFilter.mode(Colors.greenAccent.withOpacity(.4), BlendMode.srcOver),
            fit: BoxFit.cover,
          ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 8.0,
              sigmaY: 9.0,
            ),
            child: Center(
              child: Container(
                width: size.width * .8,
                height: size.height * .6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: (){
                              showImagePopup(context, userData.imageUrl);
                            },
                            child: CachedNetworkImage(
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                imageUrl: userData.imageUrl,
                                imageBuilder: (context, imageProvider) => CircleAvatar(
                                      backgroundImage: imageProvider,
                                      radius: 80,
                                    )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 50),
                              const Text(
                                'Username',
                                style: TextStyle(fontSize: 12, color: AppColors.dark2, letterSpacing: 1.5),
                              ),
                              Text(
                                userData.name,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.dark2,
                                    letterSpacing: 1.5),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Email',
                                style: TextStyle(fontSize: 15, color: AppColors.dark2, letterSpacing: 1.5),
                              ),
                              Text(
                                userData.email,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.dark2,
                                    letterSpacing: 1.5),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        )
                      ],
                    ),
                    Positioned(
                        left: 0,
                        top: 20,
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new_sharp,
                              color: Colors.white.withOpacity(.5),
                            ))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
