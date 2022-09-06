import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:apikicker/Common/color_settings.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:apikicker/Home/home.dart';


class PostPage extends StatefulWidget {
  PostPage();

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String tweetcontents = ""; // ツイート投稿用

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  reverse: true,
                  child: _cardItem(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //カードアイテム
  Widget _cardItem( BuildContext context ) {
    return GestureDetector(
      child: Card(
        margin: const EdgeInsets.all(10),
        color: bgColor2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20) /*角の丸み*/
        ),
        child: Container(
          // alignment: Alignment.topLeft,
          padding: const EdgeInsets.fromLTRB(20, 10, 15, 2),
          // const BoxDecoration(
          //     // border: Border(bottom: BorderSide(width: 1, color: lineColor))
          //     ),

          //カード内のアイテム
          child: Column(children: [
            //キャンセルと投稿ボタン
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                /*左揃えにする*/
                children: <Widget>[
                  //キャンセルボタン
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'キャンセル',
                      style: TextStyle(
                        color: Colors.red, //文字の色を白にする
                        fontWeight: FontWeight.bold, //文字を太字する
                        fontSize: 12.0, //文字のサイズを調整する
                      ),
                    ),
                  ),

                  //投稿ボタン
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 38,
                      decoration:  BoxDecoration(
                        // shape: BoxShape.circle,
                        borderRadius: BorderRadius.circular(5),
                        gradient: gColor,

                      ),
                      // padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('pocTweetAdd');
                          final results = await callable('tweetcontents');
                          Navigator.of(context).pop(results);
                        },
                        label: const Text(
                          '投稿する',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold, /*太字*/
                          ),
                        ),
                        icon: const Icon(Icons.create, size: 20),
                        style: ElevatedButton.styleFrom(primary: Colors.transparent),
                        // style: ElevatedButton.styleFrom(
                        //   // primary: accentColor,
                        //   onPrimary: Colors.black,
                        //   shape: const StadiumBorder(),
                        //   padding: const EdgeInsets.fromLTRB(20, 10, 25, 10),
                        // ),
                      ),
                    ),
                    // ),
                  ),
                ]),

            //ユーザーアイコンと入力
            Row(crossAxisAlignment: CrossAxisAlignment.center,
                /*左揃えにする*/
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(5, 0, 20, 10),
                   //画像を丸型にする
                    // child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(100),
                    //     child: Image.asset(image,
                    //         scale: 20,
                    //         width: 40,
                    //         height: 40,
                    //         fit: BoxFit.cover)),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(5, 0, 0, 10),
                    child: Text(
                      'testname',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ]),

            //入力画面
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 30),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 140,
                decoration: const InputDecoration(
                  counterStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  hintText: "メッセージを書く",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                onChanged: (String value) {
                  setState(() {
                    tweetcontents = value;
                  });
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}