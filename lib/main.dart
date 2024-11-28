import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messenger/auth_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messenger/provider/auth_servive.dart';
import 'package:messenger/provider/chat_service.dart';
import 'package:messenger/provider/theme_provider.dart';
import 'package:messenger/provider/user_status.dart';
import 'package:messenger/screens/teset.dart';
import 'package:messenger/utils/colors.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthService()),
      ChangeNotifierProvider(create: (context) => ChatService()..getUserData()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()..init()),
      ChangeNotifierProvider(create: (context) => UserStatusService()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final userStatusService = Provider.of<UserStatusService>(context, listen: false);
    userStatusService.init();

    return Consumer<ThemeProvider>(builder: (context, ThemeProvider theme, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
        darkTheme: theme.darkTheme,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              backgroundColor: theme.isDark ? AppColors.dark : AppColors.primary,
              titleTextStyle: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              centerTitle: true),
        ),
        home:  AppBarWidget(),
      );
    });
  }
}
