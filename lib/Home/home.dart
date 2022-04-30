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
  String tweetlist = "";
  String tweetcontents = "";
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
          // API テスト - usaTweetTest
          ElevatedButton(
            child: const Text('usaTweetTest'),
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              onPrimary: Colors.white,
            ),
            onPressed: () async {
              HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('usaTweetTest');
              final results = await callable();
              print('sucess');
              print( results.data.toString() );
              tweetlist = results.data.toString();
            },
          ),
          SizedBox(height: 4),
          Text( 'tweetlist' ),
          SizedBox(height: 16),
          // API テスト - usaTweetAdd - Tweet 内容入力フォーム
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
                labelText: "ツイート本文",
            ),
            onChanged: (String value) {
              setState(() {
                tweetcontents = value;
              });
            },
          ),
          SizedBox(height: 8),
          // API テスト - usaTweetAdd
          ElevatedButton(
            child: const Text('usaTweetAdd'),
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              onPrimary: Colors.white,
            ),
            onPressed: () async {
              HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('usaTweetAdd');
              final results = await callable( tweetcontents );
              // test
              print('sucess');
              print( results.data.toString() );
              print( tweetcontents );
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
