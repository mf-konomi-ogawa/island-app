/*    ログイン画面    */
import 'package:apikicker/Home/home.dart';
import 'package:apikicker/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apikicker/Header/header.dart';
import 'package:apikicker/Auth/password_reset.dart';
import 'package:apikicker/Auth/firebase_auth_error.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* ログイン画面 */
class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

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
                child: LoginForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ログイン画面 認証用 state */
class LoginForm extends ConsumerWidget {
  LoginForm({Key? key}) : super(key: key);

  // パスワード入力フォームでエンターキー押下でログインを実行するように
  final _loginFocusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providerから値を受け取る
    final emailStateController = ref.read(emailProvider.notifier);
    final email = ref.watch(emailProvider);
    final passwordStateController = ref.watch(passwordProvider.notifier);
    final password = ref.watch(passwordProvider);

    return Column(
      children: <Widget>[
        TextFormField(
//          controller: TextEditingController( text: "ryo_usagawa@mforce.co.jp" ), // デバッグ用初期値
          decoration: const InputDecoration(labelText: "メールアドレス"),
          textInputAction: TextInputAction.next, // エンターキー押下後に次のフィールドへフォーカスするように設定
          autofocus: true, // 画面開いた際に自動でフォーカスするように設定
          onChanged: (String value) {
            // Providerから値を更新
            emailStateController.state = value;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "パスワード"),
          obscureText: true,
          onChanged: (String value) {
            passwordStateController.state = value;
          },
          onFieldSubmitted: (_) {
            //エンターキーを押した時の処理
            FocusScope.of(context).requestFocus(_loginFocusNode);
          },
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.topRight,
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
              child: const Text('パスワードを忘れた'),
            ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          // ログインボタン
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            focusNode: _loginFocusNode,
            onPressed: () async {
              // ログイン
              final FirebaseAuthResultStatus result = await signInEmail(
                email , password,
              );
              if( result == FirebaseAuthResultStatus.Successful ) {
                // ログイン成功
                // タイムライン画面に遷移＋ログイン画面を破棄
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return const Home();
                  }),
                );
              } else {
                final errorMessage = exceptionMessage(result);
                // ログイン失敗
                Flushbar(
                    title : "失敗しました" ,
                    message : "ログインに失敗しました：$errorMessage" ,
                    backgroundColor: Colors.redAccent,
                    margin: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(8),
                    duration:  const Duration(seconds: 4),
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.black,
                    )
                ).show(context);
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
        const SizedBox(height: 36),
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
