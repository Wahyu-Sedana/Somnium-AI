import 'package:flutter/material.dart';
import 'package:somnium_ai/localization/app_localizations.dart';

class FormWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isError;

  const FormWidget({super.key, required this.controller, required this.isError});

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;

    return SizedBox(
      height: 200,
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          hintText: appLocalization.translate("form_hint"),
          hintStyle: TextStyle(color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isError ? Colors.red : Colors.transparent,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isError ? Colors.red : Colors.blue,
              width: 2,
            ),
          ),
        ),
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
