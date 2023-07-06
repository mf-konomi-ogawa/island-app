import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:apikicker/Provider/user_provider.dart';
import 'package:apikicker/main.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:apikicker/Common/flushbar.dart';
import 'package:apikicker/Common/color_settings.dart';

// 撮影した写真を表示する画面
class DisplayPictureScreen extends ConsumerWidget {
  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  final String imagePath;

  // 撮影した写真を Storage にアップロードする
  void _uploadPic(BuildContext context, WidgetRef ref) async {
    try {
      // ファイルパスを設定
      File file = File(imagePath);
      // Storage にファイルアップロード
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('よろしいですか？'),
        backgroundColor: bgColor2,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _uploadPic(context, ref);
              int count = 0;
              Navigator.popUntil(context, (_) => count++ >= 2);
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Center(child: Image.file(File(imagePath))),
    );
  }
}
