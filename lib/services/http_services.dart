import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HttpServices {
  final _dio = Dio();

  Future<Response?> get({required String path}) async {
    try {
      final response = await _dio.get(path);
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
