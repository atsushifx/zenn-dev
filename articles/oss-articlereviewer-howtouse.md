---
title: "TechArticleReviewer: 技術ブログ執筆を支援する記事編集フレームワーク"
emoji: "📝"
type: "tech"
topics: [ "生成AI", "AIチャットボット", "chatgpt", "prompt", "oss" ]
published: false
---

## はじめに

`atsushifx`です。

GitHub で、[`TechArticleReviewer`](https://github.com/atsushifx/tech-article-reviewer) という技術記事編集フレームワークを公開しました。
このフレームワークは`ChatGPT`のようなチャットAI向けに、技術ブログをレビューするプロンプトを提供します。
出力結果を活用することで、文章の精度を向上させ、質の高い技術記事を効率的に執筆できます。

## プロンプトの使い方

この章では、プロンプトの基本的な使い方を説明します。

1. プロンプトのダウンロード:
   [TechArticleReviewer](https://github.com/atsushifx/tech-article-reviewer/)リポジトリから`article-review.prompt` をダウンロードします。

2. プロンプトの設定:
   PC上の`article-review.prompt`をエディタ (`VS Code`など) で開き、以下の項目を設定します。

   | 項目 | 変数名 | 詳細 | 備考 |
   | --- | --- | --- | --- |
   | 主題 | :theme | 記事のテーマ、何を書くか | |
   | 対象読者 | :target | 記事の対象となる読者 | 複数でもいい |
   | ゴール | :goal | 記事の目的 |  |
   | リンク | :link | 参考サイトへのリンク | なくてもよい |
   | 特記事項 | :remark | 記事をレビューするうえでの特記事項 | 変更したくない文などを設定する |

   たとえば、この記事をレビューする場合、プロンプト中の記述は次のようになります:

   ```text:review.prompt
   """"

   :theme: ; 記事を書く上で主題となる話

   - レビュープロンプト 'TechArticleReviewer'の紹介

   """"

   :target: ; 作成した記事の対象読者

   - zenn:<https://zenn.dev/>にて記事を書いている／書こうとしているITエンジニア

   """"

   :goal:  ; 記事の目標 (例: 読者がZennで記事を書けるようにする)

   - ITエンジニアが、プロンプトを試してみる

   """"

   :link: ; 記事の参考資料となるWebサイトへのリンク

   - TechArticleReviewer: <https://github.com/atsushifx/tech-article-reviewer/>

   """"

   :remark: ; たとえば、特定の表現や文体を保持したい場合など

   - "`atsushifx`です"は、変更しない

   """"
   ```

   と、なります。

3. プロンプトの実行:
   [ChatGPT](https://chatgpt.com/)、[Claude](https://claude.ai/) などの`AIチャットボット`にアクセスし、上記のプロンプトをコピー&ペーストして実行します。
   プロンプトが正しく解釈されるとメッセージが表示され、入力待ちになります。

   ```text:
   プロンプトを確認しました。レビューを開始するには、/begin コマンドを実行してください。
   レビュー対象の文章を入力いただければ、指示に従ってレビューを行います。

   ```

4. 技術記事のレビュー:
   対象の技術記事を`/begin`、`/end`で囲んで、チャット AI に送信します。

   ```text:
   /begin

   ---
   title: "TechArticleReviewer: 生成AIを使った記事編集フレームワーク"
   emoji: "📝"
   type: "tech"
   topics: [ "生成AI", "AIチャットボット", "chatgpt", "prompt", "oss" ]
   published: false
   ---

   ## はじめに

   `atsushifx`です。

    <!-- 以下、記事の本文 -->

   /end
   ```

   レビュー結果が表示されます。

   ```chatgpt:
   以下は、レビュー結果です。改善点と修正案をセクションごとに整理しました。

   -----
   セクション: タイトル

   - 行番号: 1
     改善点: タイトルに冗長さがあり、「生成AIを使った」という表現が直接的すぎます。「生成AIを活用した」とすることで、より洗練された印象を与えられます。
     修正案: "TechArticleReviewer: 生成AIを活用した技術記事編集フレームワーク"
     修正前: "TechArticleReviewer: 生成AIを使った記事編集フレームワーク"
     修正後: "TechArticleReviewer: 生成AIを活用した技術記事編集フレームワーク"

    ```

5. 記事の修正:
   出力されたレビュー結果を参考に記事を改善します。とくに問題がなければ、修正案の文章に書き換えてもかまいません。

   ```chatgpt
   ---
   title: "TechArticleReviewer: 生成AIを使った記事編集フレームワーク"
   emoji: "📝"
   type: "tech"

   ```

6. レビュー、修正の繰り返し:
   修正後の記事を、さらに`/begin`、`/end`ではさんでレビューします。
   こうして記事をブラッシュアップします。

7. 記事の確認:
   ブラッシュアップが終わったら、`Preview`で記事を読んでみます。
   問題がなければ、`zenn`に記事を公開して終了です。

## おわりに

この記事では、TechArticleReviewer のレビュー用プロンプトを紹介しました。
このプロンプトを使えば、記事のレビューが容易にでき、記事の質を高めることができます。
この記事も本プロンプトを使用してレビューしました。

プロンプトを試してみて、ぜひフィードバックをお寄せください。
それでは、Happy Hacking!
