---
title: "WSL2: WSL2 に Debian をインストールする方法"
emoji: "📚"
type: "tech"
topics: ["wsl", "Linux", "Debian", "インストール"]
published: true
---

## tl;dr

`Windows WSL2`に、`Debian`をインストールするには、

1. `wsl --set-default-version 2`

2. `wsl --install -d Debian`

3. Windows Terminal を立ち上げなおす

で、できます。

これで`Windows Terminal`から`Debian`が使えるようになります。

## はじめに

wsl __(Windows Subsystem for Linux)__ には、CLI で使える wsl コマンドがあります。
ここでは、上記の`wsl`コマンドを使って`Debian`をインストールします。

### wslコマンドでDebianをインストールする

次の手順で、Debian をインストールします。

1. wsl コマンドで、kernel バージョンを指定します。
    コマンドラインで、`wsl --set-default-version 2`を実行します。

   ``` PowerShell: Windows Terminal
   # wsl --set-default-version 2
   WSL 2 との主な違いについては、https://aka.ms/wsl2
   を参照してください
   この操作を正しく終了しました。

   ```

2. wsl コマンドで、`Debian`をインストールします。
    コマンドラインで、`wsl --install -d Debian`を実行します。

   ``` PowerShell: Windows Terminal
   # wsl --install -d Debian
   インストール中: Debian GNU/Linux
   Debian GNU/Linux はインストールされました。
   Debian GNU/Linux を開始しています...
   ```

3. `Debian Console`が表示されるので、ユーザーとパスワードを設定します。
   Console で`<ユーザー名>`と`<パスワード>`を設定します。

   ``` bash: Debian Console - Windows Terminal
   Installing, this may take a few minutes...
   Please create a default UNIX user account. The username does not need to match your Windows username.
   For more information visit: https://aka.ms/wslusers
   Enter new UNIX username: atsushifx
   New password:
   Retype new password:
   passwd: password updated successfully
   Installation successful!

   atsushifx@ys:~$
   ```

以上で、`Debian`のインストールは終了です。

### Windows TerminalにDebianを登録する

インストールした`Debian`を使うために、`Windows Terminal`に`Debian`を登録します。

1. 新しいプロフィールを作成する
  Windows Terminal の設定を開きます。
  左のメニューをスクロールすると`+`ボタンが出てくるので、クリックして新しいプロフィールを作成します。

2. `Debian`を設定する。
   作成した"新しいプロフィール"の設定項目に Debian を設定します。
     次の項目を設定します。

   | 設定項目        | 設定       |
   | -- | --- |
   | プロフィール名 | wsl Debian |
   | コマンド ライン | `wsl.exe`  |

3. ターミナルで`Debian`を起動する
  作成したプロフィールで`Debian`を開始します。

   ``` bash: Debian Console - Windows Terminal
   atsushifx@ys:/mnt/c/Users/atsushifx$

   ```

以上で、`Debian`の開始は終了です。以後は、`Windows Terminal`上で`Debian`を使えます。
