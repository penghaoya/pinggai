import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:ping_gai_helper/api/user.dart';

class RegisterPage extends StatefulWidget {
  final String mode; // 接收 mode 参数

  const RegisterPage({super.key, required this.mode});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isCountingDown = false;
  int _countDown = 60;
  Timer? _timer;

  late String _pageMode;
  late String _pageTitle;
  late String _buttonText;

  @override
  void initState() {
    super.initState();
    // 使用从 widget 中传入的 mode 参数
    _pageMode = widget.mode;
    _pageTitle = _pageMode == 'reset' ? '重置密码' : '注册';
    _buttonText = _pageMode == 'reset' ? '重置密码' : '注册';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _verificationCodeController.dispose();
    _passwordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountDown() {
    setState(() {
      _isCountingDown = true;
      _countDown = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countDown > 0) {
        setState(() {
          _countDown--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isCountingDown = false;
        });
      }
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text;
    final code = _verificationCodeController.text;
    final password = _passwordController.text;
    final isReset = widget.mode == 'reset';
    final actionText = isReset ? '重置密码' : '注册';

    print('手机号: $phone');
    print('验证码: $code');
    print('密码: $password');
    _showSnackBar('正在处理$actionText...');
    try {
      final res = await registerORreset(
        mode: widget.mode,
        qq: phone,
        code: code,
        password: password,
      );
      print('$res');
      _hideSnackBar();
      if (res['code'] == 0) {
        Get.back();
        // ignore: use_build_context_synchronously
        TDToast.showSuccess("$actionText成功", context: context);
      } else {
        TDToast.showText(res["msg"] ?? '操作失败', context: context);
      }
    } catch (e) {
      print('$actionText过程中出现错误: $e');
      _hideSnackBar();
      TDToast.showText('$actionText失败，请稍后重试', context: context);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _hideSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.mode);
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle),
        elevation: 0,
      ),
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
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'QQ',
                        hintText: '请输入您的QQ号码',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入您的QQ号码';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _verificationCodeController,
                            decoration: const InputDecoration(
                              labelText: '验证码',
                              hintText: '请输入验证码',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请输入验证码';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        TDButton(
                          size: TDButtonSize.large,
                          type: TDButtonType.outline,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.primary,
                          onTap: _isCountingDown
                              ? null
                              : () async {
                                  if (_phoneController.text != "") {
                                    var res = await sendEmailCode(
                                        widget.mode, _phoneController.text);

                                    if (res['code'] == 0) {
                                      _startCountDown();
                                      TDToast.showIconText(
                                        '验证码发送成功',
                                        icon: TDIcons.check_circle,
                                        // ignore: use_build_context_synchronously
                                        context: context,
                                      );
                                      print('验证码发送成功');
                                    } else {
                                      TDToast.showText('${res['msg']}',
                                          // ignore: use_build_context_synchronously
                                          context: context);
                                    }
                                    print('发送验证码到: ${_phoneController.text}');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('请输入正确的QQ号码')),
                                    );
                                  }
                                },
                          text: _isCountingDown ? '$_countDown s' : '获取验证码',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: _pageMode == 'reset' ? '新密码' : '密码',
                        hintText: _pageMode == 'reset' ? '请输入新密码' : '请输入密码',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入密码';
                        }
                        if (value.length < 6) {
                          return '密码长度至少为6位';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    TDButton(
                      text: _buttonText,
                      size: TDButtonSize.large,
                      type: TDButtonType.outline,
                      shape: TDButtonShape.rectangle,
                      theme: TDButtonTheme.primary,
                      onTap: _submitForm,
                    ),
                    if (_pageMode == 'register') ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('已有账号？'),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('立即登录'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
