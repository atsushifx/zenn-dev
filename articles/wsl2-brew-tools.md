---
title: "WSL開発環境: brewでインストールする便利ツール"
emoji: "☕"
type: "tech"
topics: ["WSL", "開発環境", "brew", "開発ツール", ]
published: false
---

## はじめに

WSL でのソフトウェア開発に便利なツールをインストールします。
Homebrew にあわせ、`brew`コマンドでインストールします。

## パッケージ一覧

### 開発ツール

| パッケージ | 説明 | 備考 |
| --- | --- | --- |
| `git-delta` | `git diff`の結果を分かりやすい形式で表示 |  |
| `gibo` | `gitignore`用のテンプレートを出力 |  |

### Git/GitHub関連ツール

| パッケージ | 説明 | 備考 |
| --- | --- | --- |
| `gh` | GitHubの各種機能をコマンドラインから呼び出し |  |
| `ghq` | GitHubなどのリポジトリ管理ツール |  |

### 効率化ツール

| パッケージ | 説明 | 備考 |
| --- | --- | --- |
| `peco` | インクリメンタルサーチ&選択 | GitHubのリポジトリ移動などに使用 |
| `fzf` | fuzzy finder |  |
| `ripgrep` | 高機能`grep` |  |

## 各ツールのインストール

### インストールスクリプト

一覧で紹介したツールをインストールします。
以下のスクリプトを実行します:

```bash:install.sh
pkgs="
  git-delta
  gibo
  gh
  ghq
  peco
  fzf
  ripgrep
"
brew install $pkgs
```

### gitの設定

`git diff`の結果を`delta`で見るための設定を追加します。

以下の設定を`git/config`に追加します:

``` ~/.config/git/config

```




## おわりに
