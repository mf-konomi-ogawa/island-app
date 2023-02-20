import 'dart:async';
import 'package:flutter/material.dart';
import 'package:apikicker/Common/flushbar.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:apikicker/Common/color_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileEditForm extends ConsumerStatefulWidget {
  ProfileEditForm(this.id, this.userName, this.profileText, this.photoUri, {Key? key})
      : super(key: key);

  String id = "";
  String userName = "";
  String profileText = "";
  String photoUri = "";

  @override
  _ProfileEditForm createState() => _ProfileEditForm();
}

class _ProfileEditForm extends ConsumerState<ProfileEditForm> {
  String ownUserName = "";
  String profileText = "";
  String personId = "";
  String currentOwnUserName = "";
  String currentProfileText = "";
  String photoUri = "";

  @override
  void initState() {
    super.initState();
    ownUserName = currentOwnUserName = widget.userName;
    profileText = currentProfileText = widget.profileText;
    personId = widget.id;
    photoUri = widget.photoUri;
  }

  /*
  * 画像アップロード処理
  * */
  Future _uploadPic( BuildContext context ) async {
    // 画像を選択
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage( source: ImageSource.gallery );
    File file = File(image!.path);
    try {
      // Storage にファイルアップロード
      String uploadName = 'usericon.png';
      final storageRef = FirebaseStorage.instance.ref().child('users/$personId/icon/$uploadName');
      final task = await storageRef.putFile(file);

      // person の photoUri を更新する
      final userPhotoUri = await task.ref.getDownloadURL();
      var data = {
        "uid": personId,
        "photoUri": userPhotoUri,
      };
      HttpsCallable callable = FirebaseFunctions
          .instance
          .httpsCallable('pocUpdateProfilePhotoUri');
      final result = await callable(data);
    }
    catch( e ){
      // 画像じゃないやつとかヘンテコなやつはいったん問答無用で弾く
      // TODO:エラハン細かく作る
      print( e );
      showTopFlushbarFromProfileError( 'エラー' , '画像のアップロードに失敗しました', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String?> updateProfile = {
      "uid": personId,
      "name": ownUserName,
      "profileText": profileText,
    };
    return SizedBox(
      height: 600,
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
                      'プロフィールの編集',
                      style: TextStyle(
                        color: Colors.white, //文字の色を白にする
                        fontWeight: FontWeight.bold, //文字を太字する
                        fontSize: 18.0, //文字のサイズを調整する
                      ),
                    ),
                  ),
                  // キャンセルボタン
                  GestureDetector(
                    child: const Text(
                      'キャンセル',
                      style: TextStyle(
                        color: Colors.red, //文字の色を白にする
                        fontWeight: FontWeight.bold, //文字を太字する
                        fontSize: 12.0, //文字のサイズを調整する
                      ),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  // 編集OKボタン
                  GestureDetector(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // 名前とプロフィール文に変更がない場合はupdateしない
                        if (currentProfileText ==
                                updateProfile['profileText'] &&
                            currentOwnUserName == updateProfile['name']) {
                          Navigator.pop(context);
                        } else {
                          HttpsCallable callable = FirebaseFunctions.instance
                              .httpsCallable('pocUpdateProfile');
                          final results = await callable(updateProfile);
                          Navigator.of(context).pop(results);
                          showTopFlushbarFromActivity(
                              "プロフィール編集", "プロフィールを編集しました。", context);
                        }
                      },
                      label: const Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.white, //文字の色を白にする
                          fontWeight: FontWeight.bold, //文字を太字する
                          fontSize: 14.0, //文字のサイズを調整する
                        ),
                      ),
                      icon: const Icon(Icons.create, size: 10),
                    ),
                  ),
                ]),
            // 画像は中央寄せにする
            GestureDetector(
              onTap: () async {
                await _uploadPic(context);
              },
              child : Center(
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  width: 120,
                  height: 120,
                  //画像を丸型にする
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage( imageUrl:photoUri , fit: BoxFit.fill ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await _uploadPic(context);
              },
              child:Center(
                child: GestureDetector(
                  child: const Text(
                    '画像をアップロード',
                    style: TextStyle(
                      color: Colors.white, //文字の色を白にする
                      fontWeight: FontWeight.bold, //文字を太字する
                      fontSize: 12.0, //文字のサイズを調整する
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            //入力画面
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 30),
              child: TextField(
                controller: TextEditingController(text: ownUserName),
                decoration: const InputDecoration(
                  labelText: "ユーザー名",
                  labelStyle: TextStyle(color: textColor),
                  hintText: "ユーザー名を入力",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: textColor,
                    ),
                  ),
                ),
                style: const TextStyle(color: textColor),
                keyboardType: TextInputType.text,
                onChanged: (String value) {
                  updateProfile['name'] = value;
                },
              ),
            ),
            const SizedBox(height: 8),
            //入力画面
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 30),
              child: TextField(
                controller: TextEditingController(text: profileText),
                decoration: const InputDecoration(
                  labelText: "プロフィール",
                  labelStyle: TextStyle(color: textColor),
                  hintText: "プロフィールを入力",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: textColor,
                    ),
                  ),
                ),
                style: const TextStyle(color: textColor),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onChanged: (String value) {
                  updateProfile['profileText'] = value;
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
