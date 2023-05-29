import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../app/constants.dart';
import '../data/hive/hive_utils.dart';

const String _applicationJson = 'application/json';
const String _contentType = 'content-type';
const String _accept = 'accept';
const String _authorization = 'authorization';

class DioFactory {
  Dio getDio() {
    Dio dio = Dio();

    final token = HiveUtils.getToken();

    Map<String, String> headers = {
      _contentType: _applicationJson,
      _accept: _applicationJson,
      _authorization: 'Bearer $token',
    };

    dio.options = BaseOptions(
      baseUrl: UrlConstants.versionUrl,
      connectTimeout: const Duration(seconds: AppDefaults.connectionTimeOutSeconds),
      receiveTimeout: const Duration(seconds: AppDefaults.connectionTimeOutSeconds),
      headers: headers,
    );

    // (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
    //   client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };

    if (kReleaseMode) {
      // print('Release Mode no logs');
    } else {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          error: true,
          request: true,
          responseBody: true,
        ),
      );
    }

    return dio;
  }
}
