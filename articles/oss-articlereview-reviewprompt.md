---
title: "TechArticleReviewer: 生成AIを使った記事編集フレームワーク"
emoji: "📝"
type: "tech"
topics: [ "生成AI", "AIチャットボット", "chatgpt", "prompt", "oss" ]
published: false
---

## はじめに

`atsushifx`です。

`GitHub`で、`TechArticleReviewer` <https://github.com/atsushifx/tech-article-reviewer> という生成AI用プロンプトを公開しました。

`TechArticleReviewer`は、主に技術ブログの記事をレビューし、ブログを改善するためのプロンプトです。
このプロンプトの出力結果をもとに記事をブラッシュアップすることで、誰でも質の高い技術記事を書けるようになります。

プロンプトは`MITライセンス`にて公開しているので、商用の記事を書くときにも利用できます。
ぜひ、皆さん使ってみてください。

## プロンプトの使い方

ここでは、プロンプトの簡単な使い方を説明します。

1. プロンプトのダウンロード:
   GitHubの[TechArticleReviewer](ttps://github.com/atsushifx/tech-article-reviewer/) 上の`article-review.prompt` というファイルをダウンロードします。
   (article-review.prompt のページでコピー&ペーストでもかまいません)

2. プロンプトの設定:
   PC上の`artilce-review.prompt`をエディタで開き、以下の項目を設定します。

   | 項目 | 変数名 | 詳細 | 備考 |
   | --- | --- | --- | --- |
   | 主題 | :theme | 記事のテーマ、何の記事を書くかの、何を書く | |
   | 対象読者 | :target | 記事の対象となる読者 | 複数でもいい |
   | ゴール | :goal | 記事の目的 |  |
   | リンク | :link | 参考サイトへのリンク | なくてもよい |
   | 特記事項 | :remark | 記事をレビューする上での特記事項 | 変更したくない文などを設定する |

   たとえば、この記事自体をレビューする場合

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

   - TechArtilceReviewer: <https://github.com/atsushifx/tech-article-reviewer/>

   """"

   :remark: ; その他、記事をレビューする上で注意してほしいこと

   """"
   ```

   と、なります。

3. プロンプトの実行:
   適当なAIチャットボット ([ChatGPT](<https://chatgpt.com/、[Claude>](<https://claude.ai/>) など) にアクセスし、上記のプロンプトをコピー&ペーストして実行します。
   AIが正しくプロンプトを解釈すれば、次のようなメッセージが表示されます (違うこともあります)。

   ```chatgpt
   いつでも /begin コマンドでレビューを始められます。また、具体的な修正案やフィードバックについてのご要望があればお知らせください。

   ```

4. 技術記事のレビュー:
   レビューしたい技術記事を`/begin`、`/end`ではさんで、チャットAIに送信します。

   ```chatgpt:
   /begin
   ---
   title: "TechArticleReviewer: 生成AIを使った記事編集フレームワーク"
   .
   .
   .

   /end
   ```

   レビュー結果が表示されます。

   ```chatgpt:
   以下は、レビュー結果です。改善点と修正案をセクションごとに整理しました。

   -----
   セクション: タイトル

   - 行番号: 1
   - 改善点: タイトルに誤字が含まれています。"AerticleReviewer" は "ArticleReviewer" の誤記です。また、タイトルが冗長で簡潔さに欠けます。
   - 修正案: "TechArticleReviewer: 生成AIを活用した技術記事編集フレームワーク"
   - 修正後: "TechArticleReviewer: 生成AIを活用した技術記事編集フレームワーク"

    ```

5. 記事の修正:
   出力されたレビュー結果を参考に文章を改善します。特に問題がなければ、修正案の文章に書き換えてもかまいません。

   ```chatgpt
   ---
   title: "TechArticleReviewer: 生成AIを使った記事編集フレームワーク"
   emoji: "📝"
   type: "tech"

   ```

6. レビュー、修正の繰り返し:
   修正後の記事を、さらに`/begin`、`/end`ではさんでレビューします。
   こうして記事をブラッシュアップしていきます。

7. 記事の確認:
   ブラッシュアップが終わったら、`Preview`で記事を読んでみます。
   問題がなければ、`zenn`に記事を公開して終了です。

## おわりに

この記事では、TechArticleReviewerのレビュー用プロンプトを紹介しました。
このプロンプトを使えば質の高い技術記事が書けるようになりますし、この記事もプロンプトでレビューしています。

できればプロンプトを使ってみてフィードバックをいただけると嬉しいです。
それでは、Happy Hacking!
