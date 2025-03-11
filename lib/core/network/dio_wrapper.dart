import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dms_assement/core/network/failures.dart';
import 'package:flutter/material.dart';

abstract class IDioWrapper {
  Future<Response<dynamic>> onPost({
    required String api,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<Response<dynamic>> onPostImageData(
      {required String api, required String data});

  Future<Response<dynamic>> onPatch(
      {required String api,
      required dynamic data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers});

  Future<Response<dynamic>> onGet(
      {required String api,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
      bool isPullToRefresh = false});

  void onCancel();

  Future<String> downloadFile(String path);
}

class DioWrapperImp implements IDioWrapper {
  final Dio _dio;

  DioWrapperImp(this._dio);

  dynamic _processResponse(Response<dynamic> response) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response;
    } else {
      throw _mapDioError(response);
    }
  }

  Failure _mapDioError(Response<dynamic> response) {
    debugPrint("Response: ${response.data}");
    switch (response.statusCode) {
      case 400:
        return DioBadRequest(message: response.data['error'] ?? "Bad Request");
      case 401:
        return DioUnAuthorized(
            message: response.data['error'] ?? "Unauthorized Request");
      case 404:
        return DioNotFoundError(
            message: response.data['error'] ?? "Resource Not Found");
      case 408:
        return DioTimeoutError(
            message: response.data['error'] ?? "Request Timeout");
      case 500:
        return ServerFailure("Internal Server Error");
      case 503:
        return ServiceUnavailableFailure(
          message: response.data['error'] ?? "Service Unavailable",
        );
      default:
        return DioDefaultFailure(message: "Unknown Error");
    }
  }

  @override
  Future<Response<dynamic>> onPost({
    required String api,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        api,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _processResponse(response);
    } on DioException catch (err) {
      debugPrint("Error Status Code: ${err.response?.statusCode}");
      log("Error Response Data: ${err.response?.data}");
      debugPrint("Error Message: ${err.message}");
      throw _mapDioError(err.response!);
    }
  }

  @override
  Future<Response<dynamic>> onPostImageData({
    required String api,
    required String data,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(data),
      });
      final response = await _dio.post(api, data: formData);
      return _processResponse(response);
    } on DioException catch (err) {
      throw _mapDioError(err.response!);
    }
  }

  @override
  Future<Response<dynamic>> onPatch({
    required String api,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.patch(
        api,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _processResponse(response);
    } on DioException catch (err) {
      throw _mapDioError(err.response!);
    }
  }

  @override
  Future<Response<dynamic>> onGet({
    required String api,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool isPullToRefresh = false,
  }) async {
    try {
      final response = await _dio.get(
        api,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _processResponse(response);
    } on DioException catch (err) {
      throw _mapDioError(err.response!);
    }
  }

  @override
  void onCancel() {
    _dio.close(force: true);
  }

  @override
  Future<String> downloadFile(String path) async {
    try {
      final response = await _dio.download(
        path,
        "downloaded_file",
      );
      if (response.statusCode == 200) {
        return "File downloaded successfully.";
      } else {
        throw Exception("Failed to download file: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
