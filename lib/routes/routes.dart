import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ping_gai_helper/pages/app_main/app_mian.dart';
import 'package:ping_gai_helper/pages/app_main/my/my.dart';
import 'package:ping_gai_helper/pages/login/lgoin.dart';
import 'package:ping_gai_helper/pages/login/register_page.dart';
import 'package:ping_gai_helper/pages/pinggai/baishi/bai_shi.dart';
import 'package:ping_gai_helper/pages/pinggai/jdl/jdl.dart';
import 'package:ping_gai_helper/pages/pinggai/mnd/mnd.dart';
import 'package:ping_gai_helper/pages/pinggai/xyqbc/xyqbc.dart';
import 'package:ping_gai_helper/routes/route_name.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: RouteName.home, page: () => const HomePage()),
    GetPage(name: RouteName.login, page: () => const LoginPage()),
    GetPage(name: RouteName.my, page: () => const MyPage()),
    GetPage(
        name: RouteName.register,
        page: () => RegisterPage(mode: Get.arguments),
        transition: Transition.rightToLeft),
    GetPage(name: RouteName.mdn, page: () => const Mnd()),
    GetPage(name: RouteName.jdl, page: () => const JDL()),
    GetPage(name: RouteName.baishi, page: () => const BaiShi()),
    GetPage(name: RouteName.xyqbc, page: () => const XYQBC()),
  ];

  static Route<dynamic> unknownRoute() {
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(child: Text('未知路由')),
      ),
    );
  }
}
