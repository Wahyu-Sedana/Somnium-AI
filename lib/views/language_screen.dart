import 'package:flutter/material.dart';
import 'package:somnium_ai/main.dart';
import 'package:somnium_ai/routes/route.dart';
import 'package:somnium_ai/utils/assets.dart';
import 'package:somnium_ai/localization/app_localizations.dart';
import 'package:somnium_ai/utils/session.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? selectedLanguage;

  void _changeLanguage(String languageCode) async {
    Map<String, Locale> languageMap = {
      "ja_jp": const Locale('ja', 'JP'),
      "id_id": const Locale('id', 'ID'),
      "en_us": const Locale('en', 'US'),
    };

    if (languageMap.containsKey(languageCode)) {
      await SessionManager.saveLanguageCode(languageCode);
      MainApp.setLocale(context, languageMap[languageCode]!);
      setState(() {
        selectedLanguage = languageCode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage(background2), context);
    precacheImage(const AssetImage(iconapp), context);

    final List<Map<String, String>> languages = [
      {"code": "ja_jp", "name": "日本語 (Japanese)"},
      {"code": "id_id", "name": "Bahasa Indonesia"},
      {"code": "en_us", "name": "English"},
    ];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            background2,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.3),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 20),
                  child: Image.asset(
                    iconapp,
                    width: 120,
                    height: 120,
                  ),
                ),

                // Title
                Text(
                  AppLocalizations.of(context)!.translate("select_language"),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: languages.map((language) {
                      bool isSelected = selectedLanguage == language["code"];

                      return GestureDetector(
                        onTap: () => _changeLanguage(language["code"]!),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.black.withOpacity(0.5)
                                : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15),
                            border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                language["name"]!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (isSelected) const Icon(Icons.check_circle, color: Colors.white),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: ElevatedButton(
                    onPressed: selectedLanguage != null
                        ? () {
                            Navigator.pushNamed(context, AppsRoute.home);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedLanguage != null ? Colors.black.withOpacity(0.5) : Colors.grey,
                      fixedSize: const Size(double.maxFinite, 50),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.translate("next"),
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
