---

title: "asustor NAS : NASへのログイン用にsshキーを設定する"
emoji: "🍆"
type: "tech" # tech: 技術記事
topics: ["NAS", "terminal", "ssh", "開発環境"]
published: true

---

## tl;dr

初期設定では、asustor NAS へのログインはユーザー名とパスワードで認証しています。
セキュリティが確保できないため、鍵を設定して ssh鍵でログインするようにします。

## ssh鍵の作成 ~(PC側)~

ssh 鍵は秘密鍵と公開鍵の 2つのファイルからできています。秘密鍵はクライアントである PC 側におき、公開鍵はサーバーである NAS 側におきます。

秘密鍵は無闇にコピーしたりするものではないため、ssh鍵の作成は PC 側で行います。

### ssh-keygenによるssh鍵の作成

ssh鍵の作成は、ssh鍵作成ツール`ssh-keygen`を使います。ここでは、使用したオプションの説明だけしておきます。

| ssh-keygen | オプション   | 説明                                                         |
| ---------- | ------------ | ------------------------------------------------------------ |
|            | -t ed25519   | 鍵を作成する暗号アルゴリズムを指定します。ここでは、ed25519を使います |
|            | -f id_nas    | 生成した鍵のファイル名を指定します。他の鍵との重複を避けるため、NAS用である`id_nas`を指定しています |
|            | -C atsushifx | 公開鍵ファイルにつけるコメントです。ここでは、自身のアカウントである`atsushifx`を指定しています。 |

上記のオプションを指定して、`ssh-keygen`を実行します。端末では、次のようになります。

``` powershell
 /tmp > ssh-keygen.exe -t ed25519 -f id_nas -C atsushifx
Generating public/private ed25519 key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in id_nas
Your public key has been saved in id_nas.pub
The key fingerprint is:
SHA256:FO52sgqmNjMo8Pzt2zzeqkQwpWyEJFA3m8JHBNSTtyM atsushifx
The key's randomart image is:
+--[ED25519 256]--+
|++==*.. .        |
| o.=+*.. .       |
|  o Xo .o        |
|   +Eooo         |
|     ...S .      |
|.    . . +       |
|.+  o . .        |
|o Bo + +..       |
|...=..*+=o.      |
+----[SHA256]-----+

/tmp >
```

これで、ssh 鍵ができました。フォルダ内に、`id_nas`, `id_nas.pub`の 2つのファイルがあれば作成は成功です。

作成した 2つのファイルは、HOME 下の`.ssh`フォルダに保存します。自分の環境は、[HOMEの上書き](winhack-setup-myhome)をしているので、`~/.config/.ssh/`下にファイルを保存します。

## ssh鍵の作成 ~(NAS側)~

ログイン先の NAS 側には、公開鍵をおきます。
次の手順で公開鍵ファイルを配置します。

1. .ssh ディレクトリの作成
  ssh鍵ファイルを保存するディレクトリを作成します。
  標準では、自分のホームディレクトリ直下の`.ssh`フォルダになります。
  `.ssh`内では鍵ファイルの読み込み行います。そのため、`chmod`を使い、他ユーザーは宇あ読み込み専用にしておきます。

   ``` bash
   atsushifx@agartha $ mkdir .ssh
   atsushifx@agartha $ chmod 644 .ssh
   atsushifx@agartha $ 
   ```

2. 公開鍵ファイルのコピー
  ファイル共有機能を使い、`~/.ssh`下に PC 側で作った`id_nas.pub`ファイルをコピーします。
  コピーした`id_nas.pub ファイルを読み込み専用にします。

   ```bash
   atsushifx@agartha $ chmod 444 .ssh/id_nas.pub
   
   ```

以上で、公開鍵の設置は終了です。

## rloginの設定

これで NAS に ssh鍵でログインできるようになりました。端末ソフト`rlogin`が ssh鍵でログインするように設定します。

次の手順で、rlogin を設定します。

1. rlogin の起動
   rlogin を起動し、[ファイル]-[サーバーに接続]として[Server Select]ダイアログを開きます。
   ![Server Select](https://i.imgur.com/ritfqWx.jpg)

2. サーバーの編集
   NAS サーバを選択し、[編集]をクリックして[Server Edit Entry]ダイアログを開きます。
   ![Server Edit Entry](https://i.imgur.com/cm76shE.jpg)

3. ssh鍵の設定
  [SSH 認証鍵]をクリックします。[ファイル選択]ダイアログが開くので、`id_nas`を選択します。
   ![ファイル選択](https://i.imgur.com/sW6LQei.jpg)

4. ssh鍵の設定 (2)
  [開く]をクリックします。[Server Edit Entry]ダイアログに戻るので[OK]をクリックします。
   ![Server Edit Entry](https://i.imgur.com/cm76shE.jpg)

5. 設定の保存
  [Server Select]ダイアログに戻ります。[OK]をクリックします。
   ![Server Select](https://i.imgur.com/ritfqWx.jpg)

6. 設定の保存 (2)
  [サーバーログイン]ダイアログが表示されます。[OK]をクリックします。
   ![ログイン](https://i.imgur.com/JgPSRKd.jpg)

7. 設定終了
   端末画面が表示されます。
   ![端末](https://i.imgur.com/H42JOGZ.jpg)

以上で、rlogin の設定は終了です。
