---
title: "WSL開発環境: Debian tarアーカイブを使用した高速セットアップ"
emoji: "🐧"
type: "tech"
topics: ["WSL", "Debian", "import", "カスタマイズ",]
published: false
---

## はじめに

この記事では、カスタマイズ済みの Debian[^2] の`tarアーカイブ`を、WSL[^1] にインポートする方法を紹介します。

Debian アーカイブをインポートすることで、初期設定の時間を大幅に削減できます。

[^1]: WSL (Windows Subsystem for Linux): Windows 上で Linux 環境を実行するためのサブシステム
[^2]: Debian: Linux ディストリビューションの 1つ

## 1. カスタマイズされた Debian のインポート

カスタマイズ済みの Debian アーカイブをダウンロードし、WSL にインポートする手順を説明します。

### 1.1 Debianアーカイブのダウンロード

`Google Drive`の[PublicArchives](https://drive.google.com/drive/u/1/folders/1lFB3LtSv8ifIBesODG1XNYOsUlPsddLU)上の Debian アーカイブファイル`custom-debian.tar.7z`を、ダウンロードします。

次の手順で Debian アーカイブをダウンロードしてください:

1. [PublicArchives](https://drive.google.com/drive/u/1/folders/1lFB3LtSv8ifIBesODG1XNYOsUlPsddLU)にアクセス
   ![PublicArchives](https://imgur.com/GNakFoH.jpg)

2. `custom-debian-tar.7z`の右端のメニューでダウンロードを選択
   ![メニューでダウンロードを選択](https://imgur.com/7K0l7EL.jpg)

3. ダイアログの\[エラーを無視してダウンロード]ボタンをクリックしてダウンロード
  ![ファイルのウィルススキャンを実行できません](https://imgur.com/o4SZp6T.jpg)

以上で、`custom-debian.tar.7z`のダウンロードは終了です。

### 1.2 Debianアーカイブの展開

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

### 1.3. Debianのインポート

展開に成功すると、`custom-debian.tar`ファイルができているはずです。
この tar ファイルを、WSL にインポートします。

PowerShell で、次のコマンドを実行します:

```powershell
wsl --import Debian C:\Users\atsushifx\.local\share\wsl\debian .\custom-debian.tar
```

実行結果は、次のようになります。

```powershell
> wsl --import Debian C:\Users\atsushifx\.local\share\wsl\debian .\custom-debian.tar
インポート中です。この処理には数分かかることがあります。
この操作を正しく終了しました。

>

```

上記のように、"この操作を正しく終了しました。"と出力されれば、インポートは成功しています。

## 2. デフォルトユーザーの設定

インポート時は、ユーザーアカウントが`pwruser`となっています。また、`root`でログインするようになっています。
インポートした Debian を使うには、`pwruser`を自分のアカウントに変更して、デフォルトユーザーに設定する必要があります。

### 2.1 ユーザーアカウントの変更

ユーザーアカウント`pwruser`を、自アカウントに変更します。

bash で、アカウント変更スクリプトを実行します:

```bash
move_useraccount.sh <myaccount>   # <myaccount>は、自分のアカウントに置き換えてください
```

### 2.2 デフォルトユーザーの設定

起動時のデフォルトユーザーを設定します。
以下のように、`/etc/wsl.conf`を設定します。

```:/etc/wsl.conf


## User settings
[user]
default=<myaccount>    # <myaccount>は、自分のアカウントに置き換えてください。

```

これで、Debian 起動時に自アカウントでログインします。

### 2.3 パスワードの設定

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

## 3. WSLの再起動

以上で、WSL の設定は終了です。
WSL を再起動することで上記の設定が反映され、Debian に自アカウントでログインするようになります。

PowerShell で次のコマンドを実行し、WSL をシャットダウンします:

```powershell
wsl --shutdown
```

以後、Debian は開発環境が構築された状態で起動します。

## 4. 追加の設定

この章では、開発環境を自分の GitHub で管理する方法を紹介します。
これにより、設定ファイルをバージョン管理でき、環境のバックアップや移行が簡単にできます。

### 4.1 dotfilesの組み込み

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

### 4.2 `what`コマンドのインストール

[`dotfiles`の組み込み](#41-dotfilesの組み込み)によって、`what`コマンドが削除されます。
[`what`コマンドによるスクリプト管理](https://zenn.dev/atsushifx/articles/wsl2-shell-command-what)にしたがって、`what`コマンドをインストールします。

## おわりに

以上で、Debian の高速セットアップは終了です。
この環境をもとにプログラミング言語や開発ツールをインストールすると、プログラミング言語用の開発環境が構築できます。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- WSL で使用する Linux ディストリビューションをインポートする: <https://learn.microsoft.com/ja-jp/windows/wsl/use-custom-distro>
- `what`コマンド: <https://raw.githubusercontent.com/atsushifx/agla-shell-utils/main/agla/what>
