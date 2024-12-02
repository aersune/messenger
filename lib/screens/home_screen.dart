import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/model/user.dart';
import 'package:messenger/widgets/drawer_menu.dart';
import 'package:messenger/widgets/list.dart';
import 'package:messenger/widgets/user_card.dart';
import 'package:provider/provider.dart';
import '../provider/chat_service.dart';
import '../provider/user_status.dart';
import '../widgets/favs_widget.dart';
import 'chat_room_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;



  final DatabaseReference _statusRef = FirebaseDatabase.instance.ref('status');

  @override
  Widget build(BuildContext context) {
    final userStatusService = context.read<UserStatusService>();
    final chatService = context.read<ChatService>();
    chatService.getUserData();
    userStatusService.init();



    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: AppBar(
        title: const Text("Messages"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ListWood()),
              );
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
          if(snapshot.hasData && snapshot.data!.snapshot.exists) {


            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: _buildUserList(data),
              ),
            );
          }
          return const SizedBox();
          }
          ),

    );
  }

  Widget _buildUserList(Map<dynamic, dynamic> userStatus) {
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
            return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: buildUserListItem(document, index, userStatus));
          },
        );
      },
    );
  }

  Widget buildUserListItem(DocumentSnapshot document, int index, Map<dynamic, dynamic> userStatus) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    final UserData userData = UserData.fromJson(data);
    if (_auth.currentUser!.email == userData.email) {
      return FavoritesWidget(
        callback: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChatRoomScreen(
              userData: userData,
            );
          }));
        }
      );
    } else if(_auth.currentUser!.email != data['email']){
      return UserCard(
       userData: userData,
        isOnline: userStatus[data['uid']]['status'] == 'online',
        callback: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChatRoomScreen(
             userData: userData,
            );
          }));
        },

        // userStatus[data['uid']]['status'] == 'online',

      );

    }else{
      return const SizedBox();
    }
  }
}
