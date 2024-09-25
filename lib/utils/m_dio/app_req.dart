import 'package:dio/dio.dart';
import 'package:ping_gai_helper/routes/route_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart' as getx;

class AppRequest {
  late Dio _dio;
  late String _token;
  // 初始化 Dio
  AppRequest({String baseUrl = 'http://116.196.80.9:3000'}) {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5), // 连接超时
      receiveTimeout: const Duration(seconds: 3), // 接收数据超时
      headers: {
        'Content-Type': 'application/json',
      },
    );

    _dio = Dio(options);

    // 请求拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 从 SharedPreferences 获取 token
        final prefs = await SharedPreferences.getInstance();
        _token = prefs.getString('token') ?? '';
        // 如果 token 存在，则添加到请求头
        if (_token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $_token';
        }

        print('请求: ${options.method} ${options.path}');
        return handler.next(options); // 继续请求处理
      },
      onResponse: (response, handler) {
        return handler.next(response); // 继续响应处理
      },
      onError: (DioError e, handler) async {
        if (e.response?.statusCode == 401) {
          // 如果响应状态码是401，处理登录过期
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('token'); // 清除本地存储的 token
          getx.Get.offNamed(RouteName.login); // 跳转到登录页面
          return handler.reject(e); // 终止后续处理
        }
        print('Dio 错误: ${e.message}');
        return handler.next(e); // 继续错误处理
      },
    ));
  }

  // GET 请求
  Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    Response response = await _dio.get(path, queryParameters: queryParameters);
    return _handleResponse(response);
  }

  // POST 请求
  Future<Map<String, dynamic>> post(String path, {dynamic data}) async {
    Response response = await _dio.post(path, data: data);
    return _handleResponse(response);
  }

  // PUT 请求
  Future<Map<String, dynamic>> put(String path, {dynamic data}) async {
    Response response = await _dio.put(path, data: data);
    return _handleResponse(response);
  }

  // DELETE 请求
  Future<Map<String, dynamic>> delete(String path, {dynamic data}) async {
    Response response = await _dio.delete(path, data: data);
    return _handleResponse(response);
  }

  // 统一处理响应数据
  Map<String, dynamic> _handleResponse(Response response) {
    if (response.data['code'] == 0) {
      // 成功，返回统一格式
      return {
        'code': 0,
        'msg': '',
        'data': response.data['data'],
      };
    } else {
      // 失败，返回统一格式
      return {
        'code': response.data['code'],
        'msg': response.data['msg'] ?? '未知错误',
        'data': null,
      };
    }
  }

  // 处理业务状态码的错误并返回消息
  String _getErrorMessage(int code, String message) {
    switch (code) {
      case 10000:
        return '参数校验异常: $message';
      case 10001:
        return '用户已存在: $message';
      case 10002:
        return '用户名或密码错误: $message';
      case 10003:
        return '验证码过期或者无效: $message';
      case 10004:
        return '密码验证失败: $message';
      case 10005:
        return '尚未注册，请先注册: $message';
      case 10006:
        return '验证码仍然有效，请检查您的邮箱: $message';
      case 10007:
        return '登录已过期或无效: $message';
      default:
        return '未知错误: $message';
    }
  }
}
