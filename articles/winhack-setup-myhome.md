---

title: "環境変数'HOME'を上書きして、オレオレ設定フォルダをつくる"
emoji: "🪟"
type: "tech"
topics: [Windows,個人開発,開発環境,カスタマイズ,hack]
published: true

---

# はじめに

Windows環境で普通にbashやvimを使うと、`Users/xxxxx/`下に大量にdotfileをつくられます*(ヒストリーなど)*。

邪魔なので、環境変数"`HOME`"を上書きすることで上記のファイルを設定フォルダ内にまとめることにしました。



# 設定フォルダについて

フォルダ名は、`.config`にしました。確かscoopが自身の情報を格納するために使っていたかがします。しかも、dotfileで最初の方に出てくるので使い勝手がいいのです。

現状、以下のようなディレクトリツリーで運用しています。

```shell
.config
  ├─ .config
  │    └─ git
  │        ignore ... globalな.gitignore
  ├─ .ssh
  └─ scoop
  .git-crendicials
  .gitconfig
```



# 環境変数"`HOME`"を設定する

次の手順で、環境変数を設定します。

1.  [Win]+R `systempropertieadvanced`とします。

    ![システムの詳細設定](https://i.imgur.com/v8t3EeQ.jpg)
    
    


2.  [システムのプロパティ]画面が表示されます。[環境変数(N)]をクリックします。

    ![システムのプロパティ](https://i.imgur.com/JLDm0Be.jpg)
    
    


3.  [環境変数]画面が表示されます

    ![](https://i.imgur.com/evyEYgP.jpg)
    
    


4.  [新規(N)]をクリックします。[ユーザー変数の編集]ダイアログが出てくるので、変数名に`HOME`、変数値に`%USERPROFILE%\.config`を入力して、[OK]をクリックします。

    ![](https://i.imgur.com/VLxW95x.jpg)
    
    


5.  [環境変数]画面に戻ります。ユーザー環境変数`HOME`が追加されています。

    ![環境変数](https://i.imgur.com/J9SlPHc.jpg)
    
    

6.  [OK]をクリックし、[環境変数]画面を閉じます。同様にして、[システムのプロパティ]画面を閉じます。

  

7.  以上で、環境変数`HOME`の設定は終了です。



# 環境変数`HOME`を設定する: <sub>(スクリプト)</sub>

環境変数の設定は、Powershellスクリプトでもできます。セットアップスクリプトのために、やり方を書いておきます。

まずは、スクリプトから

``` envSetup.ps1

#
# system variable refer
$sysEnv = [System.Environment]

# HOME
$newHOME=$env:USERPROFILE + "/.config"
$env:HOME = $newHOME
$sysEnv::SetEnvironmentVariable("HOME", $newHOME, "USER")

```


環境変数を設定するには、`setEnvironmentVariable`メソッドを使います。このとき、ユーザー環境変数かシステム環境変数かを指定する必要があります。
ここではユーザー環境変数を設定するので第3引数に"USER"を指定しています。システム環境変数の場合は第3引数に"MACHINE"を指定します。

環境変数は、システム環境に設定するので変数$sysEnvに`[System.Environment]`を代入しています。

以後、Windowsのセットアップ時にこのスクリプトを実行すれば環境変数`HOME`を設定するようになります。

