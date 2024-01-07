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

以上で、`custom-debian.tar.7z`をダウンロ－ドできます。

## 2. Debianのカスタマイズ

## 3. その他

## おわりに

## 参考資料

### Webサイト
