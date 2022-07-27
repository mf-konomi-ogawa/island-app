/*        island       */
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:apikicker/Auth/login.dart';

/* プログラム開始点 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase 初期化
  await Firebase.initializeApp(
    options : FirebaseOptions(
      apiKey: "AIzaSyBu6veShb20Y9sBv3LysUBE9O0Fp7R33R4",
      appId: "1:229244289320:web:2235e6cb1bf6fe032d501d",
      messagingSenderId: "229244289320",
      projectId: "island-develop",
      authDomain: "island-develop.firebaseapp.com",
      storageBucket: "island-develop.appspot.com",
    )
  );
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
