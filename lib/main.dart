/*        island       */
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:apikicker/Auth/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apikicker/Home/home.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:apikicker/Home/timeline_screen.dart';

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

final activityReplyListLengthProvider = StateProvider((ref) => null);

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

/* プログラム開始点 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  timeAgo.setLocaleMessages("ja", timeAgo.JaMessages()); // 投稿時間などの設定用ライブラリを設定

  // // FCM の通知権限リクエスト
  // final messaging = FirebaseMessaging.instance;
  // await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
  // // トークンの取得
  // final token = await messaging.getToken();
  // print('🐯 FCM TOKEN: $token');
  runApp(
    // Riverpodでデータを受け渡しできる状態にする
    const ProviderScope(child: MyApp()),
  );
}

/* アプリメイン関数 */
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'island develop',
        initialRoute: '/', // 初期画面を'/'とする
        routes: {
          '/TimelineScreen': (context) => TimelineScreen(),
        },
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // TODO : スプラッシュ画面にする
              return const SizedBox();
            }
            if (snapshot.hasData) {
              // User が null ではない、つまりサインイン済みのホーム画面へ
              return const Home();
            }
            // User が null である、つまり未サインインのサインイン画面へ
            return const WelcomePage();
          },
        ),
      );
}
