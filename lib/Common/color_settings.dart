import 'package:flutter/material.dart';

const Color footerColor = Color(0xFF292929); /*フッターの色(一番濃い灰色)*/
const Color bgColor = Color(0xFF303237); /*暗い背景色*/
const Color bgColor2 = Color(0xFF36393F); /*背景より気持ち明るい灰*/
const Color lineColor = Color(0xFF45484E); /*投稿を区切る線の色(背景より明るい灰)*/
const Color textColor = Color(0xFFDCDDDE); /*テキストの色(白)*/
const Color textColor2 = Color.fromRGBO(112, 118, 123, 1);
const Color accentColor = Color(0xFF62CDFF); /*アクセントカラー(差し色)*/
const LinearGradient gColor = LinearGradient(
  colors: [
    Color(0xff5319bf),
    Color(0xff19cdff),
    Color(0xffff40b3),
    Color(0xffffe3bc),
  ],
); /*アクセントカラー(差し色)*/

// ボタンカラー(デザイントークンができるまで)
const Color buttonColor = Color.fromRGBO(65, 129, 255, 1);
const Color buttonColor2 = Color.fromRGBO(69, 72, 78, 1);

//投稿ボタン
const BoxDecoration gradationBox = BoxDecoration(
  shape: BoxShape.circle,
  gradient: LinearGradient(
    begin: FractionalOffset.topLeft,
    end: FractionalOffset.bottomRight,
    colors: [
      Color(0xff5319bf),
      Color(0xff19cdff),
      Color(0xffff40b3),
      Color(0xffffe3bc),
    ],
  ),
);

BoxDecoration gradationButton = BoxDecoration(
  borderRadius: BorderRadius.circular(20.0),
  gradient: const LinearGradient(
    begin: FractionalOffset.topLeft,
    end: FractionalOffset.bottomRight,
    colors: [
      Color(0xff5319bf),
      Color(0xff19cdff),
      Color(0xffff40b3),
      Color(0xffffe3bc),
    ],
  ),
);
