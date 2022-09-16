import 'package:apikicker/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:apikicker/Common/color_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TweetForm extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tweetContent = <String, String?> {
      "uid": ref.watch(userProvider)?.uid,
      "value": "",
    }; // ツイート投稿用
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
                  child: _cardItem(context, tweetContent),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //カードアイテム
  Widget _cardItem( BuildContext context, Map tweetContent ) {
    return GestureDetector(
      child: Card(
        margin: const EdgeInsets.all(10),
        color: bgColor2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20) /*角の丸み*/
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 15, 2),

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
                        borderRadius: BorderRadius.circular(5),
                        gradient: gColor,

                      ),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('pocTweetAdd');
                          final results = await callable( tweetContent );
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
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
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
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(5, 0, 0, 10),
                    child: const Text(
                      'testname',
                      style: TextStyle(
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
                  tweetContent['value'] = value;
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}