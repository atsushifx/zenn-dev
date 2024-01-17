---
title: "WSL開発環境: カスタマイズ済みDebianのインポートによる高速セットアップ"
emoji: "🐧"
type: "tech"
topics: ["WSL", "Debian", "import", "カスタマイズ",]
published: false
---

## はじめに

この記事では、WSL (Windows Subsystem for Linux)[^1]上で使用するカスタマイズ済み Debian[^2] をインポートする方法を説明します。
これにより、WSL上の開発環境が短時間で構築できます。

[^1]: WSL (Windows Subsystem for Linux): Windows 上で Linux 環境を実行するためのサブシステム
[^2]: Debian: Linux ディストリビューションの 1つ

## 1. Debian アーカイブの概要

カスタマイズ済みの Debian アーカイブは、ツールのインストール、環境設定を含む`tar アーカイブ`[^3]ファイルです。
たとえば、`Git`、`XDG Base Directory`、テキストエディタの設定など、開発効率を向上させるツールと設定が含まれています。

この記事では、[環境構築の記事まとめ](https://zenn.dev/atsushifx/articles/wsl2-debian-setup-matome) でセットアップした Debian をエクスポートしています。
なお、一般公開のため、`dotfiles`は`git`クローンではなく直接ダウンロード方式を採用しています。

[^3]: `tarアーカイブ`: UNIX/Linux で標準的な複数のファイル／ディレクトリをまとめる型式

## 2. wslインポートの概要

`wsl --import`コマンドは、`tar`アーカイブ形式の Linux ディストリビューションをインポートするために利用されます。

### 2.1. wsl インポートのコマンドライン

`wsl --import`[^4] コマンドは、tar アーカイブ形式でエクスポートされた Linux ディストリビューションを指定したディレクトリにインポートします。
この機能により、カスタマイズされた環境を簡単に再現できます。

`wsl --import`コマンドは、次の形式で実行します。

```powershell
wsl --import <ディストリビューション> <インポートディレクトリ> <tarアーカイブ>
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

次の手順にしたがって、Debian アーカイブをダウンロードします:

1. \[[PublicArchives](https://drive.google.com/drive/u/1/folders/1lFB3LtSv8ifIBesODG1XNYOsUlPsddLU)]にアクセス
   ![PublicArchivesフォルダのスクリーンショット](https://imgur.com/GNakFoH.jpg)

2. `custom-debian.tar.7z`の右端のメニューでダウンロードを選択
   ![custom-Debian.tar.7zの右端の目メニューでダウンロードを選択](https://imgur.com/7K0l7EL.jpg)

3. ダイアログの\[エラーを無視してダウンロード]ボタンをクリックしてダウンロード
  ![`エラーを無視してダウンロード'`ボタンをクリック](https://imgur.com/o4SZp6T.jpg)

以上で、`custom-debian.tar.7z`のダウンロードは終了です。

### 3.2 Debianアーカイブの展開

ダウンロードした Debian アーカイブを`7zip`[^5]で展開します。
`7zip`は、さまざまな形式の圧縮ファイルを扱うことができる強力なツールで、`7z`型式にも対応しています。
このコマンドを使って、ダウンロードした`7z`ファイルを展開し、WSL で使用できる形式にします。

次のコマンドを実行して展開します:

1. '7z`コマンドによる展開:

   ```powershell
   7z x custom-debian.tar.7z
   ```

   実行結果が次のようになれば、展開は成功しています。

   ```powershel]

   7-Zip 23.01 (x64) : Copyright (c) 1999-2023 Igor Pavlov : 2023-06-20

   Scanning the drive for archives


   Everything is Ok

   $
   ```

[^5]: `7zip`: `7z`型式および`zip`型式に対応したファイルアーカイブ・圧縮・展開ツール

### 3.3 インポートディレクトリの設定

インポートディレクトリは、ユーザーが管理できるディレクトリを指定する必要があります。
ここでは、UNIX/Linux の設定ファイル、データファイル用のディレクトリ規格である`XDG Base Directory`[^6]に従うことで、ディレクトリの一貫性を確保しています。
Debian のインポートディレクトリは、`/~/.local/share/wsl/debian`となります。

次の手順で、インポートディレクトリを作成します:

1. インポートディレクトリの作成

   ```powershell
   mkdir ~/.local/share/wsl/debian
   ```

以上で、インポートディレクトリの設定は終了です。

[^6]: `XDG Base Directory`: Linux システムで設定ファイルやデータファイルを管理するための標準ディレクトリ構造

### 3.4  Debianアーカイブのインポート

正常に展開できていれば`custom-debian.tar`ファイルができているはずです。
Debian アーカイブのインポートには、PowerShell で、次のコマンドを実行します:

1. Debian のインポート

   ```powershell
   wsl --import Debian C:\Users\<myaccount>\.local\share\wsl\debian .\custom-debian.tar  # <myaccount>は、自分のアカウントに置き換えてください
   ```

   実行結果は、次のようになります。

   ```powershell

   インポート中です。この処理には数分かかることがあります。
   この操作を正しく終了しました。

   $
   ```

上記のように、"この操作を正しく終了しました。"と出力されれば、インポートは成功しています。

## 4. デフォルトユーザーアカウントの変更

インポート時の Debian では、ユーザーアカウントが`pwruser`に設定され、`root`アカウントでログインします 。
インポートした Debian を使うには、`pwruser`を自分のアカウントに変更して、デフォルトユーザーに設定する必要があります。

### 4.1 ユーザーアカウントの変更

ユーザーアカウントを`pwruser`から自分のアカウントに変更する必要があります。
変更には、スクリプト`move_useraccount.sh`を使用します。

次の手順で、アカウントを変更します:

1. ユーザーアカウントの変更

   ```bash
   move_useraccount.sh <myaccount>   # <myaccount>は、自分のアカウントに置き換えてください
   ```

以上で、ユーザーアカウントの変更は終了です。

### 4.2 デフォルトユーザーの設定

起動時のデフォルトユーザーを設定します。
以下のように、`/etc/wsl.conf`を設定します:

```:/etc/wsl.conf


## User settings
[user]
default=<myaccount>    # <myaccount>は、自分のアカウントに置き換えてください。

```

このように、`/etc/wsl.conf`の`[user]`セクションで`default`に自分のアカウントを設定します。
この結果、デフォルトユーザーが自分のアカウントになります。

WSL を再起動すると、Debian 起動時に自分のアカウントでログインするようになります。

### 4.3 パスワードの設定

セキュリティのため、自分のアカウントにパスワードを設定します。
アカウントのセキュリティを確保するため、強固なパスワードを設定してください。推奨されるパスワードは、複雑で長く、予測しにくいものです。

bash で、次のコマンドを実行してパスワードを設定します:

```bash
passwd <myaccount>  # <myaccount>.は自分のアカウントに置き換えてください。
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
Debian の設定を反映させるため、WSL を再起動します。
これにより、新しくカスタマイズされた環境が利用できます。

次のコマンドを実行し、WSL をシャットダウンします:

1. WSL のシャットダウン
   次のコマンドを実行し、WSL をシャットダウンします。

   ```powershell
   wsl --shutdown
   ```

再起動後は、Debian は新しくカスタマイズされた状態で動作し、ユーザーのアカウントでログインします。

## 6. 追加の設定

カスタマイズした Debian では`dotfiles`[^7]がバージョン管理されていません。
このセクションでは、既存の`dotfiles`を削除し、最新版を組み込む方法を紹介します。
次に、`what`コマンドを再インストールする方法を紹介します。

[^7]: `dotfiles`: UNIX/Linux の設定ファイル用を管理するリポジトリ、または設定ファイル自身

### 6.1 `dotfiles`の組み込み

以下の手順で、既存の`dotfiles`を削除し最新版を組み込みます。

1. `/opt/`下のサブディレクトリを削除:
    `/opt/bin`, `/opt/etc` をシンボリックリンクにするため削除します。
    以下のコマンドを実行します:

    ```bash
    sudo rm -fr /opt/etc /opt/bin
    ```

2. `dotfiles`を削除:
    `~/.local/`下の`dotfiles`ディレクトリを削除します。
    次のコマンドを実行します:

    ```bash
    rm -fr ~/.local/dotfiles
    ```

3. `dotfiles`の組み込み:
    [`dotfiles`を使った環境管理](https://zenn.dev/atsushifx/articles/wsl2-debian-dotfiles) にしたがって、`dotfiles`を組み込みます。

以上で、`dotfiles`の組み込みは完了です。

### 6.2 `what`コマンドのインストール

`what`コマンド[^8]は、シェルスクリプトや設定ファイルの特定のコメントを解析し、ファイルの概要やバージョンを出力するユーティリティです。

次の手順で、`what`コマンドを再インストールします:

1. `what`コマンドの再インストール
   [`what`コマンドによるスクリプト管理](https://zenn.dev/atsushifx/articles/wsl2-shell-command-what) にしたがって、`what`コマンドを再インストールします。

[^8]: `what`コマンド: シェルスクリプトや設定ファイルの概要を出力するコマンド

## おわりに

以上で、カスタマイズ済みの Debian のセットアップは完了です。
この記事に従えば、WSL上の開発環境を素早く、効率的にセットアップできます。
この環境に追加のツールやプログラミング言語をインストールし、個々のプロジェクトにあわせてカスタマイズできます。

自分のプロジェクトにあわせて迅速に開発環境を構築し、効率的な開発体験を楽しみましょう。
それでは、Happy Hacking!

## 参考資料

### Webサイト

- WSL の基本的なコマンド: <https://learn.microsoft.com/ja-jp/windows/wsl/basic-commands>
- WSL で使用する Linux ディストリビューションをインポートする: <https://learn.microsoft.com/ja-jp/windows/wsl/use-custom-distro>
- 環境構築の記事まとめ: <https://zenn.dev/atsushifx/articles/wsl2-Debian-setup-matome>
- dotfiles を使った環境管理: <https://zenn.dev/atsushifx/articles/wsl2-debian-dotfiles>
- what コマンド: <https://raw.githubusercontent.com/atsushifx/agla-shell-utils/main/agla/what>
