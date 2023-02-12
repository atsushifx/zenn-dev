---
title: "VS Code: プロファイルが実装されたので、既定のプロファイルの拡張を最小限にする"
emoji: "🧪"
type: "tech"
topics: ["VSCode", "VisualStudioCode", "プロファイル", "開発環境"]
published: false
---

## tl;dr

- 空のプロファイルから、いちいち拡張を入れたり設定をするのは面倒くさい
- 既定のプロファイルがあるから、これをもとにプロファイルをつくれば楽になる
- 既定のプロファイルから開発環境ごとの邪魔な拡張を消して、最小限の構成にする

以上、Enjoy

## もっと詳しく

Visual Studio Code(Ver 1.75)からプロファイル機能がつきました。今までは Workspace ごとに拡張の有効／無効を設定していましたが、これからはプロファイルを設定することで必要な拡張をいれるだけでよくなりました

プロファイルの作成は、空のプロファイルによるⅠから作成するものと現在のプロファイルをもとにしたものがあります。今までの設定は。“既定”のプロファイルに保存されているので、これからは既定をもとにプロファイルを作成することにしました。

もともとの既定のプロファイルには、すべての Workspace の設定や拡張機能があるため、このままでは使えません。既定のプロファイルを Visual Studio Code 全体用の拡張や、核開発環境で共通に使う拡張など最小限の構成にします。

その後は、既定のプロファイルをもとに、使用するプログラミング言語ごとのプロファイルを作成すれば、最小限の設定や拡張の追加ですむことにになります。

## 最小限の構成を作成する

### 最小限の拡張のインストール

既定のプロファイルに入れる、つまり最小限の構成に使う拡張はつぎのようになります。

  1. Visual Studio Code 自体に関する拡張、日本語ランゲージパックなど
  2. 各環境すべてで使うであろう拡張、Markdown 編集拡張など
  3. プログラミング時に開発効率がアップするので入れておきたい拡張

以上の方針で、いかの拡張機能をいれました。

| 拡張 | 機能 | コメント |
|--- |--- |--- |
| Japanese Language Pack for Visual Studio Code | 日本語ランゲージパック | |
| EditorConfig for VS Code | .editorconfigの設定反映 | エディタのインデントは EditorConfig で |
| Iceberg Theme | 配色テーマ | Iceberg Light を使っている |
| Json Editor | jsonファイルの編集 | VS Codeの設定ファイル編集用 |
| Open | ファイルをOSのデフォルトクライアントで開く | ファイルをブラウザなどで開く |
| WakaTime | VS Code用WakaTime拡張 | VS Codeの稼働時間をWakaTimeではかる |
| Markdown All in One | Markdown編集機能 | 各種ドキュメントはMarkdownを使っている |
| Markdown Preview Enhanced | Markdownプレビュー機能を強化 | |
| markdownlint | Markdown記法用文法チェッカ | |
| indent-rainbow | テキストのインデントをカラー表示 |  |
| licenser | workspaceに指定のOSSライセンスを追加 | 自作プログラムはMITライセンスにしてるので |
| Linter | 多言語対応Lint | markdownlintに対応している。ほかのプログラミング言語でも使うので |

### VS Codeの設定

フォントの設定や、拡張機能の設定など各環境で共通な設定をしておきます。
自分の場合、だいたいこんな感じ

| 項目 | 設定 | コメント |
| --- | --- | --- |
| エディタ - fontFamily | "'PlemolJP35 Console NFJ', 'Source Serif 4','DejaVu Serif'", | |
| エディタ - autoIndent | "advanced", | .editorconfigで設定 |
| licenser - license | MIT | |
| licenser - author | atsushifx [[MailAddress]] | 本名と連絡用メールアドレス |

これらの設定もプロファイル作成時に引き継がれます。

## プロファイルのバックアップ

作成したプロファイルは、gist またはローカルのファイルにバックアップできます。
戻すときは、「プロファイルのインポート」をおこないます。

自分の場合、作成したプロファイルはつぎのようになりました。

@[gist](https://gist.github.com/atsushifx/a926d1cbd3f67642c7cc03a916db2297)

## おわりに

このように、最小構成のプロファイルを作成することで環境ごとのプロファイル作成が簡単になりました。
この記事も、既定のプロファイルに zenn 用の拡張機能を追加しただけで使えました。

皆さんもプロファイルをうまく活用して、プログラミングを楽しみましょう。

それでは、Happy Hacking.
