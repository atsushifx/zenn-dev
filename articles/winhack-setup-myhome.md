---
title: "Windows: hacks: 環境変数'HOME'を上書きして、オレオレ設定フォルダをつくる"
emoji: "🪟"
type: "tech"
topics: [Windows,開発環境,カスタマイズ,hack]
published: false

---

:::message

2021年12月24日 改訂。

:::

## tl;dr

環境変数"`HOME`"を設定すると、UNIX 系ツールの設定ファイルが Windows とは別のディレクトリに保存できます。

## はじめに

Windows 環境で bash や vim を使うと、$USERPROFILE ~(通常なら、`(C:\Users\<ユーザ名>\`))~下に大量に dotfile がつくられます。
例えば`.bash_history`や`.lesshst'のようなヒストリーファイル、`.bashrc`のような設定ファイルといった具合です。

これらの各種 dotfile は、ホームディレクトリ下に置かれます。
しかし、Windows の場合はすでに Documents や Downloads のような各種フォルダがおかれていますし、各種のシステムファイルもおかれています。

さらに bash の設定などの dotfile がこのディレクトリに含まれると邪魔です。そのため、環境変数"`HOME`"を上書きすることで上記のファイルを設定フォルダ内にまとめました。

## ホームディレクトリについて

### ホームディレクトリとは

ホームディレクトリは、ユーザーがコンピュータを使ううえで基準になるディレクトリです。Windows では、通常`C:\Users\<ユーザ名>`となります。
`Windows Terminal`では、`~`でホームディレクトリを示します。Terminal 上で、`cd ~`とすればホームディレクトリに移動します。

### 環境変数"`HOME`"と"`USERPROFILE`"

ホームディレクトリはユーザーごとに場所が変わります。また、PC のハードウェア環境によっても替わります。
データ用に Dドライブを増設してホームを Dドライブに移動した場合は、ホームディレクトリは"`D:\Users\<ユーザー>`"となります。

このためホームディレクトリは環境変数に格納されて、各種アプリは環境変数の値をもとに自身の設定ファイルを探します。
ホームディレクトリは、UNIX/Linux 系 OS では"`HOME`"に、Windows では"`USERPROFILE`"に格納されています。

### 設定フォルダについて

上記のことから Windows で環境変数"`HOME`"を設定すると、各種設定ファイルの位置を`$USERPROFILE'下から移動できます。

この各種設定ファイルを格納するフォルダ~(設定フォルダ)は、
フォルダ名は、`.config`にしました。確か scoop が自身の情報を格納するために使っていたかがします。しかも、dotfile で最初の方に出てくるので使い勝手がいいのです。

現状、以下のようなディレクトリツリーで運用しています。

 ``` PowerShell: ~/.config
 .config
   ├─ .config
   │    └─ git
   │        ignore ... globalな.gitignore
   ├─ .ssh
   └─ scoop
   .git-crendicials
   .editorconfig
   .gitconfig

 ```

## 環境変数"`HOME`"を設定する

次の手順で、環境変数を設定します。

1. [システムの詳細設定]を開く
  [Win]+R とし、[ファイル名を指定して実行]画面に`systempropertieadvanced`と入力して実行します。

   ![systempropertiesadvanced 実行](https://i.imgur.com/v8t3EeQ.jpg)

2. [環境変数]を開く
  [システムのプロパティ]画面が表示されます。[環境変数(N)]をクリックします。

   ![システムのプロパティ](https://i.imgur.com/JLDm0Be.jpg)

3. [環境変数]画面
  [環境変数]が表示されます。

   ![環境変数](https://i.imgur.com/evyEYgP.jpg)

4. "`HOME`"の追加
  [新規(N)]をクリックします。[ユーザー変数の編集]ダイアログが出てくるので、変数名に`HOME`、変数値に`%USERPROFILE%\.config`を入力して、[OK]をクリックします。

    ![新しいユーザー変数](https://i.imgur.com/VLxW95x.jpg)

5. "`HOME`"の保存
  [環境変数]画面に戻ります。ユーザー環境変数`HOME`が追加されています。

   ![環境変数](https://i.imgur.com/J9SlPHc.jpg)

6. アプリの終了
  [OK]をクリックし、[環境変数]画面を閉じます。
   同様にして、[システムのプロパティ]画面を閉じます。

以上で、環境変数`HOME`の設定は終了です。

### 環境変数`HOME`を設定する: *(PowerShellスクリプト版)*

環境変数の設定は、PowerShell script でもできます。セットアップスクリプトのために、やり方を書いておきます。
スクリプトは、次のようになります。

 ``` PowerShell: envSetup.ps1
 
 #
 # system variable refer
 $sysEnv = [System.Environment]

 # HOME
 $newHOME=$env:USERPROFILE + "/.config"
 $env:HOME = $newHOME
 $sysEnv::SetEnvironmentVariable("HOME", $newHOME, "User")

 ```

環境変数を設定するには、`setEnvironmentVariable`メソッドを使います。このとき、ユーザー環境変数かシステム環境変数かを指定する必要があります。
ここではユーザー環境変数を設定するので第3引数に"User"を指定しています。システム環境変数の場合は第3引数に"Machine"を指定します。

環境変数は、システム環境に設定するので変数$sysEnv に`[System.Environment]`を代入しています。
以後、Windows のセットアップ時にこのスクリプトを実行すれば環境変数`HOME`を設定するようになります。

## まとめ

環境変数"`HOME`"を設定して、各種設定ファイルを"`USERPROFILE`"下から分離しました。
これにより、GitHub を利用して設定ファイルが共有できるようになりました。
