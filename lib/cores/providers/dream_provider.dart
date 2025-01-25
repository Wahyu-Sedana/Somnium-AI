import 'package:flutter/material.dart';
import 'package:somnium_ai/cores/models/dream_request.dart';
import 'package:somnium_ai/cores/models/dream_response.dart';
import 'package:somnium_ai/cores/services/dream_service.dart';

class DreamProvider extends ChangeNotifier {
  final DreamService _dreamService = DreamService();
  DreamResponse? _dreamResponse;
  bool _isLoading = false;
  String? _errorMessage;

  DreamResponse? get dreamResponse => _dreamResponse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDreamInterpretation(String question, String locale, String figures) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    DreamRequest request = DreamRequest(
      question: question,
      locale: locale,
      figures: figures,
    );
    try {
      _dreamResponse = await _dreamService.postDreamInterpretation(request);
      if (_dreamResponse == null) {
        _errorMessage = "Failed to get response from server.";
      }
    } catch (e) {
      _errorMessage = "Error: $e";
    }

    _isLoading = false;
    notifyListeners();
  }
}
