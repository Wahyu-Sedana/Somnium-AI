import 'package:flutter/material.dart';
import 'package:somnium_ai/utils/assets.dart';
import 'package:somnium_ai/views/result_screen.dart';
import 'package:somnium_ai/widgets/form_widget.dart';
import 'package:somnium_ai/localization/app_localizations.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isError = false;
  String selectedFigure = "";
  String selectedLanguage = "";

  @override
  void initState() {
    super.initState();
  }

  void _handleSubmit() {
    if (_controller.text.trim().isEmpty) {
      setState(() {
        _isError = true;
      });
    } else {
      setState(() {
        _isError = false;
      });
      print("Submitted: ${_controller.text}");
      String question = _controller.text.trim();
      print(selectedFigure);
      print(selectedLanguage);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(question: question),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            background2,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.asset(
                        iconapp,
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        appLocalization.translate("form_title"),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FormWidget(
                            controller: _controller,
                            isError: _isError,
                          ),
                          if (_isError)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                appLocalization.translate("form_error"),
                                style: const TextStyle(color: Colors.red, fontSize: 16),
                              ),
                            ),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.5),
                            fixedSize: const Size(170, 50)),
                        child: Text(
                          appLocalization.translate("back"),
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          fixedSize: const Size(170, 50),
                        ),
                        child: Text(
                          appLocalization.translate("submit"),
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
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
