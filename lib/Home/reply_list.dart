

import 'package:apikicker/Common/color_settings.dart';
import 'package:apikicker/main.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';

class ReplyList extends ConsumerStatefulWidget {
  const ReplyList(this.id, {Key? key}) : super(key: key);

  final String id;

  @override
  _ReplyListState createState() => _ReplyListState();

}

class _ReplyListState extends ConsumerState<ReplyList> {

  String debugReplyListData = "";
  List<dynamic> replyList = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async{
    final firestore = ref.read(firebaseFirestoreProvider);
    var querySnapShot= await firestore.collection("Organization")
      .doc("IXtqjP5JvAM2mdj0cntd").collection("space")
      .doc("nDqwJANhr1evjCBu5Ije").collection("Activity")
      .doc("vD3FY8cRBsj9UWjJQswy").collection("PersonalActivity")
      .orderBy('createdAt', descending: false)
      .where("isReplyToActivity", isEqualTo: true).where("replyActivityId", isEqualTo: widget.id).get();

    List<dynamic> tempReplyList = [];
    querySnapShot.docs.forEach( (doc) {
      // ドキュメントIDをそれぞれのツイートに含める
      Map<String, dynamic> replyInfo = 
          {
            "id": doc.id,
          };
      replyInfo.addAll(doc.data());
      tempReplyList.add(replyInfo);
    });
    setState(() {
      replyList = tempReplyList;
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
        child: ListView.builder(
          itemCount: replyList.length,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
          //コンテナの中に配置していく
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
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
                                        child: Text(
                                          replyList[index]['personId'],
                                          style: const TextStyle(
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
                                    ]),

                                //テキスト(投稿本文)
                                Container(
                                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
                                  child: Text(
                                    replyList[index]['contents'],
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ]
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
      )
    );
  }
}