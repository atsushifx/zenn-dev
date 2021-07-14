---

title: "asustor NAS : NASへのログイン用にsshキーを設定する"
emoji: "🍆"
type: "tech" # tech: 技術記事
topics: ["NAS", "terminal", "ssh", "開発環境"]
published: false

---
# tl;dr

asustor NASへのログインは、ユーザー名とパスワードで認証しています。これではセキュリティが確保できないため、sshキーを設定してssh鍵でログインするようにします。



# sshキーの作成 *(PC側)*

ssh鍵は秘密鍵と公開鍵の2つのファイルから出来ています。秘密鍵はクライアントであるPC側におき、公開鍵はサーバーであるNAS側におきます。

秘密鍵は無闇にコピーしたりするものではないため、sshキーの作成はPC側で行います。



## ssh-keygenでsshキーを作成します。

sshキーの作成は、sshキー作成ツール`ssh-keygen`を使います。ここでは、簡単なオプションの説明だけしておきます。

| ssh-keygen | オプション   | 説明                                                         |
| ---------- | ------------ | ------------------------------------------------------------ |
|            | -t ed25519   | 鍵を作成する暗号アルゴリズムを指定します。ここでは、現時点最強のed25519を使います |
|            | -f id_nas    | 生成した鍵のファイル名を指定します。他の鍵との重複を避けるため、NAS用である`id_nas`を指定しています |
|            | -C atsushifx | 公開鍵ファイルにつけるコメントです。ここでは、自身のアカウントである`atsushifx`を指定しています。 |



上記のオプションを指定して、`ssh-keygen`を実行します。端末では、次のようになります。

``` powershell
/tmp > ssh-keygen.exe -t ed25519 -f id_nas -C　atsushifx
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



これで、ssh鍵ができました。フォルダ内に、`id_nas`, `id_nas.pub`の2つのファイルがあれば作成は成功です。

作成した2つのファイルは、HOME下の`.ssh`フォルダに保存します。自分の環境は、(HOMEの上書き)[winhack-setup-myhome]をしているので、`=/.config/.ssh/`下にファイルを保存します。



# sshキーの作成 *(NAS側)*

ログイン先のNAS側には、公開鍵をおきます。次の手順で、公開鍵ファイルを配置します。

1. sshキーファイルを保存するディレクトリを作成します。標準では、自分のホームディレクトリ直下の`.ssh`フォルダになります。

   `.ssh`内では鍵ファイルの読み込み行います。そのため、`chmod`を使い、他ユーザーは宇あ読み込み専用にしておきます。

   ``` bash
   atsushifx@agartha $ mkdir .ssh
   atsushifx@agartha $ chmod 644 .ssh
   atsushifx@agartha $ 
   ```



2. ファイル共有機能を使い、`.ssh`下にPC側で作った`id_nas.pub`ファイルをコピーします。


3. コピーした`id_nas.pubファイルを読み込み専用にします。

   ```bash
   atsushifx@agartha $ chmod 444 .ssh/id_nas.pub
   
   ```



4. 以上で、公開鍵の接地は終了です

