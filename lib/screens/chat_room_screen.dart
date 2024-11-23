import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        final chatProvider = Provider.of<ChatService>(context, listen: false);
        chatProvider.messageController.clear();
        chatProvider.isEditing = false;
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: theme.isDark ? AppColors.dark : AppColors.primary,
          // automaticallyImplyLeading: false,
          title: Row(
            children: [
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


            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.search,
                opticalSize: 50,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.ellipsis_vertical,
              ),)
          ],
          centerTitle: false,
        ),
        backgroundColor: theme.isDark ? AppColors.dark : AppColors.primary,
        body: Column(
          children: [
            Expanded(
                // height: size.height * 0.78,
                child: _buildMessageList()),
            Container(
              color: theme.isDark ? AppColors.textFieldDark : AppColors.teal
                ..withOpacity(.5),
              width: size.width,
              child: SendMessageWidget(
                receiverUserId: widget.receiverUserId,
              ),
            ),
          ],
        ),
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

          return SingleChildScrollView(
            reverse: true,
            child: ListView(
              dragStartBehavior: DragStartBehavior.down,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
            ),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    bool whoSender = data['senderId'] == _auth.currentUser!.uid;
    final theme = context.watch<ThemeProvider>();
    Color senderColor = theme.isDark ? AppColors.dark3 : AppColors.primary.withGreen(150);
    Color receiverColor = theme.isDark ? AppColors.dark4 : AppColors.primary2.withOpacity(.4);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: whoSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: GestureDetector(
                onTapDown: (details) => _showContextMenu(
                  position: details.globalPosition,
                  message: data['message'],
                  messageId: snapshot.id,
                  context: context,
                  whoSender: whoSender,
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: whoSender ? senderColor : receiverColor,
                    // color: AppColors.primary.withGreen(150),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    crossAxisAlignment: whoSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        textAlign: TextAlign.left,
                        data['message'],
                        style: const TextStyle(color: AppColors.light, fontSize: 18),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          data['isChanged'] == true
                              ? const Padding(
                                  padding: EdgeInsets.only(right: 5.0),
                                  child: Text(
                                    'changed',
                                    style: TextStyle(fontSize: 12, color: AppColors.light),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          Text(
                            DateFormat('hh:mm').format(data['timestamp'].toDate()),
                            style: const TextStyle(fontSize: 12, color: AppColors.light),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.check,
                            size: 15,
                            color: AppColors.light,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  void _showContextMenu(
      {required Offset position,
      required String message,
      required String messageId,
      required BuildContext context,
      required bool whoSender}) async {
    final chatProvider = context.read<ChatService>();

    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final _chatService = context.read<ChatService>();
    await showMenu<String>(
      menuPadding: EdgeInsets.zero,
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        overlay.size.width - position.dx,
        overlay.size.height - position.dy,
      ),
      items: [
        const PopupMenuItem<String>(
          value: 'copy',
          child: Text('Copy'),
        ),
        if (whoSender)
          const PopupMenuItem<String>(
            value: 'edit',
            child: Text('Edit'),
          ),
        if (whoSender)
          const PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete'),
          ),
      ],
    ).then((value) {
      if (value == 'copy') {
        Clipboard.setData(ClipboardData(text: message));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Copied to clipboard'),
          duration: Duration(milliseconds: 200),
        ));
      } else if (value == 'edit') {
        chatProvider.editMessage(messageId, message, context);
        FocusScope.of(context).requestFocus(chatProvider.messageFocusNode);
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit feature not implemented')));
      } else if (value == 'delete') {
        _chatService.deleteMessage(messageId: messageId, otherUserId: widget.receiverUserId);
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delete feature not implemented')));
      }
    });
  }
}
