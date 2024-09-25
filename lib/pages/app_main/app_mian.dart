import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ping_gai_helper/pages/app_main/clound/clound.dart';
import 'package:ping_gai_helper/pages/app_main/home/home.dart';
import 'package:ping_gai_helper/pages/app_main/my/my.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  DateTime? _lastPressedAt;

  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Clound(),
    MyPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          Fluttertoast.showToast(
            msg: "再按一次退出应用",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          return false; // 不退出应用
        }
        return true; // 退出应用
      },
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: SizedBox(
          height: 50,
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            elevation: 8.0,
            iconSize: 15,
            selectedFontSize: 12.0,
            unselectedFontSize: 12.0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            unselectedItemColor: const Color.fromARGB(255, 10, 10, 10),
            selectedItemColor: const Color(0xFF448AFF),
            showUnselectedLabels: true,
            onTap: _onItemTapped,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Image.asset(
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                  'assets/images/home.png',
                ),
                activeIcon: Image.asset(
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                  'assets/images/home_ed.png',
                ),
                label: '活动',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                  'assets/images/clound.png',
                ),
                activeIcon: Image.asset(
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                  'assets/images/clound_ed.png',
                ),
                label: '云抓包',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                  'assets/images/my.png',
                ),
                activeIcon: Image.asset(
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                    'assets/images/my_ed.png'),
                label: '我的',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
