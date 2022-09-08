/*        island       */
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:apikicker/Auth/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

// ユーザー情報の受け渡しを行うためのProvider
final userProvider = StateProvider((ref) {
  return FirebaseAuth.instance.currentUser;
});

// メールアドレスの受け渡しを行うためのProvider
final emailProvider = StateProvider.autoDispose((ref) {
  return '';
});

// パスワードの受け渡しを行うためのProvider
final passwordProvider = StateProvider.autoDispose((ref) {
  return '';
});



/* プログラム開始点 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    // Riverpodでデータを受け渡しできる状態にする
    const ProviderScope(
      child: MyApp()
    ),
  );
}

/* アプリメイン関数 */
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'island API Kicker',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const WelcomePage(),
    );
  }
}
