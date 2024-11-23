import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:messenger/provider/chat_service.dart';
import 'package:provider/provider.dart';


class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    nameFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final prov = context.watch<ChatService>();
    final prov2 = context.read<ChatService>();
    final userName = prov.userData.name;


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Edit profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InstaImageViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  image: const NetworkImage(
                    'https://picsum.photos/200',
                  ),
                  width: size.width * .4,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // textarea for edit user name with design icons and text
            TextField(
                focusNode: nameFocusNode,
                controller: nameController,

                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.white.withOpacity(.2),
                  prefixIcon: const Icon(Icons.person),
                  hintText: "$userName",
                )),
            const SizedBox(
              height: 25,
            ),
            TextField(
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.white.withOpacity(.2),
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: "${prov.userData.email}",
                )),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.shade100,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                   Navigator.of(context).pop();
                    nameFocusNode.unfocus();
                  },
                  child: const Text("Cancel", style: TextStyle(color: Colors.white),),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    prov2.changeName(nameController.text.trim());
                    prov2.getUserData();
                    nameFocusNode.unfocus();
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
