import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/provider/chat_service.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';
import '../utils/colors.dart';

class SendMessageWidget extends StatefulWidget {
  final String receiverUserId;

  const SendMessageWidget({
    super.key,
    required this.receiverUserId,
  });

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = context.watch<ThemeProvider>();
    final chatProvider = Provider.of<ChatService>(context, listen: false);
    final chatWatcher = context.watch<ChatService>();
    // final chatPro = Provider.of<ChatService>(context);
    void sendMessage() async {
      if (chatProvider.messageController.text.isNotEmpty) {
        await _chatService.sendMessage(
          receiverId: widget.receiverUserId,
          message: chatProvider.messageController.text.trim(),
          isReply: chatWatcher.isReplying,
          repliedMessage: chatWatcher.editingMessage,
          replyMessId: chatWatcher.editingMessageId,
          replyUser: chatWatcher.repliedMessageSenderId,
        );
        chatProvider.messageController.clear();
        chatProvider.cancelReply();
      }
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: size.width * .9,
        maxHeight: size.height * .2,
        minHeight: size.height * .05,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: TextField(
          enabled: true,
          focusNode: chatWatcher.messageFocusNode,
          controller: chatProvider.messageController,
          minLines: 1,
          maxLines: 5,
          style:  const TextStyle(color: AppColors.light),
          textAlign: TextAlign.left,
          decoration: InputDecoration(

            hintText: "Message",
            hintStyle: TextStyle(color: AppColors.light.withOpacity(.45)),
            suffixIcon: IconButton(
                onPressed: () {
                  if (chatWatcher.isEditing) {
                    _chatService.updateMessage(
                        otherUserId: widget.receiverUserId,
                        messageId: chatWatcher.editingMessageId,
                        newMessage: chatProvider.messageController.text.trim());
                    chatProvider.messageController.clear();
                    chatProvider.editingMessageId = "";
                    chatProvider.messageFocusNode.unfocus();
                    chatProvider.isEditing = false;
                    chatProvider.isReplying = false;
                  } else {
                    sendMessage();
                    // chatProvider.messageFocusNode.unfocus();
                  }
                },
                icon: Icon(
                  chatWatcher.isEditing ? Icons.check_circle : Icons.send_outlined,
                  color: theme.isDark ? AppColors.darkButton : AppColors.light,
                )),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: theme.isDark ? AppColors.textFieldDark : AppColors.teal,
            prefixIcon: Container(
              margin: const EdgeInsets.all(8),
              width: 40,
              height: 40,
              child: IconButton(
                  onPressed: () {
                    print('adadw');
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: theme.isDark ? AppColors.darkButton : AppColors.primary2,
                  ),
                  icon: Transform.rotate(
                    angle: .45,
                    child: Icon(
                      Icons.attach_file,
                      color: theme.isDark ? AppColors.dark : AppColors.primary,
                      size: 25,
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
