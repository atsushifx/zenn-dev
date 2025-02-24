---
title: "WinHacks: Windows で GnuPG による署名付きコミットを確実に実現する設定方法"
emoji: "🔧"
type: "tech"
topics: ["Windows", "GnuPG", "Gpg4win", "署名" ]
published: true
---

## はじめに

atsushifx です。

この記事では、開発環境で `GnuPG` を用いた署名付きコミットを設定する手順を説明します。
`Git` の設定によって署名付きコミットが失敗する問題とその対処法についても説明します。

## 技術用語

この記事で使用される、主要な技術用語について解説します。

- `GnuPG`:
  `GNU` プロジェクトが開発した、公開鍵暗号方式によるデータ暗号化と電子署名のためのオープンソースツール

- `Gpg4win`:
  Windows 向けに`GUI`ツール、暗号化ツール、証明書管理ツールを含んだ、総合`GnuPG`パッケージ

- `Git`:
  分散型バージョン管理システム

- `署名付きコミット`:
  `Git`で開発者が電子署名を付与し、改ざん防止と認証をするためのコミット手法

- `GNUPGHOME`:
  `GnuPG` の設定ファイルを格納するディレクトリを指定する環境変数

## 1. `GnuPG`のインストールと設定

`Windows` 環境での`GnuPG`のインストールと設定方法を解説します。
環境変数の設定、`Gpg4win`のインストール、システム`Path`への追加、設定ファイルの作成およびリンクを設定し、シェル上での動作環境を整えます。

### 1.1 環境変数`GNUPGHOME`の設定

通常、`GnuPG` の設定ファイルは `${USERPROFILE}/.gnupg` に配置されます。
これを、`Windows` の既定の設定ディレクトリ `~/AppData/Roaming`内に配置するため、環境変数 `GNUPGHOME` を設定します。

以下のコマンドで、環境変数を設定します。

```powershell
[System.Environment]::SetEnvironmentVariable("GNUPGHOME", "${env:AppData}\gnupg", "User")
```

以上で、`User`環境変数に`GNUPGHOME`が設定されるので、`Windows Terminal`を再起動し、設定を反映させます。
以下のコマンドを実行し、環境変数を確認します。

```powershell
echo $env:GNUPGHOME
C:\Users\<ユーザー名>\AppData\Roaming\gnupg
```

上記のように、`AppData\Roaming`となっていれば正常に設定されています。

### 1.2 `Gpg4win`のインストール

`winget`を使って`Gpg4win`をインストールします。次のコマンドを実行します。

```powershell
winget install GnuPG.Gpg4win --interactive --location "C:\app\develop\utils\gpg4win"
```

このとき、`GnuPG`パッケージも一緒にインストールされ、`c:\app\develop\utils\gnupg` には `gpg`バイナリが配置されます。
`c:\app\develop\utils\gpg4win` には `Windows用クライアント` がインストールされます。

:::message alert
インストール先を`...\gnupg`とすると、`gpg`と`gpg4win`が同一のディレクトリにインストールされます。
この場合、異なるバージョンの`GnuPG`バイナリと競合し、`gpg.exe` が正しく動作しない可能性があります。

:::

### 1.3 システム`Path`への追加

システム`Path`にディレクトリを追加し、シェル上から`gpg.exe`を実行できるようにします。

- `C:\app\develop\utils\gnupg\bin`    (`gpg`およぼ各種バイナリ)
- `C:\app\develop\utils\gpg4win\bin`  (`Windows用クライアント`)

の 2つです。

以下のシェルスクリプトを実行し、パスを追加します。

@[gist](https://gist.github.com/atsushifx/1e5b2afaff42dbab9b840620130e72e5?file=add_gnupg_path.ps1)

インストール時に追加された `C:\app\develop\utils\gpg4win\..\gnupg\bin` は、必要がなくなったので削除しておきます。

`Windows Terminal` を再起動し、編集後の `Path` をシェルに反映させます。
これで、`PowerShell`上で `gpg` が使用できます。

### 1.4 設定ファイル (`gpg.conf`等) の作成

`GnuPG`の動作を定義する設定ファイルを作成します。
これらは`dotfiles`リポジトリで管理するため、`${XDG_CONFIG_HOME}/gnupg`下に設定ファイルを作成し、`${GNUPGHOME}`下にシンボリックリンクします。

1. 設定ファイルを作成する。
   - `gpg.conf`:
     @[gist](https://gist.github.com/atsushifx/1e5b2afaff42dbab9b840620130e72e5?file=gpg.conf)

   - `gpg_agent.conf`:
     @[gist](https://gist.github.com/atsushifx/1e5b2afaff42dbab9b840620130e72e5?file=gpg_agent.conf)

   - `dirmngr.conf`:
     @[gist](https://gist.github.com/atsushifx/1e5b2afaff42dbab9b840620130e72e5?file=dirmngr.conf)

2. インストールスクリプトを実行する。
   @[gist](https://gist.github.com/atsushifx/1e5b2afaff42dbab9b840620130e72e5?file=install_gpgconf.ps1)

これにより、`${GNUPGHOME}`配下に設定ファイルのシンボリックリンクが作成され、`GnuPG`が設定を参照できるようになります。

## 2. 署名付きコミットの実現

この章では、`GitHub` に署名付きコミットをするための手順を説明します。

### 2.1 `Git`用`GPG鍵`の作成

署名をするために、`GnuPG`で`GPG鍵`を作成する必要があります。
`Windows Terminal`で`gpg --full-generate-key`を実行し、対話形式で`GPG鍵`を作成できます。

詳しい方法は、[`GPGチートシート`](https://zenn.dev/shuh/articles/gpg-cheatsheet) を参照してください。

今回の`GPG鍵`の設定項目は、次のようになります。

| 設定項目 | 設定 | 説明 | 備考 |
| --- | --- | --- | --- |
| 有効期限 | 3y | 鍵の有効期限を3年に設定 | 期限が切れた後に更新が必要 |
| 本名 | [Your Name] | 鍵の所有者名 | `GitHub`のプロフィール名と同じにするのを推奨 |
| 電子メールアドレス | [Your Email] | 鍵に関連つけるメールアドレス | `GitHub`に登録されたメールアドレスと同一にする |
| パスフレーズ | [Your Pass phrase] | 鍵を保護するためのパスフレーズ | セキュリティのため、推測されにくいものを設定 |

上記以外の質問は、デフォルト設定のままとします。

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

- `GitHub` で認証済みのメールアドレスを指定しない場合、`verified` と認識されません。
- `gpg.exe`は正しいフルパスを指定しないと、エラー発生の可能性があります。

```bash: ${XDG_CONFIG_HOME}/git/config
[commit]
  gpgsign = true                    # GPGで署名する

[user]
  signingkey = <GitHubに認証済みのメールアドレス>       # `GitHub` で `verified` として認識されるために必要

[gpg]
  program = "C:\app\develop\utils\gnupg\bin\gpg.exe"  # 署名に使用する`GnuPG`

```

上記のように設定することで、コミット時に自動的に`GnuPG`の署名が有効になります。

コミット時には、以下のダイアログが表示されます。
![パスフレーズ入力](/images/articles/gnupg-setup/ss-gpg-signing-dialog.png)
*パスフレーズ入力*

正しいパスフレーズを入れてコミットすると、署名付きコミットになります。

### 2.3 `GitHub`への公開鍵登録

`GitHub`に上記の`GPG鍵`を登録することで、`GitHub`上のコミットが認証済み (`verified`) となります。
これにより、自分の `GitHubリポジトリ` の信頼性を高めることができます。

:::message
`verified`にするためには、`GPG鍵`のメールアドレスが`GitHub`で認証済みである必要があります。
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

   `pub`キーの後に表示される`ed25519/CF658DD4B12C3FE5`の後ろ 16桁の英数字が`鍵ID`となります。

2. 公開鍵の出力:
   次のコマンドで、公開鍵を出力します。`鍵ID`は 1. で確認したものを使用します。
   鍵の出力後、`type`コマンドで公開鍵が適切に出力されているかを確認します。

   ```powershell
   gpg --armor  --export CF658DD4B12C3FE5 --output public-key.asc
   type public-key.asc
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
  [`New GPG Key`]をクリックし、タイトルを入力した後、公開鍵 (`public-key.asc`の内容) を貼り付けて[`Add GPG key`]をクリックします。

   ![Add new GPG key](/images/articles/gnupg-setup/ss-github-gpg-add-key.png)
   *Add new GPG key*

以上で公開鍵の登録は完了です。
登録後は、`GitHub`上のコミットが認証済みとなります。

## 3. トラブルシューティング

この章では、`GnuPG`に関する簡単なトラブルシューティングを載せておきます。

### [`TB-0001`]: `gpg: invalid size of lockfile`

`invalid size of lockfile`エラーが表示される場合、パスに空白が含まれている可能性があります。
検索パスに`Program Files` など空白を含むパスがあると、同様のエラーが発生します。

`git/config`の`gpg.program`には、フルパスを指定し、`"`で囲んでください。

```git/config
# エラー発生: 検索パス、実行時パスに空白が含まれている可能性がある
program = gpg.exe

# 解決策、フルパスで指定し、'"'で囲む
program = "C:\app\develop\utils\gnupg\bin\gpg.exe"
```

## おわりに

今回の記事では、`Windows`環境で `GnuPG` を使用して署名付きコミットをするための手順を説明しました。
`Gpg4win` のインストール、`Git` の設定、`GitHub` への公開鍵登録を順に行なうことで、署名付きコミットの環境を構築できるようになります。

署名付きコミットを導入することで、開発者のなりすましを防ぎ、プロジェクトの信頼性を向上できます。
特に`OSS`やチーム開発においては、コミットの正当性を保証することが重要です。
署名付きコミットを導入し、より安全で確実な開発環境を構築しましょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [`GPG`チートシート](https://zenn.dev/shuh/articles/gpg-cheatsheet):
  `GnuPG`でよく使うコマンドの解説。鍵の作成、共有方法など

- [`Git` のさまざまなツール - 作業内容への署名](https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E3%81%95%E3%81%BE%E3%81%96%E3%81%BE%E3%81%AA%E3%83%84%E3%83%BC%E3%83%AB-%E4%BD%9C%E6%A5%AD%E5%86%85%E5%AE%B9%E3%81%B8%E3%81%AE%E7%BD%B2%E5%90%8D):
  `Git`でコミットなどに署名をする方法

- [`GitHub` - コミット署名の検証を管理する](https://docs.github.com/ja/authentication/managing-commit-signature-verification):
  `GitHub`にて、コミットが認証済みかどうかを管理する方法
