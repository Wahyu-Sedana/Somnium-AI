import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:somnium_ai/cores/models/dream_request.dart';
import 'package:somnium_ai/cores/models/dream_response.dart';

class DreamService {
  static const String _baseUrl =
      "https://test-dream-api.jepang-indonesia.com/api/v1/dream-interpretation";
  final Dio _dio = Dio();

  DreamService() {
    _dio.interceptors.add(PrettyDioLogger(responseBody: true, requestHeader: true));
  }

  Future<DreamResponse?> postDreamInterpretation(DreamRequest request) async {
    try {
      Response response = await _dio.post(
        _baseUrl,
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return DreamResponse.fromJson(response.data);
      } else {
        print("Error: ${response.data}");
        return null;
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data ?? e.message}");
      return null;
    }
  }
}
