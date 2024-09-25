import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ping_gai_helper/controllers/user_controller.dart';
import 'package:ping_gai_helper/routes/route_name.dart';
import 'package:ping_gai_helper/routes/routes.dart';

void main() async {
  Get.put(UserController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '瓶盖助手',
      initialRoute: RouteName.login,
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.routes,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          accentColor: Colors.blueAccent,
        ),
        appBarTheme: const AppBarTheme(
          // 状态栏图标为深色
          // systemOverlayStyle: SystemUiOverlayStyle.light,
          // AppBar 背景透明，我们将使用自定义渐变色
          // color: Colors.transparent,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        ),
        // 添加 BottomNavigationBar 的主题设置
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          backgroundColor: Colors.white,
          elevation: 8,
          // 去除水波纹效果
          selectedIconTheme: IconThemeData(size: 24),
          unselectedIconTheme: IconThemeData(size: 24),
        ),
        // 去除全局水波纹效果
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    );
  }
}
