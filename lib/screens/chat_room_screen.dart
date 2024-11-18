import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/provider/chat_service.dart';
import 'package:messenger/utils/colors.dart';
import 'package:messenger/widgets/message_widget.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';

class ChatRoomScreen extends StatefulWidget {
  final String receiverUserId;
  final String receiverUserEmail;
  final String receiverUserName;

  const ChatRoomScreen(
      {super.key, required this.receiverUserId, required this.receiverUserEmail, required this.receiverUserName});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.isDark ? AppColors.dark : AppColors.primary,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage("https://picsum.photos/200"),
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              widget.receiverUserName,
            ),
            const Spacer(),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.search,
                  opticalSize: 50,
                )),
          ],
        ),
        centerTitle: false,
      ),
      backgroundColor: theme.isDark ? AppColors.dark : AppColors.primary,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Expanded(child: _buildMessageList()),
          Positioned(
            bottom: size.height * .04,
            child: SendMessageWidget(
              receiverUserId: widget.receiverUserId,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverUserId, _auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    bool whoSender = data['senderId'] == _auth.currentUser!.uid;
    final theme = context.watch<ThemeProvider>();
    Color senderColor = theme.isDark ? AppColors.dark3 : AppColors.primary.withGreen(150);
    Color receiverColor = theme.isDark ? AppColors.dark4 : AppColors.primary2.withOpacity(.4);
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          crossAxisAlignment: whoSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: whoSender ? senderColor : receiverColor,
                  // color: AppColors.primary.withGreen(150),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Text(
                  data['message'],
                  style: const TextStyle(
                    color: AppColors.light,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
