---
title: "WSL 2: GitHubからパッケージをダウンロードしてWSLをセットアップする方法"
emoji: "🐧"
type: "tech"
topics: ["Windows", "Linux", "WSL", "環境構築" ]
published: false
---

## はじめに

atsushifx です。
`WSL`環境を構築したのですが、最初は`ENOENT`エラーが出て`wsl`コマンドが使えませんでした。
[Windows の機能の有効化または無効可]を使用して、機能の無効化を試してもエラーのままでした。
最終的に`GitHub`から`wsl`のパッケージをインストールすることで解決しました。

この記事は、上記のようにエラーで`WSL`環境が構築できない場合に、`GitHub`上の`wsl`パッケージを用いて`WSL`をセットアップする方法を説明します。

## 用語集

- `WSL` (`Windows Subsystem for Linux`):
  Windows上で Linux 環境を実行するための機能

- `GitHub`:
  ソフトウェア開発プロジェクトのためのホスティングサービス

- `dism.exe`:
  Windows のイメージ管理・修復ツール

## 1. オーバービュー

`WSL`について基本的な事柄を説明します。

### 1.1 `WSL`とは

`WSL` (`Windows Subsystem for Linux`) は、Windows上で Linux 環境を実行するための機能です。
実際の Linux ディストリビューションを動作させているため、より高い互換性が特徴です。

### 1.2 `WSL1`と`WSL2`の違い

`WSL1`はシステムコールを変換する互換レイヤー形式を採用しており、軽量で高速な起動が可能です。
`WSL2`は実際の Linux カーネルを仮想環境で呼び出すエミュレーション形式を採用しており、より高い互換性を実現しています。

## 2. `WSL`環境の構築

この章では、`WSL`環境を構築する手順を紹介しています。

### 2.1 仮想化機能の有効化

`WSL`を使用するために、`Windows`の仮想マシン関連の機能を有効にします。
次の手順で、機能を有効にします。

1. 管理者ターミナルの起動:
  [スタートメニュー]で右クリックし、[ターミナル(管理者)]を選択します。
   管理者権限で`Windows Terminal`が起動します。
   ![管理者ターミナル](/images/articles/wsl2-setup/ss-termianl-admin.png)
   *管理者ターミナル*

2. 機能の有効化:
   以下のコマンドを実行し、機能を有効化します。

   ```powershell
   dism.exe /online /enable-feature /all /featurename:VirtualMachinePlatform /norestart
   dism.exe /online /enable-feature /all /featurename:Microsoft-Hyper-V-All /norestart
   dism.exe /online /enable-feature /all /featurename:Microsoft-Windows-Subsystem-Linux /norestart
   ```

   ![機能の有効化](/images/articles/wsl2-setup/sm-dism-enable.gif)
   *機能の有効化*

3. PC の再起動:
  `shutdown`コマンドで、PC を再起動します。

  ```powershell
  shutdown /r /t 0
  ```

以上で、仮想化機能の有効化は完了です。

### 2.2 `WSL`のインストール

次の手順で、`GitHub`から`WSL`をダウンロードし、インストールします。

1. `WSL`のダウンロード:
   [`WSL`の`release`](https://github.com/microsoft/WSL/releases) から、`wsl.2.xx.x.x64.msi`をダウンロードします。
   ![`WSL release`](/images/articles/wsl2-setup/ss-wsl-github-release.png)

2. `WSL`のインストール:
   ダウンロードした`wsl.2.xx.x.64.msi`を実行して、`WSL`をインストールします。
   ![`インストール`](/images/articles/wsl2-setup/ss-wsl-install.png)

3. `WSL`の確認:
   `wsl --version`を実行し、`WSL`がインストールされているかを確認します。

   ```powershell
   wsl --version

   WSL バージョン: 2.4.11.0
   カーネル バージョン: 5.15.167.4-1
   WSLg バージョン: 1.0.65
   MSRDC バージョン: 1.2.5716
   Direct3D バージョン: 1.611.1-81528511
   DXCore バージョン: 10.0.26100.1-240331-1435.ge-release
   Windows バージョン: 10.0.26100.3194
   ```

上記のように、バージョンが表示されれば、`WSL`のインストールは完了です。

### 2.3 `WSL`のセットアップ

`WSL`の動作確認をします。
次のコマンドを実行します。

1. 規定バージョンの設定:
  `wsl --set-default-version`コマンドで、`WSL 2`を設定します。

   ```powershell
   wsl --set-default-version 2

   WSL 2 との主な違いについては、https://aka.ms/wsl2
    を参照してください
   この操作を正しく終了しました。
   ```

2. `wsl`コマンドの実行:
   `wsl --install`を実行し、既定のディストリビューション (例: Ubuntu) をインストールします。

   ```powershell
    wsl --install

   ダウンロード中: Ubuntu
   [==============            24.7%                           ]

   インストール中: Ubuntu
   [==============            24.7%                           ]

   ディストリビューションが正常にインストールされました。'wsl.exe -d Ubuntu' を使用して起動できます
   ```

3. `ディストリビューション`の削除:
   `wsl`が正常に動作したので、インストールしたディストリビューションを削除します。

   ```powershell
   wsl --unregister Ubuntu

   登録解除。
   この操作を正しく終了しました。
   ```

以上で、`WSL`のセットアップは完了です。

## 3. トラブルシューティング

### 3.1 代表的なトラブルと対処法

#### [WSL-001]: `wsl`が実行できない

トラブル: エラーが出て`wsl`コマンドが実行できない。

- 原因:
  `WSL`が無効になっている、あるいは関連ファイルが壊れている。

- 対処法:
  手動で`WSL`をインストールする。
  以下の手順を実行する。

  1. 機能の無効化:
     以下のコマンドで、機能を無効化し、PC を再起動する。

     ```powershell
     dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart
     dism.exe /online /disable-feature /featurename:VirtualMachinePlatform /norestart
     dism.exe /online /disable-feature /featurename:Microsoft-Hyper-V-All /norestart

     shutdown /r /t 0
     ```

  2. 機能の有効化:
     以下のコマンドで、機能を有効化し、PC を再起動する。

     ```powershell
     dism.exe /online /enable-feature /all /featurename:VirtualMachinePlatform /norestart
     dism.exe /online /enable-feature /all /featurename:Microsoft-Hyper-V-All /norestart
     dism.exe /online /enable-feature /all /featurename:Microsoft-Windows-Subsystem-Linux /norestart

     shutdown /r /t 0
     ```

  3. `WSL`のインストール:
     [`WSL`リポジトリ](https://github.com/microsoft/WSL) から`WSL`をダウンロードする。
     ダウンロードした`wsl.2.x.xx.msi`を実行し、`WSL`をインストールする。

以上で、`WSL`がセットアップできる。

#### [FEAT-001]: 機能が有効化できない

トラブル: `WSL`などの機能が有効化できない。

- 原因:
  機能に関連するファイルが壊れている、中途半端に残っている。

- 対処法:
  機能を完全に無効化し、再度、有効にする。
  次の手順で、完全に無効化する。

  1. 機能の無効化:
     以下のコマンドで、機能を無効化し、PC を再起動する。

     ```powershell
     dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart
     dism.exe /online /disable-feature /featurename:VirtualMachinePlatform /norestart
     dism.exe /online /disable-feature /featurename:Microsoft-Hyper-V-All /norestart

     shutdown /r /t 0
     ```

  2. ファイル、イメージの修復:
     以下のコマンドでシステムファイル、イメージを修復する

     ```powershell
     sfc /scannow
     DISM /Online /Cleanup-Image /RestoreHealth
     ```

  3. PC の再起動:
     以下のコマンドで、PC を再起動する

     ```powershell
     shutdown /r /t/ 0
     ```

上記を実行後、機能を有効化する。

## おわりに

上記の手順で、`wsl --version`コマンドでもタイムアウトするような場合でも`WSL`環境が構築できました。
エラーで`WSL`環境が構築できない場合に、この記事が参考になると幸いです。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [Windows Subsystem for Linux に関するドキュメント](https://learn.microsoft.com/ja-jp/windows/wsl/):
  Microsoft による`WSL`の公式ドキュメント

- [とほほのWSL入門](https://www.tohoho-web.com/ex/wsl.html):
  `WSL`の入門事項まとめ
