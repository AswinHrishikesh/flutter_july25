import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_july25/utils/app_sections.dart';
import 'package:flutter_july25/view/splash_screen/spalsh_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox(AppSections.NOTEBOX);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      home: SplashScreen(),
    );
  }
}
