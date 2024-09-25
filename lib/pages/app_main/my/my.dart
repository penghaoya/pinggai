import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ping_gai_helper/common/otherfun/other_fun.dart';
import 'package:ping_gai_helper/controllers/user_controller.dart';
import 'package:ping_gai_helper/routes/route_name.dart';
import 'package:ping_gai_helper/utils/tool/tips_util.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final RxString desc = "欢迎使用瓶盖客户端".obs;
  final UserController _userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
  }

  void joinQQ(String key) async {
    String url =
        'mqqopensdkapi://bizAgent/qm/qr?url=http%3A%2F%2Fqm.qq.com%2Fcgi-bin%2Fqm%2Fqr%3Ffrom%3Dapp%26p%3Dandroid%26jump_from%3Dwebapi%26k%3D$key';
    try {
      await launch(url);
    } catch (_) {
      Tips.info("跳转失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // 更柔和的背景色
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: buildHeader(),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 5,
            ),
            sliver: SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                ),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OtherFunButton(
                            title: "加入组织",
                            icon: Icons.import_contacts_rounded,
                            onTap: () {
                              joinQQ('B7-nwAW9I09JjUZKSfaCtkBLoXXD-rfg');
                            },
                            iconColor: Colors.red,
                          ),
                        ),
                        Expanded(
                          child: OtherFunButton(
                            title: "应用开发",
                            icon: Icons.catching_pokemon,
                            onTap: () async {
                              Tips.info("待开发");
                            },
                            iconColor: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: OtherFunButton(
                            title: "代理配置",
                            icon: CupertinoIcons.settings,
                            onTap: () {
                              Tips.info("待开发");
                            },
                            iconColor: Colors.blue,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      height: 150, // 增加高度
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15), // 增加圆角
                child: Image.network(
                  'https://q2.qlogo.cn/headimg_dl?dst_uin=${_userController.qq}&spec=640',
                  width: 65, // 增加图片大小
                  height: 65,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userController.qq,
                      style: const TextStyle(
                        fontSize: 20, // 增加字体大小
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // 改为白色以提高对比度
                        shadows: [
                          Shadow(
                            blurRadius: 2,
                            color: Colors.black26,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Obx(
                      () => Text(
                        desc.value,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TDButton(
                text: '退出登录',
                size: TDButtonSize.medium,
                type: TDButtonType.text,
                shape: TDButtonShape.round,
                theme: TDButtonTheme.defaultTheme,
                onTap: () async {
                  Get.offNamed(RouteName.login);
                  await _userController.logout();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
