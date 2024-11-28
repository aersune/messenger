import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/widgets/drawer_menu.dart';
import 'package:messenger/widgets/user_card.dart';
import 'package:provider/provider.dart';
import '../provider/user_status.dart';
import 'chat_room_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final DatabaseReference _statusRef = FirebaseDatabase.instance.ref("status");

  // @override
  // void initState() {
  //   super.initState();
  //   _statusRef.onValue.listen((DatabaseEvent event) {
  //     final data = Map<String, dynamic>.from(event.snapshot.value as Map);
  //     List<UserStatus> statuses = [];
  //     data.forEach((userId, statusData) {
  //       statuses.add(UserStatus.fromMap(userId, statusData));
  //     });
  //     setState(() {
  //       _userStatuses = statuses;
  //       print(_userStatuses[0].isOnline);
  //     });
  //     print(_userStatuses[0].isOnline);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // final userStatus = Provider.of<UserStatusService>(context, listen: false);
    // userStatus.init();
    final setUserStatus = Provider.of<UserStatusService>(context, listen: false);
    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: AppBar(
        title: const Text("Messages"),
        actions: [
          IconButton(
            onPressed: () {
              // print(_userStatuses[0].isOnline);
            },
            icon: const Icon(
              CupertinoIcons.search,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: StreamBuilder(
          stream: _statusRef.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            List<UserStatus> statuses = data.entries.map((entry) {
              return UserStatus.fromMap(entry.key, entry.value);
            }).toList();
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: _buildUserList(statuses),
              ),
            );
          }),
    );
  }

  Widget _buildUserList(List<UserStatus> statuses) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }



        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 20),
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot document = snapshot.data!.docs[index];
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            UserStatus userStatus = statuses[index];
            print(userStatus.status);
            return buildUserListItem(document,index, userStatus);
          },);
        //   ListView(
        //   shrinkWrap: true,
        //   physics: const NeverScrollableScrollPhysics(),
        //   padding: const EdgeInsets.symmetric(vertical: 20),
        //   children: snapshot.data!.docs.asMap().entries.map((entry) {
        //     int index = entry.key;
        //     UserStatus userStatus = statuses[index];
        //     DocumentSnapshot document = entry.value;
        //     Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        //     return buildUserListItem(document, index, userStatus);
        //   }).toList(),
        // );
      },
    );
  }

  Widget buildUserListItem(DocumentSnapshot document, int index, UserStatus userStatus) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    if (_auth.currentUser!.email != data['email']) {
      return UserCard(
        name: data['name'],
        email: data['email'],
        // imageUrl: data['imageUrl'],
        callback: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChatRoomScreen(
              receiverUserEmail: data['email'],
              receiverUserId: data['uid'],
              receiverUserName: data['name'],
            );
          }));
        },
        isOnline: userStatus.status == 'online',
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
