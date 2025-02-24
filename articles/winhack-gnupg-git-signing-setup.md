---
title: "WinHack: WindowsでGnuPGによる署名付きコミットを確実に実現する設定方法"
emoji: "🔧"
type: "tech"
topics: ["Windows", "GnuPG", "Gpg4win", "署名" ]
published: false
---

## はじめに

atsushifx です。
この記事では、開発環境の構築時に、`GnuPG`を使って署名付きコミットを実現する手順を解説します。
`Git`の設定によっては`git commit`ができなくなる問題の回避方法についても解説しています。

## 1. `GnuPG`のインストールと設定

### 1.1 環境変数`GNUPGHOME`の設定

設定ファイルは、`${USERPROFILE}`下に置かないというポリシーにもとづき、環境変数を設定します。
以下のコマンドを実行します。

```powershell
[System.Environment]::SetEnvironmentVariable("GNUPGHOME", "${env:AppData}\gnupg", "User")
```

設定をシェルに反映させるため、`Windows Terminal`を再起動します。
以下のコマンドで、設定を確認できます。

```powershell
echo $env:GNUPGHOME
C:\Users\<ユーザー名>\AppData\Roaming\gnupg
```

上記のように、`AppData\Roaming`となっていれば正常に設定されています。

### 1.2 `Gpg4win`のインストール

`winget`を使って、`Gpg4win`をインストールします。
以下のコマンドを実行します。

```powershell
winget install GnuPG.Gpg4win --interactive --location C:\app\develop\utils\gpg4win
```

これで、`c:\app\develop\utils\gnupg`に`GnuPG`本体が、`c:\app\develop\utils\gpg4win`に`Windows用クライアント`がインストールされます。

:::message warn
インストール先を`...\gnupg`とすると、`GnuPG`と`gpg4win`が同一のディレクトリにインストールされます。
この場合、コマンドが競合して意図しないコマンドを実行する可能性があります。

:::

### 1.3 システム`Path`への追加

`Gpg4win`および`Gnupg`をシェルから容易に実行できるよう、`Path`にそれぞれのディレクトリを追加します。
追加するのは:

- `c:\app\develop\utils\gnupg`:   `GnuPG`本体
- `c:\app\develop\utils\gpg4win`: `Windows用クライアント`

の 2つです。

以下のシェルスクリプトを実行し、パスを追加します。

@[gist](https://gist.github.com/atsushifx/1e5b2afaff42dbab9b840620130e72e5?file=add_gnupg_path.ps1)

インストール時に追加された `C:\app\develop\utils\gpg4win\..\gnupg\bin` は、必要がなくなったので削除しておきます。

`Windows Terminal`を再起動して編集後の`Path`をシェルに反映させます。
以上で、`PowerShell`上で`GnuPG`が使えるようになります。

### 2.4 設定ファイル (`gpg.conf`等) の作成

`GnuPG`を動作を設定するため設定ファイルを作成します。
これらは`dotfiles`リポジトリで管理するため、`${XDG_CONFIG_HOME}/gnupg`下に設定ファイルを作成し、`${GNUPGHOME}`下にシンボリックリンクします。

まずは、以下の設定ファイルを作成します。

- `gpg.conf`:
  @[gist](https://gist.github.com/atsushifx/1e5b2afaff42dbab9b840620130e72e5?file=gpg.conf)

- `gpg_agent.conf`:
  @[gist](https://gist.github.com/atsushifx/1e5b2afaff42dbab9b840620130e72e5?file=gpg_agent.conf)

- `dirmngr.conf`:
  @[gist](https://gist.github.com/atsushifx/1e5b2afaff42dbab9b840620130e72e5?file=dirmngr.conf)

つぎに、以下のインストールスクリプトを実行します。

@[gist](https://gist.github.com/atsushifx/1e5b2afaff42dbab9b840620130e72e5?file=install_gpgconf.ps1)

これにより、`${GNUPGHOME}`下に設定ファイルのシンボリックリンクが作成され、`GnuPG`が設定を参照できます。

## 2. 署名付きコミットの実現

この章では、`GitHub`に署名付きコミットをするための手順を説明します。

### 2.1 `Git`用`GPG鍵`の作成

署名をするために、`GnuPG`で`GPG鍵`を作成する必要があります。
`Windows Terminal`で`gpg --full-generate-key`を実行し、質問に答えれば`GPG 鍵`が作成されます。

詳しい方法は、[`GPGチートシート`](https://zenn.dev/shuh/articles/gpg-cheatsheet) を参照してください。

今回の`GPG鍵`の設定項目は、次のようになります。

| 設定項目 | 設定 | 説明 | 備考 |
| --- | --- | --- | --- |
| 有効期限 | 3y | |  |
| 本名 | [Your Name] | | `GitHub`のハンドルと同一にする |
| 電子メールアドレス | [Your Email] | `GitHub`に登録したEメールアドレス | `gpg.conf`にも同一の設定 |
| パスフレーズ | [Your Pass phrase] |  | 簡単にばれないようなパスフレーズを作成する |

上記以外の質問は、デフォルトの選択とします。

作成した`GPG鍵`は、以下のコマンドで確認ができます。

```powershell
gpg --list-keys --keyid-format=long

[keyboxd]
---------
pub   ed25519/CF658DD4B12C3FE5 2025-02-20 [SC] [有効期限: 2028-02-20]
      EA13413644F0FF3BE792A291CF658DD4B12C3FE5
uid                 [  究極  ] Furukawa Atsushi <atsushifx@gmail.com>
sub   cv25519/30D808FC247E1BAF 2025-02-20 [E] [有効期限: 2028-02-20]
```

上記のような表示がされていれば、鍵が正常に作成されています。

### 2.2 `Git`のグローバル設定

作成した`GPG鍵`で署名付きコミットをするために、`Git`のグローバル設定を変更します。
`Git`のグローバル設定 (`${XDG_CONFIG_HOME}/git/config`) に、以下の設定を追加します。

```bash: ${XDG_CONFIG_HOME}/git/config
[commit]
  gpgsign = true                    # GPGで署名する

[user]
  signingkey = atsushifx@gmail.com  # GPG鍵に設定したメールアドレス

[gpg]
  program = "C:/app/develop/utils/gnupg/bin/gpg.exe"  # 署名に使用する`GnuPG`

```

:::message warn
`gpg.program`は、正しいパスをフルパスを指定する必要があります。
指定しない場合は、エラーでコミットできなくなります。

:::

上記のように設定することで、コミット時に自動的に`GnuPG`の署名が有効になります。

コミットを行なうと以下のダイアログが表示されます。
![パスフレーズ入力](/images/articles/gnupg-setup/ss-gpg-signing-dialog.png)
*パスフレーズ入力*

正しいパスフレーズを入れてコミットすると、署名付きコミットになります。

### 2.3 `GitHub`への公開鍵登録

`GitHub`に上記の`GPG鍵`を登録することで、`GitHub`上のコミットが認証済み (`verified`) となります。
これにより、自分の `GitHubリポジトリ` の信頼性を高めることができます。

:::message
`verified`にするためには、`GPG`鍵のメールアドレスが`GitHub`で認証済みである必要があります。
:::

以下の手順で、`GPG鍵`を登録します。

1. `鍵ID`の確認:
   次のコマンドで、`GPG`鍵を確認します。

   ```powershell
   gpg --list-keys --keyid-format=long
   [keyboxd]
   ---------
   pub   ed25519/CF658DD4B12C3FE5 2025-02-20 [SC] [有効期限: 2028-02-20]
         EA13413644F0FF3BE792A291CF658DD4B12C3FE5
   uid                 [  究極  ] Furukawa Atsushi <atsushifx@gmail.com>
   sub   cv25519/30D808FC247E1BAF 2025-02-20 [E] [有効期限: 2028-02-20]
   ```

   このとき、`pub`のあとの`CF658DD4B12C3FE5`が`鍵ID`です。

2. 公開鍵の出力:
   次のコマンドで、公開鍵を出力します。`鍵ID`は 1. で確認した門を使用します。

   ```powershell
   gpg --armor  --export CF658DD4B12C3FE5 --output public-key.asc
   ```

   作成されたファイルは、

   ```ascii
   -----BEGIN PGP PUBLIC KEY BLOCK-----

   abcdxxxx
    .
    .
   -----END PGP PUBLIC KEY BLOCK-----
   ```

   という形式になっています。

3. `GitHub`にアクセス:
   [`GitHub - SSH and GPG keys`](https://github.com/settings/keys) にアクセスします。
   [`GitHub`](https://github.com/) からは、[右上のアイコン]-[Settings]を開き、左サイドのメニューで[SSH and GPG keys]を選択します。

   ![SSH and GPG keys](/images/articles/gnupg-setup/ss-github-gpg-keys.png)
   *SSH and GPG keys*

4. 公開鍵の貼り付け:
  [`New GPG Key`]をクリックします。[`Add new GPG key`]画面が表示されるので、タイトルと公開鍵を貼り付け、[`Add GPG key`]をクリックします。

   ![Add new GPG key](/images/articles/gnupg-setup/ss-github-gpg-add-key.png)
   *Add new GPG key*

   :::message
   公開鍵は、1.で作成したファイル`public-key.asc`の内容です
   :::

以上で、公開鍵の登録は完了です。
登録後は、`GitHub`上のコミットが認証済みとなります。

## 3. トラブルシューティング

この章では、`GnuPG`に関する簡単なトラブルシューティングを載せておきます。

- [`TB-0001`]: `gpg: invalid size of lockfile`と出力されて、コミットできない。
  検索`Path`、実行時`Path`に空白が含まれていると、このエラーが出ます。
  `Git`の設定で、フルパスかつ`"`で囲むとエラーは発生しません。

  `gpg.exe`が存在する`Path`を確認し、`program`を再設定してください。

  ```git/config
  # error発生
  program = gpg.exe

  # 正常に動く
  program = "C:/app/develop/utils/gnupg/bin/gpg.exe"
  ```

## おわりに

今回の記事では、`Windows`環境上の`Git`で署名付きコミットをするための手順を説明しました。
`Gpg4win`のインストール、`Git`の設定、`GitHub`への公開鍵の登録までステップごとに解説したので、わかりやすく環境が構築できるでしょう。

記事での設定手順やトラブルシューティングを参考にすれば、署名付きコミットの環境が構築できるでしょう。
各自の開発環境に合わせてカスタマイズするときの参考になれば幸いです。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [`GPG`チートシート](https://zenn.dev/shuh/articles/gpg-cheatsheet):
  `GnuPG`でよく使うコマンドの解説。鍵の作成、共有方法など

- [`Git` のさまざまなツール - 作業内容への署名](https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E3%81%95%E3%81%BE%E3%81%96%E3%81%BE%E3%81%AA%E3%83%84%E3%83%BC%E3%83%AB-%E4%BD%9C%E6%A5%AD%E5%86%85%E5%AE%B9%E3%81%B8%E3%81%AE%E7%BD%B2%E5%90%8D):
  `Git`でコミットなどに署名をする方法

- [`GitHub` - コミット署名の検証を管理する](https://docs.github.com/ja/authentication/managing-commit-signature-verification):
  `GitHub`にて、コミットが認証済みかどうかを管理する方法
