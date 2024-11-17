import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/utils/colors.dart';
import 'package:messenger/widgets/user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text("Messages"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.search, color: Colors.white,),
          ),
          const SizedBox(width: 20,)
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topRight,
            colors: [
              AppColors.primary,
              AppColors.primary2.withOpacity(.5),
            ],
          )
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserCard(),
            ],
          ),
        ),
      ),
    );
  }
}
