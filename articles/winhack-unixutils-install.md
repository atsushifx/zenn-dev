---
title: "WindowsにUNIX系ツールをインストールする方法"
emoji: "🪟"
type: "tech"
topics: ["Windows", "CLI", "Coreutils", "開発環境", "環境構築" ]
published: false
---

## はじめに

この記事では、Windows 環境で使用できる`UNIX`系ツールのインストール方法を紹介します。

`less`,`grep`など`Linux`環境でよく使われているツールは、Windows にも移植されています。
これらの`UNIX`系ツールを Windows にインストールすることで、`Linux`と同様の操作ができるようになり、コンソールでの生産性が大きく上昇します。

## 1. UNIX系ツールとは

ここでいう UNIX 系ツールは、`sh`、`bash`などのシェルや`Coreutils`などで、`UNIX`/`Linux`の中心となるコマンド群をまとめて提供しています。

`Windows 10/11`では標準で`PowerShell`が使用でき、エイリアスで`rm`、`ls`のような UNIX コマンドも使用できます。
ただし、オプションは`PowerShell`のままなので注意が必要です。

Windows 上でも、`BusyBox`、`Coreutils`といった UNIX系ツールのパッケージをインストールすることで、`Linux`と同じ操作ができるようになります。

### 1.1. BusyBox

`BusyBox` は、`Linux`環境で使用するシェルと主要コマンドをまとめて１つのパッケージにしたプログラムです。
`sh`、`bash`といったシェルも含まれているため、シェルの代わりにもなります。
`BusyBox`をインストールすると、Windows 上でもシェルを含んだ Linux 環境がひととおりそろいます。

`BusyBox`には`ls`コマンドのほか、`rm`や`cat`など、多数のコマンドが含まれています。これらのコマンドは、`BusyBox`のサブコマンドとして呼び出せるほか、それぞれ独立したコマンドとしても機能します。
`BusyBox`内のそれぞれのコマンドを実行するには、シンボリックリンクを利用してそれぞれのコマンド名で`BusyBox`を呼びだす必要があります。

たとえば、`ls`というコマンド名で`BusyBox`を呼びだすと`BusyBox`は`ls`と同様の動作をします。
また、`rm`というコマンド名で`BusyBox`を呼びだすと、`BusyBox`は`rm`と同様の動作をします。

``` PowerShell
busybox ls .    # `ls .`と同様の動作
ls .            # シンボリックリンクにより、busyboxがを実行される。動作は busyboxが`ls .`を実行する

```

### 1.2. Coreutils

`Coreutils`（GNU Core Utilities）は、`UNIX/Linux`系`OS`で中核となる`ls`,`cat`,`rm`などの一群のコマンドをまとめて提供しているパッケージです。
BusyBox はパッケージの中でも主要なコマンドだけを提供していますが、Coreutils はすべてのコマンドを提供しています。

### 1.3. less (ページャー)

less はファイルの内容を画面に表示するページャーの一種です。
`Linux`環境下で頻繁に使用されるため、インストールしておくと便利です。

### 1.4. grep (検索ツール)

`grep` (`GNU grep`)は、ファイル内にキーワードが存在するかをチェックする検索ツールです。
Linux ディストリビューションとの互換性を考えると、インストールしておくと便利です。

### 1.5. tree

tree は、ファイルやディレクトリをツリー表示するコマンドです。
Windows にも tree コマンドがありますが、Linux に移植されたほうが機能豊富です。
機能の豊富さのために、Linux版の`tree`コマンドをインストールします。

## 2. UNIX系ツールのインストール

### 2.1. 前提環境

#### ディレクトリ構成

Windows 側は、以下のディレクトリ構成です。

``` ディレクトリツリー
c:\
 |-- app
 |   |-- develop   # 開発ツール
 |   |-- launnch   # アプリショートカット用
 |   \-- scoop     # Scoop Global (app,shimsなどのScoop用サブディレクトリあり)
 |
 \-- bin
     |-- Wz        # Wzエディタ
     |-- init      # 初期化用
     |-- neovim    # NeoVIM エディタ
     |-- scripts   # 各種スクリプト
     `-- tools     # UNIX系ツール、コマンドラインツール

```

Scoop を使ってインストールしたコマンドは、`Scoop`コマンドによって`c:\app\scoop\`下の適切なディレクトリに配置されます。
そのほかのコマンドは、Windows のコマンドライン用コマンドを配置するディレクトリ`c:\bin\tools`下にインストールします。

#### 環境変数`Path`

ディレクトリ構成に従い、`Path`を設定しておきます。
Path は、つぎのようになります。

``` powershell
c:\bin;C:\bin\scripts;c:\bin\tools;c:\bin\wz;C:\bin\neovim\bin;C:\app\develop\ide\VSCode\bin;c:\app;c:\app\launch;C:\app\scoop\shims;C:\app\develop\scm\github\gitlfs;C:\app\develop\scm\github\cli\;...

```

両方とも Windows の環境変数`PATH`に登録しているので、コンソールを起動すればすぐに UNIX系コマンドが使えます。

#### ターミナル (管理者)

どのコマンドも全ユーザー用にインストールするため、管理者権限でターミナルを開いてください。
![Terminal(Admin)](https://i.imgur.com/s9UlEdQm.png)

### 2.2. BusyBoxのインストール

`BusyBox`は`Scoop`でインストールできます。
次の手順で、`BusyBox`をインストールします。

1. `BusyBox`をインストールする

   ``` powershell: terminal
   scoop install busybox --global
   ```

以上で、BusyBox のインストールは終了です。

### 2.3. CoreUtilsのインストール

Scoop には、通常の`coreutils`と`Rust`製の`uutils`があります。
今回は、`uutils`をインストールします。

1. `coreutils`をインストールする

   ``` powershell: terminal
   scoop install uutils-coreutils --global
   ```

以上で、`Core Utils`のインストールは終了です。

### 2.4. less, grep のインストール

`less`,`grep`とも`Scoop`でインストールできます。
次の手順で、`less`,`grep`をインストールします。

1. `less`をインストールする

   ``` powershell: terminal
   scoop install less --global
   ```

2. `grep`をインストールする

   ``` powershell: terminal
   scoop install grep --global
   ```

以上で、`less`,`grep`のインストールは終了です。

### 2.5. treeのインストール

`tree`は`Scoop`ではインストールできません。そのため、手動でパッケージをダウンロードしてインストールします。
次の手順で、'tree'をインストールします。

1. [Tree for Windows](https://gnuwin32.sourceforge.net/packages/tree.htm)にアクセスする
   [![Tree for Windows](https://i.imgur.com/FhehnD0m.png)](https://gnuwin32.sourceforge.net/packages/tree.htm)

2. [Binariesのリンク](http://downloads.sourceforge.net/gnuwin32/tree-1.5.2.2-bin.zip)をクリックし、アーカイブをダウンロードする

3. ダウンロードしたアーカイブを展開する

4. 展開して出てきた"`tree.exe`"を"`c:\bin\tools`"にコピーする

   ``` powershell: terminal
   cp .\tree-1.5.2.2-bin\bin\tree.exe c:\bin\tools\

   ```

以上で、`tree`のインストールは終了です。

## さいごに

この記事では、Windows に UNIX系のツールをインストールする方法を紹介しました。
UNIX系ツールを使うことにより、Windows上でも柔軟な操作が可能になります。

他に必要なツールがある場合は、`winget`や`Scoop`などのパッケージマネージャーから簡単にインストールできます。

それでは、Happy Hacking!

## 技術用語と注釈

- UNIX系ツール: `UNIX/Linux`下で使用されるコマンドラインツール。簡単なコマンド(`ls`,`mv`など)から、複雑なコマンド(`less`など)も含む
- Scoop: Windows 用のパッケージマネージャー。オープンソースのツールが充実している
- PATH: システムがコマンドを探索するディレクトリのリストを格納した環境変数。コマンドが Path上のディレクトリに含まれていれば、ユーザーはそのコマンドを任意の場所から実行できる

## 参考資料

### ツール関連

1. GNU core utilities: <https://www.gnu.org/software/coreutils/>
2. uutils coreutils: <https://github.com/uutils/coreutils>
3. Busybox for Windows: <https://frippery.org/busybox/>
4. less: <https://www.greenwoodsoftware.com/less/>
5. GNU grep: <https://www.gnu.org/software/grep/>
6. Tree for Linux: <http://mama.indstate.edu/users/ice/tree/>
7. Tree for Windows: <https://gnuwin32.sourceforge.net/packages/tree.htm>

### パッケージマネージャー

1. Scoop: <https://scoop.sh/>
2. winget (Windows Package Manager): <https://github.com/Microsoft/winget-cli>
