import 'dart:convert';

class DreamRequest {
  final String question;
  final String locale;
  final String figures;

  DreamRequest({required this.question, required this.locale, required this.figures});

  Map<String, dynamic> toJson() {
    return {
      "question": question,
      "locale": locale,
      "figures": figures,
    };
  }

  String toRawJson() => jsonEncode(toJson());
}
