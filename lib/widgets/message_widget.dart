import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/provider/chat_service.dart';
import 'package:provider/provider.dart';

import '../provider/auth_servive.dart';
import '../utils/colors.dart';

class SendMessageWidget extends StatefulWidget {
  final String receiverUserId;

  const SendMessageWidget({super.key, required this.receiverUserId});

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  final TextEditingController messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  void sendMessage() async{
    if(messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverUserId, messageController.text);
      messageController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;


    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: size.width * .9,
        maxHeight: size.height * .2,
        minHeight: size.height * .05,
      ),
      child: TextField(
        controller: messageController,
        minLines: 1,
        maxLines: 5,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          hintText: "Message",
          hintStyle:  const TextStyle(color: AppColors.light),
          suffixIcon: IconButton(onPressed: () {
            sendMessage();

          }, icon:  const Icon(Icons.send_outlined, color: AppColors.light,)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.primary2.withOpacity(.5),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            width: 40,
            height: 40,
            child: IconButton(onPressed: () {},

                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary2,

                ),
                icon:  const Icon(Icons.camera_alt_outlined, color: AppColors.primary,size: 25,)),
          ),
        ),
      ),
    ) ;
  }
}
