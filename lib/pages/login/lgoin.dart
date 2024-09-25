import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ping_gai_helper/controllers/user_controller.dart';
import 'package:ping_gai_helper/routes/route_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SharedPreferences _prefs;
  final _formKey = GlobalKey<FormState>();
  bool _agreedToTerms = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserController _userController = Get.find<UserController>();
  bool _obscureText = true;
  String? _usernameError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_clearError);
    _passwordController.addListener(_clearError);
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    // 这里可以添加更多的初始化逻辑
    setState(() {
      _usernameController.text = _prefs.getString("username") ?? '';
      _passwordController.text = _prefs.getString('password') ?? '';
      _agreedToTerms = _prefs.getBool('agreedToTerms') ?? false;
    }); // 如果需要更新 UI，调用 setState
  }

  @override
  void dispose() {
    _usernameController.removeListener(_clearError);
    _passwordController.removeListener(_clearError);
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearError() {
    setState(() {
      _usernameError = null;
      _passwordError = null;
    });
  }

  void _showAgreement(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: ContentBox(title: title),
      ),
    );
  }

  void _validateInputs() {
    setState(() {
      _usernameError = _usernameController.text.isEmpty ? '请输入用户名' : null;
      _passwordError = _passwordController.text.isEmpty ? '请输入密码' : null;
    });
  }

  void _login() async {
    _validateInputs();
    if (_usernameError == null && _passwordError == null && _agreedToTerms) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      var result =
          await _userController.loginState(qq: username, password: password);
      if (result['status']) {
        // 跳转到主页面或其他页面
        Fluttertoast.showToast(
          msg: "${result['msg']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        Get.offNamed(RouteName.home);
        // 存储账号和密码
        await _prefs.setString('username', username);
        await _prefs.setString('password', password);
        await _prefs.setBool('agreedToTerms', _agreedToTerms);
      } else {
        TDToast.showText("${result['msg']}", context: context);
      }
    } else if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请同意用户协议和隐私政策')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    return Scaffold(
      body: Theme(
        data: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              splashFactory: NoSplash.splashFactory,
            ),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/login_logo.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: "QQ",
                          hintText: "您的QQ号码",
                          prefixIcon: const Icon(Icons.person),
                          suffixIcon: _usernameController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: _usernameController.clear,
                                  child: Icon(Icons.clear,
                                      size: 18, color: Colors.grey[600]),
                                )
                              : null,
                          errorText: _usernameError,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: "密码",
                          hintText: "您的登录密码",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                            onPressed: () =>
                                setState(() => _obscureText = !_obscureText),
                          ),
                          errorText: _passwordError,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, RouteName.register,
                              arguments: "reset"),
                          child: Text(
                            "忘记密码？",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TDButton(
                        text: '登录',
                        size: TDButtonSize.large,
                        type: TDButtonType.outline,
                        shape: TDButtonShape.rectangle,
                        theme: TDButtonTheme.primary,
                        onTap: _login,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("没有账号？"),
                          TextButton(
                            onPressed: () =>
                                Get.toNamed('/register', arguments: 'register'),
                            child: Text(
                              "立即注册",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomRadioButton(
                            value: _agreedToTerms,
                            onChanged: (value) =>
                                setState(() => _agreedToTerms = value),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 12,
                                ),
                                children: [
                                  const TextSpan(text: "我已阅读并同意"),
                                  TextSpan(
                                    text: "《用户协议》",
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              elevation: 0,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: const ContentBox(
                                                title: "用户协议",
                                              ),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ContentBox extends StatelessWidget {
  final String title;

  const ContentBox({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),
          const Text(
            '用户在使用瓶盖小助手(以下简称"本软件")提供的网络服务前有义务仔细阅读本协议。用户在此不可撤销地承诺，若其使用本软件提供的网络服务，将视为用户同意并接受本协议全部条款的约束，此后用户无权以未阅读本协议或对本协议有任何误解为由，主张本协议无效或要求撤销本协议。',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          const Text(
            '第一条\n保护用户个人信息是一项基本原则，我们将会采取合理的措施保护用户的个人信息。除法律法规规定的情形外，未经用户许可我们不会向第三方公开、透漏个人信息。APP对相关信息采用专业加密存储与传输方式，保障用户个人信息安全，如果您选择同意使用APP软件，即表示您认可并接受APP服务条款及其可能随时更新的内容。',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          const Text(
            '第二条\n本软件所提供的服务为本人练习项目，仅供学习参考，若使用者使用本软件进行对目标网站造成损害所有的后果由使用者自行承担，与本作者无任何关系，特此声明。',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          const Text(
            '第三条\n本软件请在下载后24h内删除，否则后续操作所造成的后果由使用者自行承担。\n我们拥有对上述条款的最终解释权。',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 22),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("关闭", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomRadioButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomRadioButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: value ? Theme.of(context).primaryColor : Colors.grey,
            width: 2,
          ),
        ),
        child: value
            ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
