import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apikicker/Auth/login.dart';
import 'package:apikicker/Home/timeline.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:developer' as developer;

class MainHome extends StatefulWidget {
  MainHome(this.user); // 引数からユーザー情報を受け取れるようにする
  final User user; // ユーザー情報

  @override
  MainHomeState createState() => MainHomeState();
}

class MainHomeState extends State<MainHome> {
  String tweetlist = ""; // ツイート一覧取得用
  String tweetlistAllGet = ""; // ツイート一覧取得用
  String tweetcontents = ""; // ツイート投稿用
  String deletePersonalActivityId = ""; // ツイート削除用
  String getUsersAllLimit = ""; // ユーザー取得テスト用

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: SelectableText('island API Kicker'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // ログアウト処理
              await FirebaseAuth.instance.signOut();
              // ログイン画面に遷移＋タイムライン画面を破棄
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return WelcomePage();
                }),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              child: SelectableText('ログインユーザー：${widget.user.email}'),
            ),
            SizedBox(height: 4),
            // デバッグ用ページ切り替え
            Container(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                child: const Text('タイムライン画面へ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  // タイムライン画面に遷移＋ログイン画面を破棄
                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final User user = auth.currentUser!;
                      return TimelineListScreen(user);
                    }),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            // API テスト - usaTweetAdd - Tweet 内容入力フォーム
            Container(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration( labelText: "ツイート本文を入力", border: OutlineInputBorder() ),
                onChanged: (String value) {
                  setState(() {
                    tweetcontents = value;
                  });
                },
              ),
            ),
            SizedBox(height: 8),
            // API テスト - pocTweetAdd
            Container(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                child: const Text('usaTweetAdd'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                ),
                onPressed: () async {
                  developer.log( "[START]「ツイート投稿」を開始します。", name: "dev.logging" );
                  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('pocTweetAdd');
                  final results = await callable( tweetcontents );
                  // test
                  developer.log( "「ツイート投稿」に成功しました。", name: "dev.logging" );
                  developer.log( "変数 tweetcontents = ${tweetcontents}", name: "dev.logging" );
                  developer.log( "[END]「ツイート投稿」を終了します。", name: "dev.logging" );
                  Flushbar(
                      title : "ツイート投稿" ,
                      message : "ツイートを投稿しました。" ,
                      backgroundColor: Colors.blueAccent,
                      margin: EdgeInsets.all(8),
                      borderRadius: BorderRadius.circular(8),
                      duration:  Duration(seconds: 4),
                      icon: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      )
                  )..show(context);
                },
              ),
            ),
            SizedBox(height: 32),
            // API テスト - deletePersonalActivity - PersonalActivityId 内容入力フォーム
            Container(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration( labelText: "PersonalActivityId を入力", border: OutlineInputBorder() ),
                onChanged: (String value) {
                  setState(() {
                    deletePersonalActivityId = value;
                  });
                },
              ),
            ),
            SizedBox(height: 8),
            // API テスト - pocDeletePersonalActivity
            Container(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                child: const Text('deletePersonalActivity'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                ),
                onPressed: () async {
                  developer.log( "[START]「ツイート削除」を開始します。", name: "dev.logging" );
                  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('pocDeletePersonalActivity');
                  final results = await callable(deletePersonalActivityId);
                  // test
                  developer.log( "削除レスポンス = ${results.data.toString()}" , name: "dev.logging" );
                  developer.log( "「ツイート削除」に成功しました。", name: "dev.logging" );
                  developer.log( "[END]「ツイート削除」を終了します。", name: "dev.logging" );
                  Flushbar(
                      title : "ツイート削除" ,
                      message : "ツイートを削除しました。" ,
                      backgroundColor: Colors.blueAccent,
                      margin: EdgeInsets.all(8),
                      borderRadius: BorderRadius.circular(8),
                      duration:  Duration(seconds: 4),
                      icon: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      )
                  )..show(context);
                },
              ),
            ),
            SizedBox(height: 32),

            SizedBox(height: 8),
            Divider(color: Colors.black38, height: 12, indent: 4, endIndent: 4),
            SizedBox(height: 8),

            // API テスト - pocTweetTest
            Container(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                child: const Text('ツイート取得テスト'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                ),
                onPressed: () async {
                  developer.log( "[START]「ツイート取得テスト」を開始します。", name: "dev.logging" );
                  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('pocTweetTest');
                  final results = await callable();
                  Map<String, dynamic> map = results.data;
                  setState(() {
                    tweetlist = results.data.toString();
                    developer.log( "変数 results.data = ${map['usa']}", name: "dev.logging" );
                    developer.log( "変数 tweetlist = ${tweetlist}", name: "dev.logging" );
                  });
                  developer.log( "「ツイート取得テスト」の実行に成功しました。", name: "dev.logging" );
                  developer.log( "[END]「ツイート取得テスト」を終了します。", name: "dev.logging" );
                  Flushbar(
                      title : "ツイート取得" ,
                      message : "ツイートを取得しました。" ,
                      backgroundColor: Colors.blueAccent,
                      margin: EdgeInsets.all(8),
                      borderRadius: BorderRadius.circular(8),
                      duration:  Duration(seconds: 4),
                      icon: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      )
                  )..show(context);
                },
              ),
            ),
            SizedBox(height: 4),
            Container(
              alignment: Alignment.centerLeft,
              child: SelectableText( 'ツイート取得テスト結果：\n${tweetlist}' ),
            ),
            SizedBox(height: 4),

            SizedBox(height: 8),
            Divider(color: Colors.black38, height: 12, indent: 4, endIndent: 4),
            SizedBox(height: 8),

            // API テスト - pocTweetTestAllGet
            Container(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                child: const Text('ツイート取得テスト(AllGet)'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                ),
                onPressed: () async {
                  developer.log( "[START]「ツイート取得テスト All Get」を開始します。", name: "dev.logging" );
                  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('pocTweetTestAllGet');
                  final results = await callable();
                  setState(() {
                    tweetlistAllGet = results.data.toString();
                    developer.log( "変数 tweetlistAllGet = ${tweetlistAllGet}", name: "dev.logging" );
                  });
                  developer.log( "「ツイート取得テスト AlL Get」の実行に成功しました。", name: "dev.logging" );
                  developer.log( "[END]「ツイート取得テスト All Get」を終了します。", name: "dev.logging" );
                  Flushbar(
                      title : "ツイート取得 All Get" ,
                      message : "ツイートを取得しました。" ,
                      backgroundColor: Colors.blueAccent,
                      margin: EdgeInsets.all(8),
                      borderRadius: BorderRadius.circular(8),
                      duration:  Duration(seconds: 4),
                      icon: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      )
                  )..show(context);
                },
              ),
            ),
            SizedBox(height: 4),
            Container(
              alignment: Alignment.centerLeft,
              child: SelectableText( 'ツイート取得テスト結果：\n${tweetlistAllGet}' ),
            ),
            SizedBox(height: 4),

            SizedBox(height: 8),
            Divider(color: Colors.black38, height: 12, indent: 4, endIndent: 4),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
