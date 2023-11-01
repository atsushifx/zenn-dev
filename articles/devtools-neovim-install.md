---
title: "wingetを使ったNeovimのインストール"
emoji: "🍣"
type: "tech"
topics: [ "tips", "winget", "Neovim", "開発環境" ]
published: false
---

## はじめに

`Neovim`は、Linux 環境で幅広く使用されているテキストエディタ`Vim`の強化版です。
この記事では、Windows の公式パッケージマネージャーである`winget`を使用して、`Neovim`をインストールする方法について詳しく説明します。
`Neovim` を導入することで、開発環境を強化し、プログラミングの生産性を向上させることができます。

## `Neovim`のインストール

### `winget`のオプション

`winget`で対話的にインストールするには`--interactive`オプションを使います。
同様にインストール先を変更するには`--location`オプションを使います。

`Neovim`のインストーラーでは上記オプションが使えないので、`--override`オプションでインストーラーのオプションを指定します。

### インストール先ディレクトリの設定

[GitHubのリポジトリ](https://github.com/Neovim/Neovim/blob/master/cmake.packaging/WixPatch.xml)にあるように、`Neovim`はインストール先ディレクトリを`INSTALL_ROOT`プロパティで設定します。

インストーラー起動時に、上記"`INSTALL_ROOT`"を指定することでインストール先を変更できます。

### 対話形式インストールの設定

`Neovim`のインストーラーでは、`msiexec`の対話形式インストールを使用します。
このため、`/qf`オプションを使います。

### `winget`によるインストール

winget では、`winget install --id Neovim.Neovim`で`Neovim`をインストールできます。
インストール先を指定する場合は、次のオプションで`winget を実行します。

```powershell
winget install --id Neovim.Neovim --override "/qf INSTALL_ROOT=c:\bin\nvim"
```

実行結果は、次のようになります。

```powershell
C:  > winget install --id Neovim.Neovim --override "/qf INSTALL_ROOT=c:\bin\nvim"

見つかりました Neovim [Neovim.Neovim] バージョン 0.9.2
このアプリケーションは所有者からライセンス供与されます。
Microsoft はサードパーティのパッケージに対して責任を負わず、ライセンスも付与しません。
このパッケージには次の依存関係が必要です:
  - パッケージ
      Microsoft.VCRedist.2015+.x64
ダウンロード中 https://github.com/Neovim/Neovim/releases/download/v0.9.2/nvim-win64.msi
  ██████████████████▌             25.0 MB / 40.4 MB

```

## `Neovim`の設定

### "Path"の追加

環境変数"Path"に`Neovim`の実行ディレクトリ"`c:\bin\nvim\bin`"を追加します。
次の手順で、"Path"を設定します。

1. \[環境変数]ダイアログを開く:
   ![環境変数](https://i.imgur.com/evyEYgP.jpg)

2. システム環境変数"Path"に"`c:\bin\nvim\bin`"を追加:
   システム環境変数"Path"を選んで\[編集]をクリックし、"`c;\bin\nvim\bin`"を追加して\[OK]をクリックします。

3. \[環境変数]ダイアログを閉じる:
   \[OK]をクリックして、ダイアログを閉じます。

または、PowerShell で次のコマンドを実行します。

```powershell
[System.Environment]::SetEnvironmentVariable("Path",  [System.Environment]::GetEnvironmentVariable("Path", "Machine")+";c:\bin\nvim\bin", "Machine")

```

以上で、"Path"の追加は終了です。
PC を再起動すると、変更した"Path"がシェルに反映されます。

### `vim.exe`の作成

デフォルトエディタが`vim`の場合にあわせ、シンボリックリンク`vim.exe`を作成します。
次のコマンドを実行します。

```powershell
New-Item -Path C:\bin\nvim\bin\vim.exe -Type SymbolicLink -Value C:\bin\nvim\bin\nvim.exe

```

以上で、`vim`で`Neovim`が立ち上がります。

## おわりに

この記事では、`winget`を使って`Neovim`を Windows 上に簡単にインストールする方法を説明しました。

`Neovim` の魅力は、カスタマイズ性が高く、プラグインを活用してさらに拡張できることです。
`Neovim`を自分好みのカスタマイズし、素晴らしいプログラミング環境を構築しましょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [`Neovim` 公式サイト](http://neovim.io/)
- [`Neovim` GitHubリポジトリ](https://github.com/neovim/neovim)
