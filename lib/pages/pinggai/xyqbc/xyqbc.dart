import 'package:dio/dio.dart' as dio_package;

import 'package:flutter/material.dart';
import 'package:ping_gai_helper/common/logger/log_manager.dart';
import 'package:ping_gai_helper/common/tab_bar/custom_tab_bar.dart';
import 'package:ping_gai_helper/common/table/flexible_data_table.dart';
import 'package:ping_gai_helper/utils/pinggai_dio/axios.dart';
import 'package:ping_gai_helper/utils/tool/tesk.dart';
import 'package:ping_gai_helper/utils/tool/tips_util.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';

class XYQBC extends StatefulWidget {
  const XYQBC({super.key});

  @override
  XYQBCState createState() => XYQBCState();
}

class XYQBCState extends State<XYQBC> with SingleTickerProviderStateMixin {
  // 状态栏
  int userTotal = 0;
  int keyTotal = 0;
  int allTaskTotal = 0;
  int taskTotal = 0;

  late TabController _tabController;
  late List<Map<String, dynamic>> _data;
  final deviceInfo = DeviceInfoPlugin();
  // 控制任务
  ValueNot<bool> terminateNotifier = ValueNot(false);

  // 用户token
  TextEditingController userInputController = TextEditingController();
  TextEditingController taskInputController = TextEditingController();

  //延迟
  final TextEditingController _sleepMinController =
      TextEditingController(text: '3');
  final TextEditingController _sleepMaxController =
      TextEditingController(text: '5');

  // 请求实例

  final axios = Axios(
    baseUrl: 'https://13.yx94.cn/refactor/general/2023',
    defaultHeaders: {
      'Referer':
          ' https://servicewechat.com/wxb736479133333676/432/page-frame.html',
    },
  );
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _data = [];
  }

// 页面销毁时执行
  @override
  void dispose() {
    userInputController.dispose();
    taskInputController.dispose();
    _tabController.dispose();
    LogManager().clearLogs();
    super.dispose();
  }

  //校验输入内容
  List<String>? validateAndSplitInput(String input) {
    final trimmedInput = input.trim();
    if (trimmedInput.isEmpty) {
      Tips.info("输入内容为空，请检查");
      return null;
    }

    List<String> lines = trimmedInput
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    if (lines.isNotEmpty) {
      return lines;
    }

    Tips.info("格式不正确，请检查输入");
    return null;
  }

  void _addNewData() async {
    // 验证输入
    List<String>? users = validateAndSplitInput(userInputController.text);
    List<String>? tasks = validateAndSplitInput(taskInputController.text);

    if (users == null || tasks == null) {
      return;
    }
    // 延迟数据转换
    final minDelayText = _sleepMinController.text;
    final maxDelayText = _sleepMaxController.text;
    final int? minDelay = int.tryParse(minDelayText);
    final int? maxDelay = int.tryParse(maxDelayText);
    if (minDelay == null || maxDelay == null) {
      Tips.info("请确保延迟时间输入正确");
      return;
    }

    // 创建任务列表
    List<Map<String, String>> taskMap = assignTasks({
      'user': users,
      'task': tasks,
    });

    // 更新任务状态
    setState(() {
      userTotal = users.length;
      keyTotal = tasks.length;
      allTaskTotal = taskMap.length;
      taskTotal = taskMap.length;
      terminateNotifier.value = false;
    });
    processTasks(
      taskList: taskMap,
      doSomething: (index, assignment) async {
        LogManager().info('用户: ${assignment['user']} 使用 ${assignment['task']}');
        try {
          final RegExp regExp = RegExp(r'(?:.*?/)?([^/]+)/?$');
          final match = regExp.firstMatch(assignment['task'] as String);
          String arcode = match?.group(1) as String;
          // 扫码
          final codeCheck = await axios.post(
            '/projectCheck/codeCheck',
            data: dio_package.FormData.fromMap({'qrCode': arcode}),
            headers: {
              'Cookie': assignment['user'],
            },
          );
          String code = codeCheck['code'];
          if (code == '900') {
            Tips.info("检查用户是否有效");
            LogManager().info('${codeCheck['msg']}--${assignment['user']}');
            return;
          }
          // 复购提现
          final postMoney = await axios.post(
            '/luckyDrawV2/receiveRepurchaseSunday',
            data: {},
            headers: {
              'Cookie': assignment['user'],
            },
          );
          if (postMoney['data']['code'] == '200') {
            // ignore: prefer_interpolation_to_compose_strings
            LogManager().info("提现成功:" + postMoney['data']['unit_money']);
          } else {
            LogManager().info("${postMoney['data']['msg']}");
          }
          //抽奖
          final postPrize = await axios.post(
            '/luckyDrawV2/drawNewRecordPre',
            data: dio_package.FormData.fromMap(
              {'locationClassifyId': 1, 'firstScan': 1},
            ),
            headers: {
              'Cookie': assignment['user'],
            },
          );
          String msgPrize = '';
          if (postPrize[code] == '200') {
            msgPrize = postPrize['data']['drawResult']['prizeName'];
          } else {
            msgPrize = postPrize['msg'];
          }
          LogManager().info("抽奖：$msgPrize");
          setState(() {
            _data.add({
              'id': '${index + 1}',
              'userSuffix': '${assignment['user']}',
              'cardPassword': '${match?.group(1)}',
              'result': msgPrize,
            });
            taskTotal = allTaskTotal - _data.length;
          });
        } catch (e) {
          LogManager().err('出错了: $e,');
        }
      },
      onTerminate: () {
        LogManager().info('处理终止回调');
      },
      onFinish: () {
        LogManager().warning("任务已完成");
      },
      onAwait: (t) {
        LogManager().warning("----等待了$t秒时间-----");
      },
      onError: (e) {
        LogManager().err('任务处理过程中出现异常: $e');
      },
      minDelaySeconds: minDelay,
      maxDelaySeconds: maxDelay,
      terminateNotifier: terminateNotifier,
    );
  }

  void reset() async {
    setState(() {
      _data = [];
      userInputController.text = '';
      taskInputController.text = '';
      LogManager().clearLogs();
      userTotal = 0;
      keyTotal = 0;
      allTaskTotal = 0;
      taskTotal = 0;
      terminateNotifier.value = false;
      _tabController.animateTo(0);
    });
    Tips.info("数据已重置");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('元气冰茶'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            CustomTabBar(
              width: MediaQuery.of(context).size.width - 20,
              controller: _tabController,
              tabs: const ['任务管理', '运行日志'],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildTaskManagementTab(),
                  _buildLogOrSettingTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskManagementTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TDButton(
                    text: '开始任务',
                    size: TDButtonSize.small,
                    type: TDButtonType.outline,
                    shape: TDButtonShape.rectangle,
                    theme: TDButtonTheme.primary,
                    onTap: () {
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: false,
                        barrierLabel: 'Dismiss',
                        barrierColor: Colors.black.withOpacity(0.5),
                        pageBuilder: (
                          BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                        ) {
                          return Center(
                            child: Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              child: Container(
                                height: 220,
                                width: 400,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "当前任务配置",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "当前任务配置确认启动",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: SizedBox(
                                            height: 40,
                                            width: 10,
                                            child: TextField(
                                              controller: _sleepMinController,
                                              decoration: const InputDecoration(
                                                labelText: '开始延迟',
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text("~",
                                            style: TextStyle(fontSize: 16)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: SizedBox(
                                            height: 40,
                                            child: TextField(
                                              controller: _sleepMaxController,
                                              decoration: const InputDecoration(
                                                labelText: '结束延迟',
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TDButton(
                                          text: '启动任务',
                                          icon: TDIcons.star,
                                          size: TDButtonSize.small,
                                          type: TDButtonType.outline,
                                          shape: TDButtonShape.rectangle,
                                          theme: TDButtonTheme.primary,
                                          onTap: () {
                                            _addNewData();
                                            Navigator.of(context).pop();
                                            FocusScope.of(context).unfocus();
                                          },
                                        ),
                                        TDButton(
                                          text: '取消',
                                          size: TDButtonSize.small,
                                          icon: TDIcons.close,
                                          type: TDButtonType.outline,
                                          shape: TDButtonShape.rectangle,
                                          theme: TDButtonTheme.defaultTheme,
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            FocusScope.of(context).unfocus();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 5),
                  TDButton(
                    text: '强行停止',
                    size: TDButtonSize.small,
                    type: TDButtonType.outline,
                    shape: TDButtonShape.rectangle,
                    theme: TDButtonTheme.danger,
                    onTap: () {
                      Tips.info("任务已终止");
                      terminateNotifier.value = true;
                    },
                  ),
                  const Spacer(),
                  TDButton(
                    text: '重置',
                    size: TDButtonSize.small,
                    type: TDButtonType.outline,
                    shape: TDButtonShape.rectangle,
                    theme: TDButtonTheme.primary,
                    onTap: () {
                      reset();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Container(
                    height: 90,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: MediaQuery.of(context).size.width - 10,
                    child: TextField(
                      controller: userInputController,
                      autofocus: false,
                      style: const TextStyle(color: Colors.black, fontSize: 11),
                      minLines: 100,
                      maxLines: 100,
                      cursorColor: Colors.green,
                      cursorRadius: const Radius.circular(3),
                      cursorWidth: 1,
                      showCursor: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        hintText: "请输入用户数据例子:\n用户1\n用户2",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: MediaQuery.of(context).size.width - 10,
                    child: TextField(
                      controller: taskInputController,
                      autofocus: false,
                      style: const TextStyle(color: Colors.black, fontSize: 10),
                      minLines: 100,
                      maxLines: 100,
                      cursorColor: Colors.green,
                      cursorRadius: const Radius.circular(3),
                      cursorWidth: 1,
                      showCursor: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        hintText:
                            "请输入卡密数据注意格式\n例子:\nhtttp://xxxx.com/xxxx\nhtttp://xxxx.com/xxxx",
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
            child: FlexibleDataTable(
              data: _data,
              containerHeight: 300,
              rowHeight: 25,
              headerFontSize: 12,
              headerBackgroundColor: Colors.black,
              borderColor: Colors.grey.shade300,
              columns: [
                ColumnConfig(
                  field: 'id',
                  title: 'ID',
                  width: 35,
                  fixed: FixedPosition.left,
                  customBuilder: (value) => Text(
                    value,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ColumnConfig(
                  field: 'result',
                  title: '抽奖结果',
                  width: 90,
                  customBuilder: (value) => Text(
                    value,
                    style: TextStyle(
                      color: value == '中奖' ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                    ),
                  ),
                ),
                ColumnConfig(
                  field: 'userSuffix',
                  title: '用户',
                  width: 130,
                  customBuilder: (value) => Text(
                    _truncateText(_substring(value, 20), 30),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ColumnConfig(
                  field: 'cardPassword',
                  title: '卡密',
                  width: 120,
                  customBuilder: (value) => Text(
                    _truncateText(_substring(value, 15), 30),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // ColumnConfig(field: 'date', title: '日期', width: 100),
              ],
            ),
          ),
        ),
        _buildSummaryRow(),
      ],
    );
  }

  Widget _buildSummaryRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('用户数:$userTotal'),
            const SizedBox(width: 20),
            Text('卡密数:$keyTotal'),
            const SizedBox(width: 20),
            Text('总任务:$allTaskTotal'),
            const SizedBox(width: 20),
            Text('剩余任务:$taskTotal'),
          ],
        ),
      ),
    );
  }

  Widget _buildLogOrSettingTab() {
    return Scaffold(
      body: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        child: LogDisplay(
          width: MediaQuery.of(context).size.width - 10,
          backgroundColor: Colors.white,
        ),
      ),
      floatingActionButton: SizedBox(
        width: 50, // 设置宽度
        height: 50, // 设置高度
        child: FloatingActionButton(
          onPressed: () {
            LogManager().clearLogs();
          },
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.delete,
            color: Colors.black,
            size: 36, // 设置图标大小
          ),
        ),
      ),
    );
  }

  String _truncateText(String text, int? maxLength) {
    if (maxLength == null || text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }

  String _substring(String input, int length) {
    // 确保 length 不超过字符串的长度
    if (length > input.length) {
      length = input.length;
    }

    // 返回从字符串末尾开始的子字符串
    return input.substring(input.length - length);
  }
}
