import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:messenger/provider/chat_service.dart';
import 'package:messenger/utils/colors.dart';
import 'package:messenger/widgets/message_widget.dart';
import 'package:provider/provider.dart';

import '../model/message.dart';
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
  final Map<String, GlobalKey> _messageKeys = {};

  bool isScrolled = false;

  void _scrollToMessage(String messageId) {
    final context = _messageKeys[messageId]?.currentContext;
    if (context != null && _scrollController.hasClients) {
      final renderBox = context.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero).dy;
      final offset = _scrollController.offset + position - (MediaQuery.of(context).size.height / 2);
      _scrollController.animateTo(
        offset,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  void navToFirst() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final context = _scrollController.position.context.storageContext;
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          alignment: 1.0,
          curve: Curves.easeIn,
        );
      }

      // Future.delayed(const Duration(milliseconds: 100), () {
      //   if (_scrollController.hasClients) {
      //     _scrollController.jumpTo(_scrollController.position.maxScrollExtent + 400);
      //
      //     // _scrollController.addListener((){
      //     //   if(_scrollController.offset < _scrollController.position.maxScrollExtent - 400) {
      //     //
      //     //     // print('scroll');
      //     //     _chatService.scrollEvent(true);
      //     //   }else{
      //     //     // print('false scroll');
      //     //     _chatService.scrollEvent(false);
      //     //   }
      //     //
      //     // });
      //   }
      // });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final size = MediaQuery.of(context).size;
    final chatProvider = Provider.of<ChatService>(context, listen: false);
    final chatWatch = context.read<ChatService>();
    // bool isScrolled = chatWatch.isScrolling;
    // _scrollController.addListener((){
    //   if(_scrollController.offset < _scrollController.position.maxScrollExtent - 400) {
    //
    //     // print('scroll');
    //     chatProvider.scrollEvent(true);
    //   }else{
    //     // print('false scroll');
    //     chatProvider.scrollEvent(false);
    //   }
    //
    // });
    return WillPopScope(
      onWillPop: () async {
        chatProvider.messageController.clear();
        chatProvider.isEditing = false;
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.isDark ? AppColors.dark : AppColors.primary,
          // automaticallyImplyLeading: false,
          title: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage("https://picsum.photos/200"),
              ),
              const SizedBox(width: 16),
              Text(widget.receiverUserName),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                print(chatWatch.isReplying);
              },
              icon: const Icon(
                CupertinoIcons.search,
                opticalSize: 50,
              ),
            ),
            PopupMenuButton(
                onSelected: (val) {
                  // print(val);
                  if (val == 'first') {
                    navToFirst();
                  } else if (val == 'clear') {
                    // open showmodal and as clear history or not
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                                backgroundColor: theme.isDark ? AppColors.dark : AppColors.primary,
                                title: const Text('Clear History'),
                                content: const Text('Are you sure you want to clear chat history?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      chatProvider.clearHistory(widget.receiverUserId);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Yes', style: TextStyle(color: Colors.white)),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                                  )
                                ]));
                  }
                },
                color:  theme.isDark ? AppColors.dark : AppColors.deepGreen,
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'first',
                        child: Text(
                          'Go to first message',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'clear',
                        child: Text(
                          'Clear history',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'changeBg',
                        child: Text(
                          'Change background',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text(
                          'Delete chat',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ]),
          ],
          centerTitle: false,
        ),
        backgroundColor: theme.isDark ? AppColors.dark : AppColors.primary,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    // height: size.height * 0.78,
                    child: _buildMessageList()),
                chatWatch.isReplying
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.01),
                        color: theme.isDark ? AppColors.textFieldDark : AppColors.teal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.reply,
                              color: AppColors.light,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chatWatch.whoSender
                                      ? "Reply to ${chatWatch.userData.name}"
                                      : "Reply to  ${widget.receiverUserName}",
                                  style: const TextStyle(
                                      color: AppColors.light, fontWeight: FontWeight.w500, letterSpacing: 1),
                                ),
                                SizedBox(
                                    width: size.width * .5,
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      chatWatch.editingMessage,
                                      style: TextStyle(color: AppColors.light.withOpacity(.5)),
                                    )),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  chatProvider.cancelEditing();
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: AppColors.light,
                                ))
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                chatWatch.isEditing
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.01),
                        color: theme.isDark ? AppColors.textFieldDark : AppColors.teal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.edit,
                              color: AppColors.light,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Editing",
                                  style:
                                      TextStyle(color: AppColors.light, fontWeight: FontWeight.w500, letterSpacing: 1),
                                ),
                                SizedBox(
                                    width: size.width * .5,
                                    child: Text(
                                      overflow: TextOverflow.ellipsis,
                                      chatWatch.editingMessage,
                                      style: TextStyle(color: AppColors.light.withOpacity(.5)),
                                    )),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  chatWatch.isReplying ? chatProvider.cancelReply() : chatProvider.cancelEditing();
                                },
                                icon: const Icon(Icons.close))
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
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
            isScrolled
                ? Positioned(
                    bottom: size.height * 0.1,
                    right: 16,
                    child: IconButton.outlined(
                        style: IconButton.styleFrom(
                            side: const BorderSide(color: Colors.transparent),
                            padding: const EdgeInsets.all(10),
                            backgroundColor: theme.isDark ? AppColors.textFieldDark : AppColors.primary2),
                        onPressed: _scrollToBottom,
                        icon: const Icon(
                          CupertinoIcons.chevron_down,
                          color: AppColors.teal,
                        )))
                : const SizedBox(),
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
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
            }
          });
          return ListView.builder(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            // physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var document = snapshot.data!.docs[index];
              var messageId = document.id;
              _messageKeys[messageId] = GlobalKey();

              return _buildMessageItem(snapshot: document, key: _messageKeys[messageId]!, messageId: messageId);
            },
            // children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
          );
        });
  }

  Widget _buildMessageItem({required DocumentSnapshot snapshot, required GlobalKey key, required messageId}) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    bool whoSender = data['senderId'] == _auth.currentUser!.uid;
    final theme = context.watch<ThemeProvider>();
    Color senderColor = theme.isDark ? AppColors.dark3 : AppColors.primary.withGreen(150);
    Color receiverColor = theme.isDark ? AppColors.dark4 : AppColors.primary2.withOpacity(.4);
    final userData = context.watch<ChatService>().userData;
    Message message = Message.fromJson(data);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: whoSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            ConstrainedBox(
              key: key,
              // key: isResponse ? _responseKey : null,
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: GestureDetector(
                onTapDown: (details) => _showContextMenu(
                  position: details.globalPosition,
                  message: message.message,
                  messageId: snapshot.id,
                  context: context,
                  whoSender: whoSender,
                  senderId: message.senderId,
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
                      message.isReplied == true
                          ? InkWell(
                              onTap: () {
                                _scrollToMessage(message.repliedMessageId!);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: whoSender ? AppColors.dark2.withOpacity(.5) : AppColors.dark2,
                                    borderRadius: BorderRadius.circular(10),
                                    border: const Border(
                                        left: BorderSide(
                                      color: AppColors.dark2,
                                      width: 5,
                                    ))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.repliedMessageSenderId != widget.receiverUserId
                                          ? "${userData.name}"
                                          : widget.receiverUserName,
                                      style: const TextStyle(
                                          fontSize: 15, color: AppColors.light, fontWeight: FontWeight.w500),
                                    ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width * 0.45,
                                      ),
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        "${message.repliedMessage}",
                                        style: const TextStyle(fontSize: 12, color: AppColors.light),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 5),
                      Text(
                        textAlign: TextAlign.left,
                        message.message,
                        style: const TextStyle(color: AppColors.light, fontSize: 18),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          message.isChanged == true
                              ? const Padding(
                                  padding: EdgeInsets.only(right: 5.0),
                                  child: Text(
                                    'changed',
                                    style: TextStyle(fontSize: 12, color: AppColors.light),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          Text(
                            DateFormat('hh:mm').format(message.timestamp.toDate()),
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
      required String senderId,
      required bool whoSender}) async {
    // final chatProvider = context.read<ChatService>();

    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final chatService = context.read<ChatService>();
    // final chatService = Provider.of<ChatService>(context);
    await showMenu(
      menuPadding: EdgeInsets.zero,
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        overlay.size.width - position.dx,
        overlay.size.height - position.dy,
      ),
      items: [
        const PopupMenuItem(
          value: 'reply',
          child: Text('Reply'),
        ),
        const PopupMenuItem(
          value: 'copy',
          child: Text('Copy'),
        ),
        if (whoSender)
          const PopupMenuItem(
            value: 'edit',
            child: Text('Edit'),
          ),
        if (whoSender)
          const PopupMenuItem(
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
        chatService.setMessage(messageId, message);
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit feature not implemented')));
      } else if (value == 'delete') {
        chatService.deleteMessage(messageId: messageId, otherUserId: widget.receiverUserId);
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delete feature not implemented')));
      } else if (value == 'reply') {
        chatService.replayMessage(message: message, senderId: senderId, messageId: messageId);
      }
    });
  }
}
