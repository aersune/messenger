import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:messenger/provider/chat_service.dart';
import 'package:messenger/screens/profile.dart';
import 'package:messenger/utils/colors.dart';
import 'package:provider/provider.dart';
import '../provider/auth_servive.dart';
import '../provider/theme_provider.dart';
import 'dart:io';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  bool isDark = false;


  File? downloadedFile;



  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<AuthService>(context, listen: false);
    final chatService = context.watch<ChatService>();
    final theme = context.watch<ThemeProvider>();
    final user = chatService.userData;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      backgroundColor: theme.isDark ? AppColors.dark : AppColors.primary2,
      child: Consumer<ThemeProvider>(builder: (context, ThemeProvider theme, child) {
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            //drawer header
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: theme.isDark ? AppColors.dark2 : AppColors.primary,
              ),
              currentAccountPicture: Stack(
                children: [
                  InstaImageViewer(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: downloadedFile == null
                          ? Image.network('https://picsum.photos/200', width: 100, height: 100)
                          : Image(
                              image: FileImage(
                                downloadedFile!,
                              ),
                              width: 100,
                              height: 100,
                              fit: BoxFit.fitHeight,
                            ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {


                        },
                        child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: theme.isDark ? AppColors.dark : AppColors.light,
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 15,
                            )),
                      ))
                ],
              ),
              accountName: Text(
                "${user.name}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              accountEmail: Text("${user.email}"),
            ),


             ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfile()) );
              },
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              onTap: () {
                theme.changeTheme();
              },
              title: const Text("Dark"),
              trailing: Switch(
                  thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Icon(
                          Icons.dark_mode,
                          color: AppColors.light,
                        );
                      }
                      return const Icon(
                        Icons.light_mode,
                        color: AppColors.primary,
                      );
                    },
                  ),
                  value: theme.isDark,
                  activeColor: AppColors.dark,
                  inactiveThumbColor: AppColors.light,
                  trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                  inactiveTrackColor: AppColors.primary,
                  activeTrackColor: AppColors.dark2,
                  onChanged: (bool value) {
                    theme.changeTheme();
                  }),
            ),

            const ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
            ),
            Divider(
              color: Colors.black.withOpacity(.2),
              height: 10,
              thickness: 1,
            ),

            ListTile(
              onTap: () {
                prov.firebaseAuth.signOut();
              },
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
            ),
          ],
        );
      }),
    );
  }
}
