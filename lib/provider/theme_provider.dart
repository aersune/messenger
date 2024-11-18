import 'package:flutter/material.dart';
import 'package:messenger/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;



  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.dark,
    primaryColorDark: AppColors.dark,
    // Define other dark theme properties here
  );
  final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    primaryColorDark: Colors.white,
    // Define other light theme properties here
  );




  changeTheme() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDark = !_isDark;
    await prefs.setBool('isDark', _isDark);
    notifyListeners();
  }


  init() async{
   final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDark =  prefs.getBool('isDark') ?? false;
    notifyListeners();
  }
}