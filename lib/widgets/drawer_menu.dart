import 'package:flutter/material.dart';
import 'package:messenger/utils/colors.dart';
import 'package:provider/provider.dart';

import '../provider/auth_servive.dart';
import '../provider/theme_provider.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  bool isDark = false;



  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<AuthService>(context, listen: false);
    final user = prov.firebaseAuth.currentUser!;
    final theme = context.watch<ThemeProvider>();




    return Drawer(
      width: MediaQuery.of(context).size.width * 0.6,
      backgroundColor: theme.isDark ? AppColors.dark : AppColors.primary2,
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider theme, child) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              //drawer header
              UserAccountsDrawerHeader(

                decoration:  BoxDecoration(
                  color: theme.isDark ? AppColors.dark2 : AppColors.primary,


                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: NetworkImage('https://picsum.photos/200'),
                ),
                accountName: Text(
                  "${user.displayName}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                accountEmail: Text("${user.email}"),
              ),

              const ListTile(
                leading: Icon(Icons.person),
                title: Text("Profile"),
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                onTap: (){
                  theme.changeTheme();
                },
                title: const Text("Dark"),
                trailing: Switch(
                    thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Icon(Icons.dark_mode, color: AppColors.light,);
                        }
                        return const Icon(Icons.light_mode, color: AppColors.primary,);
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
        }
      ),
    );
  }

}
