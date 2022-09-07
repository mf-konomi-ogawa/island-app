import 'package:apikicker/Common/color_settings.dart';
import 'package:apikicker/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      // Appbar
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text(
          '通知',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Stack(alignment: Alignment.bottomRight, children: <Widget>[
        ListView(
          // Column(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              color: bgColor2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20) /*角の丸み*/
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ExpansionTile(
                    title: _titleAreaItem("近日開催予定のイベント"),
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: accentColor,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => EventDetails(
                      //               "データマネジメント分科会",
                      //               "Dmbokをグループ毎に読み解いて"
                      //                   "シェアすることで不足している知識を吸収します",
                      //               'assets/images/icon_image/20220321.jpg',
                      //               "3/24",
                      //               "メタデータとは？",
                      //               "3/24(木)　18：00~　",
                      //               "gatherで開催",
                      //               "自由参加",
                      //               "ファイルが増えれば増えるほど、その管理は煩雑になります。"
                      //                   "\nそんな問題を解決するのが「メタデータ」です。"
                      //                   "個人のパソコンだけではなく公共のデータベースなど、"
                      //                   "メタデータが活用されているシーンは少なくありません。"
                      //                   "\n近年はデータサイエンスの分野でもメタデータの活用が目立っています。"
                      //                   "\n\nそのメタデータについて、メタデータとは何か、どう管理するのか、どう扱うのかを整理していきます。",
                      //               "メタデータは\n組織でしっかり管理すべきもの",
                      //               "メタデータを管理することで、データの品質が向上し"
                      //                   "データの性質を様々な角度から分析できる等になったり、セキュリティが強化されるなどたくさんのメリットがあります。",
                      //               "【次回】ビジネスシーンにおける「問題提起」とは何か",
                      //               "4/25(月)　19：00~　",
                      //               "Teamsで開催",
                      //               "特になし",
                      //               "「問題提起」という言葉を聞いたことはあるでしょうか。"
                      //                   "ビジネスの場では、しばしば使われることがあります。\n\n今回はこの「問題提起」について解説していきます。",
                      //             )));
                      //   },
                      //   child: _eventItem(
                      //       "ソリューション事業部会",
                      //       Image.asset('assets/images/icon_image/20220321.jpg',
                      //           width: 50,
                      //           height: 50,
                      //           scale: 80,
                      //           fit: BoxFit.cover),
                      //       "3/24"),
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => EventDetails(
                      //               "ガリ勉部",
                      //               "ビジネス書を読んで人前でレコメンドすることで自分の理解を促進するだけでなく、"
                      //                   "みんなでシェアして全員で賢くなれるコンテンツです",
                      //               'assets/images/a.png',
                      //               "4/2",
                      //               "仕事の悩みが「軽くなる読書」",
                      //               "4/2(土)　10：00~　",
                      //               "高田馬場",
                      //               "上司に報告",
                      //               "困難のない挑戦はない。頭では分かっていても、変化や未知のものを避ける"
                      //                   "「現状維持バイアス」が働くのが、人間の本能でもある。このバイアスに、"
                      //                   "読書を通じて対処できるようになったと語るのが、メンズスキンケアの市場を拡大させたブランド"
                      //                   "「BULK HOMME（以下、バルクオム）」の創業者・野口卓也（のぐち たくや）さんだ。"
                      //                   "\n\nそんな野口さんに、若手ビジネスパーソンのお守りとなるような"
                      //                   "「苦境に陥った時に救ってくれる5冊」を、印象的なシーンとともに聞いてきた",
                      //               "本を読めば視野が広がる",
                      //               "本を読むことで得た知識や情報を糧に、自分自身を成長させていくことができます",
                      //               "【次回】アフターコロナビジネスのマーケティング戦略とは",
                      //               "5/7(土)　10：00~　",
                      //               "Teams",
                      //               "特になし",
                      //               "新型コロナウイルス禍で街の人流は大きく変わりました。"
                      //                   "\n\n人の行動範囲がどう変化したのか？消費行動の最新の傾向は？"
                      //                   "こうしたトレンドを正確につかむことが、アフターコロナのビジネスには欠かせません。",
                      //             )));
                      //   },
                      //   child: SingleChildScrollView(
                      //     child: _eventItem(
                      //         "ガリ勉部",
                      //         Image.asset('assets/images/a.png',
                      //             width: 50,
                      //             height: 50,
                      //             scale: 80,
                      //             fit: BoxFit.cover),
                      //         "4/2"),
                      //   ),
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) =>
                      //             const Home()));
                      //   },
                      //   child: _plusEventItem(),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            // _eventItem(),
            _replyItem(
                "UserName0",
                Image.asset('assets/images/mori.png', scale: 30),
                "この文章は一つ目です。長さを確認したいので別々に分けています"),
            _reactionItem('この文章がリアクションされたものです。どうやって紐づけるか悩みますね'),
            _reactionItem('リアクションが複数あるので、通知欄にどう表示するか悩み中です'),
            _replyItem(
                "UserName0",
                Image.asset('assets/images/mori.png', scale: 30),
                "この文章は一つ目です。長さを確認したいので別々に分けています"),
            _reactionItem('リアクションが複数あるので、通知欄にどう表示するか悩み中です'),
            _replyItem(
                "UserName0",
                Image.asset('assets/images/mori.png', scale: 30),
                "この文章は一つ目です。長さを確認したいので別々に分けています"),
            _replyItem(
                "UserName0",
                Image.asset('assets/images/mori.png', scale: 30),
                "この文章は一つ目です。長さを確認したいので別々に分けています"),
          ],
        ),
      ]),
    );
  }

  //通知の中身
  Widget _eventItem(String title, Image image, String day) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Row(crossAxisAlignment: CrossAxisAlignment.center,
              /*左揃えにする*/
              children: <Widget>[
                //画像処理
                Container(
                  margin: const EdgeInsets.fromLTRB(30, 10, 10, 10),
                  padding: const EdgeInsets.only(left: 10),
                  //画像を丸型にする。サイズ感は画像読み込むところで行う
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12), child: image),
                ),

                //右側
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    /*左揃えにする*/
                    children: <Widget>[
                      //開催日
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Text(
                          day + "開催",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ),

                      //イベント名
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),
              ]),
        ],
      ),
    );
  }

  //タイトルヘッダー
  Widget _titleAreaItem(String title) {
    return GestureDetector(
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          /*中央揃えにする*/
          children: <Widget>[
            //見出し
            Container(
              // color: back2Color,
              padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
              child: Text(
                title,
                style: const TextStyle(
                  color: accentColor,
                  fontSize: 18.0,
                ),
              ),
            ),
            // const Spacer(),

            const Spacer(),
            //閉じるボタン
            // Container(
            //   // color: back2Color,
            //   padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
            //   child: const Icon(
            //     Icons.close,
            //     color: Colors.grey,
            //     size: 18,
            //   ),
            // ),
            // ),
          ],
        ),
      ]),
    );
  }

  //さらに表示
  Widget _plusEventItem() {
    return GestureDetector(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        /*左揃えにする*/
        children: <Widget>[
          //見出し
          Container(
            // color: back2Color,
            padding: const EdgeInsets.only(bottom: 15),
            child: const Text(
              "さらに表示",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ),
          // const Spacer(),
        ],
      ),
    );
  }

  //リプライ
  Widget _replyItem(String title, Image image, String text) {
    return GestureDetector(
      //コンテナの中に配置していく
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

                  //画像を丸型にする。サイズ感は画像読み込むところで行う
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100), child: image),
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
                                    start: Colors.pink, end: Colors.redAccent),
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

                        //あなたへの返信
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                          child: const Text(
                            "  >あなたへの返信",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13.0,
                            ),
                          ),
                        ),

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
    );
  }

  //リアクション
  Widget _reactionItem(String text) {
    return GestureDetector(
      //コンテナの中に配置していく
      child: Container(
        // alignment: Alignment.topLeft,
        padding: const EdgeInsets.fromLTRB(10, 10, 15, 2),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: lineColor))),

        //横に並べる
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          /*上揃えにする*/
          children: <Widget>[
            Flexible(
              child: Column(children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  /*上揃えにする*/
                  children: <Widget>[
                    // アイコンを並べる
                    Row(crossAxisAlignment: CrossAxisAlignment.start,
                        /*左揃えにする*/
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                            child: _iconItem(
                              Image.asset('assets/images/maru2.png',
                                  width: 35, height: 35, fit: BoxFit.cover),
                              const Icon(
                                Icons.favorite,
                                color: accentColor,
                                size: 20,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: _iconItem(
                              Image.asset(
                                  'assets/images/icon_image/20211217.jpg',
                                  width: 35,
                                  height: 35,
                                  fit: BoxFit.cover),
                              const Icon(
                                Icons.thumb_up_alt,
                                color: accentColor,
                                size: 20,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: _iconItem(
                              Image.asset(
                                  'assets/images/icon_image/20211218.jpg',
                                  width: 35,
                                  height: 35,
                                  fit: BoxFit.cover),
                              const Icon(
                                Icons.sentiment_satisfied_alt,
                                color: accentColor,
                                size: 20,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: _iconItem(
                              Image.asset('assets/images/mori.png',
                                  width: 35, height: 35, fit: BoxFit.cover),
                              const Icon(
                                Icons.star_rate,
                                color: accentColor,
                                size: 20,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: _iconItem(
                              Image.asset(
                                  'assets/images/icon_image/20220208.jpg',
                                  width: 35,
                                  height: 35,
                                  fit: BoxFit.cover),
                              const Icon(
                                Icons.thumb_up_alt,
                                color: accentColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ]),
                  ],
                ),
                //リアクションした人たち
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                  child: const Text(
                    "User_Name1さん他4人があなたの投稿へリアクションしました",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                //テキスト(投稿本文)
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  //リアクションした人のアイコン
  //仮作成
  Widget _iconItem(Image image, Icon icon) {
    return GestureDetector(
      child: Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        /*左揃えにする*/
          children: <Widget>[
            //ユーザーアイコン
            Container(
              margin: const EdgeInsets.all(4.0),
              // 画像を丸型にする。サイズ感は画像読み込むところで行う
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: image,
                // child:
              ),
            ),
            //背景の黒丸
            Container(
              margin: const EdgeInsets.only(left: 20, top: 20),
              width: 30,
              height: 30,
              // アイコンを差し込む
              decoration: const BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              // child: ClipRRect(
              //   borderRadius: BorderRadius.circular(100),
              //   child: icon
              //   // child:
              // ),
            ),

            //リアクションアイコン
            Container(
              margin: const EdgeInsets.only(left: 25, top: 25),
              // アイコンを差し込む
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100), child: icon
                // child:
              ),
            ),
          ]),
    );
  }
}