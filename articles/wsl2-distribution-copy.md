---
title: "WSL2: WSLで開発環境構築用にカスタムディストリビューションを作成する"
emoji: "🐧"
type: "tech"
topics: [ "wsl", "開発環境", "環境構築", "wslconf", "ディストリビューション" ]
published: false
---

## はじめに

WSL（Windows Subsystem for Linux）は、Windows 上で Linux ディストリビューションを実行する機能です。・
WSL を使うことで、開発者は Linux 上のツールやコマンドを使用でき、Web 開発やバックエンド開発がスムーズに行えます。

ここでは、既存のディストリビューションをもとに開発環境用にカスタムディストリビューションを作成することで、既存の開発環境などに影響を受けない開発環境の作成方法を説明します。

## WSLのディストリビューション管理

### WSLにおけるディストリビューションとは

WSL では、`Debian`、`Ubuntu`、`Oracle Linux`などのさまざまな Linux ディストリビューションが利用できます。
これらのディストリビューションは、`Microsoft Store` で提供されています。

また、[ArchWSL](https://github.com/yuk7/ArchWSL)や[wsldl](https://github.com/yuk7/wsldl)などのツールを使うことで、任意の Linux ディシトリビューションを利用することもできます。

## 開発用ディシトリビューションの作成

開発用ディストリビューション作成の流れは、次のようになります。

1. wsl.conf を設定し、各ディストリビューション共通の動作を設定する

2. 元ディストリビューションから開発用ディストリビューションを複製する

3.  Windows Terminal に開発ディストリビューションの設定を追加する

4.  開発用ディストリビューション特有の設定を行なう 

上記の手順で、開発用ディストリビューションを作成します。

### wsl.confの設定

WSL では`/etc/wsl.conf`ファイルを使用することで、ディストリビューションの動作を細かく設定できます。
ここでは、ディストリビューション複製時に使うであろう設定を下記の表に載せています。

| セクション | 設定項目 | 適用 |
| --- | --- | --- |
| boot | systemd | true: WSL 起動時に`systemd`デーモンも起動 |
| network | hostname | WSL ディストリビューションのホスト名 |
| interop | appendWindowsPath | false: 通常のパスのあとに、Windows 上のパス設定を追加しない |
| user | default | WSL 起動時にログインするユーザー名 |

これらの設定を各ディストリビューションで同じにすることで、設定の一貫性を保つことができます。

### wsl.confの設定方法

以下の内容で、`/etc/wsl.conf`ファイルを作成します。
wsl.conf では `#` によるコメントが可能です。

``` :wsl.conf
# Boot with systemd daemon 
[boot]
systemd = true

[network]
# hostname changed by distribution
hostname = <my_custom_hostname>

[interop]
# do not add Windows path
appendWindowsPath = false

[user]
default = <defaultUserName>

```

デォストリビューションを再起動すると、`/etc/wsl.conf`が適用された状態で Linux が起動します。

### ディストリビューションの複製

ディストリビューションの作成には、WSL の`export`、`import`機能を使用します。
export で元ディストリビューションの tar アーカイブを作成後、開発ディストリビューション側で作成した tar アーカイブを import します。

### ディストリビューションの複製方法

以下の手順で、ディストリビューションを複製します。

1. 指定したディストリビューションを tar アーカイブに保存する
  
   ``` powershell
   wsl --export Debian debian.tar
   ```
   上記のコマンドで、`debian.tar`に元ディストリビューションがアーカイブされます
  

2. 開発ディストリビューション側で、1. で作成した tar アーカイブを import する
   
   ``` powershell
   wsl --import dev-debian ~/.local/share/wsl/dev-debian ./debian.tar
   ```

以上で、ディストリビューションの複製は終了です。

### Windows Terminalの設定

作成した開発ディストリビューション上で作業ができるように、windows Terminal に設定を追加します。

設定の手順は、次のようになります。

1. Windows Terminal を開く
2. `Ctrl+,`として設定画面を開き、[新しいプロファイルを追加します]を選択します。

   rプロファイルを複製するで、元のプロファイル (今回は`Debian`)を複製します。

3. 複製したプロファイルのコマンドラインを書き換え、開発用ディストリビューションを指定します

4. 複製したプロファイルを保存し、Windows Terminal をとじる

以上で、設定の追加は終了です。次からは、Windows Terminal で開発ディストリビューションが選べるようになりなす。

### 開発ディストリビューションの設定を行なう

LinuxBrew や Node.js など、開発に必要な環境を設定します。
それぞれの開発環境によって詳細は異なるので、ここでは説明しません。
それぞれの公式サイトなどを参照してください。

## さいごに

`/etc/wsl.conf`によって、均一な設定で複数のディストリビューションを管理できます。
これにより、設定の手間が減り、効率的な開発が可能となります。

## 技術用語と注釈

- WSL (Windows Subsystem for Linux)：Windows 環境下で Linux ディストリビューションを動作させる機能
- `wsl.conf`: WSL の各ディストリビューションの細かな動作を設定できるファイル
- `systemd`: Linux システムの初期化処理やサービス管理を行なうデーモン

## 参考資料

### Webサイト

- [WSL での詳細設定の構成](https://learn.microsoft.com/ja-jp/windows/wsl/wsl-config)
- [ArchWSL](https://github.com/yuk7/ArchWSL)
- [wsldl](https://github.com/yuk7/wsldl)
