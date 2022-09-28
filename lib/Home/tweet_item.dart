import 'package:apikicker/Common/color_settings.dart';
import 'package:apikicker/Home/tweet_details.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:like_button/like_button.dart';

class TweetItem extends StatefulWidget {
  TweetItem(this.id, this.title, this.image, this.text, {Key? key}) : super(key: key);

    String id;
    String title;
    String image;
    String text;

  @override
  State<TweetItem> createState() => _TweetItemState();
}

class _TweetItemState extends State<TweetItem> {
  String? dropdownValue = "ツイートを削除";
  List<String> dropdownItems = [ "ツイートを削除" ];
  List<dynamic> receivedEmotions = [];
  bool currentUserHasLike = false;

  String debug = "";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async{
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('pocEmotionGet');
    final results = await callable({"id": widget.id});
    setState(() {
      debug = results.data.toString();
      print(debug);
      receivedEmotions = results.data;
      // 
      for (var emotion in receivedEmotions) {
        if(emotion.personId == "1") {
          currentUserHasLike = true;
        }
      }
    });
  }

  void _controlDialog(documentId, dropdownValue) {
    if(dropdownValue == "ツイートを削除") {
      _showAlertDialog(documentId);
    }
  }
  
  void _showAlertDialog(documentId) async {
    BuildContext innerContext;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        innerContext = context;
        return AlertDialog(
          backgroundColor: bgColor,
          title: const Text('ツイートを削除しますか？'),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0
          ),
          titlePadding: const EdgeInsets.all(10),
          actions: [
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                    ),
                    child: const Text('OK'),
                    onPressed: () {
                      _deletePersonalActivity(documentId);
                      Navigator.pop(innerContext);
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor2,
                    ),
                    child: const Text('キャンセル'),
                    onPressed: () {
                      Navigator.pop(innerContext);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
    // setState(() => _setResultString(result));
  }

  void _deletePersonalActivity(personalActivityId) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('pocDeletePersonalActivity');
    final results = await callable(personalActivityId);
    print("results:" + results.toString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: ((context) => TweetDetails(
            widget.id,
            widget.title,
            widget.text,
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
                    child: Image.asset(widget.image,
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
                                  widget.title,
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
                              
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: DropdownButton<String>(
                                  // value: dropdownValue,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                  },
                                  dropdownColor: bgColor,
                                  style: const TextStyle(
                                    color: Colors.white
                                  ),
                                  items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                      onTap: () {
                                        _controlDialog(widget.id, dropdownValue); 
                                      }
                                    );
                                  }).toList(),
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    size: 18,
                                    color: Colors.grey
                                  ),
                                  underline: Container(
                                    height: 0,
                                  ),
                                )
                              ),
                            ]),

                        //テキスト(投稿本文)
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
                          child: Text(
                            widget.text,
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
                                likeCount: receivedEmotions.length,
                                //アニメーションで変化するときの色
                                circleColor: const CircleColor(
                                    start: Colors.tealAccent, end: accentColor),
                                likeBuilder: (bool isLiked) {
                                  isLiked = currentUserHasLike;
                                  //表示するアイコン
                                  return Icon(
                                    Icons.favorite,
                                    size: 25,
                                    color: isLiked ? accentColor : Colors.grey,
                                  );
                                },
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