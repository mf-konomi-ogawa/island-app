import 'package:apikicker/Footer/bottom_navigation.dart';
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

  @override
  Widget build(BuildContext context) {
    return const BottomNavigation();
  }
}
