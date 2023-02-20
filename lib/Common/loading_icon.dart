import 'package:flutter/material.dart';

///画面上にローディングアニメーションを表示する
Widget createProgressIndicator() {
  return Container(
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        color: Colors.green,
      ));
}
