---
title: "Claude CodeをWSLなしのWindows環境で実行する方法"
emoji: "🛠️"
type: "tech"
topics: [ "claude", "claudecode", "windows", "busybox", "vibecoding", ]
published: false
---

<!-- vale Google.Slang = NO --> <!-- vale Google.WordList = NO -->

## TL;DR

次のステップで、Windows の PowerShell コンソール上で `claude code` を動かせるようになります（WSL 不要）。

1. `scoop` で `busybox` をインストール
2. Claude Code のマニュアルに従って `claude` をインストール
3. 'claude' が内部で参照する `/usr/bin/bash` を、BusyBox の `bash` (実際には、`ash`) に切り替えるようプロンプトで指示

以上で、WSL を使わなくても、Windows ネイティブの環境で `claude code` による `vibecoding` が可能になります。

## はじめに

atsushifx です。

Claude Code に手を出しました。
システム要件には「WSL 経由の Windows」と書かれており、Windows のターミナルは使えないと思っていました。
しかし、少しの工夫で Windows ターミナル上でも動作させることができました。

この記事では、これらの工夫を紹介し、Windows ネイティブ環境で Claude Code を使う方法を説明します。

WSL が難しいと感じるかたでも、Windows ターミナルや PowerShell が使えるかたには役立つ内容です。
この記事が、Claude Code を試すきっかけになれば幸いです。

Enjoy!

### 想定読者

本記事は、次のような読者を想定しています:

- Claude Code や ChatGPT などの AI コーディングツールを試してみたいエンジニア
- scoop や PowerShell による Windows 向けの CLI 環境構築に慣れているかた
- WSL の使用が制限されている環境 (例：企業 PC) でも Claude Code を活用したいかた

## 技術用語

- `Claude Code`:
  Anthropic 社が提供する対話型 AI による自然言語からのコード生成 CLI。REPL モードやインタラクティブ編集機能を備える。

- `BusyBox`:
  多数の Unix 系コマンドを 1つに統合した軽量バイナリ。Windows 上でも Linux 風のシェル操作を可能にする。

- `scoop`:
  Windows 向けのコマンドラインパッケージマネージャー。`busybox` や `Node.js` などの導入に使用。

- `bash`:
  Unix/Linux で一般的なシェル。Claude Code が内部で `/usr/bin/bash` を前提にしているため互換対策が必要。

- `ash`:
  `busybox` が提供する軽量シェル。`bash` の代替として動作するが、一部非互換あり。

- `pnpm`:
  `Node.js` 向けのパッケージマネージャー。高速性と効率性に優れる。

- `Node.js`:
  JavaScript ランタイム。Claude Code や関連ツールの動作に必要。

- `vibecoding`:
  Claude Code で提唱される、人間の「感覚」や「意図」を自然言語から即座にコードへ変換する開発スタイル。

- `PowerShell`:
  Windows 標準のコマンドラインシェル。今回の導入環境のベース。

- `README.md`:
  プロジェクトの説明・使用方法などを記載する文書ファイル。Claude Code でも初期設定として活用。

- `/usr/bin/bash`:
  Claude Code が想定した、フルパスの`bash`。Windows には存在しないため、調整が必要。

## 1. Claude CodeとBusyBoxの概要

### 1.1 Claude Codeの概要

Claude Code は、Anthropic 社が開発・提供する AI エージェント型のコーディング支援ツールです。
`CLI` (コマンドラインインターフェース) で動作し、ユーザーの自然言語による命令に従い、プログラムコードを自律的に生成・修正・改善することが特徴です。

このツールは「vibe coding (バイブコーディング)」と呼ばれる開発スタイルに最適化されています。
バイブコーディングとは、明確な設計書や仕様書ではなく、思いつきや要求レベルの自然言語で指示を与えることで、AI が最適なコードを生成・提案するスタイルです。

<!-- textlint-disable ja-technical-writing/sentence-length -->

たとえば「TypeScript でクラスベースの ToDo 管理アプリを作りたい」といった曖昧で抽象度の高いプロンプトに対しても、Claude Code はコンテキストを把握し、適切なクラス設計、関数構造、インターフェース定義などを自動で出力してくれます。

<!-- textlint-enable -->

Claude Code は実行結果や文脈に応じて「自ら考え、コードを再構成する」という循環的なアプローチも持ちあわせています。
これは、従来の LLM ベースの補完ツールと異なり、エージェントとして一連の問題解決プロセスを単体で進行できる設計に基づいています。

このように、Claude Code は「一度きりの補完」にとどまらず、AI が自律的に学習・再構成を試みるという観点から、自然言語による柔軟なコーディング支援の可能性を大きく広げる存在といえます。特にプロトタイピング、スクリプト生成、反復的な開発の場面で、その効果を実感できるはずです。

### 1.2 BusyBoxの概要

BusyBox は、`The Swiss Army Knife of Embedded Linux` とも呼ばれる、軽量で多機能な UNIX コマンド群の集合体です。
1つのバイナリに、以下のような UNIX/Linux で一般的に使われるコマンドを多数内包しており、POSIX 準拠の操作環境を再現できます。

- `sh` シェル
- `ls` ファイルのリスト出力
- `cat` ファイルの内容出力
- その他の多数のコマンド

Windows 環境向けにも移植されたバージョンが提供されていて、Windows 上でも多くの UNIX コマンドを PowerShell や cmd から利用できます。

Claude Code は、内部でシェルスクリプトベースの処理 (特に bash) を実行する設計になっています。そのため、通常の Windows 環境ではそのまま動作しませんが、BusyBox を導入することで、UNIX 互換のシェルおよびコマンド環境を擬似的に提供できます。

<!-- textlint-disable ja-technical-writing/sentence-length -->

この「擬似 UNIX 環境」があることで、Claude Code のような Linux 想定の CLI ツールが、WSL（Windows Subsystem for Linux）を導入せずとも実行可能になるのです。
BusyBox はその要件を最小限の構成で満たしてくれる実用的な代替手段といえるでしょう。<!-- textlint-enable -->

### 1.3 ScoopとBusyBox

Windows 環境において CLI ツールを効率的に管理・導入するための手段として、Scoop パッケージマネージャーは非常に有用です。Scoop は PowerShell 上で動作し、Node.js や Git、7zip など、開発に必要なツール類をシンプルなコマンドでインストール・アップデート・アンインストールできます。

BusyBox の Windows 版も Scoop 経由で簡単にインストールできます。次のコマンドを PowerShell で実行するだけで、BusyBox のバイナリがパスに追加され、sh や ls などの UNIX 系コマンドが使えるようになります。

```powershell
scoop install busybox -g
```

Scoop で導入された BusyBox は、コマンドごとに別名のラッパーが作成されており、たとえば ls を実行すると、実体は busybox.exe ls が呼ばれる仕組みになっています。
このおかげで、UNIX ライクなコマンド群を Windows 上で違和感なく利用できます。

Claude Code が内部で呼び出す bash や cat、grep といったコマンドにも、BusyBox は十分に対応しています。
これにより、WSL や他の仮想環境を必要とせずに、UNIX 前提のツールである Claude Code を Windows ネイティブで動作させる基盤が整います。

Scoop を使った BusyBox の導入は、開発者にとって非常に軽量かつ再現性の高い手法です。特に、WSL が使えない企業環境や、セットアップの簡略化を求める開発現場では、有力な選択肢となります。

## 2. なぜWSLなしでClaude Codeが動くのか

### 2.1 Claude Code の内部動作 (bash 呼び出し)

Claude Code は、ユーザーからの自然言語による指示を受け取り、内部でさまざまなツールやスクリプトを呼び出しながら、反復的にコードを生成・評価・修正していく「エージェント型」の設計が特徴です。
そのプロセスの中核を担っているのが、GNU bash シェルをベースとしたスクリプト実行環境です。

<!-- textlint-disable ja-technical-writing/sentence-length -->
<!-- markdownlint-disable line-length -->

Anthropic の公式ドキュメント「Bash tool」<https://docs.anthropic.com/en/docs/agents-and-tools/tool-use/bash-tool> によると、Claude Code は内部で「bash CLI ツール」として動作する環境を持ち、セッション中に渡されたコマンドやツール定義を維持しつつ継続的に実行します。
そのため、Windows ネイティブ環境では bash の呼び出しができず、通常は動作しません。

[Best practices for agentic coding](https://www.anthropic.com/engineering/claude-code-best-practices) の記事にもある通り、Claude Code は Unix 環境を前提としており、以下のようなコマンド群を自然に使います:

- `ls`, `cat`, `grep`, `echo` などの標準ユーティリティ
- `bash` を使った条件分岐、ループ、関数定義を含むシェルスクリプト
- `chmod` や `mkdir` などのファイル操作系コマンド

<!-- markdownlint-enable -->

このような構成のため、Windows ネイティブ環境ではそのままでは動作しません。
とくに bash の呼び出しパスとして `/usr/bin/bash` がハードコードされているケースがあり、これを実現するには WSL または同等の POSIX 環境が必要です。

しかし、後述する BusyBox の導入と簡易エイリアスによって、この制約を回避し、最小限の設定で Windows 上でも Claude Code を実行可能にできます。これが「WSL なしでも動かせる」技術的背景です。

### 2.2 BusyBoxによる最低限のUNIX環境の構築

Claude Code が内部で実行する `bash` やその他の UNIX コマンド群は、一般的に POSIX に準拠した動作環境を前提としています。
Windows 環境には標準でこれらのコマンド群は含まれておらず、たとえば `ls`, `cat` などは Linux と同様には使えません。

BusyBox はこの問題に対して軽量かつ実用的な解決手段を提供するツールです。
BusyBox の特徴は、1つのバイナリのなかに多数の UNIX コマンドを統合している点にあります。
`busybox.exe` という単一ファイルを実行することで、その引数に応じて `sh`, `ls`, `grep`, `mv` などをすべて模倣できます。

```powershell
busybox sh
busybox ls
busybox cat filename.txt
```

Scoop 経由で BusyBox をインストールすると、こうしたコマンドがそれぞれ個別のバイナリとして `PATH` に登録され、Windows の PowerShell や cmd から `sh`, `ls` などをそのまま使えるようになります。
これは Claude Code が必要とするコマンド環境を、最小限の構成で実現できて非常に有効です。

特に `sh` の存在は重要です。Claude Code は `bash` ベースのスクリプトを中心に動作しますが、BusyBox に含まれる `sh` は `ash` ベースでありながら、`bash` のサブセットとして十分な互換性を持っています。
このため、Claude Code が求めるスクリプトの実行に必要な基本機能 (変数展開、パイプ、条件分岐、ループなど) はおおむね問題なくカバーできます。

結果として、BusyBox を導入するだけで「最低限の UNIX 環境」が Windows 上に構築され、Claude Code の動作要件を満たす環境が整います。
これは、より重い仮想化や WSL 環境を導入せずとも、Claude Code の真価を体験するための実用的なソリューションとなります。

### 2.3 `/usr/bin/bash`の代わりに`bash`を使う

Claude Code が内部で `bash` を呼び出す際、ハードコードされたパス `/usr/bin/bash` を指定している場合があります。
しかし、Windows 環境はパス構造が違うため、このようなパスは存在しません。
この問題は、Claude Code のプロンプト内で bash のパスを上書きすることで回避可能です。

次のプロンプトで回避します:

```markdown
- use 'bash' instead of '/usr/bin/bash' for Windows compatibility
```

このようにして、内部で呼ばれる `bash` の参照先を、Windows 上に存在する `bash` (BusyBox による代用) へと置き換えることが可能です。

## 3. Claude CodeをWSLなしでWindowsにセットアップする手順

Claude Code は、Node.js 環境で動作する CLI アプリとして提供されています。
Node.js とパッケージマネージャー (ここでは pnpm) を事前にインストールしておく必要があります。

### 3.1 インストール環境の確認

Node.js およびパッケージマネージャー (今回は pnpm)がインストール済みか確認します。
それぞれ、バージョンを確認します。

Node.js のバージョン確認:

```powershell
node -v
# 例: v22.16.0
```

pnpm のバージョン確認:

```powershell
pnpm -v
# 例: 10.12.1
```

それぞれ、バージョン番号が表示されればインストールされています。
インストールされていない場合は、`Volta`などを利用してインストールしてください。

```powershell
volta install node@22
success: installed and set node@22.16.0 as default

volta install pnpm@latest
success: installed pnpm@10.12.1 with executables: pnpm, pnpx
```

### 3.2 BusyBox のインストール

PowerShell で次のコマンドを入力すると、Scoop 経由で BusyBox をインストールできます。

```powershell
scoop install busybox -g  # グローバルインストール（管理者権限が必要）
```

> `-g`オプションはグローバルインストールを意味し、管理者権限での実行が必要です。
> インストールで、Scoop パス上に BusyBox の各コマンドのエイリアスが追加されます。

結果、PowerShell や cmd から、`bash`, `grep`などの UNIX 系コマンドが使えるようになります。

例:

```powershell
bash --version
```

これで、Claude Code が必要とするシェル環境が整います。特に BusyBox には、シェルである`sh`,`bash`が含まれているため、shell スクリプトの実行にも対応できます。

### 3.3 Claude Code のインストール

次の手順で、Claude Code をインストールします:

```powershell
pnpm add -g @anthropic-ai/claude-code
```

インストールに成功すると、`claude --version`でバージョンを確認できます。

```powershell
claude --version
1.0.30 (Claude Code)
```

以上で、Claude Code のインストールは完了です。

### 3.4 `claude /login`による認証

Claude Code を使用するには、最初に claude /login コマンドでログイン処理を行なう必要があります。これは、Anthropic のアカウントに紐づいたトークンを CLI に認識させるための手続きです。

次の手順で、Claude Code を認証します。

1. `claude /login`の実行:
   ターミナル上で、`claude /login`を実行します。

   ```powershell
   claude /login
   ```

2. `login method`で`Claude Account`を選択します:
   ![`login method`](/images/articles/vibecoding-01/ss-claude_console_start.png)

3. 認証用にブラウザを開きます:
   ![ブラウザ認証](/images/articles/vibecoding-01/ss-claude_browser_auth.png)

4. 認証に成功すると認証トークンが発行されます:
   ![トークン取得](/images/articles/vibecoding-01/ss-claude_browser_token.png)

5. ターミナルに戻り、認証トークンを貼り付けます。
   ![認証トークン貼り付け](/images/articles/vibecoding-01/ss-claude_console_token.png)

6．認証に成功すると「login successful.」と表示されます。
`login successful.`とメッセージが表示されます。

以上で、claude の認証は終了です。

### 3.5 bash 呼び出しの工夫

Claude Code の内部動作では、UNIX 環境における `bash` の存在が前提となっており、デフォルトでは `/usr/bin/bash` を実行パスとして参照する場合があります。
Linux/WSL 環境では自然な指定ですが、Windows 環境には `/usr/bin` のようなディレクトリ構造が存在しないため、呼び出しに失敗します。

この問題に対しては、Claude Code のプロンプト指示を工夫することで回避可能です。

#### ✅ 回避策: プロンプト内でパスを変更する

Claude Code に対して、bash の呼び出しパスを明示的に `bash` (PATH に通っている BusyBox 版) に変更するように促すことで、適切にコマンドを実行させることができます。たとえば、次のような指示をプロンプトに含めます:

```markdown
- use 'bash' instead of '/usr/bin/bash' for Windows compatibility
```

この一文を冒頭や設定ブロックに加えることで、Claude Code の実行エージェントが `/usr/bin/bash` の代わりに `bash` を呼び出すようになります。
これにより、Windows 上の BusyBox に含まれる `bash` が実行され、コマンド全体が正常に動作します。

> BusyBoxで使われているシェルは`bash`ではなく`ash`、組み込み用Linuxなどに使われている軽量シェルです。
> `ash`が`bash`として呼び出された場合は`bash`互換モードで動作しますが、完全な`bash`互換ではありません。
> 高度な bashスクリプトは動作しない可能性があります。

#### 🔄 補足: 実行パスの変更は現時点でユーザー指示による制御が中心

Claude Code には設定ファイルやグローバルなパスマッピングの仕組みは提供されていません。
claude はプロジェクトで使用する設定を `./CLAUDE.md`に保存します。
このなかに、上記のプロンプトを追加することで`bash`を使用するようになります。

## 4. 実行例と活用のヒント

### 4.1 `ESTA`における実行例

[`ESTA`](https://github.com/atsushifx/esta)（Easy‑Setup‑Tools‑Action）は、開発環境の初期構築や GitHub Actions の自動化支援を目的としたプロジェクトです。
このプロジェクトの開発作業において、Claude Code を活用し、ドキュメント整備や設定ファイルの編集などを効率化しています。

#### 🧪 シナリオ：READMEにオンボーディングリンクを追加する

目的は、`docs/onboarding/README.ja.md` へのリンクを既存の `README.md` と `README.ja.md` に追加することです。

---

1. **プロンプトの入力**
   Claude Code を実行し、次のようなプロンプトを入力します:

   ```markdown
   README.md,README.ja.md にオンボーディングドキュメント`docs/onboarding/README.ja.md`へのリンクを追加し、そのための説明文を挿入して
   ```

2. **To Do の設定**
   Claude は内部的に、実行すべきタスクの一覧を自動で抽出・表示します：

   - ☐ Read existing README.md to understand current structure
   - ☐ Read existing README.ja.md to understand current structure
   - ☐ Add onboarding link and description to README.md
   - ☐ Add onboarding link and description to README.ja.md

3. **変更の提案**
   Claude はファイルの変更点として、以下のような `README.md` の差分を提案します:
   ('+'が付いている行は、claude が追加した行です)

   ```markdown
   20 + ### 📚 Getting Started
   21 +
   22 + For detailed setup instructions and development guidelines, see our [onboarding documentation](docs/onboarding/README.ja.md).
   23 +

   ```

4. **変更の承認と適用**
   CLI 上で `Yes` を選択することで、提案された内容をそのままファイルに適用できます。

5. **一連の操作の継続**
   同様の手順で `README.ja.md` に対する編集提案も受け入れて反映させます。

6. **セッションの終了**
   作業が完了すると Claude から「完了しました」とメッセージが出ます
   `quit` まはた `/exit` を入力して終了します。

---

このように、Claude Code を使うことで「実装」だけでなく「ドキュメント整備」も自然言語ベースで効率よく進めることができます。構造化された ToDo の生成、差分の提案、ファイルの直接編集まで一貫して行なえるため、プロジェクト初期のセットアップや反復的な作業にも非常に有効です。

## おわりに

この記事では、Windows ネイティブ環境、つまり WSL を使わない環境で Claude Code を使う方法を紹介しました。
また、`ESTA`プロジェクトで、実際に Claude Code を使ってみた例も紹介しました。

Claude Code の公式サイトでも、動作環境には WSL が前提とされていました。
`bash`などの UNIX/Linux 系ツールを使うことが前提であるため、Windows では互換性の問題があったためです。
しかし、BusyBox のような軽量な POSIX 互換ツールと Scoop の組み合わせにより、最小限の工夫でこうした障壁を越えることができます。

Claude Code による「vibe coding」は、単なる補完を超えた「開発スタイルそのものの変革」をもたらす可能性を秘めています。
日常的なプロトタイピングや、ドキュメント整備、反復的な開発タスクにおいても、高速かつ直感的なフィードバックループを実現できるでしょう。

ぜひ、あなた自身の Windows ターミナル環境で Claude Code を体験し、その力を開発に活かしてみてください。

それでは、Happy Hacking!
