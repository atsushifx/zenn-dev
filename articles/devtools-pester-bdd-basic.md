---
title: "PowerShell: Pesterを使ったBDDの実践"
emoji: "🚀"
type: "tech"
topics: [ "PowerShell", "Pester", "BDD", "ユニットテスト", "コーディング" ]
published: false
---

## 1. はじめに

この記事では、Pester を使った BDD __(振る舞い駆動開発__)[^1]を、関数`Remove-Comments`を実装しながら説明します。
Pester のインストール手順については、[Pesterのインストール手順](devtools-pester-install)を参照してください。

ここでは、パイプ形式で入力したテキストからコメントを削除する関数"`Remove-Comments`"を実装しながら、BDD について解説します。

[^1]: BDD __(振る舞い駆動開発)__: ソフトウェア開発手法の 1つで、ユニットテストを通じて振る舞いを記述することで、実装に先立って要件を明確にする

## 2. 機能要件

以下の要件のコメントを満たすように、関数を作成します。
作成する関数は、以下の条件にしたがってコメントを削除するものとします。

- 行コメント: '`#`'から始まる任意の文字列 (行末までコメント)
- 付加コメント: 行の途中に'`#`'があった場合、以降をコメント
- インラインコメント: '`<#`','`#>`'ないの文章
- マルチラインコメント: 行頭が'`<#`'ではじまり、行末が'`#>`'で終わる行までをコメント
- コメント削除後の行頭、行末の空白を削除
- テキストはパイプによる入力可能

以上の要件を満たすように、関数を作成します。

## 3. 開発環境

以下の環境で、PowerShellスクリプトを作成します。

### 3.1 開発ツールとバージョン

- PowerShell 7.3.4
- Pester 5.4.1
- Visual Studio Code 1.78.0

### 3.2 ディレクトリ構成

以下のディレクトリで関数を開発します。

``` text: ディレクトリ構成
 ..
  |-- .editorconfig
  \-- Remove-Comments
      \-- Tests

```

開発するスクリプトは`Remove-Comments`下に、Pester のテストスクリプトは`Tests`下に作成します。
`New-Fixture`コマンドレットとは違い、テストコードを`Tests/`下にまとめているので、注意してください。

## 4. BDDを使った開発プロセス

### 4.1. 1st BDD

最初の BDD では、以下のことを確認します。

- Pester テストが走る
- 作成すべき関数が存在する
- 未実装の部分があれば、`fail`を出力する

まずは、テストケースを作成します。

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments.Tests-1.ps1)

作成する関数は、以下のようになります。

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments-1.ps1)

関数に何も実装されていないことを示すため、"No implementation"エラーを投げています。

上記のコードで`Invoke-Pester`として`Pester`を実行します。

この場合の結果が、

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=output-illegal-notfound)

のように、`CommandNotFoundException:`が出力される場合は、テストする関数が正常に読み込めていません。

`BeforeAll`で読み込もうとしているスクリプトファイルの名前が間違っているか。あるいは`Remove-Comments.ps1`ではない間違ったファイル名になってるはずです。
この場合は、コードを見直して、スクリプトを読み込むようにします。

`Invoke-Pester`の出力が、

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=output)

のように、"RuntimeException: No implementation"と出力されていれば、関数を正常に読み込んでいます。

これで、Pester が正常に動いていることが確認できました。

### 4.2. 2nd BDD (コードの実装)

ここでは、以下のことを目的とします。

- テストが通るコードを実装する

目的を満たすために、最低限のコードを実装します。

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments-2.ps1)

テスト結果は、

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=output-passed-2)

と、`Tests Passed 1`となります。
関数`Remove-Comments`が正常に動いていることが確認できました。

このように、テストを通るためだけのコードを書くことで、ムダのないコードを書くことができます。

以後は、

- テストケースを書く
- すべてのテストが通るように、コードを実装

というループをくりかえして、開発します。

### 4.3. 3rd BDD (行コメント削除)

行コメント削除機能を実装します。
"Remove-Comments.Tests.ps1"にユニットテストを実装し、そのテストを通すように目的のコードを実装します。

#### 行コメント

ここでは、以下のことを目的とします。

- 1行コメント(行すべてがコメント)の削除をテストするコードを書く
- 付加コメント(行の途中からのコメント)の削除をテストするコードを書く
- 1行コメントの削除機能を実装
- 付加コメントの削除機能を実装

行コメント削除機能テスト用に、テストケースを追加します。

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments.Tests-3.ps1)

`Should`コマンドレットでコメント削除後の文字列と一致するかチェックします。

上記のコードを通るように、コードを実装します。
"removeComments.ps1"のコードは、

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments-3.ps1)

となります。

上記のコードで、テストがすべて通ります。

#### 文字列内のコメントを無視

ここでは、以下のことを目的とします。

- 文字列内のコメントを削除しないテストケースを追加
- 文字列内のコメントを削除しない処理を実装
- 文字列内のコメントは残し、文字列外のコメントを削除する処理を実装

まずは、テストケースを追加します。
テストコードは、

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments.Tests-4.ps1)

となります。

そして、すべてのテストケースが通るように`removeComments.ps1`を修正します。
修正したコードは、

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments-4.ps1)

となります。

これで、行コメントの削除機能が実装されました。

### 4.4. 4th BDD (インラインコメントとマルチラインコメント)

[3rd BDD](#43-3rd-bdd-行コメント削除)と同様にテストケースを追加し、すべてのテストケースを通すように目的のコードを修正します。

ここでは、以下のことを目的とします。

- インラインコメントを削除するテストケースを追加
- インラインコメントないの行コメントを無視するテストケースを追加
- インラインコメント内の文字列を無視するテストケースを追加
- マルチラインコメントを削除するテストケースを追加
- インラインコメントを削除するコードを実装
- マルチラインコメントを削除するコードを実装

上記の目的を満たす最終的なテストコードは、

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments.Tests-5.ps1)

となります。

すべてのテストケースを通すように修正したコードは、

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments-5.ps1)

となります。

### 4.5 リファクタリングおよびコメントの整備

ここまでで、記事通りに開発していれば、すべてのテストケースをパスしているはずです。
機能の実装自体は、ここで終了です。

ヘッダコメントを追加し、コードを見直して難しいところにコメントを追加します。
以上で、コードの作成は終了です。

## 5. さいごに

この記事では、BDD による開発の流れを簡単にまとめました。
今回の記事で学んだ内容をまとめると:

1. Pester を使った BDD の基本的な開発プロセスを理解しました。
2. スクリプトの開発におけるテスト主導開発（TDD）の方法を学びました。
3. 各種のコメント形式（行コメント、付加コメント、インラインコメント、マルチラインコメント）を削除する関数 Remove-Comments を PowerShell で実装しました。

これらの知識を活用して、実際の開発プロジェクトで BDD を利用することで、品質の高いコードを作成できるようになります。

それでは、Happy Hacking!

## 参考資料

### 公式

- [Pester公式サイト](https://pester.dev/)
- [Microsoft PowerShell 公式ドキュメント](https://learn.microsoft.com/ja-jp/powershell/)

### Webサイト

- [Pester - GitHub](https://github.com/pester/Pester)
