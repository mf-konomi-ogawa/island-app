import 'dart:async';
import 'dart:io';

import 'package:apikicker/Common/color_settings.dart';
import 'package:apikicker/Common/flushbar.dart';
import 'package:apikicker/Home/take_picture_screen.dart';
import 'package:apikicker/Provider/user_provider.dart';
import 'package:apikicker/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as developer;

class ProfileEditForm extends ConsumerWidget {
  ProfileEditForm(
      {required this.textNameEditingController,
      required this.textProfileEditingController});
  Map<String?, String?> updateProfile = {};

  TextEditingController textNameEditingController = TextEditingController();
  TextEditingController textProfileEditingController = TextEditingController();

  bool isDisabledOKButton = false;

  /*
  * プロフィール画像アップロード処理
  * */
  Future<dynamic> _uploadPic(BuildContext context, WidgetRef ref) async {
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
      final filePath =
          '/users/${ref.watch(userProvider)?.uid}/icon/usericon.png';
      final task = await storage.ref(filePath).putFile(file);

      // person の photoUri を更新する
      final userPhotoUri = await task.ref.getDownloadURL();
      var data = {
        "uid": ref.watch(userProvider)?.uid,
        "photoUri": userPhotoUri,
      };
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('pocUpdateProfilePhotoUri');
      final result = await callable(data);
      ref.watch(ownUserPhotoUriProvider.notifier).state = data["photoUri"]!;
    } catch (e) {
      // 画像じゃないやつとかヘンテコなやつはいったん問答無用で弾く
      // TODO:エラハン細かく作る
      print(e);
      showTopFlushbarFromProfileError('エラー', '画像のアップロードに失敗しました', context);
    }
  }

  /*
  * プロフィール編集処理
  * */
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      onPressed: isDisabledOKButton
                          ? null
                          : () async {
                              // ボタンを無効にする
                              isDisabledOKButton = true;

                              // 名前とプロフィール文に変更がない場合はupdateしない
                              if (ref.read(ownUserProfileTextProvider) ==
                                      textProfileEditingController.text &&
                                  ref.read(ownUserNameProvider) ==
                                      textNameEditingController.text) {
                                Navigator.pop(context);
                              } else {
                                // 更新情報を詰める
                                updateProfile = {
                                  "uid": ref.read(userProvider)?.uid,
                                  "name": textNameEditingController.text,
                                  "profileText":
                                      textProfileEditingController.text,
                                };

                                // ユーザープロフィール更新APIを叩く
                                HttpsCallable callable = FirebaseFunctions
                                    .instance
                                    .httpsCallable('pocUpdateProfile');
                                final results = await callable(updateProfile);

                                //  API実行後に画面戻る
                                Navigator.of(context).pop(results);
                                showTopFlushbarFromActivity(
                                    "プロフィール編集", "プロフィールを編集しました。", context);

                                // 更新情報を反映する
                                ref.read(ownUserNameProvider.notifier).state =
                                    textNameEditingController.text;
                                ref
                                    .read(ownUserProfileTextProvider.notifier)
                                    .state = textProfileEditingController.text;
                              }

                              // ボタンを有効にする
                              isDisabledOKButton = false;
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
            // ユーザー画像
            // 中央寄せにして表示
            GestureDetector(
              onTap: () async {
                await _uploadPic(context, ref);
              },
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  width: 120,
                  height: 120,
                  //画像を丸型にする
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                        imageUrl: ref.watch(ownUserPhotoUriProvider),
                        placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        errorWidget: (context, url, error) => const Center(
                              child: Icon(Icons.error),
                            ),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
            ),
            // 画像をファイルから選択してアップロードするボタン
            GestureDetector(
              onTap: () async {
                await _uploadPic(context, ref);
              },
              child: Center(
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
            const SizedBox(height: 12),

            // カメラで写真を撮影するボタン
            GestureDetector(
              onTap: () {
                if (isGlobalCamera) {
                  showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Expanded(
                          child: TakePictureScreen(camera: globalCamera));
                    },
                  );
                } else {
                  showTopFlushbarFromProfileError(
                      "エラー", "端末のカメラ機能が無効です。", context);
                }
              },
              child: Center(
                child: GestureDetector(
                  child: const Text(
                    'カメラを使う',
                    style: TextStyle(
                      color: Colors.white, //文字の色を白にする
                      fontWeight: FontWeight.bold, //文字を太字する
                      fontSize: 12.0, //文字のサイズを調整する
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            //入力画面
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 30),
              child: TextField(
                controller: textNameEditingController,
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
                  ref.read(ownUserNameStateProvider.notifier).state.text =
                      value;
                  updateProfile['name'] = value;
                },
              ),
            ),
            const SizedBox(height: 8),
            //入力画面
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 30),
              child: TextField(
                controller: textProfileEditingController,
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
                maxLines: 4,
                onChanged: (String value) {
                  updateProfile['profileText'] = value;
                },
              ),
            ),
            //Container(child: TakePictureScreen(camera: globalCamera)),
          ]),
        ),
      ),
    );
  }
}
