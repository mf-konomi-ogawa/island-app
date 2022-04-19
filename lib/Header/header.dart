/* ヘッダー UI 部分の定義 */
import 'package:flutter/material.dart';

/* ログイン画面のヘッダ まるーい形の描画 */
class _HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height,
        size.width,
        size.height * 0.5,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

/* ログイン画面ヘッダ */
class _HeaderBackground extends StatelessWidget {
  final double height;

  const _HeaderBackground({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _HeaderCurveClipper(),
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            colors: [
              Color(0xFF6669FD),
              Color(0xFF62E7FF),
            ],
            stops: [0, 1],
          ),
        ),
      ),
    );
  }
}

/* ログイン画面 ヘッダのロゴ画像 */
class _HeaderTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Image.asset('images/logo_dummy.png'),
        ),
        SizedBox(height: 4),
      ],
    );
  }
}

/* ログイン画面 ヘッダ設定 */
class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height = 600;
    return Container(
      height: height,
      child: Stack(
        children: [
/*          Align(
            alignment: Alignment.topCenter,
            child: _HeaderBackground(height: height),
          ),
いったんロゴ表示のため、ヘッダの background を外している
*/          Align(
            alignment: Alignment.topCenter,
            child: Padding(
//              padding: EdgeInsets.only(top: 96),
              padding: EdgeInsets.only(top: 32,left:16,right:16),
              child: _HeaderTitle(),
            ),
          ),
        ],
      ),
    );
  }
}
