import 'package:apikicker/Home/notification_screen.dart';
import 'package:apikicker/Home/profile_screen.dart';
import 'package:apikicker/Home/search_screen.dart';
import 'package:apikicker/Home/timeline_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apikicker/Common/color_settings.dart';


class Home extends StatefulWidget {
  const Home(this.user); // 引数からユーザー情報を受け取れるようにする
  final User user; // ユーザー情報

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  int _selectedIndex = 0;

  static final List<Widget> _pageList = [
    const TimelineScreen(),
    const SearchScreen(),
    const NotificationScreen(),
    const ProfileScreen()
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: _pageList,
        )
      ),

      // ボトムナビゲーション
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.white,
        backgroundColor: footerColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '検索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '通知',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'プロフィール',
          ),
        ],
        selectedItemColor: accentColor,
      ),
    );
  }

}
