import 'package:apikicker/Common/color_settings.dart';
import 'package:apikicker/Home/reply_form.dart';
import 'package:apikicker/Home/reply_list.dart';
import 'package:apikicker/Home/tweet_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:apikicker/Common/timeago.dart';
import 'package:apikicker/Repository/delete_personal_activity.dart';

class TweetDetails extends ConsumerStatefulWidget {
  TweetDetails(this.id, this.title, this.image, this.text, this.timeago, {Key? key}) : super(key: key);

  String id;
  String title;
  String image;
  String text;
  Timestamp timeago;

  @override
  _TweetDetailsState createState() => _TweetDetailsState();
}

class _TweetDetailsState extends ConsumerState<TweetDetails> {
  String id = "";
  String title = "";
  String image = '';
  String text = "";
  String timeago = "";

  String? dropdownValue = "ツイートを削除";
  List<String> dropdownItems = [ "ツイートを削除" ];

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
                      deletePersonalActivity(documentId);
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

  @override
  //タイムラインのコンテンツ部分
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      //確認用の投稿を何パターンか作成する
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text(
          '戻る',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          _detail(
              widget.id,
              widget.title,
              Image.asset(widget.image,
                  scale: 30, width: 50, height: 50, fit: BoxFit.cover),
              widget.text,
              widget.timeago
          ),
          Flexible(
            child: ReplyList(
              widget.id,
            ),
          )
        ],
      ),
      bottomNavigationBar: GestureDetector(
        child: Container(
          height: 30,
          color: bgColor,
          child: const Text('コメントを書く', style: TextStyle(color: textColor2))
        ),
        onTap: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 500,
                color: bgColor2,
                child: ReplyForm(id)
              );
            },
          );
        },
      )
    );
  }

  //投稿の詳細
  Widget _detail(String? id, String title, Image image, String text , Timestamp timeago) {
    return GestureDetector(
      //コンテナの中に配置していく
      child: Container(
        padding: const EdgeInsets.fromLTRB(2, 10, 2, 2),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: lineColor))),

        //（アイコン）（ユーザー名・投稿）を縦に並べる
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            /*上揃えにする*/
            children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  /*左揃えにする*/
                  children: <Widget>[
                    // ユーザーアイコン
                    Container(
                      margin: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                      //画像を丸型にする。サイズ感は画像読み込むところで行う
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: image),
                    ),

                    //ユーザー名
                    Container(
                      padding: const EdgeInsets.fromLTRB(4, 0, 0, 2),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 21.0,
                        ),
                      ),
                    ),

                    // 投稿時間表示(今から数えた時間が表示される)
                    Container(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 2),
                      child: Text(
                        createTimeAgoString(timeago.toDate()),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                    ),

                    const Spacer(),
                    /*クリップアイコンを右端に寄せるための記述*/

                    // メニューボタン
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
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                child: Text(
                  text,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 18.0,
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
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                      mainAxisAlignment: MainAxisAlignment.start,
                      likeCount: 16,
                      /*リアクションを押された数*/
                      //カウント数字の色を変える
                      countBuilder: (int? count, bool isLiked, String text) {
                        final Color color = isLiked ? accentColor : Colors.grey;
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
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                      mainAxisAlignment: MainAxisAlignment.start,
                      likeCount: 2,
                      countBuilder: (int? count, bool isLiked, String text) {
                        final Color color = isLiked ? accentColor : Colors.grey;
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
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                      mainAxisAlignment: MainAxisAlignment.start,
                      likeCount: 20,
                      countBuilder: (int? count, bool isLiked, String text) {
                        final Color color = isLiked ? accentColor : Colors.grey;
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
                          start: Color(0xFFC107FF), end: Color(0xFFC107FF)),
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
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                      mainAxisAlignment: MainAxisAlignment.start,
                      likeCount: 39,
                      countBuilder: (int? count, bool isLiked, String text) {
                        final Color color = isLiked ? accentColor : Colors.grey;
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
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                      mainAxisAlignment: MainAxisAlignment.start,
                      likeCount: 8,
                      countBuilder: (int? count, bool isLiked, String text) {
                        final Color color = isLiked ? accentColor : Colors.grey;
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
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
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
      ),
    );
  }
}