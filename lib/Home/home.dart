import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apikicker/Auth/login.dart';

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// リスト一覧画面用Widget
class MainHome extends StatefulWidget {
  // 引数からユーザー情報を受け取れるようにする
  MainHome(this.user);

  //ユーザー情報
  final User user;

  @override
  MainHomeState createState() => MainHomeState();
}

class MainHomeState extends State<MainHome> {
  String tweetlist = ""; // ツイート一覧取得用
  String tweetcontents = ""; // ツイート投稿用
  String deletePersonalActivityId = ""; // ツイート削除用
  String getUsersAllLimit = ""; // ユーザー取得テスト

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('island API Kicker'),
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

      body: Align(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              child: Text('ログインユーザー：${widget.user.email}'),
            ),
            SizedBox(height: 4),
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
            // API テスト - usaTweetAdd
            Container(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                child: const Text('usaTweetAdd'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                ),
                onPressed: () async {
                  print('[START]「ツイート投稿」を開始します。');
                  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('usaTweetAdd');
                  final results = await callable( tweetcontents );
                  // test
                  print('「ツイート投稿」に成功しました。');
                  print( results.data.toString() );
                  print( tweetcontents );
                  print('[END]「ツイート投稿」を終了します。');
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
            // API テスト - deletePersonalActivity
            Container(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                child: const Text('deletePersonalActivity'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                ),
                onPressed: () async {
                  print('[START]「ツイート削除」を開始します。');
                  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('deletePersonalActivity');
                  final results = await callable(deletePersonalActivityId);
                  // test
                  print('「ツイート削除」に成功しました。');
                  print( results.data.toString() );
                  print( deletePersonalActivityId );
                  print('[END]「ツイート削除」を開始します。');
                },
              ),
            ),
            SizedBox(height: 32),

            SizedBox(height: 8),
            Divider(color: Colors.black38, height: 12, indent: 4, endIndent: 4),
            SizedBox(height: 8),

            // API テスト - usaTweetTest
            Container(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                child: const Text('ツイート取得テスト'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                ),
                onPressed: () async {
                  print('[START]「ツイート取得テスト」を開始します。');
                  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('usaTweetTest');
                  final results = await callable();
                  print('「ツイート取得テスト」の実行に成功しました。');
                  print( results.data.toString() );
                  setState(() {
                    tweetlist = results.data.toString();
                  });
                  print('[END]「ツイート取得テスト」を終了します。');
                },
              ),
            ),
            SizedBox(height: 4),
            Container(
              alignment: Alignment.centerLeft,
              child: Text( 'ツイート取得テスト結果：\n${tweetlist}' ),
            ),
            SizedBox(height: 4),

            SizedBox(height: 8),
            Divider(color: Colors.black38, height: 12, indent: 4, endIndent: 4),
            SizedBox(height: 8),

            // API テスト - getUsersAllLimit
            Container(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                child: const Text('getUsersAllLimit'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                ),
                onPressed: () async {
                  print('[START]「getUsersAllLimit」を開始します。');
                  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getUsersAllLimit');
                  final results = await callable();
                  print('「getUsersAllLimit」の実行に成功しました。');
                  print( results.data.toString() );
                  setState(() {
                    getUsersAllLimit = results.data.toString();
                  });
                  print('[END]「getUsersAllLimit」を終了します。');
                },
              ),
            ),
            SizedBox(height: 4),
            Container(
              alignment: Alignment.centerLeft,
              child : Text( 'getUsersAllLimit結果：\n${getUsersAllLimit}' ),
            ),
            SizedBox(height: 4),

            SizedBox(height: 8),
            Divider(color: Colors.black38, height: 12, indent: 4, endIndent: 4),
            SizedBox(height: 8),

            SizedBox(height: 128),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Image.asset('images/logo_island_not-transparent.png'),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
