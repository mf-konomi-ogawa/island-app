import 'package:flutter/material.dart';
import 'package:apikicker/Common/color_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
import 'package:apikicker/main.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TimelineProfileScreen extends ConsumerStatefulWidget {
  TimelineProfileScreen(this.id, this.userName, this.photoUri, {Key? key})
      : super(key: key);

  String id = "";
  String userName = "";
  String photoUri = "";

  @override
  _TimelineProfileScreen createState() => _TimelineProfileScreen();
}

class _TimelineProfileScreen extends ConsumerState<TimelineProfileScreen> {
  String userName = "";
  String profileText = "";
  String personId = "";
  String photoUri = "";

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async{
    userName = widget.userName;
    personId = widget.id;
    photoUri = widget.photoUri;

    final firestore = ref.read(firebaseFirestoreProvider);

    // 自己紹介を取得
    var profileTextDocumentSnapShot = await firestore
        .collection("Organization")
        .doc("IXtqjP5JvAM2mdj0cntd")
        .collection("space")
        .doc("nDqwJANhr1evjCBu5Ije")
        .collection("Person")
        .doc(personId)
        .get();
    setState(() {
      profileText = profileTextDocumentSnapShot.data()!['profileText'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String?> updateProfile = {
      "uid": personId,
      "name": userName,
    };
    return SizedBox(
      height: 320,
      child: Card(
        margin: const EdgeInsets.all(10),
        color: bgColor2,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 15, 2),
          child: Column(children: <Widget>[
            // ユーザー情報更新タイトル
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                /*左揃えにする*/
                children: <Widget>[
                  // プロフィールの編集ラベル
                  GestureDetector(
                    child: const Text(
                      'プロフィール',
                      style: TextStyle(
                        color: Colors.white, //文字の色を白にする
                        fontWeight: FontWeight.bold, //文字を太字する
                        fontSize: 18.0, //文字のサイズを調整する
                      ),
                    ),
                  ),
                ]),
            // 画像は中央寄せにする
            Center(
              child: Container(
                margin: const EdgeInsets.all(4.0),
                width: 120,
                height: 120,
                //画像を丸型にする
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  // TODO:上位から画像のパスを引っ張ってくる
                  child: CachedNetworkImage( imageUrl:photoUri ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ユーザー名
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 30),
              child: Center(
                child: GestureDetector(
                  child: Text(
                    userName ,
                    style: const TextStyle(
                      color: Colors.white, //文字の色を白にする
                      fontWeight: FontWeight.bold, //文字を太字する
                      fontSize: 20.0, //文字のサイズを調整する
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // プロフィール
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 30),
              child: Center(
                child: GestureDetector(
                  child: const Text(
                    'プロフィール',
                    style: TextStyle(
                      color: Colors.white, //文字の色を白にする
                      fontWeight: FontWeight.bold, //文字を太字する
                      fontSize: 12.0, //文字のサイズを調整する
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 30),
              child: Center(
                child: GestureDetector(
                  child: Text(
                    profileText,
                    style: const TextStyle(
                      color: Colors.white, //文字の色を白にする
                      fontWeight: FontWeight.bold, //文字を太字する
                      fontSize: 16.0, //文字のサイズを調整する
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
