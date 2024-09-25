import 'package:flutter/cupertino.dart';
import 'package:ping_gai_helper/common/otherfun/other_fun.dart';
import 'package:flutter/material.dart';
import 'package:ping_gai_helper/pages/app_main/home/swiper.dart';
import 'package:ping_gai_helper/routes/route_name.dart';
import 'package:ping_gai_helper/utils/tool/tips_util.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            '瓶盖助手',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 轮播图
            const Swiper(),
            // 公告
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Image.asset(
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                    'assets/images/notify.png',
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: TextScroll(
                      '使用中遇到问题请加群反馈,获取新的软件版本 ,  反馈QQ群: 973376410 ',
                      mode: TextScrollMode.endless,
                      velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
                      delayBefore: Duration(milliseconds: 500),
                      pauseBetween: Duration(milliseconds: 50),
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.right,
                      selectable: true,
                    ),
                  ),
                ],
              ),
            ),
            // 基本功能
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100],
              ),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  const Text(
                    "基础功能",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OtherFunButton(
                          title: "美年达",
                          icon: Icons.assignment,
                          onTap: () {
                            // print("美年达被点击");
                            // 在这里添加导航逻辑
                            Tips.info("待开发");
                            // Get.toNamed(RouteName.mdn);
                          },
                          iconColor: Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: OtherFunButton(
                          title: "百事串码",
                          icon: Icons.login,
                          onTap: () async {
                            Get.toNamed(RouteName.baishi);
                            // 在这里添加导航逻辑
                          },
                          iconColor: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: OtherFunButton(
                          title: "佳得乐",
                          icon: CupertinoIcons.settings,
                          onTap: () {
                            Get.toNamed(RouteName.jdl);
                            // 在这里添加导航逻辑
                          },
                          iconColor: Colors.orange,
                        ),
                      ),
                      Expanded(
                        child: OtherFunButton(
                          title: "元气冰茶",
                          icon: CupertinoIcons.bell,
                          onTap: () {
                            // Tips.info("待开发");
                            Get.toNamed(RouteName.xyqbc);
                          },
                          iconColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OtherFunButton(
                          title: "陕西雪花",
                          icon: Icons.lock,
                          onTap: () {
                            Tips.info("待开发");
                            // Get.toNamed(RouteName.mdn);
                          },
                          iconColor: Colors.purple,
                        ),
                      ),
                      Expanded(
                        child: OtherFunButton(
                          title: "元气森林",
                          icon: Icons.history,
                          onTap: () {
                            Tips.info("待开发");
                            // Get.toNamed(RouteName.mdn);
                          },
                          iconColor: Colors.teal,
                        ),
                      ),
                      Expanded(
                        child: OtherFunButton(
                          title: "湖南青岛",
                          icon: Icons.settings_system_daydream,
                          onTap: () {
                            Tips.info("待开发");
                            // Get.toNamed(RouteName.mdn);
                          },
                          iconColor: Colors.indigo,
                        ),
                      ),
                      Expanded(
                        child: OtherFunButton(
                          title: "乌苏",
                          icon: Icons.info,
                          onTap: () {
                            Tips.info("待开发");
                            // Get.toNamed(RouteName.mdn);
                          },
                          iconColor: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
