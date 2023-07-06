import 'package:apikicker/Common/color_settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apikicker/Auth/login.dart';
import 'package:apikicker/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
import 'package:apikicker/Home/profile_activity.dart';
import 'package:apikicker/Home/profile_edit.dart';
import 'package:apikicker/Home/profile_clip.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:apikicker/Provider/user_provider.dart';

const _tabs = [
  '投稿',
  'クリップ',
];

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void initState(WidgetRef ref) {
    _load(ref);
  }

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
    querySnapShot.docs.forEach((doc) {
      // タイムライン情報に自身のユーザー情報を紐づける
      if (doc.data()['personId'] == ref.read(userProvider)?.uid) {
        Map<String, dynamic> tweetInfo = {
          "id": doc.id,
          "username": ownUser!['name'],
          "photoUri": ownUser['photoUri'],
          "profileText": ownUser['profileText'],
        };
        tweetInfo.addAll(doc.data());
        tempTweetList.add(tweetInfo);
      }
    });

    ref.watch(ownActivityContentsListProvider.notifier).state = tempTweetList;
    ref.watch(ownUserNameProvider.notifier).state = ownUser!['name'];
    ref.watch(ownUserPhotoUriProvider.notifier).state = ownUser['photoUri'];
    ref.watch(ownUserProfileTextProvider.notifier).state =
        ownUser['profileText'];

    return "Data Loading";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: bgColor2,
        appBar: AppBar(
          backgroundColor: bgColor2,
          elevation: 0,
          title: const Text(
            'アカウント',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          // leading: const Icon(Icons.settings),
          /*設定アイコン*/
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              /*ログアウトアイコン*/
              onPressed: () async {
                _showAlertDialog(context);
              },
            ),
          ],
        ),
        body: DefaultTabController(
          length: _tabs.length, // This is the number of tabs.
          child: FutureBuilder<String>(
              future: _load(ref),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  // ロード終了
                  return NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        //スクロールしたら折りたたまれる要素(アイコンや名前、説明文など)
                        SliverList(
                          delegate: SliverChildListDelegate([
                            // 自身の名前・プロフィール画像
                            _profileItem(ref),
                            // 編集ボタン
                            _profileButtonItem(context, ref),
                            _profileSentenceItem(ref),
                          ]),
                        ),
                        //スクロールしたら上にとどまる要素(タブ)
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _StickyTabBarDelegate(
                            //タブ
                            TabBar(
                              labelColor: accentColor,
                              /*選択された時の色*/
                              unselectedLabelColor: Colors.white38,
                              /*選択されていないときの色*/
                              indicatorColor: accentColor,
                              /*下のボーダー*/
                              tabs: _tabs
                                  .map((String name) => Tab(text: name))
                                  .toList(),
                            ),
                          ),
                        ),
                      ];
                    },
                    //タブの中身
                    body: TabBarView(
                      children: <Widget>[
                        // 自身の投稿一覧
                        Center(
                          child: ProfileActivity(
                              ref.watch(ownActivityContentsListProvider)),
                        ),
                        // クリップ一覧
                        Center(
                          child: ProfileClip(),
                        ),
                        // Center(child: ClipPage()), /*クリップ一覧*/
                      ],
                    ),
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
              }),
        ));
  }
}

void _showAlertDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: const Text('ログアウトしますか？'),
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
                  onPressed: () async {
                    // ログアウト処理
                    await FirebaseAuth.instance.signOut();
                    await Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return WelcomePage();
                    }));
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor2,
                  ),
                  child: const Text('キャンセル'),
                  onPressed: () {
                    Navigator.pop(context);
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

//プロフィールの設定(調整部分)
Widget _profileItem(WidgetRef ref) {
  return GestureDetector(
    //コンテナの中に配置していく
    child: Container(
      // alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(10, 10, 15, 2),
      decoration: const BoxDecoration(),

      //（アイコン）（ユーザー名・投稿）を横に並べる
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          /*上揃えにする*/
          children: <Widget>[
            //投稿左側の設定
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              /*上揃えにする*/
              children: <Widget>[
                // アイコン
                _iconItem(
                  CachedNetworkImage(
                      imageUrl: ref.watch(ownUserPhotoUriProvider),
                      fit: BoxFit.fill),
                ),
              ],
            ),
            //投稿右側の設定
            Flexible(
              child: Column(children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    /*左揃えにする*/
                    children: <Widget>[
                      // ユーザー名
                      _nameItem(ref, "SOL", "プロダクト開発グループ"),
                    ]),
              ]),
            ),
          ]),
    ),
  );
}

//プロフィールアイコン
Widget _iconItem(CachedNetworkImage image) {
  return GestureDetector(
    child: Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          /*左揃えにする*/
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
              width: 120,
              height: 120,
              //画像を丸型にする
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: image,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

//名前とかプロフィール説明とか
Widget _nameItem(WidgetRef ref, String group1, String group2) {
  return GestureDetector(
    child: Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          /*中央揃えにする*/
          children: <Widget>[
            //ユーザー名
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
              child: Text(
                ref.watch(ownUserNameProvider),
                //name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold, /*太字*/
                ),
              ),

              //名前下のボーダーライン
              //名前の文字数に合わせて長さが変化する
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: accentColor,
                    width: 3,
                  ),
                ),
              ),
            ),

            //ユーザーの所属
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                group1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                ),
                // textAlign: TextAlign.center,
              ),
            ),

            //ユーザーの所属詳細
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                group2,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                ),
                // textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

//プロフィール文（自己紹介）
Widget _profileSentenceItem(WidgetRef ref) {
  return GestureDetector(
    child: Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          /*中央揃えにする*/
          children: <Widget>[
            //ユーザー名
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Text(
                ref.watch(ownUserProfileTextProvider),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

//プロフィール編集ボタン
Widget _profileButtonItem(BuildContext context, WidgetRef ref) {
  return GestureDetector(
    child: Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          /*中央揃えにする*/
          children: <Widget>[
            //ユーザー名
            Container(
              height: 40,
              width: 250,
              padding: const EdgeInsets.fromLTRB(2, 2, 8, 8),
              child: ElevatedButton(
                child: const Text(
                  'プロフィールを編集',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
                onPressed: () {
                  showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      TextEditingController textNameEditingController =
                          TextEditingController(
                              text: ref.watch(ownUserNameProvider));
                      TextEditingController textProfileEditingController =
                          TextEditingController(
                              text: ref.watch(ownUserProfileTextProvider));
                      return Container(
                          height: 580,
                          color: bgColor2,
                          child: SingleChildScrollView(
                              child: ProfileEditForm(
                                  textNameEditingController:
                                      textNameEditingController,
                                  textProfileEditingController:
                                      textProfileEditingController)));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

//タブバーの設定
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: bgColor, child: tabBar);
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
