# island API Kicker

アプリから API の動作確認を行うためのプロジェクトです。

## 使い方

まずは API Kicker にログインするためのアカウントを、Firebase authentication に登録してください。
以下の Firebase コンソールからユーザを追加すれば OK です。
https://console.firebase.google.com/u/1/project/island-develop/authentication/users

API Kicker を clone したら、IDE から Web / スマホエミュレータのどちらかで起動します。
(どちらでも大丈夫ですが Web の方がビルド時間が少なく、スマホエミュレータの起動も省けるので、起動確認をするだけなら Web 版をお勧めします。)
ログイン画面が表示されるので、Firebase authentication に登録したアカウントでログインします。
ホーム画面に遷移したら、現在実装されている API をコールする画面が表示されます。
