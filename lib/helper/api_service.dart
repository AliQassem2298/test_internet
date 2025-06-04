import 'package:dio/dio.dart';

// String baseUrlImage = 'http://127.0.0.1:8000';
// String baseUrl = 'http://127.0.0.1:8000/api'; //////// windows

String baseUrlImage = 'http://10.0.2.2:8000';
String baseUrl = 'http://10.0.2.2:8000/api'; ///// emulator

// String baseUrlImage = 'http://192.168.27.48:8000';
// String baseUrl = 'http://192.168.27.48:8000/api'; ///// mobilde

// String baseUrlImage = 'https://3b01-185-177-125-71.ngrok-free.app';
// String baseUrl = 'https://3b01-185-177-125-71.ngrok-free.app/api'; ///// server

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio dio;

  ApiService._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<Response> getRequest(String endpoint, {String? token}) async {
    try {
      final response = await dio.get(
        endpoint,
        options: Options(headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        }),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postRequest(String endpoint, dynamic body,
      {String? token}) async {
    try {
      final response = await dio.post(
        endpoint,
        data: body,
        options: Options(headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        }),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> putRequest(String endpoint, dynamic body,
      {String? token}) async {
    try {
      final response = await dio.put(
        endpoint,
        data: body,
        options: Options(headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        }),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteRequest(String endpoint, {String? token}) async {
    try {
      final response = await dio.delete(
        endpoint,
        options: Options(headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        }),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
