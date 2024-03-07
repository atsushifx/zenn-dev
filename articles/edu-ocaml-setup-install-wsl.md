---
title: "OCaml: WSL環境にOCamlをセットアップする"
emoji: "🐪"
type: "tech"
topics: [ "WSL", "OCaml", "環境構築", "関数型プログラミング", ]
published: false
---

## はじめに

この記事では、Windows の`WSL`環境に`OCaml`をセットアップする手順をご紹介します。
`OCaml` は、`ML`系の関数型プログラミング言語で、静的型付けやパターンマッチなどの特徴があります。
この手順に従えば、`WSL`上で`OCaml`を簡単にインストールし、関数型プログラミングの学習環境を構築できます。

`OCaml`をセットアップし、関数型プログラミングの世界を楽しみましょう。
Enjoy!

## 技術用語

## `OCaml`とは

### `OCaml`の特徴

`OCaml`は、静的型付けの関数型プログラミング言語です。
主な特徴として以下があげられます:

- 厳密な型チェック
- 型推論による型の自動推定
- パターンマッチ
- モジュールシステム
- オブジェクト指向プログラミングのサポート

`OCaml`は「マルチパラダイム言語」と呼ばれ、関数型と手続き型、オブジェクト指向の要素を兼ね備えています。

### `opam` (`OCaml`パッケージマネージャー)

`opam`は`OCaml`用のパッケージマネージャーです。
`OCaml`自身も`opam`で提供されており、複数のバージョンの`OCaml`を切り替えて使うことができます。

`opam`により提供されるパッケージには、さまざまなパッケージがあります。
たとえば、`utop`というパッケージは、`OCaml`の`REPL`を大幅に機能拡張し、編集機能やタブ補完機能を追加します。

ほかのさまざまなパッケージは、`opam list -a`で見ることができます。
色々なパッケージを試してみるのも良いでしょう。

## 前提条件

この記事では、以下の条件が満たされている必要があります。
条件が満たされていないときは、[WSL開発環境: 環境構築の記事まとめ](https://zenn.dev/atsushifx/articles/wsl2-debian-setup-matome)の各記事にしたがって、環境を構築してください。

- `Homebrew`がインストール済み
- `XDG Base Directory`仕様の各環境変数`XDG_CONFIG_HOME`が設定済み
- `dotfiles`による`bash`環境が設定済み

以上です。

## `OCaml`のインストール

`OCaml`をインストール手順は、次の通りです。

### `OPAMROOT`の設定

`OPAMROOT`は`opam`がパッケージを管理する場所を指定する環境変数です。
`OPAMROOT`を指定しない場合は、Windows は、`＄USERPROFILE/.opam`でパッケージを管理します。

この記事では、`XDG Base Direcory`に準じた`OPAMROOT`を設定することで、環境をクリーンに保ちます。
次の手順で、`OPAMROOT`を設定します。

1. `envrc`に以下の行を追加する:

   ```bash:~/.config/envrc
   #  ocaml
   export OPAMROOT="$XDG_DATA_HOME/opam"
   ```

以上で、`OPAMROOT`の設定は完了です。

### `bubblewrap`のインストール

`bubblewrap`は、ユーザー権限でサンドボックスを作成するツールです。
`OCaml`では、サンドボックス機能を実現するために使われています。

次の手順で、`bubblewrap`をインストールします。

1. `brew`でインストール:

  ```bash
  brew install bubblewrap`
  ```

以上で、`bubblewrap`のインストールは完了です。

### ターミナル (WSL)の再起動

ここまでで設定した環境変数を`WSL`に反映させるため、ターミナル`WSL`を再起動します。
次の手順で、ターミナルを再起動します。

1. ターミナルの終了
   `exit`を入力し、ターミナルを終了します:

   ```bash
   exit
   ```

2. WSL の起動
   `Windows Terminal`のプルダウンメニューで、`Debian`を選択します。
   ![Terminal-プルダウンメニュー](https://i.imgur.com/wAW3pvL.jpg)

以上で、WSL の再起動は完了です。

### `opam`のインストール

パッケージマネージャー`opam`は、`brew`を使ってインストールします。
次の手順で、`opam`をインストールします。

1. `brew`で、`opam`をインストールする:

   ```bash
   brew install opam
   ```

以上で、`opam`のインストールは終了です。

### `opam`の初期化

`opam`の各種コマンドを使えるように、`opam`を初期化します。
次の手順で、`opam`を初期化します。

1. `opam init`で`opam`を初期化します:

   ```bash
   opam init --bare --shell=bash -a
   ```

以上で、`opam`の初期化は終了です。

### `opam switch`での`OCaml`のインストール

`opam switch`は複数のバージョンの`OCaml`をインストールできる機能です。
インストールした`OCaml`は、`opam switch`で切り替えられます。

次の手順で、`OCaml`をインストールします。

1. `OCaml`をインストールする:

   ```bash
   opam switch create current 5.1.1
   ```

   **注意**:
   上記の`5.1.1`は、`OCaml`のバージョンを指定します。
   どのバージョンが指定できるかは、`ocaml switch list-available`を使用してください。

以上で、`OCaml`のインストールは終了です。

### `profile`の設定

`OCaml`の環境を設定するため、`$XDG_CONFIG_HOME/profile`に次の行を追加します。
<!-- markdownlint-disable line-length -->
```bash:$XDG_CONFIG_HOME/profile
# opam configuration setup
test -r /home/atsushifx/.local/share/opam/opam-init/init.sh && . /home/atsushifx/.local/share/opam/opam-init/init.sh > /dev/null 2> /dev/null || true

```
<!--markdownlint-enable -->
以上で、`profile`の設定は終了です。

### ターミナルの再起動

`profile`で設定した`OCaml`の設定を反映させるため、ターミナル (WSL)を再起動します。
次の手順で、ターミナルを再起動します。

1. ターミナルの終了
   `exit`を入力し、ターミナルを終了します:

   ```bash
   exit
   ```

2. WSL の起動
   `Windows Terminal`のプルダウンメニューで、`Debian`を選択します。
   ![Terminal-プルダウンメニュー](https://i.imgur.com/wAW3pvL.jpg)

以上で、WSL の再起動は完了です。

## `OCaml`の起動、終了

`OCaml`が正常にインストールできたかどうかを確認するため、`OCaml`を起動、終了します。

### `OCaml`の起動

次のコマンドで、`OCaml`を起動します。

```bash
ocaml
```

以下のように、プロンプトが表示されれば成功です。

```ocaml
The OCaml version 5.1.1
Enter #help;; for help.

#
```

以上で、`OCaml`の起動は終了です。

### `OCaml`の終了

起動した`OCaml`を終了するには、`quit`ディレクティブを入力する方法と、`EOF`を入力する方法の 2つがあります。
次の方法で、`OCaml`を終了します。

1. `quit`ディレクティブを入力する:
   `#` (ディレクティブ開始), `quit` (コマンド), `;;` (終端記号)を入力して、`OCaml`を終了させる

   ```ocaml
   # #quit;;

   $
   ```

2. `EOF`を入力する:
   `Ctrl+D`を打ち、`EOF`を入力する

   ```ocaml
   # [Ctrl+D を入力]

   $
   ```

以上で、`OCaml`の終了は完了です。

## おわりに

ここまでの手順で、`WSL`上に`OCaml`の基本的な実行環境が構築できました。

今後は`OCaml`用の統合開発環境の導入や、さまざまなパッケージの活用などを通して、`OCaml`による本格的な関数型プログラミングをするのも良いでしょう。」

関数型プログラミングの面白さを体感し、プログラミングスキルの向上に役立ててください。
それでは、Happy Hacking!

## 参考資料

### Webサイト

- **[公式サイト](https://ocaml.org/)**:
  `OCaml`公式サイト。`OCaml`の配布、パッケージの配布、チュートリアルの提供などを行っている。
- **[`OCaml` - `Wikipedia`](https://ja.wikipedia.org/wiki/OCaml)**:
  Wikipedia による `OCaml`の解説。
- **[WSL開発環境: 環境構築の記事まとめ](https://zenn.dev/atsushifx/articles/wsl2-debian-setup-matome)**:
  この記事での前提となる WSL環境の構築方法の説明記事へのリンク集

### Webリソース

- **[`OCaml`チュートリアル(日本語)](https://v2.ocaml.org/learn/tutorials/index.ja.html)**:
  公式サイトによる、`OCaml`チュートリアル日本語訳。
- **[`IoPLMaterials`](https://kuis-isle3sw.github.io/IoPLMaterials/)**:
  京都大学による`OCaml`プログラミングの講義資料。
- **[お気楽`Ocaml`プログラミング入門](http://www.nct9.ne.jp/m_hiroi/func/ocaml.html)**:
  広井誠氏による`OCaml`プログラミング紹介ページ。機能紹介と演習など。

### 本 (含むPDF)

- **[関数型言語で学ぶプログラミングの基本](https://tatsu-zine.com/books/programming-basics-with-ocaml)**:
  2024年、最新の`OCaml`のによる関数型プログラミングの学習本。

- **[プログラミングの基礎](https://www.saiensu.co.jp/search/?isbn=978-4-7819-9932-6&y=2018)**:
  お茶の水女子大の浅井健一先生による、プログラミング講義の教科書。

- **[`OCaml`入門テキスト](https://www.fos.kuis.kyoto-u.ac.jp/~igarashi/class/isle4-09w/mltext.pdf)**:
  京都大学の五十嵐先生による`OCaml`入門テキスト。1章は古いのスキップ推奨。
