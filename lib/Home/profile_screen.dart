import 'package:apikicker/Common/color_settings.dart';
import 'package:apikicker/Home/tweet_details.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:apikicker/Auth/login.dart';

const _tabs = [
  '投稿',
  'クリップ',
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor2,
      appBar: AppBar(
        backgroundColor: bgColor2,
        elevation: 0,
        title: const Text(
          'プロフィール',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        leading: const Icon(Icons.settings),
        /*設定アイコン*/
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            /*ログアウトアイコン*/
            onPressed: () async{
              await FirebaseAuth.instance.signOut();
              await Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                return WelcomePage();
              }));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('ログアウトしました。')),
              );
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: _tabs.length, // This is the number of tabs.
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              //スクロールしたら折りたたまれる要素(アイコンや名前、説明文など)
              SliverList(
                delegate: SliverChildListDelegate([
                  _profileItem(),

                  //編集ボタン
                  _profileButtonItem(),

                  _profileSentenceItem("ここに自己紹介文が入ります。\n"
                      "長くても4行くらいの想定です。最大100文字くらいがいいかなと。"
                      "中央揃えですが変えてもいいかも。"),
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
                    tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                  ),
                ),
              ),
            ];
          },
          //タブの中身
          body: const TabBarView(
            children: <Widget>[
              // Center(child: SubmissionPage()),
              /*投稿一覧*/
              // Center(child: ClipPage()), /*クリップ一覧*/
            ],
          ),
        ),
      ),
    );
  }
}

//プロフィールの設定(調整部分)
Widget _profileItem() {
  return GestureDetector(
    //コンテナの中に配置していく
    child: Container(
      // alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(10, 10, 15, 2),
      decoration: const BoxDecoration(),

      //（アイコン）（ユーザー名・投稿）を横に並べる
      child: Row(crossAxisAlignment: CrossAxisAlignment.center,
          /*上揃えにする*/
          children: <Widget>[
            //投稿左側の設定
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              /*上揃えにする*/
              children: <Widget>[
                //アイコン
                _iconItem(Image.asset(
                  'images/kkrn_icon_user_1.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.fill,
                )),
              ],
            ),
            //投稿右側の設定
            Flexible(
              child: Column(children: <Widget>[
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    /*左揃えにする*/
                    children: <Widget>[
                      //ユーザー名
                      _nameItem("User_name", "SOL", "プロダクト開発グループ"),
                    ]),
              ]),
            ),
          ]),
    ),
  );
}

//プロフィールアイコン
Widget _iconItem(Image image) {
  return GestureDetector(
    child: Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          /*左揃えにする*/
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),

              //画像を丸型にする。サイズ感は画像読み込むところで行う
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: image,
              ),
            ),

            //不要な気がする。画像クリックで拡大表示と変更できるようにしたら良いのでは..?
            // Container(
            //   margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
            //   child: const Text(
            //     'プロフィール画像を変更する',
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 12.0,
            //     ),
            //   ),
            // ),
            // ),
            // ),
          ],
        ),
      ],
    ),
  );
}

//名前とかプロフィール説明とか
Widget _nameItem(String name, String group1, String group2) {
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
                name,
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
Widget _profileSentenceItem(String profileSentence) {
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
                profileSentence,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
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

//プロフィール編集ボタン
Widget _profileButtonItem() {
  return GestureDetector(
    child: Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          /*中央揃えにする*/
          children: <Widget>[
            //ユーザー名
            Container(
              height:40,
              width: 250,
              decoration:  BoxDecoration(
                // shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(20),
                gradient: gColor,
              ),
              // padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: ElevatedButton(
                child: const Text(
                  'プロフィールを編集',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold, /*太字*/
                  ),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.transparent),
                // style: ElevatedButton.styleFrom(
                //   primary: accentColor,
                //   onPrimary: Colors.black,
                //   shape: const StadiumBorder(),
                //   padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                // ),
                onPressed: () {},
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

