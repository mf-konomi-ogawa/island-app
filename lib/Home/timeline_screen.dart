import 'package:apikicker/Home/tweet_form.dart';
import 'package:apikicker/Home/tweet_item.dart';
import 'package:apikicker/main.dart';
import 'package:flutter/material.dart';
import 'package:apikicker/Common/color_settings.dart';
import 'package:apikicker/Common/flushbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'dart:developer' as developer;
import 'dart:async';

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  List<dynamic> tweetContentslist = []; // アクティビティの内容
  String ownUserName = ''; // 自身のユーザー名

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<String> _load() async {
    final firestore = ref.read(firebaseFirestoreProvider);

    // アクティビティ取得
    var querySnapShot = await firestore
        .collection("Organization")
        .doc("IXtqjP5JvAM2mdj0cntd")
        .collection("space")
        .doc("nDqwJANhr1evjCBu5Ije")
        .collection("Activity")
        .doc("vD3FY8cRBsj9UWjJQswy")
        .collection("PersonalActivity")
        .orderBy('createdAt', descending: true)
        .where("isReplyToActivity", isEqualTo: false)
        .get();

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

    // 自身のユーザー名を取得
    var usernameDocumentSnapShot = await firestore
        .collection("Organization")
        .doc("IXtqjP5JvAM2mdj0cntd")
        .collection("space")
        .doc("nDqwJANhr1evjCBu5Ije")
        .collection("Person")
        .doc(ref.watch(userProvider)?.uid)
        .get();
    var ownUser = usernameDocumentSnapShot.data();
    ownUserName = ownUser!['name'];

    // タイムライン情報の設定
    List<dynamic> tempTweetList = [];
    String tempUserName = "";
    String tempPhotoUri = "";
    querySnapShot.docs.forEach((doc) {
      // タイムライン情報にユーザー情報を紐づける
      for (int i = 0; i < tempUserList.length; i++) {
        if (tempUserList[i]['id'] == doc.data()['personId']) {
          tempUserName = tempUserList[i]['name'];
          tempPhotoUri = tempUserList[i]['photoUri'];
        }
      }
      // ドキュメントIDをそれぞれのツイートに含める
      Map<String, dynamic> tweetInfo = {
        "id": doc.id,
        "username": tempUserName,
        "photoUri": tempPhotoUri,
      };
      tweetInfo.addAll(doc.data());
      tempTweetList.add(tweetInfo);
    });

    // tweetContentslist にタイムライン情報とユーザー情報を詰める
    setState(() {
      tweetContentslist = tempTweetList;
    });

    return "Data Loaded";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor2,
        elevation: 0,
        title: Image.asset(
          'images/app_icon/island_app_icon_transparent.png',
          height: 32,
          width: 32,
        ),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            await _load();
          },
          child: FutureBuilder<String>(
            future: _load(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                // ロード終了
                return ListView.builder(
                  itemCount: tweetContentslist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        color: bgColor,
                        child: TweetItem(
                          tweetContentslist[index]['id'],
                          tweetContentslist[index]['personId'],
                          'images/kkrn_icon_user_1.png',
                          tweetContentslist[index]['contents'],
                          tweetContentslist[index]['createdAt'],
                          tweetContentslist[index]['username'],
                          tweetContentslist[index]['photoUri'],
                        ));
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
      ),
      // 投稿ボタン
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor,
        child: Container(
          // decoration: gradationBox,
          child: const Icon(Icons.edit),
          padding: const EdgeInsets.all(17.0),
        ),
        onPressed: () async {
          final results = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return TweetForm(ownUserName);
            }),
          );
          if (results != null) {
            showTopFlushbarFromActivity(
                "投稿", "アクティビティを投稿しました。", context);
          }
        },
      ),
    );
  }
}
