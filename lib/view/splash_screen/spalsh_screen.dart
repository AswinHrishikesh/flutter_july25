import 'package:flutter/material.dart';
import 'package:flutter_july25/utils/animation_constants.dart';
import 'package:flutter_july25/view/notes_screen/notes_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then(
      (value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NotesScreen()));
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Lottie.asset(AnimationConstants.SPLASH_NOTE),
      ),
    );
  }
}
