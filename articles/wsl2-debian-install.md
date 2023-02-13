---
title: "wsl2: debianをインストールする"
emoji: "📚"
type: "tech"
topics: ["wsl", "Linux", "Debian", "インストール"]
published: true
---

## wsl2にDebianをインストールする

wsl _(Windonws-Subsystem-for-Linux)_ には、CLI で使える wsl コマンドがあります。
ここでは、上記の`wsl`コマンドを使って`Debian`をインストールします。

### wslコマンドでDebianをインストールする

次の手順で、Debian をインストールします。

1. wsl コマンドで、kernel バージョンを指定します。
    コマンドラインで、`wsl --set-default-version 2`を実行します。

   ``` :Windows Terminal
   C: /atsushifx # `wsl --set-default-version 2'
   WSL 2 との主な違いについては、https://aka.ms/wsl2
   を参照してください
   この操作を正しく終了しました。
    
   C: /atsusifx # 
   ```

2. wsl コマンドで、`Debian`をインストールします。
    コマンドラインで、`wsl --install Debian`を実行します。

   ``` :Windows Terminmal
   C: /atsushifx # `wsl --install Debian`
   インストール中: Debian GNU/Linux
   Debian GNU/Linux はインストールされました。
   Debian GNU/Linux を開始しています...
   ```

3. `Debian`コンソールが表示されるので、ユーザーとパスワードを設定します。
   コンソールで`<ユーザー名>`と`<パスワード>`を設定します。

   ``` :コンソール
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

1. 空のプロフィールを作成する
  Windows Terminal の設定を開きます。
  左のメニューをスクロールすると`+`ボタンが出てくるので、クリックします。
  `空のプロフィール`が作成されます。

2. `Debian`を設定する。
   作成した`空のプロフィール`の設定項目に Debian を設定します。
     次の項目を設定します。

   | 設定項目        | 設定       |
   | --------------- | ---------- |
   | プロフィール    | wsl Debian |
   | コマンド ライン | `wsl.exe`  |

3. ターミナルで`Debian`を起動する
  作成したプロフィールで｀Debian`を起動します。

   ``` :Windows Terminal
   atsushifx@ys:/mnt/c/Users/atsushifx$
   
   ```
  
  以上で、`Debian`の起動は終了です。以後は、ターミナル上で`Debian`を使います
