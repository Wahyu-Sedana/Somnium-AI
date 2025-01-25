import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:somnium_ai/cores/providers/dream_provider.dart';
import 'package:somnium_ai/localization/app_localizations.dart';
import 'package:somnium_ai/routes/route.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    runApp(const MainApp());
  } catch (e) {
    print(e);
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
  static void setLocale(BuildContext context, Locale newLocale) {
    _MainAppState? state = context.findAncestorStateOfType<_MainAppState>();
    state?.setLocale(newLocale);
  }
}

class _MainAppState extends State<MainApp> {
  Locale _locale = const Locale('en', 'US');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DreamProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: _locale,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('id', 'ID'),
            Locale('ja', 'JP'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          onGenerateRoute: AppsRoute.generateRoute,
          initialRoute: AppsRoute.splash,
        ));
  }
}
