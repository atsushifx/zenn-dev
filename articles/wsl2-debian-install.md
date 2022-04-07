---
title: "wsl2: debianをインストールする"
emoji: "📚"
type: "tech"
topics: ["wsl2", "Debian", "インストール"]
published: false
---

## wsl2にDebianをインストールする

wsl~(Windonws-Subsystem-for-Linux)~には、CLIで使えるwslコマンドがあります。
ここでは、上記の`wsl`コマンドを使って`Debian`をインストールします。

### wslコマンドでDebianをインストールする

次の手順で、Debianをインストールします。

1. wslコマンドで、kernelバージョンを指定します。

  ``` :PowerShell
  C: /atsushifx # `wsl --set-default-version 2'
  WSL 2 との主な違いについては、https://aka.ms/wsl2
  を参照してください
  この操作を正しく終了しました。
  
  C: /atsusgifx # 
  ```

2. wslコマンドで、Debianをインストールします。

  ``` :PowerShell
  C: /atsushifx # `wsl --install Debian`
  インストール中: Debian GNU/Linux
  Debian GNU/Linux はインストールされました。
  Debian GNU/Linux を開始しています...
  ```

3. Debianコンソールが表示されるので、ユーザーとパスワードを設定します。
  
  ``` :bash
  Installing, this may take a few minutes...
  Please create a default UNIX user account. The username does not need to match your Windows username.
  For more information visit: https://aka.ms/wslusers
  Enter new UNIX username: `atsushifx`
  New password: 
  Retype new password:
  passwd: password updated successfully
  Installation successful!
  
  atsushifx@ys:~$
  ```

4. Debianコンソールを閉じ、Windows Terminalを再起動します。
