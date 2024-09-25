import 'package:flutter/material.dart';
// import 'package:ping_gai_helper/common/bottom_popup/bottom_popup.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class Clound extends StatefulWidget {
  const Clound({super.key});

  @override
  CloundState createState() => CloundState();
}

class CloundState extends State<Clound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            '云抓包',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
      body: Column(
        children: [
          TDEmpty(
            type: TDEmptyType.plain,
            emptyText: '开发中.......',
            image: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(TDTheme.of(context).radiusDefault),
                image: const DecorationImage(
                  image: AssetImage('assets/images/login_logo.png'),
                ),
              ),
            ),
          ),
          // ElevatedButton(
          //   child: const Text('显示底部弹出框'),
          //   onPressed: () {
          //     showCustomBottomSheet(
          //       context: context,
          //       title: '输入信息',
          //       height:
          //           MediaQuery.of(context).size.height * 0.6, // 设置固定高度为屏幕高度的60%
          //       child: SingleChildScrollView(
          //         child: Padding(
          //           padding: const EdgeInsets.all(16.0),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.stretch,
          //             children: [
          //               const Text("用户token"),
          //               SizedBox(
          //                 width: MediaQuery.of(context).size.width - 100,
          //                 child: TextField(
          //                   style: const TextStyle(color: Colors.blue),
          //                   minLines: 3,
          //                   maxLines: 5,
          //                   cursorColor: Colors.green,
          //                   cursorRadius: const Radius.circular(3),
          //                   cursorWidth: 5,
          //                   showCursor: true,
          //                   decoration: const InputDecoration(
          //                     contentPadding: EdgeInsets.all(5),
          //                     hintText: "请输入...",
          //                     border: OutlineInputBorder(),
          //                   ),
          //                   onChanged: (v) {},
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //       onConfirm: () {
          //         // 处理确认逻辑
          //         print('用户点击了确定');
          //         Navigator.pop(context);
          //       },
          //       onCancel: () {
          //         // 处理取消逻辑
          //         print('用户点击了取消');
          //         Navigator.pop(context);
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
