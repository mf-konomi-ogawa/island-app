/*        island       */
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:apikicker/Auth/login.dart';

/* プログラム開始点 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase 初期化
  await Firebase.initializeApp();
  runApp(MyApp());
}

/*　アプリメイン関数　*/
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'island API Kicker',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: WelcomePage(),
    );
  }
}
