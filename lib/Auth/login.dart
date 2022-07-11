/*    ログイン画面    */
import 'package:apikicker/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apikicker/Header/header.dart';
import 'package:apikicker/Auth/password_reset.dart';
import 'package:apikicker/Auth/firebase_auth_error.dart';
import 'package:another_flushbar/flushbar.dart';

/* ログイン画面 認証用 state */
class LoginFormAuth extends StatefulWidget {
  // 使用するStateを指定
  @override
  _LoginForm createState() => _LoginForm();
}

/* ログイン画面 入力フォーム */
class _LoginForm extends State<LoginFormAuth> {
  // 入力されたメールアドレス
  String newUserEmail = "";
  // 入力されたパスワード
  String newUserPassword = "";
  // パスワード入力フォームでエンターキー押下でログインを実行するように
  final _loginFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        TextFormField(
//          controller: TextEditingController( text: "ryo_usagawa@mforce.co.jp" ), // デバッグ用初期値
          decoration: InputDecoration(labelText: "メールアドレス"),
          textInputAction: TextInputAction.next, // エンターキー押下後に次のフィールドへフォーカスするように設定
          autofocus: true, // 画面開いた際に自動でフォーカスするように設定
          onChanged: (String value) {
            setState(() {
              newUserEmail = value;
            });
          },
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "パスワード"),
          obscureText: true,
          onChanged: (String value) {
            setState(() {
              newUserPassword = value;
            });
          },
          onFieldSubmitted: (_) {
            //エンターキーを押した時の処理
            FocusScope.of(context).requestFocus(_loginFocusNode);
          },
        ),
        SizedBox(height: 4),
        Align(
          alignment: Alignment.topRight,
          child : Container(
            child: TextButton(
              // ボタンをクリックした時の処理
              onPressed: () {
                // "pop"で前の画面に戻る
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    // パスワードリセット画面へ遷移
                    return ResetPasswordForm();
                  }),
                );
              },
              child: Text('パスワードを忘れた'),
            ),
          ),
        ),
        SizedBox(height: 32),
        Container(
          width: double.infinity,
          // ログインボタン
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            focusNode: _loginFocusNode,
            onPressed: () async {
              // ログイン
              final FirebaseAuthResultStatus result = await signInEmail(
                newUserEmail , newUserPassword,
              );
              if( result == FirebaseAuthResultStatus.Successful ) {
                // ログイン成功
                // タイムライン画面に遷移＋ログイン画面を破棄
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final User user = auth.currentUser!;
                    return MainHome(user);
                  }),
                );
              } else {
                final errorMessage = exceptionMessage(result);
                // ログイン失敗
                Flushbar(
                    title : "失敗しました" ,
                    message : "ログインに失敗したゾ：${errorMessage}" ,
                    backgroundColor: Colors.redAccent,
                    margin: EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(8),
                    duration:  Duration(seconds: 4),
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.black,
                    )
                )..show(context);
              }
            },
            child: Text(
              'ログイン',
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(color: Colors.black, fontSize: 20),
            ),
          ),
        ),
        SizedBox(height: 36),
      ],
    );
  }
}

// ログイン機能
Future<FirebaseAuthResultStatus> signInEmail( String email, String password) async {
  FirebaseAuthResultStatus result;
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password);
    print('succeed');
    if (userCredential.user! != null) {
      result = FirebaseAuthResultStatus.Successful;
    } else {
      result = FirebaseAuthResultStatus.Undefined;
    }
  } on FirebaseAuthException catch (e) {
    print(e.code);
    result = handleException(e);
  }
  return result;
}

/* ログイン画面 */
class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: LoginFormAuth(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
