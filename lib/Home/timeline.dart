import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apikicker/Auth/login.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:developer' as developer;
import 'package:like_button/like_button.dart';
import 'dart:collection';

const Color footerColor = Color(0xFF292929); /*フッターの色(一番濃い灰色)*/
const Color backColor = Color(0xFF303237); /*暗い背景色*/
const Color back2Color = Color(0xFF36393F); /*背景より気持ち明るい灰*/
const Color lineColor = Color(0xFF45484E); /*投稿を区切る線の色(背景より明るい灰)*/
const Color textColor = Color(0xFFDCDDDE); /*テキストの色(白)*/
const Color accentColor = Color(0xFF62CDFF); /*アクセントカラー(差し色)*/
const LinearGradient gColor = LinearGradient(
  colors: [
    Color(0xff5319bf),
    Color(0xff19cdff),
    Color(0xffff40b3),
    Color(0xffffe3bc),
  ],
); /*アクセントカラー(差し色)*/

class TimeLineHeader extends StatelessWidget {
  const TimeLineHeader({Key? key}) : super(key: key);

  get color => null;

  @override
  //ホームでの共通部分の作成(ヘッダータブ)
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        /*タブの数*/
        child: Scaffold(
          backgroundColor: backColor,
          appBar: AppBar(
            backgroundColor: backColor,
            elevation: 0,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              /*これがないとヘッダータブが上に行ってしまう*/
              children: const <Widget>[
                TabBar(
                    labelColor: accentColor,
                    /*選択されていないときの色*/
                    unselectedLabelColor: Colors.white38,
                    /*選択された時の色*/
                    indicatorColor: accentColor,
                    // indicatorColor: accentColor,
                    /*下のボーダー*/
                    tabs: <Widget>[
                      Tab(text: 'タイムライン'),
                      Tab(text: 'イベント'),
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimelineListScreen extends StatefulWidget {
  TimelineListScreen(this.user); // 引数からユーザー情報を受け取れるようにする
  final User user; // ユーザー情報

  @override
  TimelineListScreenState createState() => TimelineListScreenState();
}

class TimelineListScreenState extends State<TimelineListScreen> {
  String timelineData = "";
  LinkedHashMap tweets = LinkedHashMap();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async{
    developer.log( "[START]「ツイート取得テスト」を開始します。", name: "dev.logging" );
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('usaTweetTest');
    final results = await callable();
    setState(() {
      timelineData = results.data.toString();
      tweets[0] = {
         results.data['usa'],
      };
    });
    developer.log( "変数 timelineData = ${timelineData}", name: "dev.logging" );
    developer.log( "変数 tweets = ${tweets[0]}", name: "dev.logging" );
    developer.log( "「ツイート取得テスト」の実行に成功しました。", name: "dev.logging" );
    developer.log( "[END]「ツイート取得テスト」を終了します。", name: "dev.logging" );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,

      // body: Stack(
      //   alignment: Alignment.bottomRight,
      //   children: <Widget>[
      //     _timeLineList(context),
      //   ]
      // ),

      body: Align(
        alignment: Alignment.topCenter,
        child: Stack(
          children: <Widget>[
            _timeLineList(context),
          ]
        )
      ),

      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.white,
        backgroundColor: footerColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '検索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '通知',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'プロフィール',
          ),
        ],
        selectedItemColor: accentColor,
      ),
    );
  }

  ListView _timeLineList(BuildContext context) {
    return ListView(
      children: <Widget>[
        GestureDetector(
          child: _menuItem(
            "UserName",
            'images/mori.png',
            timelineData,
          )
        ),
      ],
    );
  }

  //投稿の設定(調整部分)
  Widget _menuItem(String title, String image, String text) {
    return GestureDetector(
      child: Container(
        // alignment: Alignment.topLeft,
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
    );
  }
}

