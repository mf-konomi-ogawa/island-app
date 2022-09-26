

import 'package:apikicker/Common/color_settings.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class ReplyList extends StatefulWidget {
  const ReplyList(this.id, {Key? key}) : super(key: key);

  final String id;

  @override
  State<ReplyList> createState() => _ReplyListState();

}

class _ReplyListState extends State<ReplyList> {

  String debugReplyListData = "";
  List<dynamic> replyList = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async{
    var requestParams = <String, String?> {
      "id": widget.id,
    }; // ツ
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('pocReplyGet');
    final results = await callable(requestParams);
    setState(() {
      debugReplyListData = results.data.toString();
      print(debugReplyListData);

      replyList = results.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        GestureDetector(
      //コンテナの中に配置していく
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 15, 2),
            // alignment: Alignment.topLeft,
            decoration: const BoxDecoration(
                color: bgColor2,
                border: Border(bottom: BorderSide(width: 1, color: lineColor))),

            //（アイコン）（ユーザー名・投稿）を横に並べる
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              /*上揃えにする*/
              children: <Widget>[
                //投稿左側の設定
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  /*上揃えにする*/
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(4.0),
                      // 画像を丸型にする。サイズ感は画像読み込むところで行う
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset("images/icon_image/20220202.jpg",
                        scale: 30, width: 50, height: 50, fit: BoxFit.cover),
                        // child:
                      ),
                    ),
                  ],
                ),
                //投稿右側の設定
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                          /*左揃えにする*/
                          children: <Widget>[
                            //一番上の行
                            Row(crossAxisAlignment: CrossAxisAlignment.center,
                                /*左揃えにする*/
                                children: <Widget>[
                                  //ユーザー名
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 2),
                                    child: const Text(
                                      "テストユーザー",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),

                                  //投稿時間表示(今から数えた時間が表示される)
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 2),
                                    child: const Text(
                                      '５分前',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),

                                  const Spacer(),
                                  /*クリップアイコンを右端に寄せるための記述*/

                                  
                                  LikeButton(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //アニメーションで変化するときの色
                                    circleColor: const CircleColor(
                                        start: Colors.pink, end: Colors.redAccent),
                                    likeBuilder: (bool isLiked) {
                                      //表示するアイコン
                                      return Icon(
                                        Icons.more_horiz,
                                        size: 18,
                                        color: isLiked ? accentColor : Colors.grey,
                                      );
                                    },
                                  ),
                                ]),

                            //テキスト(投稿本文)
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
                              child: const Text(
                                "テストリプライ",
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),

                            //リアクションボタン
                            //like_button.dartを使用しています
                            //リアクションボタンはもう少し小さくてもいい気がします
                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                                /*左揃えにする*/
                                children: <Widget>[
                                  //ハート
                                  LikeButton(
                                    padding:
                                    const EdgeInsets.fromLTRB(10, 0, 0, 10),
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    likeCount: 16,
                                    /*リアクションを押された数*/
                                    //カウント数字の色を変える
                                    countBuilder:
                                        (int? count, bool isLiked, String text) {
                                      final Color color =
                                      isLiked ? accentColor : Colors.grey;
                                      Widget result;
                                      if (count == 0) {
                                        result = Text(
                                          'heart',
                                          style: TextStyle(color: color),
                                        );
                                      } else {
                                        result = Text(
                                          text,
                                          style: TextStyle(color: color),
                                        );
                                      }
                                      return result;
                                    },
                                    //アニメーションで変化するときの色
                                    circleColor: const CircleColor(
                                        start: Colors.pink, end: Colors.redAccent),
                                    likeBuilder: (bool isLiked) {
                                      //表示するアイコン
                                      return Icon(
                                        Icons.favorite,
                                        size: 25,
                                        color: isLiked ? accentColor : Colors.grey,
                                      );
                                    },
                                  ),

                                  //星
                                  LikeButton(
                                    padding:
                                    const EdgeInsets.fromLTRB(10, 0, 0, 10),
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    likeCount: 2,
                                    countBuilder:
                                        (int? count, bool isLiked, String text) {
                                      final Color color =
                                      isLiked ? accentColor : Colors.grey;
                                      Widget result;
                                      if (count == 0) {
                                        result = Text(
                                          'star',
                                          style: TextStyle(color: color),
                                        );
                                      } else {
                                        result = Text(
                                          text,
                                          style: TextStyle(color: color),
                                        );
                                      }
                                      return result;
                                    },
                                    circleColor: const CircleColor(
                                        start: Colors.white38, end: Colors.yellow),
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        Icons.star_rate,
                                        size: 25,
                                        color: isLiked ? accentColor : Colors.grey,
                                      );
                                    },
                                  ),

                                  //グッド
                                  LikeButton(
                                    padding:
                                    const EdgeInsets.fromLTRB(10, 0, 0, 10),
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    likeCount: 20,
                                    countBuilder:
                                        (int? count, bool isLiked, String text) {
                                      final Color color =
                                      isLiked ? accentColor : Colors.grey;
                                      Widget result;
                                      if (count == 0) {
                                        result = Text(
                                          'good',
                                          style: TextStyle(color: color),
                                        );
                                      } else {
                                        result = Text(
                                          text,
                                          style: TextStyle(color: color),
                                        );
                                      }
                                      return result;
                                    },
                                    circleColor: const CircleColor(
                                        start: Color(0xFFC107FF),
                                        end: Color(0xFFC107FF)),
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        Icons.thumb_up_alt,
                                        size: 25,
                                        color: isLiked ? accentColor : Colors.grey,
                                      );
                                    },
                                  ),

                                  //微笑むように笑う
                                  LikeButton(
                                    padding:
                                    const EdgeInsets.fromLTRB(10, 0, 0, 10),
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    likeCount: 39,
                                    countBuilder:
                                        (int? count, bool isLiked, String text) {
                                      final Color color =
                                      isLiked ? accentColor : Colors.grey;
                                      Widget result;
                                      if (count == 0) {
                                        result = Text(
                                          'smile',
                                          style: TextStyle(color: color),
                                        );
                                      } else {
                                        result = Text(
                                          text,
                                          style: TextStyle(color: color),
                                        );
                                      }
                                      return result;
                                    },
                                    circleColor: const CircleColor(
                                        start: Colors.lightBlueAccent,
                                        end: Colors.blueAccent),
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        Icons.sentiment_satisfied_alt,
                                        size: 25,
                                        color: isLiked ? accentColor : Colors.grey,
                                      );
                                    },
                                  ),

                                  //口をあけて笑う
                                  LikeButton(
                                    padding:
                                    const EdgeInsets.fromLTRB(10, 0, 0, 10),
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    likeCount: 8,
                                    countBuilder:
                                        (int? count, bool isLiked, String text) {
                                      final Color color =
                                      isLiked ? accentColor : Colors.grey;
                                      Widget result;
                                      if (count == 0) {
                                        result = Text(
                                          'laughter',
                                          style: TextStyle(color: color),
                                        );
                                      } else {
                                        result = Text(
                                          text,
                                          style: TextStyle(color: color),
                                        );
                                      }
                                      return result;
                                    },
                                    circleColor: const CircleColor(
                                        start: Colors.lightGreenAccent,
                                        end: Colors.lightGreen),
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        Icons.sentiment_very_satisfied,
                                        size: 25,
                                        color: isLiked ? accentColor : Colors.grey,
                                      );
                                    },
                                  ),
                                ]),
                            //コメント
                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                                /*左揃えにする*/
                                children: <Widget>[
                                  Container(
                                    padding:
                                    const EdgeInsets.fromLTRB(15, 0, 0, 10),
                                    child: const Icon(
                                      Icons.speaker_notes,
                                      size: 25,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 10),
                                    child: const Text(
                                      'コメント',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 10),
                                    child: const Text(
                                      '11件',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ]),

                            // Container(
                            //   padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                            //   child:
                            //       const Icon(Icons.favorite, color: accentColor), /*リアクションボタン。改良予定*/
                            // ),
                          ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}