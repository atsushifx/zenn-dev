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
1 file, 186643947 bytes (178 MiB)

Extracting archive: .\custom-debian.tar.7z
--

Path = .\custom-debian.tar.7z
Type = 7z
Physical Size = 186643947
Headers Size = 138
Method = LZMA2:24
Solid = -
Blocks = 1

Everything is Ok

Size:       889139200
Compressed: 186643947

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

上記のように、"この操作を正しく終了しました。"と出力されれば、インポートは成功しています・

## 2. Debianのセットアップ

## 3. その他

## おわりに

## 参考資料

### Webサイト
