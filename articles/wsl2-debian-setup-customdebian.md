---
title: "WSL開発環境: tarファイルによる高速セットアップ"
emoji: "🐧"
type: "tech"
topics: ["WSL", "Debian", "import", "カスタマイズ",]
published: false
---

## はじめに

[WSL開発環境構築の記事まとめ](https://zenn.dev/atsushifx/articles/wsl2-debian-setup-matome) によって、どの Windows でも WSL上に開発環境を構築できるようになりました。
この記事では、構築をさらに簡単にするため、Debian アーカイブを使って環境を構築する方法を紹介します。

## 1. カスタマイズされたDebianのインポート

### 1.1 Debianアーカイブのダウンロード

Debian アーカイブは、`Google Drive`の[PublicArchives](https://drive.google.com/drive/u/1/folders/1lFB3LtSv8ifIBesODG1XNYOsUlPsddLU)上に`custom-debian.tar.7z`というファイル名でアップロードしています。

次の手順で Debian アーカイブをダウンロードしてください:

1. [PublicArchives](https://drive.google.com/drive/u/1/folders/1lFB3LtSv8ifIBesODG1XNYOsUlPsddLU)にアクセス
   ![IPublicArchives](https://imgur.com/GNakFoH.jpg)

2. `custom-debian-tar.7z`の右端のメニューでダウンロードを選択
   ![メニューでダウンロード「](https://imgur.com/7K0l7EL.jpg)

3. ダイアログの\[エラーを無視してダウンロード]ボタンをクリックしてダウンロード
  ![ファイルのウィルススキャンを実行できません](https://imgur.com/o4SZp6T.jpg)

以上で、`custom-debian.tar.7z`

### 1.2 Debianアーカイブの展開

ダウンロードした Debian アーカイブを tar型式のファイルに展開します。
PowerShell で次のコマンドを実行します:

```powershell
7z x  .\custom-debian.tar.7z
```

実行結果は、次のようになります:

``` powershell
> 7z x .\custom-debian.tar.7z

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

### 1.3. Debianのインポート

展開に成功すると、以下のように`custom-debian.tar`ファイルができているはずです。
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

## 2. Debianのセットアップ

インポートした Debian を使えるようにするため、ユーザーのセットアップを行います。

### 2.1 アカウントの変更

インポート時は、ユーザーアカウントが`pwruser`となっています。
インポートした Debian を使うには、このアカウントを自分のアカウントに変更する必要があります。

bash で、アカウント変更スクリプトを実行します:

```bash
move_useraccount.sh <myaccount>   # <myaccount>は、自分のアカウントに置き換えてください
```

### 2.2 デフォルトユーザーの設定

起動時のデフォルトユーザーを設定します。
以下のように、`/etc/wsl.conf`を設定します。

```:/etc/wsl.conf
 .
 .
 .
## User settings
[user]
default=<myaccount>    # <myaccount>は、自分のアカウントに置き換えてください。

```

## 3. WSLの再起動

以上で、WSL の設定委は終了です。
WSL を再起動すると、設定が反映されて開発環境が使えるようになります。

### 3.1 WSLを再起動する

WSL をシャットダウンします。
PowerShell で次のコマンドを実行します:

```powershell
wsl --shutdown
```

以後、Debian は開発環境が構築された状態で起動します。

## 4. 追加の設定

この章では、開発環境を自分の GitHub で管理する方法を紹介します。

### 4.1 dotfilesの読み込み

## おわりに

## 参考資料

### Webサイト
