import 'package:apikicker/Common/color_settings.dart';
import 'package:apikicker/Home/tweet_details.dart';
import 'package:apikicker/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:apikicker/Common/timeago.dart';
import 'package:apikicker/Repository/delete_personal_activity.dart';
import 'package:apikicker/Common/flushbar.dart';
import 'package:apikicker/Home/timeline_profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TweetItem extends ConsumerStatefulWidget {
  TweetItem(this.id, this.personId, this.image, this.text, this.timeago,
      this.username,this.photoUri,
      {Key? key})
      : super(key: key);

  String id;
  String personId;
  String image;
  String text;
  Timestamp timeago;
  String username;
  String photoUri;

  @override
  _TweetItemState createState() => _TweetItemState();
}

class _TweetItemState extends ConsumerState<TweetItem> {
  String? dropdownValue = "ツイートを削除";
  List<String> dropdownItems = ["削除"];
  List<dynamic> receivedEmotions = [];
  int emotionCount = 0;
  bool currentUserLikes = false;
  String timeago = "";
  String userPhotoUri = "";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('pocEmotionGet');
    final results = await callable({"id": widget.id});
    setState(() {
      receivedEmotions = results.data;
      emotionCount = receivedEmotions.length;
    });
    for (var emotion in receivedEmotions) {
      if (emotion['personId'] == ref.watch(userProvider)?.uid) {
        currentUserLikes = true;
      }
    }
  }

  void _controlDialog(documentId, dropdownValue) {
    if (dropdownValue == "ツイートを削除") {
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
          title: const Text('削除しますか？'),
          titleTextStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
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
                      deletePersonalActivity(documentId);
                      Navigator.pop(innerContext);
                      showTopFlushbarFromActivity(
                          "アクティビティ削除", "アクティビティを削除しました。", context);
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => TweetDetails(widget.id, widget.username,
                    widget.image, widget.text, widget.timeago,widget.photoUri ))));
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),

        // アクティビティごとのボーダー
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: lineColor))),

        /**
        *（アイコン）（ユーザー名・投稿）を横に並べる
        * **/
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          /*上揃えにする*/
          children: <Widget>[
            // 投稿左側の設定
            GestureDetector(
              // 画像タップでユーザプロフィールを表示する
              onTap: () {
                showModalBottomSheet<void>(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                        height: 540,
                        color: bgColor2,
                        child: TimelineProfileScreen(
                          widget.personId, widget.username,widget.photoUri
                    )
                    );
                  },
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                /*上揃えにする*/
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(4.0),
                    width: 36,
                    height: 36,
                    //画像を丸型にする
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      // child: Image.asset(widget.image,
                      //     scale: 15, width: 40, height: 40, fit: BoxFit.cover),
                      child: CachedNetworkImage(
                        imageUrl: widget.photoUri,
                          fit: BoxFit.fill
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //投稿右側の設定
            Expanded(
              child: Column(
                children: <Widget>[
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                      /*左揃えにする*/
                      children: <Widget>[
                        //一番上の行
                        Row(crossAxisAlignment: CrossAxisAlignment.start,
                            /*左揃えにする*/
                            children: <Widget>[
                              //ユーザー名
                              Expanded(
                                flex: 4,
                                child:Container(
                                  padding: const EdgeInsets.fromLTRB(4, 4, 0, 2),
                                  child: Text(
                                    widget.username,
                                    maxLines:1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),

                              //投稿時間表示(今から数えた時間が表示される)
                              Expanded(
                                flex: 2,
                                child:Container(
                                  padding: const EdgeInsets.fromLTRB(4, 4, 0, 2),
                                  child: Text(
                                    createTimeAgoString(widget.timeago.toDate()),
                                    style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ),

                              // メニュー
                              Expanded(
                                  flex: 1,
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    // value: dropdownValue,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue;
                                      });
                                    },
                                    dropdownColor: bgColor,
                                    style: const TextStyle(color: Colors.white),
                                    items: dropdownItems
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                          onTap: () {
                                            _controlDialog(
                                                widget.id, dropdownValue);
                                          });
                                    }).toList(),
                                    icon: const Icon(Icons.more_horiz,
                                        size: 14, color: Colors.grey),
                                    underline: Container(
                                      height: 0,
                                    ),
                                  )
                              ),
                            ]
                        ),

                        //テキスト(投稿本文)
                        Container(
                          padding: const EdgeInsets.fromLTRB(4, 2, 10, 8),
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
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                                mainAxisAlignment: MainAxisAlignment.start,
                                likeCount: emotionCount,
                                //アニメーションで変化するときの色
                                circleColor: const CircleColor(
                                    start: Colors.tealAccent, end: accentColor),
                                isLiked: currentUserLikes,
                                likeBuilder: (bool isLiked) {
                                  //表示するアイコン
                                  return Icon(
                                    Icons.favorite,
                                    size: 18,
                                    color: isLiked ? accentColor : Colors.grey,
                                  );
                                },
                                onTap: (bool isLiked) async {
                                  setState(() {
                                    currentUserLikes = !isLiked;
                                  });
                                  var data = {
                                    "emotionId": "001",
                                    "tweetId": widget.id,
                                    "uid": ref.read(userProvider)?.uid
                                  };
                                  if (currentUserLikes) {
                                    setState(() {
                                      emotionCount += 1;
                                    });
                                    HttpsCallable callable = FirebaseFunctions
                                        .instance
                                        .httpsCallable('pocEmotionAdd');
                                    await callable(data);
                                  } else {
                                    setState(() {
                                      emotionCount -= 1;
                                    });
                                    HttpsCallable callable = FirebaseFunctions
                                        .instance
                                        .httpsCallable('pocEmotionDelete');
                                    await callable(data);
                                  }
                                  return;
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
