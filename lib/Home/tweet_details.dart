import 'package:apikicker/Common/color_settings.dart';
import 'package:apikicker/Home/reply_form.dart';
import 'package:apikicker/Home/reply_list.dart';
import 'package:apikicker/Home/tweet_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:apikicker/Common/timeago.dart';
import 'package:apikicker/Repository/delete_personal_activity.dart';
import 'package:apikicker/main.dart';
import 'dart:developer' as developer;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:apikicker/Provider/user_provider.dart';
import 'package:apikicker/Common/flushbar.dart';

class TweetDetails extends ConsumerStatefulWidget {
  TweetDetails(this.id, this.username, this.image, this.text, this.timeago,
      this.photoUri, this.assetsUrls,
      {Key? key})
      : super(key: key);

  String id;
  String username;
  String image;
  String text;
  Timestamp timeago;
  String photoUri;
  String assetsUrls;

  @override
  _TweetDetailsState createState() => _TweetDetailsState();
}

class _TweetDetailsState extends ConsumerState<TweetDetails> {
  String id = "";
  String username = "";
  String image = '';
  String text = "";
  String timeago = "";
  String photoUri = "";
  List<dynamic> replyList = [];

  final List<String> menuLists = ["削除"];
  String selectedValue = "削除";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final firestore = ref.read(firebaseFirestoreProvider);
    var replyQuerySnapShot = await firestore
        .collection("Organization")
        .doc("IXtqjP5JvAM2mdj0cntd")
        .collection("space")
        .doc("nDqwJANhr1evjCBu5Ije")
        .collection("Activity")
        .doc("vD3FY8cRBsj9UWjJQswy")
        .collection("PersonalActivity")
        .orderBy('createdAt', descending: false)
        .where("isReplyToActivity", isEqualTo: true)
        .where("replyActivityId", isEqualTo: widget.id)
        .get();
    List<dynamic> tempReplyList = [];
    replyQuerySnapShot.docs.forEach((doc) {
      Map<String, dynamic> replyInfo = {"id": doc.id};
      replyInfo.addAll(doc.data());
      tempReplyList.add(replyInfo);
    });
    setState(() {
      replyList = tempReplyList;
    });
    ref.watch(replyListProvider.notifier).state = replyList;
    ref.watch(activityDocumentIdProvider.notifier).state = widget.id;
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
                          "削除", "アクティビティを削除しました。", innerContext);
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
  }

  @override
  // アクティビティ詳細画面(アクティビティ詳細、返信件数、返信リストを表示する)
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                child: _detail(
                    widget.id,
                    widget.username,
                    CachedNetworkImage(
                        imageUrl: widget.photoUri, fit: BoxFit.fill),
                    widget.text,
                    widget.timeago),
              ),
              Expanded(
                child: ReplyList(
                  widget.id,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
          child: Container(
              height: 30,
              color: bgColor,
              child:
                  const Text('コメントを書く', style: TextStyle(color: textColor2))),
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                ref.watch(activityDocumentIdProvider.notifier).state =
                    widget.id;
                return Container(
                  height: 500,
                  color: bgColor2,
                  child: ReplyForm(),
                );
              },
            );
          },
        ));
  }

  //投稿の詳細
  Widget _detail(String? id, String username, CachedNetworkImage image,
      String text, Timestamp timeago) {
    return GestureDetector(
      //コンテナの中に配置していく
      child: Container(
        padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),

        //（アイコン）（ユーザー名・投稿）を縦に並べる
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            /*上揃えにする*/
            children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  /*左揃えにする*/
                  children: <Widget>[
                    // ユーザーアイコン
                    Container(
                      margin: const EdgeInsets.all(4.0),
                      width: 36,
                      height: 36,
                      //画像を丸型にする。サイズ感は画像読み込むところで行う
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: image),
                    ),

                    //ユーザー名
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(4, 4, 0, 2),
                        child: Text(
                          username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),

                    // 投稿時間表示(今から数えた時間が表示される)
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(4, 4, 0, 2),
                        child: Text(
                          createTimeAgoString(timeago.toDate()),
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
                      child: PopupMenuButton<String>(
                          color: bgColor2,
                          child: const Icon(Icons.more_horiz,
                              size: 14, color: Colors.grey),
                          itemBuilder: (BuildContext context) {
                            return menuLists.map((String list) {
                              return PopupMenuItem(
                                  value: list,
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                  child: Text(list),
                                  onTap: () {
                                    _controlDialog(widget.id, "ツイートを削除");
                                  });
                            }).toList();
                          },
                          onSelected: (String list) {
                            setState(() {
                              selectedValue = list;
                            });
                          }),
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

              // 画像。いったん asset 1 つのみを決め打ちで表示
              Container(
                padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                child: GestureDetector(
                  child: ifAssets(widget.assetsUrls),
                ),
              ),

              //リアクションボタン
              //like_button.dartを使用しています
              //リアクションボタンはもう少し小さくてもいい気がします
              // TODO: モックなので、いったん表示しない。いいねをちゃんと実装する時に復活させる
/*              Row(crossAxisAlignment: CrossAxisAlignment.start,
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
*/
            ],
          ),
        ),
      ),
    );
  }

  /*
  * いったん画像のありなしで出し分ける
  * TODO : データが増えたら煩雑なので、リストとかにした方がいいかも
  * */
  Widget ifAssets(String value) {
    if (value != '') {
      // assets がある場合は、画像を返す
      return GestureDetector(
        child: CachedNetworkImage(
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ),
          imageUrl: widget.assetsUrls,
          height: 48,
          width: 48,
        ),
        onTap: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return Container(
                  color: bgColor2,
                  child: ActivityAssetsScreen(widget.assetsUrls));
            },
          );
        },
      );
    } else {
      // assets がない場合は、空。
      return const SizedBox();
    }
  }
}
