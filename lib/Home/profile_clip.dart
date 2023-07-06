import 'package:apikicker/Common/color_settings.dart';
import 'package:flutter/material.dart';
import 'package:apikicker/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apikicker/Provider/user_provider.dart';
import 'package:apikicker/Home/tweet_item.dart';

class ProfileClip extends ConsumerWidget {
  const ProfileClip({super.key});

  Future<String> _load(WidgetRef ref) async {
    final firestore = ref.read(firebaseFirestoreProvider);

    // エモーション取得
    var querySnapShotEmotion = await firestore
        .collection("Organization")
        .doc("IXtqjP5JvAM2mdj0cntd")
        .collection("space")
        .doc("nDqwJANhr1evjCBu5Ije")
        .collection("Emotion")
        .orderBy('createdAt', descending: true)
        .get();
    List<dynamic> tempEmotionForList = [];
    querySnapShotEmotion.docs.forEach((doc) {
      // 自身がエモーションしたドキュメントのみ抽出
      if (doc.data()['personId'] == ref.read(userProvider)?.uid) {
        Map<String, dynamic> emotionInfo = {"id": doc.data()["emotionFor"]};
        emotionInfo.addAll(doc.data());
        tempEmotionForList.add(emotionInfo);
      }
    });

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

    // 自身がエモーションをつけたアクティビティリストの設定
    List<dynamic> tempTweetList = [];
    String tempUserName = "";
    String tempPhotoUri = "";
    querySnapShot.docs.forEach((doc) {
      // 自身がエモーションをつけたアクティビティのみリストに設定
      var isEmotion = tempEmotionForList.any((value) {
        return value['emotionFor'] == doc.id;
      });
      if (isEmotion) {
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
          "personaId": doc.data()['personId'],
          "contents": doc.data()['contents'],
          "createdAt": doc.data()['createdAt'],
          "username": tempUserName,
          "photoUri": tempPhotoUri,
          "assetsUrls": doc.data()['assetsUrls'],
        };
        tweetInfo.addAll(doc.data());
        tempTweetList.add(tweetInfo);
      }
    });
    ref.watch(clipContentsListProvider.notifier).state = tempTweetList;

    return "Data Loading";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: bgColor,
      body: RefreshIndicator(
        onRefresh: () async {},
        child: _clipScreen(context, ref),
      ),
    );
  }

  Widget _clipScreen(BuildContext context, WidgetRef ref) {
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
                itemCount: ref.watch(clipContentsListProvider).length,
                itemBuilder: (BuildContext context, int index) {
                  final clipList = ref.watch(clipContentsListProvider);
                  return TweetItem(
                    clipList[index]['id'],
                    clipList[index]['personId'],
                    'images/kkrn_icon_user_1.png',
                    clipList[index]['contents'],
                    clipList[index]['createdAt'],
                    clipList[index]['username'],
                    clipList[index]['photoUri'],
                    clipList[index]['assetsUrls'],
                  );
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
