import 'package:another_flushbar/flushbar.dart';
import 'package:apikicker/Home/tweet_details.dart';
import 'package:apikicker/Home/tweet_form.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:apikicker/Common/color_settings.dart';
import 'package:like_button/like_button.dart';
import 'dart:developer' as developer;

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {

  String debugTimelineData = "";
  List<dynamic> tweetContentslist = [];

    @override
  void initState() {
    super.initState();
    _load();
  }

  void _showTopFlushbar() {
      Flushbar(
        title : "ツイート投稿" ,
        message : "ツイートを投稿しました。" ,
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Colors.blueAccent,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        duration:  const Duration(seconds: 3),
        isDismissible: true,
        icon: const Icon(
          Icons.info_outline,
          color: Colors.white,
        )
      ).show(context);
  }

  Future<void> _load() async{
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('pocTweetTestAllGet');
    final results = await callable();
    setState(() {
      debugTimelineData = results.data.toString();
      developer.log( "変数 timelineData = $debugTimelineData", name: "dev.logging" );

      tweetContentslist = results.data;
      developer.log( "変数 list.length = ${tweetContentslist.length}", name: "dev.logging" );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: RefreshIndicator(
        onRefresh: () async{
          await _load();
        },
        child : ListView.builder(
          itemCount: tweetContentslist.length,
          itemBuilder: ( BuildContext context , int index ){
            return Card(
              color: bgColor,
              child: _tweetItem(
                "UserName",
                'images/mori.png',
                tweetContentslist[index]['contents'],
              )
            );
          },
        ),
      ),
       // 投稿ボタン
      floatingActionButton : FloatingActionButton(
        child: Container(
          decoration: gradationBox,
          child: const Icon(Icons.edit),
          padding: const EdgeInsets.all(17.0),
        ),
        onPressed: () async {
          final results = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return const TweetForm();
            }),
          );
          if (results != null) {
            _load();
            _showTopFlushbar();
          }
        },
      ),
    );
  }

  
  // ツイートのデザイン
  Widget _tweetItem(String title, String image, String text) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: ((context) => TweetDetails(
            title,
            text,
            'images/mori.png',
            ))
          )
        );
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 15, 2),
        decoration: const BoxDecoration(
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

                  //画像を丸型にする
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(image,
                        scale: 15, width: 40, height: 40, fit: BoxFit.cover),
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
                                child: Text(
                                  title,
                                  // style: GoogleFonts.alice(
                                  style: const TextStyle(
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

                              //クリップ(ブックマーク的立ち位置)
                              LikeButton(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                mainAxisAlignment: MainAxisAlignment.start,
                                //アニメーションで変化するときの色
                                circleColor: const CircleColor(
                                    start: accentColor, end: Colors.redAccent),
                                likeBuilder: (bool isLiked) {
                                  //表示するアイコン
                                  return Icon(
                                    Icons.attach_file,
                                    size: 18,
                                    color: isLiked ? accentColor : Colors.grey,
                                  );
                                },
                              ),
                            ]),

                        //テキスト(投稿本文)
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
                          child: Text(
                            text,
                            style: const TextStyle(
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
                                    start: Colors.tealAccent, end: accentColor),
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
                                    start: accentColor, end: Colors.blueAccent),
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
                      ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}