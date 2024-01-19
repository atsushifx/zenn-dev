---
title: "WSL開発環境: カスタムDebianによる高速セットアップ"
emoji: "🐧"
type: "tech"
topics: ["WSL", "Debian", "import", "カスタマイズ",]
published: false
---

## はじめに

WSL[^1]にカスタマイズされた Debian[^2] をインポートして、効率的に開発環境を構築する方法を紹介します。
この方法により、一貫性のある開発環境を素早く構築でき、開発効率が向上できます。

[^1]: WSL (Windows Subsystem for Linux): Windows 上で Linux 環境を実行するためのサブシステム
[^2]: Debian: Linux ディストリビューションの 1つ

## 1. Debian アーカイブの概要

カスタマイズ済み Debian アーカイブは、開発ツールとカスタマイズされた設定を含む`tar アーカイブ`[^3]です。
これをインポートすることで、開発環境構築にかかる時間が大幅に短縮できます。

この記事で使用するアーカイブは、[環境構築の記事まとめ](https://zenn.dev/atsushifx/articles/wsl2-debian-setup-matome) で事前にセットアップされたものです。

個人の認証情報を削除するため、`dotfiles`[^4]は直接ダウンロードしたものを使用しています。

[^3]: `tarアーカイブ`: UNIX/Linux で標準的な複数のファイル／ディレクトリをまとめる型式
[^4]: `dotfiles`: UNIX/Linux の設定ファイル用を管理するリポジトリ、または設定ファイル自身

## 2. wslインポートの概要

WSL に Debian アーカイブをインポートする際には、`wsl  --import`[^5]コマンドを使用します。
これにより、環境設定の複製や移行が簡単になります。

[^5]: `wsl --import`:  WSL に Linux ディストリビューションをインポートするためのコマンド

### 2.1. wsl インポートのコマンドライン

`wsl --import`コマンドは、`tarアーカイブ`形式の Linux ディストリビューションを WSL上にインポートします。
そして、エクスポート時の Linux ディストリビューションの状態を再現します。

このコマンドを用いることで、既存の設定を保持したまま迅速に環境を構築できます。

`wsl --import`コマンドは、次の形式で実行します。

```powershell
wsl --import <ディストリビューション> <インポートディレクトリ> <tarアーカイブ>
```

各パラメーターの意味は、次の通りです:

- \<ディストリビューション>:
  WSL が起動する Linux の名前、通常は Linux ディストリビューション名
- \<インポートディレクトリ>:
  ディストリビューションのインポートするディレクトリ、インポート前に作成しておく必要がある
- \<tarアーカイブ>
  `wsl`がエクスポートした`tarアーカイブ`

**注意事項**:
インポートディレクトリは絶対ディレクトリで指定する必要があります。

## 3. カスタマイズ済みの Debian のインポート

カスタマイズ済み Debian アーカイブをダウンロードし、WSL にインポートする手順を紹介します。
これにより、ユーザーは作業を迷うことなく進めることができます。

### 3.1 Debianアーカイブのダウンロード

Debian アーカイブは、[PublicArchives](https://drive.google.com/drive/u/1/folders/1lFB3LtSv8ifIBesODG1XNYOsUlPsddLU)  からダウンロードできます。

次の手順で、Debian アーカイブをダウンロードします:

1. \[[PublicArchives](https://drive.google.com/drive/u/1/folders/1lFB3LtSv8ifIBesODG1XNYOsUlPsddLU)]にアクセス
   ![PublicArchivesフォルダのスクリーンショット](https://imgur.com/GNakFoH.jpg)

2. `custom-debian.tar-x.y.z.7z`の右端のメニューでダウンロードを選択
   ![custom-Debian.tar.7zの右端のメニューでダウンロードを選択](https://imgur.com/7K0l7EL.jpg)

3. ダイアログの\[エラーを無視してダウンロード]ボタンをクリックしてダウンロード
  ![`エラーを無視してダウンロード'`ボタンをクリック](https://imgur.com/o4SZp6T.jpg)

  **注意**:
  ウィルススキャンできないためエラーが出る。無視してよい。

以上で、`custom-debian.tar-x.y.z.7z`のダウンロードは終了です。

### 3.2 Debianアーカイブの展開

ダウンロードした Debian アーカイブを`7zip`[^6]で展開します。
`7zip`は、さまざまな形式の圧縮ファイルを扱うことができる強力なツールで、`7z`型式にも対応しています。
このコマンドを使って、ダウンロードした`7z`ファイルを展開し、WSL で使用できる形式にします。

次のコマンドを実行して展開します:

1. `7z`コマンドによる展開:
   `7z x`コマンドで、Debian アーカイブを展開する。

   ```powershell
   7z x custom-debian.tar-x.y.z.7z
   ```

   実行結果が次のようになれば、展開は成功しています。

   ```powershel
    .
    .
   Everything is Ok

   $
   ```

[^6]: `7zip`: `7z`型式および`zip`型式に対応したファイルアーカイブ・圧縮・展開ツール

### 3.3 インポートディレクトリの設定

インポートディレクトリは、ユーザーが管理できるディレクトリを指定する必要があります。
インポートディレクトリは、`XDG Base Directory`[^7] (Linux システムでのファイル配置の標準規格) に準じます。
よって、Debian のインポートディレクトリは`/~/.local/share/wsl/debian`とします。
このように、`XDG Base Directory`に従うことで、`.local`下に WSL のファイルを置くことになり、安全性が増します。

次の手順で、インポートディレクトリを作成します:

1. インポートディレクトリの作成
   インポートディレクトリを作成します。

   ```powershell
   mkdir ~/.local/share/wsl/debian
   ```

以上で、インポートディレクトリの設定は終了です。

[^7]: `XDG Base Directory`: Linux システムで設定ファイルやデータファイルを管理するための標準ディレクトリ構造

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

デフォルトユーザーアカウントの変更方法を説明します。
これにより、自分のアカウントで環境を設定できます。

### 4.1 ユーザーアカウントの変更

ユーザーアカウントを`pwruser`から自分のアカウントに変更する必要があります。
変更は、`move_useraccount.sh`スクリプトを使用します。
スクリプトは次のように実行します:

```bash
move_useraccount.sh <myaccount>
```

次の手順で、アカウントを変更します:

1. ユーザーアカウントの変更

   ```bash
   move_useraccount.sh <myaccount>   # <myaccount>は、自分のアカウントに置き換えてください
   ```

以上で、ユーザーアカウントの変更は終了です。

### 4.2 デフォルトユーザーの設定

起動時のデフォルトユーザーを`root`から自分のアカウントに変更します。
エディタで`/etc/wsl.conf`を編集し、以下のように設定します:

```:/etc/wsl.conf


## User settings
[user]
default=<myaccount>    # <myaccount>は、自分のアカウントに置き換えてください。

```

このように、`/etc/wsl.conf`の`[user]`セクションで`default`に自分のアカウントを設定します。
この結果、デフォルトユーザーが自分のアカウントになります。

WSL を再起動すると、Debian 起動時に自分のアカウントでログインするように変更されます。

### 4.3 パスワードの設定

セキュリティを保つため、自分のアカウントに強固なパスワードを設定します。
アカウントのセキュリティを確保するため、強固なパスワードを設定してください。推奨されるパスワードは、複雑で長く、予測しにくいものです。

bash で、次のコマンドを実行してパスワードを設定します:

```bash
passwd <myaccount>  # <myaccount>.は自分のアカウントに置き換えてください。
```

実行結果は、次のようになります。

```bash
$ passwd <myaccount>
New password:
Retype new password:
passwd: password updated successfully

$
```

以上で、パスワードの設定は終了です。

## 5. WSLの再起動

以上のステップで、WSL の設定は完了です。
設定を完了後、WSL を再起動して新しい設定を反映させます。これにより、カスタマイズされた Debian 環境が正しく動作します。

次のコマンドを実行し、WSL を再起動します:

1. WSL のシャットダウン
   WSL をシャットダウンします。

   ```powershell
   wsl --shutdown
   ```

2. Debian の起動
   `Windows Terminal`で Debian を選び、WSL上の Debian を起動します。

再起動後は、Debian は新しくカスタマイズされた状態で動作し、ユーザーのアカウントでログインします。

## 6. 追加の設定

WSL の再起動までのステップで、Debian の開発環境を構築できました。
この章では、Debian の環境設定をバージョン管理システムで管理する方法を紹介します。

### 6.1 `dotfiles`の組み込み

既存の`dotfiles`があると、`git`でクローンができません。
そのため、既存の`dotfiles`を削除して、その後に最新版を組み込みます。

次の手順で、既存の`dotfiles`を削除し最新版を組み込みます。

1. `/opt/`下のサブディレクトリを削除:
    `/opt/bin`, `/opt/etc` をシンボリックリンクにするため削除します。
    次のコマンドを実行します:

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

### 6.2 `what`コマンドの再インストール

`what`コマンド[^8]は、シェルスクリプトや設定ファイルの特定のコメントを解析し、ファイルの概要やバージョンを出力するユーティリティです。

次の手順で、`what`コマンドを再インストールします:

1. `what`コマンドの再インストール
   [`what`コマンドによるスクリプト管理](https://zenn.dev/atsushifx/articles/wsl2-shell-command-what) にしたがって、`what`コマンドを再インストールします。

[^8]: `what`コマンド: シェルスクリプトや設定ファイルの概要を出力するコマンド

## おわりに

以上で、カスタマイズ済みの Debian のセットアップは完了です。
この記事を参考にして、個々のプロジェクトにあわせた開発環境を素早く構築し、効率的な開発体験をしてください。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- WSL の基本的なコマンド: <https://learn.microsoft.com/ja-jp/windows/wsl/basic-commands>
- WSL で使用する Linux ディストリビューションをインポートする: <https://learn.microsoft.com/ja-jp/windows/wsl/use-custom-distro>
- 環境構築の記事まとめ: <https://zenn.dev/atsushifx/articles/wsl2-Debian-setup-matome>
- dotfiles を使った環境管理: <https://zenn.dev/atsushifx/articles/wsl2-debian-dotfiles>
- what コマンド: <https://raw.githubusercontent.com/atsushifx/agla-shell-utils/main/agla/what>
