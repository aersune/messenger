import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/utils/colors.dart';


class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold( 
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const SizedBox(width: 10,),
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage("https://picsum.photos/200"),
            ),
            const SizedBox(width: 16 ,),
            const Text("Danny Hopkins"),
            const Spacer(),
            IconButton(onPressed: () {}, icon:  const Icon(CupertinoIcons.search, opticalSize: 50,)),
          ],
        ),
        centerTitle: false,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
              bottom: size.height * .04,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: size.width * .9,
                maxHeight: size.height * .2,
                  minHeight: size.height * .05,
                ),

                child: TextField(
                  minLines: 1,
                  maxLines: 5,
                  textAlign: TextAlign.left,

                  decoration: InputDecoration(
                    hintText: "Message",
                    hintStyle:  const TextStyle(color: AppColors.light),
                    suffixIcon: IconButton(onPressed: () {}, icon:  Icon(Icons.send_outlined, color: AppColors.light,)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.primary.withOpacity(.7),
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
              )
          )
        ],
      ),
    );
  }
}
