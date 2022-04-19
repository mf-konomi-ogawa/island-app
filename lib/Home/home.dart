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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBarを表示し、タイトルも設定
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

      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
            child: Text('ログインユーザー：${widget.user.email}'),
          ),
          SizedBox(height: 4),
          // テスト用のボタン
          ElevatedButton(
            child: const Text('helloWorld'),
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              onPrimary: Colors.white,
            ),
            onPressed: () async {
              final functions = FirebaseFunctions.instance;
              final callable = functions.httpsCallable('helloWorld');
              final results = await callable();
              // test
              print('sucess');
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Image.asset('images/logo_island_transparent_small.png'),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
