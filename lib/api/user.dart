import 'package:ping_gai_helper/utils/m_dio/app_req.dart';

AppRequest request = AppRequest(baseUrl: 'http://116.196.80.9:3000/api');

Future<Map<String, dynamic>> sendEmailCode(String mode, String qq) async {
  return request.post("/auth/send-code/$mode", data: {"qq": qq});
}

Future<Map<String, dynamic>> registerORreset({
  required String mode, // 模式，必须传递
  required String qq, // qq 号码，必须传递
  required String code, // 验证码，必须传递
  required String password, // 密码，必须传递
}) async {
  return request.post("/auth/$mode", data: {
    "qq": qq,
    "code": code,
    "password": password,
  });
}

Future<Map<String, dynamic>> login({
  required String qq, // qq 号码，必须传递
  required String password, // 密码，必须传递
}) async {
  return request.post("/auth/login", data: {
    "qq": qq,
    "password": password,
  });
}

Future<Map<String, dynamic>> whoami() async {
  return request.get("/auth/whoami");
}
