import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';

// ユーザー情報
final userPhotoUriProvider = StateProvider((ref) => '');

// 自身のユーザー情報
final ownUserNameProvider = StateProvider((ref) => '');
final ownUserPhotoUriProvider = StateProvider((ref) => '');
final ownUserProfileTextProvider = StateProvider((ref) => '');

// アクティビティ
final ownActivityContentsListProvider = StateProvider((ref) => []);
final activityContentsListProvider = StateProvider((ref) => []);
final activityDocumentIdProvider = StateProvider((ref) => '');
final activityFormAssetsUrlProvider = StateProvider((ref) => '');
final activityFormTextProvider = StateProvider((ref) => '');

// エモーション
final emotionLikeCountProvider = StateProvider((ref) => 0);

// クリップ
final clipContentsListProvider = StateProvider((ref) => []);

// 返信
final replyListProvider = StateProvider((ref) => []);
final replyFormTextProvider = StateProvider((ref) => '');

// ユーザー情報変更用
final ownUserNameStateProvider =
    StateProvider.autoDispose((ref) => TextEditingController(text: ''));

// カメラ
late CameraDescription globalCamera;
final cameraProvider = StateProvider((ref) => CameraDescription);
bool isGlobalCamera = false;
