import 'package:get/get.dart';
import 'package:ping_gai_helper/routes/route_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ping_gai_helper/api/user.dart';

class UserController extends GetxController {
  final _isLoggedIn = false.obs;
  final _userId = 0.obs;
  final _qq = ''.obs;
  final _token = ''.obs;

  bool get isLoggedIn => _isLoggedIn.value;
  int get userId => _userId.value;
  String get qq => _qq.value;
  String get token => _token.value;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
    _userId.value = prefs.getInt('userId') ?? 0;
    _qq.value = prefs.getString('qq') ?? '';
    _token.value = prefs.getString('token') ?? '';
    if (_isLoggedIn.value) {
      await _checkTokenValidity();
    }
  }

  Future<void> _checkTokenValidity() async {
    try {
      final response = await whoami();
      if (response['code'] == 0) {
        // Token 有效，继续保持登录状态
        _isLoggedIn.value = true;
        _userId.value = response['data']['id'];
        _qq.value = response['data']['qq'];
        _token.value = response['data']['token'];
        await _saveUserData();
        // 跳转到首页
        Get.offNamed(RouteName.home);
      } else {
        // Token 无效，退出登录
        await logout();
        Get.offNamed(RouteName.login);
      }
    } catch (e) {
      // 处理异常，可能需要退出登录或显示错误信息
      await logout();
      Get.offNamed(RouteName.login);
    }
  }

  Future<Map<String, dynamic>> loginState(
      {required String qq, required String password}) async {
    try {
      var res = await login(qq: qq, password: password);
      if (res['code'] == 0) {
        _isLoggedIn.value = true;
        _userId.value = res['data']['id'];
        _qq.value = res['data']['qq'];
        _token.value = res['data']['token'];
        await _saveUserData();
        return {'status': true, 'msg': '登录成功'};
      } else {
        return {'status': false, 'msg': res['msg'] ?? '登录失败'};
      }
    } catch (e) {
      return {'status': false, 'msg': '登录过程中发生错误：$e'};
    }
  }

  Future<void> logout() async {
    _isLoggedIn.value = false;
    _userId.value = 0;
    _qq.value = '';
    _token.value = '';
    await _saveUserData();
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', _isLoggedIn.value);
    await prefs.setInt('userId', _userId.value);
    await prefs.setString('qq', _qq.value);
    await prefs.setString('token', _token.value);
  }

  String getErrorMessage(Map<String, dynamic> response) {
    return response['msg'] ?? '未知错误';
  }
}
