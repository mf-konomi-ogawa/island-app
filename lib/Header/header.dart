/* ヘッダー UI 部分の定義 */
import 'package:flutter/material.dart';

/* ログイン画面 ヘッダのロゴ画像 */
class _HeaderTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Image.asset('images/header/header_island_logo.png'),
        ),
        SizedBox(height: 32),
      ],
    );
  }
}

/* ログイン画面 ヘッダ設定 */
class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 0, left: 0, right: 0),
              child: _HeaderTitle(),
            ),
          ),
        ],
      ),
    );
  }
}
