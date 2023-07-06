import 'package:apikicker/Home/tweet_form.dart';
import 'package:apikicker/Home/tweet_item.dart';
import 'package:apikicker/main.dart';
import 'package:flutter/material.dart';
import 'package:apikicker/Common/color_settings.dart';
import 'package:apikicker/Common/flushbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:apikicker/Provider/user_provider.dart';

class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  Future<String> _load(WidgetRef ref) async {
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
        .limit(50)
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

    // 自身のユーザー情報を取得
    var usernameDocumentSnapShot = await firestore
        .collection("Organization")
        .doc("IXtqjP5JvAM2mdj0cntd")
        .collection("space")
        .doc("nDqwJANhr1evjCBu5Ije")
        .collection("Person")
        .doc(ref.watch(userProvider)?.uid)
        .get();
    var ownUser = usernameDocumentSnapShot.data();

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
        "profileText": ownUser!['profileText'],
        "assetsUrls": doc.data()['assetsUrls']
      };
      tweetInfo.addAll(doc.data());
      tempTweetList.add(tweetInfo);
    });

    ref.watch(activityContentsListProvider.notifier).state = tempTweetList;
    ref.watch(ownUserNameProvider.notifier).state = ownUser!['name'];
    ref.watch(ownUserPhotoUriProvider.notifier).state = ownUser['photoUri'];
    ref.watch(ownUserProfileTextProvider.notifier).state =
        ownUser['profileText'];

    return "Data Loaded";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

      // アクティビティのリスト
      body: _mainScreen(context, ref),

      // 投稿ボタン
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor,
        child: Container(
          child: const Icon(Icons.edit),
          padding: const EdgeInsets.all(17.0),
        ),
        onPressed: () async {
          final results = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return TweetForm(ref.watch(ownUserNameProvider),
                  ref.watch(ownUserPhotoUriProvider));
            }),
          );
          if (results != null) {
            showTopFlushbarFromActivity("投稿", "アクティビティを投稿しました。", context);
          }
        },
      ),
    );
  }

  Widget _mainScreen(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
        onRefresh: () async {
          await _load(ref);
        },
        child: FutureBuilder<String>(
          future: _load(ref),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              // ロード終了
              return ListView.builder(
                itemCount: ref.watch(activityContentsListProvider).length,
                itemBuilder: (BuildContext context, int index) {
                  final activityList = ref.watch(activityContentsListProvider);
                  return Card(
                      color: bgColor,
                      child: TweetItem(
                        activityList[index]['id'],
                        activityList[index]['personId'],
                        'images/kkrn_icon_user_1.png',
                        activityList[index]['contents'],
                        activityList[index]['createdAt'],
                        activityList[index]['username'],
                        activityList[index]['photoUri'],
                        activityList[index]['assetsUrls'],
                      ));
                },
              );
            } else if (snapshot.hasError) {
              // ロード失敗
              return const Text("読み込みに失敗");
            } else {
              // ロード中
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
