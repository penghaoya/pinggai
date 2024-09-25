import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Axios {
  late Dio _dio;

  Axios({
    required String baseUrl,
    Map<String, dynamic>? defaultHeaders,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: defaultHeaders ?? {},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // options.headers['Content-Type'] ??= 'application/json';
        // options.headers['Accept'] ??= 'application/json';
        options.headers['User-Agent'] ??= await _getUserAgent();
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(Response(
          requestOptions: response.requestOptions,
          data: response.data,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        ));
      },
      onError: (DioException e, handler) {
        return handler.next(e);
      },
    ));
  }

  Future<String> _getUserAgent() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return 'Mozilla/5.0 (Linux; Android ${androidInfo.version.release}; ${androidInfo.model} Build/${androidInfo.id}; wv) '
          'AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/78.0.3904.62 '
          'XWEB/2691 MMWEBSDK/200801 Mobile Safari/537.36 MMWEBID/9633 '
          'MicroMessenger/$appVersion($buildNumber) Process/toolsmp WeChat/arm64 '
          'NetType/WIFI Language/zh_CN ABI/arm64';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return 'Mozilla/5.0 (iPhone; CPU iPhone OS ${iosInfo.systemVersion.replaceAll('.', '_')} like Mac OS X) '
          'AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 '
          'MicroMessenger/$appVersion($buildNumber) NetType/WIFI Language/zh_CN';
    } else {
      return 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '
          'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36 '
          'MicroMessenger/$appVersion($buildNumber) MacWechat/3.3.0 NetType/WIFI WindowsWechat';
    }
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
