---
title: "カスタムDebian: WSL2 に Debian をインストールする方法"
emoji: "📚"
type: "tech"
topics: ["wsl", "Linux", "Debian", "インストール"]
published: false
---

## tl;dr

`Windows Terminal`で次のコマンドを実行し、`WSL`に`Debian`をインストールします。

:::message alert
`WSL2`を使用するために、`Windows 11`を推奨します
:::

1. `wsl --set-default-version 2`を実行
2. `wsl --install -d Debian`を実行
3. `Windows Terminal` を再起動

これで`Debian`を使用できます。

## はじめに

この記事では、`WSL`を使用した`Debian`をインストール方法を紹介します。
`WSL`を使用すると、`PC`に`Linux`をインストールした場合と同様の環境を構築できます。

`WSL` を使うためには、`wsl`コマンドを使用して`Linux`をインストールする必要があります。
この記事では、`Linuxディストリビューション` の 1つである Debian をインストールします。

## 1. 既定バージョンの指定

`WSL`には`WSL1`と`WSL2`があり、`WSL2`は`Windows`の仮想化技術を活用し、より高い互換性を実現しています。
この記事では、`WSL2`を使用して`Debian`をインストールします。

### 1.1 WSL2 を選ぶ理由

`WSL2`は、`Windows`の仮想化技術を活用し、`WSL1`よりも高いパフォーマンスと互換性を提供します。
主なメリットは次のとおりです。

- **フル機能の Linuxカーネル**:
  `Linuxカーネル`搭載により、多数の`Linuxアプリ`が利用可能

- **コンテナ環境への対応**:
  `Docker`などのコンテナ環境に対応し、開発用途に最適

### 1.2 既定としてWSL2を指定する

`WSL`を使うときには、`WSL1`、`WSL2`のどちらを使用するかを指定する必要があります。
`wsl --set-default-version`コマンドを用い、バージョンを指定します。

1. `wsl --set-default-version`コマンドで、バージョンを指定する

   ```powershell
   wsl --set-default-version 2
   ```

   実行結果は、次のとおりです。

   ```PowerShell
   C: > wsl --set-default-version 2

   WSL 2 との主な違いについては、<https://aka.ms/wsl2>
   を参照してください
   この操作を正しく終了しました。

   C:  >
   ```

2. `wsl --status`で既定のバージョンを確認する
   次のコマンドで、既定のバージョンを確認します。

   ```powershell
   wsl --status
   ```

   実行結果は、次のとおりです。

   ```powershell
   C: > wsl --status
   既定のディストリビューション: Debian
   既定のバージョン: 2

   C: >
   ```

`既定のバージョン: 2`と表示されていれば、設定は成功しています。

## 2. Debianのインストール

`WSL`は、`wsl`コマンドで`WSL`を設定します。
今回は、`wsl`コマンドを使って `Debian` をインストールします。

## 2.1. wslコマンドでDebianをインストールする

`wsl --install`コマンドを使用して`Debian`をインストールします。
次の手順で、Debian をインストールします。

1. `wsl --install`コマンドで`Debian`をインストールする

   ```powershell
   wsl --install -d Debian
   ```

   実行結果は、次のようになります

   ```powershell
   C: > wsl --install -d Debian
   インストール中: Debian GNU/Linux
   Debian GNU/Linux はインストールされました。
   Debian GNU/Linux を開始しています...

   ```

2. `UNIXユーザー`を作成する
   ユーザー名を設定するプロンプトが表示されます。
   `ユーザー名`、`パスワード`を設定して、`UNIXユーザー`を作成します。

   ```powershell
   Please create a default UNIX user account. The username does not need to match your Windows username.
   For more information visit: <https://aka.ms/wslusers>
   Enter new UNIX username: poweruser

   New password:
   Retype new password:

   ```

   :::message alert
   パスワードは画面に表示されません。
   また、安全性を考慮し、Windows とは異なるパスワードを設定することが推奨されます。
   :::

以上で、`Debian`のインストールは終了です。

## 3. Windows Terminalの設定

### 3.1 シェルメニューに`Debian`を追加する

`Windows Terminal`のプロファイルには、`Debian`が自動的に登録されます。
再起動後は、`Terminal`のシェルメニューに`Debian`のプロファイルが自動的に表示されます。

![シェルメニュー](/images/articles/wsl2-debian/wt-shellmenu.png)

## 4. トラブルシューティング

### 4.1 代表的なトラブルと対処法

- `WSL 2` を既定バージョンに設定できない:
  `WSL`の更新が必要です。`wsl --update`を実行して、`WSL`を最新の状態に更新してください

- インストールが進まない場合:
  `WSL`が無効の場合があります。「`Windows` の機能の有効化または無効化」で`Linux 用Windows サブシステム`が有効になっているか、確認してください。

- `Debian`のダウンロードが進まない場合:
  `Microsoft Store`から手動で`Debian`をインストールできます。`Store`で`Debian`を選択し、インストールを実行してください。

- `シェルメニュー`に`Debian`が追加されない。
  `Debian`用のプロファイルを追加すると、シェルメニューに表示されます。
  `Windows Terminal`の[設定]で設定画面を開き、[新しいプロファイルを追加します]で`Debian`を追加してください。

## おわりに

以上で、`Windows`上に`Debian`がインストールできました。
これにより多くの Linux 用ツールやアプリ (例:`Docker`, `Node.js`)が使用できるようになり、開発の幅が広がります。

次回からは、インストールした`Debian`をカスタマイズして、開発環境を構築する手順を紹介します。
カスタマイズした`Debian`をコピーすることで、勉強用などの各種開発環境が簡単に構築できます。

まずは、使いやすい`Debian`環境を構築しましょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- <https://learn.microsoft.com/ja-jp/windows/wsl/install>:
  `WSL` を使用して`Windows`に`Linux`をインストールする方法。
- <https://learn.microsoft.com/ja-jp/windows/wsl/basic-commands>:
  `WSL` の基本的なコマンド。
