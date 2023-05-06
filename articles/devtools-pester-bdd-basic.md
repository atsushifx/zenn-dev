---
title: "PowerShell: Pesterを使ったBDDの実践方法"
emoji: "🚀"
type: "tech"
topics: [ "PowerShell", "Pester", "BDD", "ユニットテスト", "コーディング" ]
published: true
---

## 1. はじめに

この記事では、PowerShell[^1] 用のテストフレームワーク Pester[^2] を使った BDD __(振る舞い駆動開発)__[^3]を、コメントを削除する関数`Remove-Comments`を実装しながら説明します。
Pester のインストール手順については、[Pesterのインストール手順](devtools-pester-install)を参照してください。

[^1]: PowerShell: 主に Window で使われるスクリプト実行環境およびシェル
[^2]: Pester: PowerShell 用の BDD テスティングフレームワーク
[^3]: BDD __(振る舞い駆動開発)__: ソフトウェア開発手法の 1つで、ユニットテストを通じて振る舞いを記述することで、実装に先立って要件を明確にする

## 2. 機能要件

今回、`Remove-Comments`関数は、以下の機能要件を満たすように開発します。

- 行コメント
- 付加コメント
- インラインコメント
- マルチラインコメント
- 上記コメントの削除
- コメント削除後の行頭、行末の空白を削除
- テキストはパイプにより入力可能

## 3. 開発環境

### 3.1. ディレクトリ構成

以下のディレクトリで関数を開発します。

``` text: ディレクトリ構成
  powershell
  |-- .editorconfig
  \-- Remove-Comments
      \-- Tests

```

今回、開発する"Remove-Comments"関数は"Remove-Comments/"ディレクトリ下で開発します。
Pester 用のテストコードは、"Remove-Comments/Tests/"下に作成します。

`New-Fixture`コマンドレットとは違い、テストコードを`Tests/`下にまとめているので、注意してください。

## 4. BDDを使った開発プロセス

BDD では、まずユニットテストを作成し、その後、実際のコードを作成します。
このループを続けることで、入力やそれに対応した出力が明確な読みやすいプログラムを書けるようになります。

この記事では、それぞれの BDD ステップでテストケースの追加と、それに対応したコードを作成します。

### 4.1. 1st BDD (Pesterの動作チェック)

最初の BDD では、以下のことを確認します。

- Pester テストが実行できる
- 作成すべき関数が存在する
- 作成すべき関数を読み込み、Pester テストを実行する
- 関数が未実装なので、`fail`を出力する

まずは、Pester に最初のテストケースを作成します。
このテストケースでは、単純に空のテキストなら空であることをチェックします。

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments.Tests-1.ps1)

次に、開発対象である`Remove-Comments`関数を作成します。
内部はまだ実装しません。その代わり、"No Implementation"という例外をスローして**未実装である**ことを示します。
作成する関数は、以下のようになります。

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments-1.ps1)

この場合の結果が、

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=output-illegal-notfound)

のように、`CommandNotFoundException:`が出力される場合は、テストする関数が正常に読み込めていません。

この Pester テストスクリプトでは、`BeforeAll`セクションで"Tests/"の 1つ下のディレクトリにある"Remove-Comments.ps1"ファイルを読み込んでいます。
ファイル名は、Pester テストスクリプトから作成しているのでテストスクリプトのファイル名が間違っていたり、コードが親ディレクトリを参照していないと上記のエラーが発生します。

ファイル名やコードを見直して、`Remove-Comments`関数を正しく読み込むようにします。

`Invoke-Pester`の出力が、

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=output)

のように、"RuntimeException: No implementation"と出力されていれば、`Remove-Comments`関数が投げた例外をキャッチしてエラーとなっています。

これで、Pester が正常に動いていることが確認できました。

### 4.2. 2nd BDD (コードの実装)

ここでは、以下のことを目的とします。

- 最初のユニットテストをパスする

上記の目的を満たすために、最低限のコードを実装します。
コードは、

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments-2.ps1)

次のようになります。

コードはパラメーター`$text`がパイプからの入力もあることを宣言し、それを単純に出力しています。

作成したコードを、`Invoke-Pester`としてテストします。

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=output-passed-2)

空のテキストが返るので`Tests Passed 1`となります。
'関数`Remove-Comments`'が、正常に動いていることが確認できました。

このように、テストを通るためだけのコードを書くことで、ムダのないコードを書くことができます。

### 4.3. 3rd BDD (行コメント削除)

行コメント削除機能を実装します。
"Remove-Comments.Tests.ps1"にユニットテストを追加し、そのテストを通すように目的のコードを実装します。

#### 4.3.1. 行コメント

ここでは、以下のことを目的とします。

- 1行コメント(行すべてがコメント)の削除をテストするコードを書く
- 付加コメント(行の途中からのコメント)の削除をテストするコードを書く
- 1行コメントの削除機能を実装
- 付加コメントの削除機能を実装

まず、テストスクリプトに行コメント削除機能テスト用のテストケースを追加します。

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments.Tests-3.ps1)

1行コメントは、空行となるので`Should -BeNullOrEmpty`でチェックします。
付加コメントは、`Should -Be`コマンドレットでコメント削除後の文字列と一致するかチェックします。

次に、`Remove-Comments`関数のコードに行コメント削除機能を実装します。
関数のコードは、

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments-3.ps1)

となります。

上記コードでテストがすべてパスするので、実装は完了です。

#### 4.3.2. 文字列内のコメントを無視

ここでは、以下のことを目的とします。

- 文字列内のコメントを削除しないテストケースを追加
- 文字列内のコメントを削除しない処理を実装
- 文字列内のコメントは残し、文字列外のコメントを削除する処理を実装

コメント削除時に、'"(ダブルクォーテーション)'で囲まれた文字列ないの`#`を無視するようにします。

まずは、テストケースを追加します。
テストコードは、

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments.Tests-4.ps1)

となります。

そして、すべてのテストケースが通るように`Remove-Comments`関数を修正します。
修正したコードは、

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments-4.ps1)

となります。

上記のコードで、すべてのユニットテストを通します。
以上で、行コメント削除機能は実装終了です。

### 4.4. 4th BDD (インラインコメントとマルチラインコメント)

[3rd BDD](#43-3rd-bdd-行コメント削除)と同様にテストケースを追加し、すべてのテストケースを通すように目的のコードを修正します。

ここでは、以下のことを目的とします。

- インラインコメントを削除するテストケースを追加
- インラインコメントないの行コメントを無視するテストケースを追加
- インラインコメント内の文字列を無視するテストケースを追加
- マルチラインコメントを削除するテストケースを追加
- インラインコメントを削除するコードを実装
- マルチラインコメントを削除するコードを実装

インラインコメントのテストケースと、マルチラインコメントのテストケースをテストコードに追加します。
最終的なテストコードは、

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments.Tests-5.ps1)

となります。

すべてのテストケースを通すように、`Remove-Comments`関数にコードを追加します。
最終的なコードは、

@[gist](https://gist.github.com/atsushifx/caa148eaffd5de7f3af5fbcd82286fec?file=remove-Comments-5.ps1)

となります。

これですべてのユニットテストをパスするので、コメント削除関数の作成は終了です。

### 4.5 リファクタリングおよびコメントの整備

[4.4](#44-4th-bdd-インラインコメントとマルチラインコメント)で、関数の作成は終了しました。

ここでは、ヘッダコメントを追加し、`Get-Help`コマンドレットで使い方がわかようにします。
また、コードを見直して難しいところにコメントを追加します。
以上で、コードの作成は終了です。

## 5. さいごに

この記事では、BDD による開発の流れを簡単に説明し、Pester を使った BDD の実践方法を紹介しました。

BDD により、テストケースを通すコードのみが実装されるため、策定した要件を明確に満たすコードを書くことができます。
また、Pester は PowerShell 用の BDD テスティングフレームワークで簡単にユニットテストが記述可能であり、継続的な品質確保が行えます。

今回、`Remove-Comments`関数の開発を通して、BDD を用いた開発プロセスがどのように機能し、どのように活用できるかをぶことができました。

今後も BDD と Pester を活用し、より品質の高いコードの開発を目指しましょう。

それでは、Happy Hacking!

## 参考資料

### 公式

- [Pester公式サイト](https://pester.dev/)
- [Microsoft PowerShell 公式ドキュメント](https://learn.microsoft.com/ja-jp/powershell/)

### Webサイト

- [Pester - GitHub](https://github.com/pester/Pester)
