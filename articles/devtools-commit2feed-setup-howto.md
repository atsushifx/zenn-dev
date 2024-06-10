---
title: "Commit2Feed: GitHubのコミット履歴をRSSフィードで出力する方法"
emoji: "🔔"
type: "tech"
topics: [ "githubaction", "githubpage", "commit2feed", "RSS", ]
published: false
---

## tl;dr

`Commit2Feed`を使用して、`RSSフィード`を生成する方法。

1. `GitHubワークフロー`に`Commit2Feed`を導入する
2. 作成したワークフローで`RSSフィード`を生成する
3. `GitHub Pages`に`RSSフィード`を組み込む

以上の手順で、リポジトリの更新情報を`RSSフィード`で発信できます。
Enjoy!

## はじめに

`GitHubリポジトリ`のコミット履歴から、`RSSフィード`を生成する`Commit2Feed`アクションを開発しました。

[TIL](https://github.com/atsushifx/til)リポジトリを例に、上記アクションの活用方法を説明します。

## 1. `Commit2Feed`とは

`Commit2Feed`は、`GitHubリポジトリ`のコミット履歴を`RSSフィード`形式で自動生成します。
`GitHubアクション`として提供されており、任意のワークフローで使用できます。

## 2. `commit2feed`のセットアップ

### 2.1 `Commit2Feed`のワークフロー設定方法

`Commit2Feed`カスタムアクションを使用して、`RSSフィード`を作成する`GitHub`ワークフローを作成します。
次の手順で`GitHubワークフロー`を作成します:

1. `GitHubワークフロー`の作成
   リポジトリに`.github/workflows`ディレクトリを作成し、`generate_rss.yml`ファイルを作成します。
   ファイルの中身は、次のようになります。

   @[gist](https://gist.github.com/atsushifx/56d5076d940da8e1a297a568e7a67abd?file=generate_rss.yml)

2. `GitHub workflows`の権限設定
   作成した`RSSフィード`をリポジトリに保存するため、`GitHub Workflow`にリポジトリへの書き込み権限を設定します。

   2.1 権限設定画面へ移動
    リポジトリ画面から、

    - `Settings`メニューを選択し
    - 左の`General`メニューから、`Actions`-`General`を選択します。

    ![GitHub Actions permissions](https://i.imgur.com/HriwbZu.png)

   2.2 権限の設定
    下段の`Workflow permissios`画面で、

    - `Read and write permissions`を選択し、
    - `Allow GitHub Actions to create and approve pull requests`をチェックします。
    - `Save`ボタンで設定を保存します。

    ![workflow permission](https://i.imgur.com/QqqWfZY.png)

### 2.2 `RSSフィード`の作成

`Generate RSS Feed`ワークフローを使い、`RSSフィード`を作成します。
次の手順で、`RSSフィード`を作成します:

1. `Generate RSS Feed`画面へ移動
   次の手順で、`Generate RSS Feed`画面に移動します。
   - `Actions`メニューを選択し、
   - `All workflows`で、`Generate RSS Feed`を選択します。

   ![`Generate Feed`](https://i.imgur.com/RspUD5l.png)

2. `RSSフィード`の作成
   次の手順で、`RSSフィード`を作成します。
   - `Run workflow`ボタンをクリックし、`Use workflow flom`ダイアログを表示します。
   - ダイアログ中の`Run workflow`ボタンをクリックし、`RSSフィード`を作成します。

   ![`Run workflow`](https://i.imgur.com/uiDxOkE.png)

3. `RSSフィード`の確認
   `RSSフィード`は、[`/docs/rss/feeds/xml`](https://raw.githubusercontent.com/atsushifx/til/main/docs/rss/feeds.xml)に作成されます。

## 3. `RSSフィード`の組み込み

作成した`RSSフィード`を、`GitHubページ`に組み込む必要があります。
これにより、`GitHubページ`の更新としてリポジトリの更新履歴が出力されます。

### 3.1 `GitHubページ`の作成

次の手順で、`GitHubページ`を作成します:

1. ページ用ディレクトリの作成
   `GitHubページ`用に`/docs`ディレクトリを作成し、TOP ページとして`index.md`ファイルを作成します。

2. ページ作成画面に移動
   2.1 リポジトリ画面で、\[Settings]を選択し、
   2.2 \[Pages]を選択します。

   ！[Pages](https://i.imgur.com/C78AEJX.png)

3. `GitHubページ`の作成
   `branch`セクションで、
   - `main`ブランチを選び、
   - `/doc`ディレクトリを選びます

   \[save]をクリックし、作成するページを保存します。

    ![Build](https://i.imgur.com/HvDq7pT.png)

4. テーマの設定
   リポジトリルートに`_config.yml`を作成し、下記の内容を設定します。

   ```yaml:_config.yml
   theme: jekyll-theme-cayman

   ```

### 3.2 `RSSフィード`を`GitHubページ`に組み込む

次の手順で、`RSSフィード`を`GitHubページ`に組み込みます:

1. カスタマイズ`headerファイル`の作成
  1.1 `/docs`下に`/_includes/head_custom.html`ファイルを作成します。
  1.2 `/_includes/head_custom.html`に次の内容を記述します。

      ```html:head_custom.html
      <link rel="alternate" type="application/atom+xml" title="RSS Feed (ATOM)" href="https://atsushifx.github.io/til/rss/feeds.xml">

      ````

2. フィードへのリンクを追加
   `index.md`ファイルを編集し、次のようにリンクを追加します。

   ```markdown: index.md
   ## RSS Feed

   [RSS Feed](https://atsushifx.github.io/til/rss/feeds.xml)

   ```

## 4. `RSSフィード`の確認

`Webブラウザ`を使って、`GitHubページ`、`RSSフィード`の確認をします。

1. `GitHubページ`は、つぎのようになります。
   ![TIL](https://i.imgur.com/QBaizjo.png)

2. `RSSフィード`は、つぎのようになります。
   ![ フィード](https://i.imgur.com/RspUD5l.png)

このように、`RSSフィード`が表示されれば、正常です。

## おわりに

以上で、`GitHubリポジトリ`の更新履歴を`RSSフィード`で出力できました。
生成した`RSSフィード`は、`GitHubページ`を通じて提供できます。

この記事のように`TIL` (`Today I Learned`)で、リポジトリの更新履歴を出力すれば、自身の学習結果を効率的に発信できます。
やり方は簡単です。この記事の`github workflow`をコピーし、記事にしたがって`GitHubページ`を作成します。
そのあとは、`GitHubページ`に追加した記事が学習履歴として`RSSフィード`に出力されます。

ぜひ、`TIL`リポジトリを作成し、自身の学習成果を共有しましょう。
それでは、Happy Hacking！

## 技術用語と注釈

- `GitHubワークフロー`:
  `GitHub`上で、自動的に実行される一連のタスク

- `Commit2Feed`:
  `GitHub`のコミット履歴を`RSSフィード`形式でを出力するカスタムアクション

- `RSSフィード`:
  Webサイトの更新情報を配信する XML形式のフォーマット

- `GitHub Pages`:
  GitHub リポジトリを用いて、静的サイトをホスティングする無料のサービス。

- `workflow`の権限設定:
  `GitHubワークフロー`がリポジトリに対して行える操作の権限を設定すること

- `GitHubアクション`:
  `GitHubリポジトリ`で自動化されたタスクを実行するための`GitHub`の機能

## 参考資料

### Webサイト

- [`Commit2Feed`](https://github.com/atsushifx/commit2feed/):
  コミット履歴から`RSSフィード`を生成する`Commit2Feed`アクションのリポジトリ
