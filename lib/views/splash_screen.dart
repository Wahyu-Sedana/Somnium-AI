import 'dart:async';

import 'package:flutter/material.dart';
import 'package:somnium_ai/utils/assets.dart';
import 'package:somnium_ai/views/language_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      precacheImage(const AssetImage(background2), context).then((val) => {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LanguageScreen()),
            )
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage(background), context);
    precacheImage(const AssetImage(iconapp), context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(background), fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconapp, height: 100),
              const Text(
                'Somnium AI',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
