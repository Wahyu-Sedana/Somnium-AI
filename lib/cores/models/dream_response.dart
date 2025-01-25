import 'dart:convert';

class DreamResponse {
  final int status;
  final String figures;
  final String response;

  DreamResponse({required this.status, required this.figures, required this.response});
  factory DreamResponse.fromJson(Map<String, dynamic> json) {
    return DreamResponse(
      status: json["status"],
      figures: json["figures"],
      response: json["response"],
    );
  }

  factory DreamResponse.fromRawJson(String str) => DreamResponse.fromJson(jsonDecode(str));
}
