import 'package:apikicker/Common/color_settings.dart';
import 'package:apikicker/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'dart:developer' as developer;
import 'package:apikicker/Common/timeago.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ReplyList extends ConsumerStatefulWidget {
  const ReplyList(this.id, {Key? key}) : super(key: key);

  final String id;

  @override
  _ReplyListState createState() => _ReplyListState();
}

class _ReplyListState extends ConsumerState<ReplyList> {
  List<dynamic> replyList = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<String> _load() async {
    final firestore = ref.read(firebaseFirestoreProvider);
    var querySnapShot = await firestore
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

    // TODO: repository に getUserList みたいなの作って共通化する
    // ユーザー情報取得
    var userDocumentSnapShot = await firestore
        .collection("Organization")
        .doc("IXtqjP5JvAM2mdj0cntd")
        .collection("space")
        .doc("nDqwJANhr1evjCBu5Ije")
        .collection("Person")
        .get();
    List<dynamic> tempUserList = [];
    userDocumentSnapShot.docs.forEach((doc) {
      Map<String, dynamic> userInfo = {"id": doc.id};
      userInfo.addAll(doc.data());
      tempUserList.add(userInfo);
    });

    List<dynamic> tempReplyList = [];
    String tempUserName = "";
    String tempUserPhotoUri = "";
    querySnapShot.docs.forEach((doc) {
      // タイムライン情報にユーザー情報を紐づける
      for (int i = 0; i < tempUserList.length; i++) {
        if (tempUserList[i]['id'] == doc.data()['personId']) {
          tempUserName = tempUserList[i]['name'];
          tempUserPhotoUri = tempUserList[i]['photoUri'];
        }
      }
      // ドキュメントIDをそれぞれのツイートに含める
      Map<String, dynamic> replyInfo = {
        "id": doc.id,
        "username": tempUserName,
        "photoUri": tempUserPhotoUri,
      };
      replyInfo.addAll(doc.data());
      tempReplyList.add(replyInfo);
    });
    setState(() {
      replyList = tempReplyList;
    });

    return "Data Loaded";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        body: RefreshIndicator(
            onRefresh: () async {
              await _load();
            },
            child: FutureBuilder<String>(
              future: _load(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: replyList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        //コンテナの中に配置していく
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
                          // alignment: Alignment.topLeft,
                          decoration: const BoxDecoration(
                              color: bgColor2,
                              border: Border(
                                  bottom:
                                      BorderSide(width: 1, color: lineColor))),
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
                                    width: 32,
                                    height: 32,
                                    // 画像を丸型にする。サイズ感は画像読み込むところで行う
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        imageUrl: replyList[index]['photoUri'],
                                          fit: BoxFit.fill
                                      )
                                    ),
                                  ),
                                ],
                              ),
                              //投稿右側の設定
                              Flexible(
                                child: Column(
                                  children: <Widget>[
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        /*左揃えにする*/
                                        children: <Widget>[
                                          //一番上の行
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              /*左揃えにする*/
                                              children: <Widget>[
                                                //ユーザー名
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          4, 4, 4, 2),
                                                  child: Text(
                                                    replyList[index]
                                                        ['username'],
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ),

                                                //投稿時間表示(今から数えた時間が表示される)
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          4, 4, 4, 2),
                                                  child: Text(
                                                    createTimeAgoString(
                                                        replyList[index]
                                                                ['createdAt']
                                                            .toDate()),
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),

                                                const Spacer(),
                                                /*クリップアイコンを右端に寄せるための記述*/
                                              ]),

                                          //テキスト(投稿本文)
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                4, 8, 10, 10),
                                            child: Text(
                                              replyList[index]['contents'],
                                              style: const TextStyle(
                                                color: textColor,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  // ロード失敗
                  return const Text("読み込みに失敗");
                } else {
                  // ロード中
                  return const Center(
                    child:CircularProgressIndicator(),
                  );
                }
              },
            )
        ));
  }
}
