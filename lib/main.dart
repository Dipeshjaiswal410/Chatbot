
import 'package:chatbot/components/constants.dart';
import 'package:chatbot/views/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primaryColor: backGround_color,
        scaffoldBackgroundColor: backGround_color,
        appBarTheme: AppBarTheme(
          color: appBar_color,
        )),
    home: splash_Screen(),
  ));
}
