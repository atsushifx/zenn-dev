---
title: "WSL開発環境: カスタマイズ済みDebianのインポートとセットアップ"
emoji: "🐧"
type: "tech"
topics: ["WSL", "Debian", "import", "カスタマイズ",]
published: false
---

## はじめに

この記事では、カスタマイズ済みの Debian[^2] の`tarアーカイブ`[^3]:を、WSL[^1] にインポートする方法を紹介します。
これにより、Debian を初期設定する手間が大幅に削減できます。

[^1]: WSL (Windows Subsystem for Linux): Windows 上で Linux 環境を実行するためのサブシステム
[^2]: Debian: Linux ディストリビューションの 1つ

## 1. Debian アーカイブの概要

カスタマイズ済み Debian アーカイブは、特定の設定やツールを含んだ、WSL のエクスポート機能で作成された tar アーカイブファイルです。
このアーカイブをインストールすることで、カスタマイズズ済みの Debian を WSL上に構築できます。

この記事では、[環境構築の記事まとめ](https://zenn.dev/atsushifx/articles/wsl2-debian-setup-matome)でセットアップした Debian をエクスポートしています。

ただし、不特定の人に配布するため、`dotfiles`はダウンロ－ドにし GitHub との連携はしていません。

この Debian アーカイブをインポートすることで、[環境構築の記事まとめ](https://zenn.dev/atsushifx/articles/wsl2-debian-setup-matome)の作業をしなくても、同一の開発環境を構築できます。」

## 2. カスタマイズされた Debian のインポート

以下のセクションで、カスタマイズ済みの Debian アーカイブをダウンロードし、WSL にインポートする手順を説明します。

### 2.1 Debianアーカイブのダウンロード

`Google Drive`の[PublicArchives](https://drive.google.com/drive/u/1/folders/1lFB3LtSv8ifIBesODG1XNYOsUlPsddLU)上の Debian アーカイブファイル`custom-debian.tar.7z`を、ダウンロードします。

次の手順で Debian アーカイブをダウンロードしてください:

1. [PublicArchives](https://drive.google.com/drive/u/1/folders/1lFB3LtSv8ifIBesODG1XNYOsUlPsddLU)にアクセス
   ![PublicArchives](https://imgur.com/GNakFoH.jpg)

2. `custom-debian-tar.7z`の右端のメニューでダウンロードを選択
   ![メニューでダウンロードを選択](https://imgur.com/7K0l7EL.jpg)

3. ダイアログの\[エラーを無視してダウンロード]ボタンをクリックしてダウンロード
  ![ファイルのウィルススキャンを実行できません](https://imgur.com/o4SZp6T.jpg)

以上で、`custom-debian.tar.7z`のダウンロードは終了です。

### 2.2 Debianアーカイブの展開

ダウンロードした Debian の`7z`アーカイブを`7zip`[^3]の展開コマンド`7z x`コマンドで展開します
展開に成功すると、`custom-debian.tar`ファイルが作成されます。

PowerShell で、以下のコマンドを実行して展開します:

```powershell
7z x custom-debian.tar.7z
```

実行結果は、次のようになります:

``` powershell
> 7z x custom-debian.tar.7z

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

>
```

上記のように`Everything is Ok`となれば、展開は成功しています。
結果、`custom-debian.tar`ファイルが作成されます。

これにより、`WSL --import`で Debian がインポートできます。

[^3]: `7zip`: `7z`型式でのファイル圧縮、展開ツール

### 2.3. Debianのインポート

展開に成功すると、`custom-debian.tar`ファイルができているはずです。
この tar ファイルを、WSL にインポートします。

PowerShell で、次のコマンドを実行します:

```powershell
mkdir  C:\Users\<myaccount>\.local\share\wsl\debian
wsl --import Debian C:\Users\<myaccount>\.local\share\wsl\debian .\custom-debian.tar
```

**注意**:
\<myaccount>は、Windows の自アカウントにかえてください。

実行結果は、次のようになります。

```powershell
> mkdir  C:\Users\<myaccount>\.local\share\wsl\debian
> wsl --import Debian C:\Users\<myaccount>\.local\share\wsl\debian .\custom-debian.tar
インポート中です。この処理には数分かかることがあります。
この操作を正しく終了しました。

>
```

**注意**:
\<myaccount>は、Windows の自アカウントにかえてください。

上記のように、"この操作を正しく終了しました。"と出力されれば、インポートは成功しています。

## 3. デフォルトユーザーの設定

インポート時は、ユーザーアカウントが`pwruser`に設定されており、`root`でログインするように設定されています 。
インポートした Debian を使うには、`pwruser`を自分のアカウントに変更して、デフォルトユーザーに設定する必要があります。

### 3.1 ユーザーアカウントの変更

ユーザーアカウント`pwruser`を、自アカウントに変更します。

bash で、アカウント変更スクリプトを実行します:

```bash
move_useraccount.sh <myaccount>   # <myaccount>は、自分のアカウントに置き換えてください
```

### 3.2 デフォルトユーザーの設定

起動時のデフォルトユーザーを設定します。
以下のように、`/etc/wsl.conf`を設定します。

```:/etc/wsl.conf


## User settings
[user]
default=<myaccount>    # <myaccount>は、自分のアカウントに置き換えてください。

```

これで、Debian 起動時に自アカウントでログインします。

### 3.3 パスワードの設定

自アカウントにパスワードを設定します。
bash で、次のコマンドを実行します:

```bash
passwd <myaccount>  # <myaccount>.は自アカウントにかきかえてください
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

**注意**:
自アカウントを安全に使用するために、強力なパスワードを設定する必要があります。複雑で予測しにくいパスワードを設定することを推奨します。

## 4. WSLの再起動

以上の手順で、WSL の設定は完了します。
WSL を再起動することで上記の設定が反映され、Debian に自アカウントでログインするようになります。

PowerShell で次のコマンドを実行し、WSL をシャットダウンします:

```powershell
wsl --shutdown
```

以後、Debian は開発環境が構築された状態で起動します。

## 5. 追加の設定

このセクションでは、ダウンロード済みの`dotfiles`を削除し、新たに`dotfiles`を組み込む方法を紹介します。
これにより、設定ファイルをバージョン管理でき、環境のバックアップや移行が簡単にできるようになります。

### 5.1 `dotfiles`の組み込み

この記事でインポートした Debian では、各種設定ファイルが`dotfiles`[^4]で管理されていません。
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

[^4]: `dotfiles`: UNIX/Linux の設定ファイル用を管理するためのバージョン管理システム上のリポジトリ

### 5.2 `what`コマンドのインストール

`dotfiles`の組み込みによって、`what`コマンドが削除されます。
[`what`コマンドによるスクリプト管理](https://zenn.dev/atsushifx/articles/wsl2-shell-command-what)にしたがって、`what`コマンドをインストールします。

## おわりに

以上で、カスタマイズ済みの Debian のセットアップは完了です。
この環境をもとにプログラミング言語や開発ツールをインストールすると、プログラミング言語用の開発環境が構築できます。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- WSL で使用する Linux ディストリビューションをインポートする: <https://learn.microsoft.com/ja-jp/windows/wsl/use-custom-distro>
- `what`コマンド: <https://raw.githubusercontent.com/atsushifx/agla-shell-utils/main/agla/what>
- 環境構築の記事まとめ: <https://zenn.dev/atsushifx/articles/wsl2-Debian-setup-matome>
