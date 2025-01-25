import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:somnium_ai/routes/route.dart';
import 'package:somnium_ai/utils/assets.dart';
import 'package:somnium_ai/localization/app_localizations.dart';
import 'package:somnium_ai/utils/session.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _saveSelectedFigure(String title) async {
    await SessionManager.saveSelectedFigure(title);
  }

  Future<void> _saveSelectedImageFigure(String image) async {
    await SessionManager.saveSelectedImage(image);
  }

  Future<void> _saveSelectedFigureId(String id) async {
    await SessionManager.saveSelectedFigureId(id);
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    final appLocalization = AppLocalizations.of(context)!;
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(appLocalization.translate("exit_title")),
            content: Text(appLocalization.translate("exit_message")),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(appLocalization.translate("cancel")),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(appLocalization.translate("exit")),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage(background2), context);
    precacheImage(const AssetImage(iconapp), context);

    final appLocalization = AppLocalizations.of(context)!;

    final List<Map<String, String>> tokohList = [
      {
        "id": "Sigmund Freud",
        "title": appLocalization.translate("freud"),
        "quote": appLocalization.translate("freud_quote"),
        "image": "assets/images/SigmundFreud2.png",
      },
      {
        "id": "Erick Erison",
        "title": appLocalization.translate("erikson"),
        "quote": appLocalization.translate("erikson_quote"),
        "image": "assets/images/ErikErikson.png",
      },
      {
        "id": "Carl Gustav Jung",
        "title": appLocalization.translate("jung"),
        "quote": appLocalization.translate("jung_quote"),
        "image": "assets/images/CarlGustav2.png",
      },
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(background2),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Logo/Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Image.asset(
                    iconapp,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),

              // Title dengan i18n
              Text(
                appLocalization.translate("home_title"),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // ListView Cards
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: tokohList.length,
                  itemBuilder: (context, index) {
                    final tokoh = tokohList[index];
                    return GestureDetector(
                      onTap: () async {
                        await _saveSelectedFigureId(tokoh["id"]!);
                        await _saveSelectedFigure(tokoh["title"]!);
                        await _saveSelectedImageFigure(tokoh["image"]!);
                        await precacheImage(const AssetImage(background2), context);
                        precacheImage(const AssetImage(iconapp), context);
                        Navigator.pushNamed(context, AppsRoute.form);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.black.withOpacity(0.5),
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, left: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tokoh["title"]!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      tokoh["quote"]!,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  tokoh["image"]!,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Tombol Kembali
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    fixedSize: const Size(double.maxFinite, 50),
                  ),
                  child: Text(
                    appLocalization.translate("back"),
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
