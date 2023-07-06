import 'package:apikicker/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:apikicker/Common/color_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apikicker/Home/timeline_screen.dart';
import 'dart:developer' as developer;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:apikicker/Provider/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:apikicker/Common/flushbar.dart';
import 'package:uuid/uuid.dart';

class TweetForm extends ConsumerStatefulWidget {
  TweetForm(this.ownUserName, this.ownUserPhotoUri, {Key? key})
      : super(key: key);

  String ownUserName;
  String ownUserPhotoUri;

  @override
  _TweetFormState createState() => _TweetFormState();
}

class _TweetFormState extends ConsumerState<TweetForm> {
  String activityPhotoUri = '';
  bool _isDisabledPost = false; // 投稿ボタンの連打制御用

  /*
  * アクティビティに画像アップロードし、パスを返す処理
  * 画像のアップロードだけして、投稿するタイミングでパスをセットする
  * */
  Future<dynamic> _uploadActivityPhoto(BuildContext context) async {
    // 画像を選択
    final pickerFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickerFile == null) {
      return;
    }

    try {
      // Storage にファイルアップロード
      File file = File(pickerFile.path);
      FirebaseStorage storage = FirebaseStorage.instance;
      // TODO : ここ uuid とかユニークの値をふる
      var uuid = Uuid();
      var newId = uuid.v4();
      final filePath =
          '/images/${ref.watch(userProvider)?.uid}/activity/$newId.png';
      final task = await storage.ref(filePath).putFile(file);

      // Storage に保存された画像のパスを取得する
      final activityPhotoUri = await task.ref.getDownloadURL();

      return activityPhotoUri;
    } catch (e) {
      // 画像じゃないやつとかヘンテコなやつはいったん問答無用で弾く
      // TODO:エラハン細かく作る
      print(e);
      showTopFlushbarFromProfileError('エラー', '画像のアップロードに失敗しました', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // アクティビティ投稿用
    var tweetContent = <String, String?>{
      "uid": ref.watch(userProvider)?.uid,
      "value": ref.watch(activityFormTextProvider),
      "assetsUrls": ref.watch(activityFormAssetsUrlProvider),
    };
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  reverse: true,
                  child: _cardItem(context, tweetContent),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //カードアイテム
  Widget _cardItem(BuildContext context, Map tweetContent) {
    return GestureDetector(
      child: Card(
        margin: const EdgeInsets.all(10),
        color: bgColor2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20) /*角の丸み*/
            ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 15, 2),

          //カード内のアイテム
          child: Column(children: [
            //キャンセルと投稿ボタン
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                /*左揃えにする*/
                children: <Widget>[
                  //キャンセルボタン
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      ref.watch(activityFormAssetsUrlProvider.notifier).state =
                          '';
                      ref.watch(activityFormTextProvider.notifier).state = '';
                    },
                    child: const Text(
                      'キャンセル',
                      style: TextStyle(
                        color: Colors.red, //文字の色を白にする
                        fontWeight: FontWeight.bold, //文字を太字する
                        fontSize: 12.0, //文字のサイズを調整する
                      ),
                    ),
                  ),

                  //投稿ボタン
                  GestureDetector(
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        //gradient: gColor,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _isDisabledPost
                            ? null
                            : () async {
                                // ボタンを無効にする
                                setState(() => _isDisabledPost = true);

                                // 投稿処理
                                HttpsCallable callable = FirebaseFunctions
                                    .instance
                                    .httpsCallable('pocTweetAdd');
                                final results = await callable(tweetContent);
                                ref
                                    .watch(
                                        activityFormAssetsUrlProvider.notifier)
                                    .state = '';
                                ref
                                    .watch(activityFormTextProvider.notifier)
                                    .state = '';
                                Navigator.of(context).pop(results);

                                // ボタンを有効にする
                                setState(() => _isDisabledPost = false);
                              },
                        label: const Text(
                          '投稿する',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold, /*太字*/
                            // backgroundColor: Colors.transparent,
                          ),
                        ),
                        icon: const Icon(Icons.create, size: 20),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor),
                      ),
                    ),
                    // ),
                  ),
                ]),

            //ユーザーアイコンと入力
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                /*左揃えにする*/
                children: <Widget>[
                  // ユーザーアイコン
                  Container(
                    margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                    width: 36,
                    height: 36,
                    //画像を丸型にする
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                          imageUrl: widget.ownUserPhotoUri, fit: BoxFit.fill),
                    ),
                  ),
                  // ユーザー名
                  Container(
                    margin: const EdgeInsets.fromLTRB(5, 8, 0, 10),
                    child: Text(
                      widget.ownUserName,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ]),

            // テキスト入力画面
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 30),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 140,
                decoration: const InputDecoration(
                  counterStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  hintText: "メッセージを書く",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                onChanged: (String value) {
                  tweetContent['value'] = value;
                  ref.watch(activityFormTextProvider.notifier).state = value;
                },
              ),
            ),

            // 添付画像の設定
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                /*左揃えにする*/
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 20, 12),
                        child: const Icon(
                          Icons.photo_size_select_actual_outlined,
                          size: 36,
                          color: textColor,
                        )),
                    // フォトアイコンタップでファイルチューザ出す
                    onTap: () async {
                      var activityPhotoUri =
                          await _uploadActivityPhoto(context);
                      tweetContent['assetsUrls'] = activityPhotoUri;
                      ref.watch(activityFormAssetsUrlProvider.notifier).state =
                          activityPhotoUri;
                    },
                  ),
                ]),

            // いったん asset 1 つのみを決め打ちで表示
            GestureDetector(
                child: ifAssetsFromActivityForm(
              ref.watch(activityFormAssetsUrlProvider),
            )),
          ]),
        ),
      ),
    );
  }

  /*
  * いったん画像のありなしで出し分ける
  * TODO : データが増えたら煩雑なので、リストとかにした方がいいかも
  * */
  Widget ifAssetsFromActivityForm(String activityPhotoUri) {
    if (activityPhotoUri != '') {
      // assets がある場合は、画像を返す
      return GestureDetector(
        child: CachedNetworkImage(
          imageUrl: activityPhotoUri,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ),
          height: 128,
          width: 128,
        ),
        onTap: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return Container(
                  color: bgColor2,
                  child: ActivityFormAssetsScreen(activityPhotoUri));
            },
          );
        },
      );
    } else {
      // assets がない場合は、なにも表示しない
      return const SizedBox();
    }
  }
}

/*
* アクティビティ投稿に表示する画像の出し分け処理によって、表示されるサムネイル部分
* */
class ActivityFormAssetsScreen extends ConsumerStatefulWidget {
  const ActivityFormAssetsScreen(this.assetsUrls, {Key? key}) : super(key: key);

  final String assetsUrls;

  @override
  _ActivityFormAssetsScreen createState() => _ActivityFormAssetsScreen();
}

class _ActivityFormAssetsScreen
    extends ConsumerState<ActivityFormAssetsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor2,
      ),
      body: Center(
          child: CachedNetworkImage(
        imageUrl: widget.assetsUrls,
      )),
      backgroundColor: bgColor,
    );
  }
}
