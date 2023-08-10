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
import 'package:apikicker/Common/color_settings.dart';
import 'package:apikicker/Common/loading_icon.dart';

/* ログイン画面 */
class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
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
    final firestore = ref.read(firebaseFirestoreProvider);

    //final testtext = ref.watch(userProvider);

    //print("testtext = $testtext");

    return Column(
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(
            labelText: "メールアドレス",
            labelStyle: TextStyle(color: textColor),
          ),
          style: TextStyle(color: textColor),
          textInputAction:
              TextInputAction.next, // エンターキー押下後に次のフィールドへフォーカスするように設定
          onChanged: (String value) {
            // Providerから値を更新
            emailStateController.state = value;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "パスワード",
            labelStyle: TextStyle(color: textColor),
          ),
          style: TextStyle(color: textColor),
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
        MaterialButton(
          focusNode: _loginFocusNode,
          splashColor: accentColor,
          padding: EdgeInsets.all(2.0),
          textColor: textColor,
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: gradationButton,
            child: const Padding(
              padding: EdgeInsets.all(12.0), // ボタンの大きさ
              child: Text(
                "ログイン",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          onPressed: () async {
            // ログイン
            final FirebaseAuthResultStatus result = await signInEmail(
              email,
              password,
            );

            if (result == FirebaseAuthResultStatus.Successful) {
              // 認証成功

              //firestoreからtempUserListを作成
              var userDocumentSnapShot = await firestore
                  .collection("Organization")
                  .doc("IXtqjP5JvAM2mdj0cntd")
                  .collection("space")
                  .doc("nDqwJANhr1evjCBu5Ije")
                  .collection("Person")
                  .get();
              List<dynamic> tempUserList = [];
              userDocumentSnapShot.docs.forEach((doc) {
                Map<String, dynamic> userInfo = {
                  "id": doc.id,
                };
                userInfo.addAll(doc.data());
                tempUserList.add(userInfo);
              });
              //tempUserListにログイン時に入力されたメールアドレスが含まれるか確認する
              final emailExists = "$tempUserList".contains("$email");
              if (emailExists) {
                //tempUserListにメールアドレスが存在する場合
                // タイムライン画面に遷移＋ログイン画面を破棄
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return const Home();
                  }),
                );
              } else {
                //tempUserListにメールアドレスが存在しない場合
                //ログイン失敗
                final errorMessage = "権限がありません";
                Flushbar(
                    title: "失敗しました",
                    message: "ログインに失敗しました：$errorMessage",
                    backgroundColor: Colors.redAccent,
                    margin: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(8),
                    duration: const Duration(seconds: 4),
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.black,
                    )).show(context);
              }
            } else {
              final errorMessage = exceptionMessage(result);
              // ログイン失敗
              Flushbar(
                  title: "失敗しました",
                  message: "ログインに失敗しました：$errorMessage",
                  backgroundColor: Colors.redAccent,
                  margin: const EdgeInsets.all(8),
                  borderRadius: BorderRadius.circular(8),
                  duration: const Duration(seconds: 4),
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.black,
                  )).show(context);
            }
          },
        ),
      ],
    );
  }
}

// ログイン機能
Future<FirebaseAuthResultStatus> signInEmail(
    String email, String password) async {
  FirebaseAuthResultStatus result;
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    print('login succeed');
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
