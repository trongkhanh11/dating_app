import 'dart:io';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

enum DioMethod { post, get, put, delete }

class APIService {
  APIService._singleton();

  static final APIService instance = APIService._singleton();

  String get baseUrl {
    if (kDebugMode) {
      return 'https://clients.ssi-crm.com/api';
    }
    return 'https://clients.ssi-crm.com/api';
  }

  Future<Response> request(String endpoint, DioMethod method,
      {Map<String, dynamic>? param,
      String? contentType,
      formData,
      token,
      isUpload}) async {
    try {
      BaseOptions baseOptions = BaseOptions(
        baseUrl: baseUrl,
        contentType: contentType ?? Headers.formUrlEncodedContentType,
      );
      if (token != '') {
        baseOptions = BaseOptions(
          baseUrl: baseUrl,
          contentType: contentType ?? Headers.formUrlEncodedContentType,
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
        );
      }
      final dio = Dio(baseOptions);
      dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
      switch (method) {
        case DioMethod.post:
          return dio.post(
            endpoint,
            data: param ?? formData,
          );
        case DioMethod.get:
          return dio.get(
            endpoint,
            queryParameters: param,
          );
        case DioMethod.put:
          if (isUpload == true) {
            return dio.post(
              options: Options(
                headers: {
                  "Content-Type": "multipart/form-data",
                },
              ),
              endpoint,
              data: param ?? formData,
            );
          } else {
            return dio.post(
              options: Options(
                responseType: ResponseType.bytes,
              ),
              endpoint,
              data: param ?? formData,
            );
          }

        case DioMethod.delete:
          return dio.delete(
            endpoint,
            data: param ?? formData,
          );
        default:
          return dio.post(
            endpoint,
            data: param ?? formData,
          );
      }
    } catch (e) {
      throw Exception('Network error');
    }
  }
}
