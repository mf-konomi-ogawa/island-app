import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apikicker/Header/header.dart';
import 'package:another_flushbar/flushbar.dart';

/* パスワードリセット画面 */
class ResetPasswordForm extends StatefulWidget {
  @override
  ResetPasswordFormState createState() => ResetPasswordFormState();
}

/* パスワードリセット画面ボディ */
class ResetPasswordFormState extends State<ResetPasswordForm> {
  // 入力されたメールアドレス
  String resetEmail = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Header(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: TextButton(
                  // ボタンをクリックした時の処理
                  onPressed: () {
                    // "pop"で前の画面に戻る
                    Navigator.of(context).pop();
                  },
                  child: Text('ログイン画面に戻る'),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: TextFormField(
                  decoration: InputDecoration(labelText: "メールアドレス"),
                  onChanged: (String value) {
                    setState(() {
                      resetEmail = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                // リセットボタン
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final result = await FirebaseAuth.instance.sendPasswordResetEmail(email: resetEmail);
                      setState(() {
                        Flushbar(
                            title : "リセット用メールを送信しました" ,
                            titleColor: Colors.black,
                            message : "パスワードリセット用メールを送信しました。メールを確認してください。" ,
                            messageColor: Colors.black,
                            backgroundColor: Colors.greenAccent,
                            margin: EdgeInsets.all(8),
                            borderRadius: BorderRadius.circular(8),
                            duration:  Duration(seconds: 4),
                            icon: Icon(
                              Icons.info_outline,
                              color: Colors.black,
                            )
                        )..show(context);
                      });
                    } catch (e) {
                      setState(() {
                        Flushbar(
                            title : "失敗しました" ,
                            message : "リセットに失敗したゾ：${e.toString()}" ,
                            backgroundColor: Colors.redAccent,
                            margin: EdgeInsets.all(8),
                            borderRadius: BorderRadius.circular(8),
                            duration:  Duration(seconds: 4),
                            icon: Icon(
                              Icons.info_outline,
                              color: Colors.black,
                            )
                        )..show(context);
                      });
                    }
                  },
                  child: Text(
                    'パスワードリセット',
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
