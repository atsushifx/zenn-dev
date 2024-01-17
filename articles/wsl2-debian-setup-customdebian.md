---
title: "WSL開発環境: カスタマイズ済みDebianのインポートとセットアップ"
emoji: "🐧"
type: "tech"
topics: ["WSL", "Debian", "import", "カスタマイズ",]
published: false
---

## はじめに

この記事では、WSL (Windows Subsystem for Linux)[^1]へカスタマイズ済み Debian[^2] をインポートする方法を説明します。
カスタマイズ済み Debian は、開発に必要なツールや設定があらかじめ組み込まれた`tarアーカイブ`[^3]型式のファイルです。
このインポートにより、WSL上で迅速に開発環境を構築できます。

[^1]: WSL (Windows Subsystem for Linux): Windows 上で Linux 環境を実行するためのサブシステム
[^2]: Debian: Linux ディストリビューションの 1つ
[^3]: `tarアーカイブ`: ファイルやディレクトリを 1つのファイルにまとめる UNIX のアーカイブ形式

## 1. Debian アーカイブの概要

カスタマイズ済み Debian アーカイブには、`Git`、`XDG Base Directory`よう環境変数など、開発効率を高めるためのツールや設定が含まれています。
これらにより、WSL 環境で迅速に開発を開始できます。

この記事では、[環境構築の記事まとめ](https://zenn.dev/atsushifx/articles/wsl2-debian-setup-matome)でセットアップした Debian をエクスポートしています。

一般公開のため、`dotfiles`は`git`クローンではなく直接ダウンロード方式を採用しています。

## 2. 技術情報

### 2.1. wsl インポートの概要

`wsl --import`[^4]コマンドを使用して、tar アーカイブ形式でエクスポートされた Linux ディストリビューションを WSL にインポートできます。
これにより、カスタマイズされた環境を簡単に再現できます。

`wsl --import`コマンドは、次の型式で実行します。

```powershell
wsl --import <ディストリビューション> <インポートディレクトトリ> <tarアーカイブ>
```

各パラメーターの意味は、次の通りです:

- \<ディストリビューション>:
  WSL が起動する Linux の名前、通常は Linux ディストリビューション名
- \<インポートディレクトリ>:
  ディストリビューションのインポートするディレクトリ、インポート前に作成して起く必要がある
- \<tarアーカイブ>
  カスタマイズ済みの Debian アーカイブ

**注意事項**:
インポートディレクトリは絶対ディレクトリで指定する必要があります。

[^4]: `wsl --import`:  WSL に Linux ディストリビューションをインポートするためのコマンド

## 3. カスタマイズされた Debian のインポート

カスタマイズ済みの Debian アーカイブをダウンロードし、その後、WSL にインポートする具体的な手順について説明します。

### 3.1 Debianアーカイブのダウンロード

`Google Drive`の[PublicArchives](https://drive.google.com/drive/u/1/folders/1lFB3LtSv8ifIBesODG1XNYOsUlPsddLU)上の Debian アーカイブファイル`custom-debian.tar.7z`を、ダウンロードします。

以下の手順で Debian アーカイブをダウンロードしてください:

1. [PublicArchives](https://drive.google.com/drive/u/1/folders/1lFB3LtSv8ifIBesODG1XNYOsUlPsddLU)にアクセス
   ![PublicArchivesフォルダのスクリーンショット](https://imgur.com/GNakFoH.jpg)

2. `custom-debian.tar.7z`の右端のメニューでダウンロードを選択
   ![custom-Debian.tar.7zの右端の目メニューでダウンロードを選択](https://imgur.com/7K0l7EL.jpg)

3. ダイアログの\[エラーを無視してダウンロード]ボタンをクリックしてダウンロード
  ![`エラーを無視してダウンロード'`ボタンをクリック](https://imgur.com/o4SZp6T.jpg)

以上で、`custom-debian.tar.7z`のダウンロードは終了です。

### 3.2 Debianアーカイブの展開

ダウンロードした Debian の`7z`アーカイブを`7zip`[^5]で展開します。
`7zip`は、さまざまな形式の圧縮ファイルを扱うことができる強力なツールで、`7z`型式にも対応しています。
このコマンドを使って、ダウンロードした`7z`ファイルを展開し、WSL で使用できる形式にします。

PowerShell で、以下のコマンドを実行して展開します:

```powershell
7z x custom-debian.tar.7z
```

実行結果は、次のようになります:

``` powershell
$ 7z x custom-debian.tar.7z

7-Zip 23.01 (x64) : Copyright (c) 1999-2023 Igor Pavlov : 2023-06-20

Scanning the drive for archives:
1 file, 185010644 bytes (177 MiB)

Extracting archive: .\custom-debian.tar.7z
--
Path = .\custom-debian.tar.7z
Type = 7z
Physical Size = 185010644
Headers Size = 138
Method = LZMA2:24
Solid = -
Blocks = 1

Everything is Ok

Size:       905297920
Compressed: 185010644

$
```

上記のように`Everything is Ok`となれば、展開は成功しています。
結果、`custom-debian.tar`ファイルが作成されます。

これにより、`WSL --import`で Debian がインポートできます。

[^5]: `7zip`: `7z`型式および`zip`型式に対応したファイルアーカイブ・圧縮・展開ツール

### 3.3  Debianアーカイブのインポート

正常に展開できていれば`custom-debian.tar`ファイルができているはずです。
これを、以下のように`wsl --import`コマンドでインポートします。

```powershell
wsl --import Debian <インポートディレクトリ> custom-debian.tar
```

インポートディレクトリは、ユーザーが管理できる適当なディレクトリを指定する必要があります。
ここでは、UNIX/Linux の設定ファイル、データファイル用のディレクトリ規格である`XDG Base Directory`[^6]に従うことで、ディレクトリの一貫性を確保しています。
Debian のインポートディレクトリは、`~/.local/share/wsl/debian`となります。

Debian アーカイブのインポートには、PowerShell で、次のコマンドを実行します:

```powershell
mkdir  C:\Users\<myaccount>\.local\share\wsl\debian
wsl --import Debian C:\Users\<myaccount>\.local\share\wsl\debian .\custom-debian.tar
```

**注意**:
\<myaccount>は、自分のアカウントに置き換えてください。

実行結果は、次のようになります。

```powershell
> mkdir  C:\Users\<myaccount>\.local\share\wsl\debian
> wsl --import Debian C:\Users\<myaccount>\.local\share\wsl\debian .\custom-debian.tar
インポート中です。この処理には数分かかることがあります。
この操作を正しく終了しました。

>
```

**注意**:
\<myaccount>は、自分のアカウントに置き換えてください。

上記のように、"この操作を正しく終了しました。"と出力されれば、インポートは成功しています。

[^6]: `XDG Base Directory`: Linux システムで設定ファイルやデータファイルを管理するための標準ディレクトリ構造

## 4. デフォルトユーザーアカウントの変更

インポート時の Debian では、ユーザーアカウントが`pwruser`に設定され、`root`アカウントでログインします 。
インポートした Debian を使うには、`pwruser`を自分のアカウントに変更して、デフォルトユーザーに設定する必要があります。

### 4.1 ユーザーアカウントの変更

インポート時の Debian のユーザーアカウントを`pwruser`から自アカウントに変更します。
変更には、スクリプト`move_useraccount.sh`を使用します。

スクリプト`move_useraccount.sh`を用いて、アカウントを変更します。
bash で、アカウント変更スクリプトを実行します:

```bash
move_useraccount.sh \<myaccount>   # <myaccount>は、自分のアカウントに置き換えてください
```

### 4.2 デフォルトユーザーの設定

起動時のデフォルトユーザーを設定します。
以下のように、`/etc/wsl.conf`を設定します。

```:/etc/wsl.conf


## User settings
[user]
default=<myaccount>    # <myaccount>は、自分のアカウントに置き換えてください。

```

このように、`/etc/wsl.conf`の`[user]`セクションで`default`に自分のアカウントを設定します。
この結果、デフォルトユーザーが自分のアカウントになります。

これで、WSL を再起動すると、Debian 起動時に自分のアカウントでログインするようになります。

### 4.3 パスワードの設定

セキュリティのため、自分のアカウントにパスワードを設定します。
アカウントのセキュリティを確保するため、強固なパスワードを設定してください。推奨されるパスワードは、複雑で長く、予測しにくいものです。

bash で、次のコマンドを実行してパスワードを設定します:

```bash
passwd \<myaccount>  # <myaccount>.は自分のアカウントに置き換えてください。
```

実行結果は、次のようになります。

```bash
$ passwd \<myaccount>
New password:
Retype new password:
passwd: password updated successfully

$
```

以上で、パスワードの設定は終了です。

**注意**:
自アカウントを安全に使用するために、強力なパスワードを設定する必要があります。複雑で予測しにくいパスワードを設定することを推奨します。

## 5. WSLの再起動

以上の手順で、WSL の設定は完了です。
これらの設定を反映させるために、WSL を再起移動する必要があります。

PowerShell で次のコマンドを実行し、WSL をシャットダウンします:

```powershell
wsl --shutdown
```

以後、Debian は開発環境が構築された状態で起動します。

## 6. 追加の設定

このセクションでは、ダウンロード済みの`dotfiles`を削除し、新たに`dotfiles`を組み込む方法を紹介します。
これにより、設定ファイルをバージョン管理でき、環境のバックアップや移行が簡単にできるようになります。

また、上記手順で削除された`what`コマンドを再インストールする方法を説明します。

### 6.1 `dotfiles`の組み込み

この記事でインポートした Debian では、各種設定ファイルが`dotfiles`[^7]で管理されていません。
設定ファイルを`dotfiles`で管理したい場合は、以下の手順にしたがってください:

1. `/opt/`下のサブディレクトリを削除:
    `/opt/bin`, `/opt/etc` をシンボリックリンクにするため削除します。
    以下のコマンドを実行します:

    ```bash
    sudo rm -fr /opt/etc /opt/bin
    ```

2. `dotfiles`を削除:
    `~/.local/`下に`dotfiles`ディレクトリを削除します。
    次のコマンドを実行します:

    ```bash
    rm -fr ~/.local/dotfiles
    ```

3. `dotfiles`の組み込み:
    [`dotfiles`を使った環境管理](https://zenn.dev/atsushifx/articles/wsl2-debian-dotfiles)にしたがって、`dotfiles`を組み込みます。

以上で、`dotfiles`の組み込みは完了です。

[^7]: `dotfiles`: UNIX/Linux の設定ファイル用を管理するためのバージョン管理システム上のリポジトリ

### 6.2 `what`コマンドのインストール

`what`コマンド[^8]は、シェルスクリプトや設定ファイルの特定のコメントを解析し、ファイルの概要やバージョンを出力するユーティリティです。

[`dotfiles`の組み込み](#61-dotfilesの組み込み)セクションの作業によって、`what`コマンド[^8]が削除さるので、[`what`コマンドによるスクリプト管理](https://zenn.dev/atsushifx/articles/wsl2-shell-command-what)にしたがって、`what`コマンドをインストールします。

[^8]: `what`コマンド: シェルスクリプトや設定ファイルの概要を出力するコマンド

## おわりに

以上で、カスタマイズ済みの Debian のセットアップは完了です。
この環境をもとにプログラミング言語や開発ツールをインストールすると、プログラミング言語用の開発環境が構築できます。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- WSL の基本的なコマンド: <https://learn.microsoft.com/ja-jp/windows/wsl/basic-commands>
- WSL で使用する Linux ディストリビューションをインポートする: <https://learn.microsoft.com/ja-jp/windows/wsl/use-custom-distro>
- 環境構築の記事まとめ: <https://zenn.dev/atsushifx/articles/wsl2-Debian-setup-matome>
- dotfiles を使った環境管理: <https://zenn.dev/atsushifx/articles/wsl2-debian-dotfiles>
- what コマンド: <https://raw.githubusercontent.com/atsushifx/agla-shell-utils/main/agla/what>
