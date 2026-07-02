import 'package:dio/dio.dart';

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  /// Change this depending on where you run the backend.

  // Android Emulator
  //static const String baseUrl = "http://10.0.2.2:8000";

  // Physical Android Device
  // static const String baseUrl = "http://192.168.1.10:8000";

  // Windows Desktop
  static const String baseUrl = "http://127.0.0.1:8000";

  late final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),

      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ),
  )..interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
      ),
    );

  // ==========================
  // GET
  // ==========================

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // ==========================
  // POST
  // ==========================

  Future<Response> post(
    String endpoint, {
    dynamic data,
  }) async {
    try {
      return await dio.post(
        endpoint,
        data: data,
      );
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // ==========================
  // PUT
  // ==========================

  Future<Response> put(
    String endpoint, {
    dynamic data,
  }) async {
    try {
      return await dio.put(
        endpoint,
        data: data,
      );
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // ==========================
  // DELETE
  // ==========================

  Future<Response> delete(
    String endpoint,
  ) async {
    try {
      return await dio.delete(endpoint);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // ==========================
  // Error Handler
  // ==========================

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timed out";

      case DioExceptionType.sendTimeout:
        return "Request timed out";

      case DioExceptionType.receiveTimeout:
        return "Server took too long to respond";

      case DioExceptionType.badResponse:
        return error.response?.data["detail"] ??
            "Server Error";

      case DioExceptionType.connectionError:
        return "Cannot connect to backend.\n\nIs FastAPI running?";

      case DioExceptionType.cancel:
        return "Request cancelled";

      default:
        return error.message ?? "Unknown Error";
    }
  }
}