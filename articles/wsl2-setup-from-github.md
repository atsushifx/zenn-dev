---
title: "WSL 2: GitHub からパッケージをダウンロードして WSL をセットアップする方法"
emoji: "🐧"
type: "tech"
topics: ["Windows", "Linux", "WSL", "環境構築" ]
published: false
---

## はじめに

atsushifx です。
`WSL`環境の構築中に`ENOENT`エラーが発生しました。
このエラーは、ファイルまたはディレクトリが見つからないことを示しており、その結果、`wsl`コマンドが実行できなくなりました。
機能を無効化し、再度有効化することを試してみましたが、改善しませんでした。
最終的に、Microsoft の`GitHub`リポジトリから`WSL`をダウンロードし、手動でセットアップしました。

この記事では、`WSL`のインストール時に発生したエラーを手動で解決する方法を解説します。

## 用語集

- `WSL` (`Windows Subsystem for Linux`):
  Windows上で Linuxバイナリをネイティブに実行できるようにする互換性レイヤー

- `GitHub`:
  バージョン管理やイシュー管理が可能なソフトウェア開発プラットフォーム

- `dism.exe`:
  Windows のイメージ管理・修復ツール

- `shutdown /r /t 0`:
  設定変更の最後に使用される、PC を即時再起動するコマンド

- `ENOENT`:
  "No such file or directory"を意味する、システムエラーコード

## 1. ``WSL`とは?

`WSL` (`Windows Subsystem for Linux`) は、Windows上で Linuxバイナリを直接実行できる互換性レイヤーです。
これにより、Linuxディストリビューションを Windows上でネイティブに動作させることができます。

## 2. `WSL1`と`WSL2`の主な違い

`WSL 1`と`WSL 2`の主な違いを、箇条書き形式で紹介します。

- `WSL 1`:
  Linuxシステムコールを Windowsカーネルに変換する互換レイヤーとして動作し、起動が高速だが、互換性に一部制限がある。

- `WSL 2`:
  軽量な仮想マシンを利用して、Microsoft が提供するカスタマイズされた Linuxカーネルを実行することで、高い互換性とパフォーマンスを実現する。

## 3. `WSL`環境の構築

エラーに対応した`WSL`環境の構築手順を説明します。

### 3.1 `WSL`、仮想化機能の有効化手順

[`Windows の機能の有効化または無効化`]を使用し、`WSL`および仮想化機能を有効化します。
次の手順で、機能を有効にします。

1. 管理者ターミナルの起動方法:
   - スタートメニューを右クリックし、[ターミナル(管理者)]を選択する。

   - 管理者権限でターミナルが起動する。
     ![管理者ターミナル](/images/articles/wsl2-setup/ss-termianl-admin.png)
     *管理者ターミナル:  スタートメニューから管理者ターミナルを開く*

2. 機能の有効化:
   - `dism`コマンドで、機能を有効化する。

     ```powershell
     # 仮想マシンプラットフォームを有効化する
     dism.exe /online /enable-feature /all /featurename:VirtualMachinePlatform /norestart
     # Hyper-Vを有効化する
     dism.exe /online /enable-feature /all /featurename:Microsoft-Hyper-V-All /norestart
     # WSL を有効化する
     dism.exe /online /enable-feature /all /featurename:Microsoft-Windows-Subsystem-Linux /norestart
     ```

     ![機能の有効化](/images/articles/wsl2-setup/sm-dism-enable.gif)
     *機能の有効化*

3. PC の再起動:

   - `shutdown`コマンドで、PC を再起動する。

     ```powershell
     # PC の即時再起動
     shutdown /r /t 0
     ```

以上で、仮想化機能の有効化は完了です。

### 3.2 手動での`WSL`のインストール

 `GitHub`から最新の`WSL`インストーラーをダウンロードし、インストールする手順を説明します。
次の手順を実行します。

1. `GitHub` から最新の`WSL`をダウンロード:
   - [`WSL`のリリースページ](https://github.com/microsoft/WSL/releases) にアクセスする。
     ![`WSL release`](/images/articles/wsl2-setup/ss-wsl-github-release.png)
     *`WSL release`*

   - 最新の`WSL`インストーラー (wsl.2.xx.arch.msi) をダウンロードする。
     Windows のアーキテクチャ (`x64` または `arm64`) に応じたバージョンを選択する。

2. `WSL`のインストール:
   - ダウンロードした`WSL`インストーラーを実行して、インストールを完了させる。
     ![`インストール`](/images/articles/wsl2-setup/ss-wsl-install.png)
     *インストール*

3. `WSL`の確認:
   - `wsl --version`を実行する。

     ```powershell
     wsl --version
     ```

   - `wsl --version`の出力を確認する。
     **出力例**
     :::message
     環境によってバージョン番号は異なります
     :::

     ```powershell
     WSL バージョン: 2.4.11.0
     カーネル バージョン: 5.15.167.4-1
     WSLg バージョン: 1.0.65
     MSRDC バージョン: 1.2.5716
     Direct3D バージョン: 1.611.1-81528511
     DXCore バージョン: 10.0.26100.1-240331-1435.ge-release
     Windows バージョン: 10.0.26100.3194
     ```

上記のように、バージョンが表示されれば、`WSL`のインストールは完了です。

### 3.3 `WSL`の動作確認

`WSL`が正常に動作しているかを、Linuxディストリビューションをインストールして確認します。
次の手順を実行します。

1. 規定バージョンの設定:
  `wsl --set-default-version`コマンドで、`WSL 2`を設定します。

   ```powershell
   wsl --set-default-version 2

   WSL 2 との主な違いについては、https://aka.ms/wsl2
    を参照してください
   この操作を正しく終了しました。
   ```

2. `wsl`コマンドの実行:
   `wsl --install`を実行し、既定のディストリビューション (`Ubuntu`) をインストールします。

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

以上で `WSL` のセットアップは完了です。

## 4. トラブルシューティング

Windows に`WSL`環境を構築する際に発生したトラブルとその対処法を掲載します。

### 4.1 代表的なトラブルと対処法

#### [WSL-001]: `wsl`が実行できない

トラブル: `ENOENT`、その他のエラーメッセージが出力され、`wsl`コマンドが実行できない。

- 原因:
   `WSL`のシステム設定が無効になっている、または必要なシステムファイルが破損している可能性があります。
   特に、`Windows Update`の影響で`WSL`関連の設定が変更された場合や、不完全なアンインストール・再インストールが行なわれた場合、この問題が発生することがあります。

- 対処法:
  手動で`WSL`をダウンロードし、インストールすることで解決できます。
  一度無効化してから再度有効し、`WSL`を手動でインストールします。

  1. 機能の無効化:
     - 機能を無効化する。

       ```powershell
       # WSL を無効化する
       dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart
       # 仮想化プラットフォームを無効化する
       dism.exe /online /disable-feature /featurename:VirtualMachinePlatform /norestart
       # Hyper-V を無効化する
       dism.exe /online /disable-feature /featurename:Microsoft-Hyper-V-All /norestart
       ```

     - PC を再起動する。

       ```powershell
       shutdown /r /t 0
       ```

  2. 機能の有効化:
     - 機能を有効化する。

       ```powershell
       # 仮想マシンプラットフォームを有効化する
       dism.exe /online /enable-feature /all /featurename:VirtualMachinePlatform /norestart
       # Hyper-V を有効化する
       dism.exe /online /enable-feature /all /featurename:Microsoft-Hyper-V-All /norestart
       # WSL を　有効化する
       dism.exe /online /enable-feature /all /featurename:Microsoft-Windows-Subsystem-Linux /norestart
       ```

     - PC を再起動する。

      ```powershell
      shutdown /r /t 0
      ```

  3. `WSL`のインストール:
     - `WSL`をダウンロードする:
       [Microsoft の`WSL`リリースページ](https://github.com/microsoft/WSL) から`WSL`をダウンロードします。

     - `WSL`をインストールする。
     　 ダウンロードした`wsl.2.xx.msi`を実行し、`WSL`をインストールします。

以上で、`WSL`がセットアップできます。

#### [FEAT-001]: 機能が有効化できない

トラブル: `WSL`などの機能が有効化できない。

- 原因:
  機能に関連するファイルが壊れている、中途半端に残っている。

- 対処法:
  機能を完全に無効化し、再度、有効にする。
  次の手順で、機能を完全に無効化し、再度有効にする。

  1. 機能の無効化:
     - 機能を無効化する。

       ```powershell
       # WSL を無効化する
       dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart
       # 仮想マシンプラットフォームを無効化する
       dism.exe /online /disable-feature /featurename:VirtualMachinePlatform /norestart
       # Hyper-V を無効化する
       dism.exe /online /disable-feature /featurename:Microsoft-Hyper-V-All /norestart
       ```

     - PC を再起動する。

       ```powershell
       shutdown /r /t 0
       ```

  2. ファイル、イメージの修復:
     - システムファイル、イメージを修復する。

       ```powershell
       sfc /scannow
       dism /Online /Cleanup-Image /RestoreHealth
       ```

     - PC を再起動する。

       ```powershell
       shutdown /r /t 0
       ```

  3. 機能の有効化:
     - 機能を有効化する。

       ```powershell
       # WSL を有効化する
       dism.exe /online /enable-feature /all /featurename:Microsoft-Windows-Subsystem-Linux /norestart
       # 仮想マシンプラットフォームを有効化する
       dism.exe /online /enable-feature /all /featurename:VirtualMachinePlatform /norestart
       # Hyper-V を有効化する
       dism.exe /online /enable-feature /all /featurename:Microsoft-Hyper-V-All /norestart
       ```

     - PC を再起動する。

       ```powershell
       shutdown /r /t 0
       ```

## おわりに

この記事では、`WSL`環境の構築中に発生する可能性のあるエラーに対処するための手順を解説しました。
`GitHub`から`WSL`をダウンロードしてセットアップすることで、最新の`WSL`をインストールし、使用できます。

`WSL` を活用することで、Windows上で簡単に Linux環境を構築できるため、開発やテストなど多様な用途に活用できます。
特に、ネイティブな Linux環境が必要な開発者にとって、デュアルブートや仮想マシンを使うことなく、快適な Linux環境を利用できるのが大きなメリットです。
また、`Docker` との統合や、Linux 向けの開発ツールの利用も容易になり、開発効率が向上します。

これを機に、ぜひ `WSL` をインストールし、快適な開発環境を手に入れてみてください。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [Linux用Windowsサブシステム とは](https://learn.microsoft.com/ja-jp/windows/wsl/about):
  公式ドキュメントによる`WSL`の概要

- [`WSL`バージョンの比較](https://learn.microsoft.com/ja-jp/windows/wsl/compare-versions):
  公式ドキュメントによる、`WSL 1`と`WSL 2`の違い

- [以前のバージョンの`WSL`の手動インストール手順](https://learn.microsoft.com/ja-jp/windows/wsl/install-manual):
  公式ドキュメントによる、`WSL`を手動でインストールする方法
