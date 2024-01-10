import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tttttt/page/usersetting.dart';
// import 'package:tttttt/page/list.dart';

import '../pages/list_page.dart';
import '../page/Home_page.dart';


class buttomview extends StatefulWidget {
  const buttomview({super.key});

  @override
  State<buttomview> createState() => _buttomviewState();
}

class _buttomviewState extends State<buttomview> {
  DateTime? currentBackPressTime;
  int nowcurrentIndex = 0;
  final Tabs = [
    const Center(
      child: Homepage(),
    ),
    const Center(
      child: ListPage(0),
    ),
    const Center(
      child: UserSettingsPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    //Statement 1 Or statement2
    if (currentBackPressTime == null ||
        currentTime.difference(currentBackPressTime!) >
            const Duration(seconds: 2)) {
      currentBackPressTime = currentTime;
      Fluttertoast.showToast(
          msg: "'뒤로' 버튼을 한번 더 누르시면 종료됩니다.",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color(0xff6E6E6E),
          fontSize: 20,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    return true;

    // SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(onWillPop: onWillPop, child: Tabs[nowcurrentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: nowcurrentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
            ),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: 'setting',
          ),
        ],
        onTap: (index) {
          setState(() {
            nowcurrentIndex = index;
          });
        },
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
      ),
    );
  }
}