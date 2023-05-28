---
title: "WindowsでUNIX系ツールを使うためのインストールガイド"
emoji: "🪟"
type: "tech"
topics: ["Windows", "CLI", "coreutils", "Scoop", "コマンドライン" ]
published: false
---

## はじめに

Windows の PowerShell コマンドライン環境は強力ですが、プログラム開発時においては、標準的に提供されているコマンドでは不足する場合があります。
そんなとき、`UNIX/Linux`環境で使われるツール類を Windows にインストールすることで、より柔軟で強力な操作が可能になります。

この記事では、Windows上で使用できるようになる UNIX系ツールのインストール方法を紹介します。

## UNIX系ツールとは

ここでいう UNIX 系ツールは、'sh'.'bash'などのシェルや`GNU CoreUtils`などの`UNIX/Linux`のコマンドライン環境の中心となるコマンド群のことを示します。
これらのツールをインストールすることで、Windows上でも Linux と同じ操作が可能です。

### BusyBox

`BusyBox`は、Linux の主要コマンドをまとめて１つのパッケージにしたプログラムです。 'sh','bash'といったシェルも含まれているため、シェルの代わりにもなります。
それぞれのコマンドは `BusyBox`のサブコマンドとして呼びだすほかに、`BusyBox`の別名として呼びだすこともできます。
`BusyBox`が`ls`,`mv`のようなコマンド名で実行されたときは、BusyBox 自身がコマンドを実行します。

``` PowerShell
busybox ls .    # ls .
ls .            # busybox .を実行するが、動作は ls .

```

### Core Utils

`Core Utils`（GNU Core Utilities）は、`UNIX/Linux`系`OS`で中核となる`ls`,`cat`,`rm`などの一群のコマンドをまとめて提供しているパッケージです。
BusyBox はパッケージの中でも主要なコマンドだけを提供していますが、Core Utils はすべてのコマンドを提供しています。

### less,grep

`less`, `grep` は UNIX/Linux 環境で頻繁に使用されるコマンドです。`Core Utils`には含まれていませんが、Linux ディストリビューションとの互換性を考えると、インストールしておくと便利です。

### tree

tree は、ファイルやディレクトリをツリー表示するコマンドです。
Windows にも tree コマンドがありますが、Linux 用のほうが機能豊富です。
ここでは、機能の豊富さと Linux との互換性のために、Linux 用の`tree`コマンドをインストールします。

## UNIX系ツールのインストール

### 前提環境

Windows 側は、以下のようにディレクトリを構成しています。

``` ディレクトリツリー
c:\
 |-- app
 |   |-- develop   # 開発ツール
 |   |-- launnch   # アプリショートカット用
 |   \- scoop     # Scoop Global
 |
 \-- bin
     |-- Wz        # Wzエディタ
     |-- init      # 初期化用
     |-- neovim    # NeoVIM エディタ
     |-- scripts   # 各種スクリプト
     `-- tools     # UNIX系ツール、コマンドラインツール

```

Scoop を使ってインストールしたコマンドは、`c:\app\scoop\`下に配置します。
そのほかのコマンドは、Windows のコマンドライン用コマンドを配置するディレクトリ`c:\bin\tools`下にインストールします。

両方とも Windows の環境変数`PATH`に登録しているので、コンソールを起動すればすぐに UNIX系コマンドが使えます。

### BusyBoxのインストール

`BusyBox`は`Scoop`でインストールできます。
次の手順で、`BusyBox`をインストールします。

1. 管理者でターミナルを開く
   ![Terminal(Admin)](https://i.imgur.com/s9UlEdQm.png)

2. `BusyBox`をインストールする

   ``` powershell
   scoop install busybox -g
   ```

以上で、BusyBox のインストールは終了です。

### CoreUtilsのインストール

Scoop には、通常の`coreutils`と`Rust`製の`uutils`があります。
今回は、`uutils`をインストールします。

1. 管理者でターミナルを開く
   ![Terminal(Admin)](https://i.imgur.com/s9UlEdQm.png)

2. `coreutils`をインストールする

   ``` powershell
   scoop install uutils-coreutils -g
   ```

以上で、`Core Utils`のインストールは終了です。

### less, grep のインストール

`less`,`grep`とも`Scoop`でインストールできます。
次の手順で、`less`,`grep`をインストールします。

1. 管理者でターミナルを開く
   ![Terminal(Admin)](https://i.imgur.com/s9UlEdQm.png)

2. `less`をインストールする

   ``` PowerShell
   scoop install less -g
   ```

3. `grep`をインストールする

   ``` PowerShell
   scoop install grep -g
   ```

以上で、`less`,`grep`のインストールは終了です。

### treeのインストール

`tree`は`Scoop`ではインストールできません。そのため、手動でパッケージをダウンロードしてインストールします。
次の手順で、'tree'をインストールします。

1. [Tree for Windows](https://gnuwin32.sourceforge.net/packages/tree.htm): <https://gnuwin32.sourceforge.net/packages/tree.htm> にアクセスします。
   [![Tree for Windows](https://i.imgur.com/FhehnD0m.png)](https://gnuwin32.sourceforge.net/packages/tree.htm)

2. [Binariesのリンク](http://downloads.sourceforge.net/gnuwin32/tree-1.5.2.2-bin.zip)をクリックし、アーカイブをダウンロードする

3. ダウンロードしたアーカイブを展開する

4. 展開して出てきた"`tree.exe`"を"`c:\bin\tools`"にコピーする

   ``` powershell
   cp .\tree-1.5.2.2-bin\bin\tree.exe c:\bin\tools\

   ```

以上で、`tree`のインストールは終了です。

## さいごに

この記事では、Windows に UNIX系のツールをインストールする方法を紹介しました。
UNIX系ツールを使うことにより、Windows上でも柔軟な操作が可能になります。

他に必要なツールがある場合は、`winget`や`Scoop`などのパッケージ管理ツールを利用することで、簡単にインストールできます。
また、`Windows 10/11`環境では、`WSL`　(`Windows Subsystem for Linux`) を使用して `Linux` をネイティブに動かすこともできます。

以上で、Windows で UNIX 系ツールをインストールする方法についての解説を終わります。

それでは、Happy Hacking!

## 技術用語と注釈

## 参考資料

### Webサイト

1. GNU core utilities: <https://www.gnu.org/software/coreutils/>
2. uutils coreutils: <https://github.com/uutils/coreutils>
3. Busybox for Windows: <https://frippery.org/busybox/>
4. less: <https://www.greenwoodsoftware.com/less/>
5. GNU grep: <https://www.gnu.org/software/grep/>
6. Tree for Linux: <http://mama.indstate.edu/users/ice/tree/>
7. Tree for Windows: <https://gnuwin32.sourceforge.net/packages/tree.htm>
