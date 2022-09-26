

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
    return Scaffold(
      backgroundColor: bgColor,
      body: ListView.builder(
        itemCount: replyList.length,
        itemBuilder: (BuildContext context, int index){
          return GestureDetector(
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
    );
  }
}