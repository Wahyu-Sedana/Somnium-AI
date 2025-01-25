import 'package:flutter/material.dart';
import 'package:somnium_ai/views/form_screen.dart';
import 'package:somnium_ai/views/home_screen.dart';
import 'package:somnium_ai/views/language_screen.dart';
import 'package:somnium_ai/views/result_screen.dart';
import 'package:somnium_ai/views/splash_screen.dart';

class AppsRoute {
  static const String home = '/home';
  static const String splash = '/splash';
  static const String form = '/form';
  static const String result = '/result';
  static const String language = '/language';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case form:
        return MaterialPageRoute(builder: (context) => const FormScreen());
      case result:
        final String question = settings.arguments as String;
        return MaterialPageRoute(builder: (context) => ResultScreen(question: question));
      case language:
        return MaterialPageRoute(builder: (context) => const LanguageScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Page Not Found'),
            ),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
