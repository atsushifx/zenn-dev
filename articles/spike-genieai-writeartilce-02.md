---
title: "Spike: Blog: プロンプトを改良して、こんどこそ Genie AIに公開できるレベルの記事を書かせる (リベンジ編)"
emoji: "👟"
type: "idea"
topics: [ "Spike", "zenn", "VS Code", "GenieAI", "ChatGPT" ]
published: false
---

## はじめに

`Genie AI`は`Visual Studio Code`(以下、`VS Code`)から、`ChatGPT`を使うためのフロントエンドツールです。`
プロンプトにブログのテーマやブロガーとしての役割を与えれば、とりあえずブログの記事全部を書いてくれます。
これは、ブログ作成のスピードアップにつながるはず。
というわけで、[前回](spike-genieai-autowrite-blog)の記事で、ブログ記事を書かせてみたわけですが。
前回の記事で書いたように、公開できそうな記事はできませんでした。
今回は、公開できるレベルの記事を書けるように、プロンプトを改良してみました。

### この記事をGenie AIで書く

実際に`Genie AI`で記事を書く例として、この記事を`Genie AI`で書いてみました。
結局、90%以上は人が書いた文章になりましたが、記事のスケルトン、つまり、公開する記事を素早く書くためのたたき台としてうまく機能しました。

## Genie AI とはなにか

はじめに、でも書いたとおり、Genie AI は`Visual Stusdio Code`から"[ChatGPT](https://chat.openai.com)"を利用するためのフロントエンドツールです。
プログラマーは編集中のコードを ChatGPT に入力して、補完されたコードやコードの説明などの答えを返すことができます。
また、左側の Genie AI ペーンを使うと、普通の質問も行えます。今回は、この機能を利用してブログの記事を執筆します。

## Genie AI でブログを書く

### Genie AIにブログを書かせるためのプロンプト

Genie AI を使用すると、プロンプトを入力するだけで、文章を書く作業を効率的に行なうことができます。
この記事では、次のプロンプトを使用しました。
ポイントは、

1. ChatGPT が重視すべき情報を role といった変数にして、文章の後に`"""`で区切って入力するようにしたこと

2. 見出しを決め、文章全体にまとまりができるようにすること

3. レビューと推敲を繰り返すことで文章の質を高めたこと

です。

``` Genie AI: 記事執筆用プロンプト
あなたは、roleで示されたブロガーです。textで示された見出しに従ってブログ記事の一節を書いてください。
remarkにしたがいWeb上の情報も参照して、間違いのない文章を書いてください
論理的、段階的に考えて出力した文章を5回レビュー、推敲して、より質の高い記事にしてください
作成した文章は、マークダウン形式で出してください
role: """
- 一流のハッカーで技術ブロガー
- アルファブロガー

remark: """
Genie AI: Visual Studio CodeでChat GPTのチャットをするための拡張機能
Editor View: チャットの文章を編集中のテキストに入力する機能

text:"""

## はじめに

## Genie AI でブログを書く

## おわりに

```

### Editor Viewを使って、直接ブログを書く

Editor View は、ChatGPT の答えを本文中に直接入力する機能です。
Genie AI 起動時にでてくる`Conversation View`と比べ、作成した文章を手動でコピー&ペーストする必要がないので、執筆スピードが大幅にアップします。

### この記事もGenie AIで書いています

そもそものテーマとして、Genie AI で Blog として公開可能な記事を書くということがあります。この記事は実際に`Genie AI`を使って書いてみました。
正確には、まず、Genie AI で初稿を書き、読みづらいところなどを書き直して第二稿を書きました。
その後は、ChatGPT にレビュー・校閲をしてもらって完成度を高めています。

## おわりに

`Genie AI`に入力するプロンプトを工夫することで、かなり質の高い文章を書いてくれるようになりました。
とはいえ、参考資料のリンクはいい加減ですし、レビュー・校閲をするとほぼ全文書き直しになります。

あくまでも、ブログを書くためのたたき台、というのが正直なところです。

質の良い Blog 記事を書くためのツールとしてなら十分に使えるというところでしょう。
それでは、Hapapy Hacking!

## 参考資料

### Webサイト

- [ChatGPT - Genie AI](https://marketplace.visualstudio.com/items?itemName=genieai.chatgpt-vscode)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Chat GPT](https://chatgpt.org/)

### ブログ記事など

- [日本語で解説！Best practices for prompt engineering with OpenAI API](https://zenn.dev/milo/articles/c8a29d4a434bc3)
g/)
- [【GPT】プロンプトエンジニアリング手法まとめ](https://qiita.com/sonesuke/items/24ac25322ae43b5651bc)
