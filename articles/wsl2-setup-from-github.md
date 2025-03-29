---
title: "WSL 2の初期設定: WSLをGitHub からパッケージをダウンロードして セットアップする方法"
emoji: "🐧"
type: "tech"
topics: ["Windows", "Linux", "WSL", "環境構築" ]
published: false
---

## はじめに

atsushifx です。
`WSL 2`環境のセットアップ中に、`ENOENT`エラーが発生しました。
このエラーは、「ファイルまたはディレクトリが見つからない」ことを示し、その結果、`wsl`コマンドが実行できませんでした。
機能を無効化してから再度有効化しましたが、改善しませんでした。
最終的に、Microsoft の`GitHub`リポジトリから`WSL`をダウンロードして手動でセットアップしました。

この記事では、`WSL`のセットアップ中に発生した`ENOENT`エラーを手動で解決する方法を解説します。

## 用語集

## 1. WSL の基本

## 1.1 WSL の概要と仕組み

`WSL` (`Windows Subsystem for Linux`) は、Windows 上で Linux の実行環境を提供する仕組みです。
従来、Linux を利用するためには、仮想マシンやデュアルブートの設定が必要でした。
しかし、`WSL` を使うことで、Windows のアプリケーションと Linux のツールを同一環境でシームレスに活用できます。

仕組みとしては、Windows カーネルが Linux のシステムコールを理解・処理するための互換レイヤーや、仮想化技術を用いて Linux カーネルを実行するコンポーネントが組み込まれています。
これにより、Linux のバイナリをほぼそのまま Windows 上で動かせる環境が整います。

特に `WSL 2` では、軽量な仮想マシンベースのアーキテクチャが採用されており、実際に Microsoft が配布しているカスタム Linux カーネルが動作します。
このアプローチにより、従来の `WSL 1` よりも高い互換性とパフォーマンスが実現されています。

## 1.2 `WSL1`と`WSL2`の違い

## 1.2 WSL1 と WSL2 の違い

`WSL` には大きく分けて `WSL 1` と `WSL 2` の 2つのバージョンがあり、それぞれに特徴と利点があります。用途や目的に応じて選択することで、より快適な開発環境を構築できます。

### WSL 1

`WSL 1` は、Linux のシステムコールを Windows カーネルに変換する「互換レイヤー」として動作します。
仮想マシンを用いず、軽量かつ起動が非常に高速であることが特徴です。
Windows のファイルシステムとの連携もスムーズで、ファイル I/O の操作は比較的高速です。

ただし、Linux カーネルが提供する一部の機能に互換性がなく、Docker などの一部ツールは正常に動作しないことがあります。

### WSL 2

`WSL 2` は、Microsoft がカスタマイズした Linux カーネルを実際に仮想マシン上で動作させる構造を採用しています。これにより、Linux と同等のシステムコール互換性が実現されており、Docker や各種開発ツールもスムーズに動作します。

WSL 1 に比べて初回起動やファイルアクセスの速度はやや劣る場合がありますが、全体としての互換性と機能性の高さから、多くの開発者にとって実用的な選択肢となっています。

## 2. システム要件の確認

`WSL 2` を利用するには、ハードウェアとソフトウェアの両面でいくつかの要件を満たしている必要があります。このセクションでは、事前に確認しておくべきポイントを整理します。

### 2.1 対応する Windows バージョン

`WSL 2` を利用するには、以下の Windows バージョンである必要があります。

- Windows 10 バージョン 1903 (ビルド 18362 以降)
- Windows 11 (全バージョン)

Windows のビルドバージョンは、以下のコマンドで確認できます。

```powershell
winver
```

Windows が上記よりも古い場合は、Windows Update を実行して最新盤にする必要があります。

### 2.2 仮想化支援機構の有無

`WSL 2` を利用するためには、CPU が仮想化支援機能 (`Intel VT-x` または `AMD-V`) を備えており、かつそれが有効になっている必要があります。
この仮想化支援機構が無効の場合、WSL 2 は正しく動作しません。

ここでは、仮想化支援機能が有効になっているかどうかを確認する方法を紹介します。

#### ハイパーバイザーの確認方法

まず、Windows 上でハイパーバイザーが有効かどうかを確認します。
これは、システムに仮想化機能が有効化されているかの初歩的なチェックになります。

1. `システム情報`の起動:
   Windows の「スタート」メニューから`システム情報`を検索して開きます。

2. ハイパーバイザーの確認:
   左側の「システムの要約」を選択し、右ペインのなかから「ハイパーバイザーが検出されました…」という記述があるかを探します。
   ![ハイパーバイザーの確認](/images/articles/wsl2-setup/ss-systeminfo-hypervisor.png)

この記述が表示されていれば、仮想化機能は OS 上で有効になっています。

#### CPUの仮想化支援機構の確認方法

システム情報でハイパーバイザーの記述が確認できなかった場合は、CPU 自体が仮想化支援機能に対応しているかを確認します。
以下の手順で確認できます。

1. `VirtualChecker`のインストール:
   [VirtualChecker](https://openlibsys.org/index-ja.html) をダウンロードしてインストールします。

2. CPU の確認:
   アプリケーションを起動すると、`Intel VT-x` や `AMD-V` が Enabled（有効）になっているかが表示されます。

表示が `Enabled` であれば、仮想化支援機構は動作しています。`Unsupported` の場合は `BIOS` (または`UEFI`) で設定を有効にする必要があります。

#### 判定結果のまとめ

上記をまとめると、以下の図になります。

| チェック方法 | チェック内容 | 表示 | 仮想化支援機構 |
| --- | --- | --- | --- |
| `システム情報` | ハイパーバイザー | 表示あり | 有効 |
| `VirtualChecker` | `VT-X`/`AMD-V` | Enabled | 有効 |

上記のいずれも有効でない場合、`WSL`を利用できません。
その場合は、`BIOS`で仮想化支援機構を有効にします。

### 2.3 必要なシステム機能の一覧と確認方法

`WSL 2{} を利用するには、いくつかの Windows 機能を有効にする必要があります。
これらの機能が無効なままだと、仮想化機能や`wsl`コマンドが正しく動作しない原因となります。

#### 必要なシステム機能

WSL 2 の動作に必要な主な Windows 機能は以下の 3つです。

| 機能名 | 説明 |
| --- | --- |
| Microsoft-Windows-Subsystem-Linux | Linux サブシステムの中核機能 |
| VirtualMachinePlatform | 仮想マシン機能の基盤 |
| Microsoft-Hyper-V-All | 仮想マシンの管理機能 (WSL 2では必須ではないが推奨) |

#### 機能の有効／無効を確認する方法

ここでは、必要な機能の一覧と、それらが有効になっているかを確認する方法を紹介します。

PowerShell で以下のコマンドを実行します:

```powershell
Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -in `
  "Microsoft-Windows-Subsystem-Linux", `
  "VirtualMachinePlatform", `
  "Microsoft-Hyper-V-All" } | Format-Table FeatureName, State
```

出力例:

```powershell
FeatureName                          State
------------                         -----
Microsoft-Windows-Subsystem-Linux    Enabled
VirtualMachinePlatform               Enabled
Microsoft-Hyper-V-All                Disabled
```

上記のように、`State` が `Enabled` であれば機能が有効化されています。
`Disabled` の場合は、手順に従って機能を有効化する必要があります。

## 3. セットアップ全体の流れ

### 3.1 ステップ概要（フロー図）

### 3.2 今後のセクションの読み方・進め方ガイド

## 4. 仮想化機能と WSL を有効化する

### 4.2 仮想化・WSL の無効化と再起動

### 4.3 必要な機能の有効化手順

### 4.4 最終的な状態の確認

## 5. GitHub から最新の WSL パッケージを導入する

### 5.1 GitHub リリースページの確認

### 5.2 インストーラーの選択と実行

### 5.3 インストール後のバージョン確認

## 6. ディストリビューションの導入と動作検証

### 6.1 WSL2 を既定に設定

### 6.2 Ubuntu のインストールと起動

### 6.3 動作確認とディストリビューションの削除

## 7. トラブルシューティング

Windows に`WSL`環境をセットアップする際に発生したトラブルとその対処法を掲載します。

### 7.1 システム関連のトラブル

#### [WSL-001]: `wsl`が実行できない

トラブル: `ENOENT`、その他のエラーメッセージが出力され、`wsl`コマンドが実行できない。

- 原因:
   `WSL`のシステム設定が無効になっている、または必要なシステムファイルが破損している可能性があります。
   `Windows Update`による設定変更や、不完全な再インストールが原因となることがあります。

- 対処法:
  `WSL`を手動でダウンロードしてインストールすることで問題を解決できます。
  以下の手順で、機能を一度無効化してから再度有効化し、`WSL`を手動でインストールします。

  1. 機能の無効化:
     - 機能を無効化する。

       ```powershell
       # WSL を無効化する
       dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart
       # 仮想マシン プラットフォームを無効化する
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
       # 仮想マシン プラットフォームを有効化する
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
       [Microsoft の`WSL`リリースページ](https://github.com/microsoft/WSL) から最新の`WSL`インストーラーをダウンロードします。

     - `WSL`をインストールする。
     　 ダウンロードした`WSL`インストーラーを実行し、`WSL`をインストールします。

以上で、`WSL`がセットアップできます。

### 7.2 設定関連のトラブル

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
       # 仮想マシン プラットフォームを無効化する
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
       # 仮想マシン プラットフォームを有効化する
       dism.exe /online /enable-feature /all /featurename:VirtualMachinePlatform /norestart
       # Hyper-V を有効化する
       dism.exe /online /enable-feature /all /featurename:Microsoft-Hyper-V-All /norestart
       ```

     - PC を再起動する。

       ```powershell
       shutdown /r /t 0
       ```

## おわりに

この記事では、`WSL`環境のセットアップ中に発生する可能性のあるエラーに対処するための手順を解説しました。
`GitHub`から`WSL`をダウンロードしてセットアップすることで、最新の`WSL`をインストールし、使用できます。

`WSL` を活用することで Windows上で Linux環境を構築できるため、開発やテストなど幅広い用途に活用できます。
ネイティブな Linux環境が必要な開発者にとって、デュアルブートや仮想マシンなしで Linux環境を利用できるのが大きなメリットです。
また、`Docker` との統合や、Linux 向けの開発ツールの利用も容易になり、開発効率が向上します。

これを機に`WSL`を導入し、より快適な開発環境を構築してみてください。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [Linux用Windowsサブシステム とは](https://learn.microsoft.com/ja-jp/windows/wsl/about):
  公式ドキュメントによる`WSL`の概要

- [`WSL`バージョンの比較](https://learn.microsoft.com/ja-jp/windows/wsl/compare-versions):
  公式ドキュメントによる、`WSL 1`と`WSL 2`の違い

- [以前のバージョンの`WSL`の手動インストール手順](https://learn.microsoft.com/ja-jp/windows/wsl/install-manual):
  公式ドキュメントによる、`WSL`を手動でインストールする方法
