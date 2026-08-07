---
id: IMPL-001
title: "Implementation: ci-lint-articles Composite Action Migration"
spec: SPEC-001
req: REQ-001
status: Draft
version: 1.0.6
created: "2026-06-23"
---

<!-- textlint-disable
  ja-technical-writing/sentence-length
  -->
<!-- markdownlint-disable line-length -->

## 1. Overview

本ドキュメントは `ci-lint-articles.yaml` を composite actions ベースに全面置き換えする実装単位を定義する。

**対象ドキュメント**:

- Spec: `specifications/specifications.md` v1.0.7
- Req: `requirements/requirements.md` v1.0.7

---

## 2. Implementation Units

### IMPL-001: ci-lint-articles.yaml 全面書き換え

**Commit granularity**: 1 コミット。

#### 2.1 Target File

```text
.github/workflows/ci-lint-articles.yaml
```

#### 2.2 Dependency: Action SHA

使用する composite actions の commit SHA:

| Action                    | Repository           | SHA                                        | Comment    |
| ------------------------- | -------------------- | ------------------------------------------ | ---------- |
| `actions/checkout`        | `actions/checkout`   | `df4cb1c069e1874edd31b4311f1884172cec0e10` | `# v6.0.3` |
| `ca-validate-environment` | `aglabo/ci-platform` | `9cc4b15bf10854ecc0fc2ea0a419d96566ea8bde` | `# v0.3.3` |
| `ca-get-changed-files`    | `aglabo/ci-platform` | `9cc4b15bf10854ecc0fc2ea0a419d96566ea8bde` | `# v0.3.3` |
| `ca-setup-repo`           | `aglabo/ci-platform` | `9cc4b15bf10854ecc0fc2ea0a419d96566ea8bde` | `# v0.3.3` |

`ca-setup-repo` の `ref` (agla-doc-tools のチェックアウト SHA):

| Repository              | SHA                                        | Comment    |
| ----------------------- | ------------------------------------------ | ---------- |
| `aglabo/agla-doc-tools` | `65055a58be00ace993489273fe2a037d1ec1468d` | `# v0.2.0` |

v0.2.0 は `engines` に `node >=24`、`pnpm >=11` を要求するため、`ca-setup-repo` のデフォルト
(`node-version: "22"`、`pnpm-version: "10"`) では `pnpm install --frozen-lockfile` が失敗する。
`node-version: "24"` と `pnpm-version: "11"` を明示的に渡さなければならない (MUST) 。

#### 2.3 Workflow Structure

```text
triggers:
  - push: branches=[main], paths=['**/*.md']
  - pull_request: branches=[main], paths=['**/*.md']
  - workflow_dispatch:
      inputs:
        fetch-depth: {type: string, required: false, default: "0"}
  - workflow_call:
      inputs:
        fetch-depth: {type: string, required: false, default: "0"}

jobs:
  lint-on-github:
    runs-on: ubuntu-latest
    timeout-minutes: 10
    permissions:
      contents: read

    env:
      # inputs is unset on push/pull_request -> the trigger-level default does not apply there
      FETCH_DEPTH: ${{ inputs.fetch-depth || '0' }}

    steps:
      1. id: checkout
         uses: actions/checkout@df4cb1c... # v6.0.3
         with:
           fetch-depth: ${{ env.FETCH_DEPTH }}
           persist-credentials: false

      2. id: validate-env
         uses: aglabo/ci-platform/.github/actions/ca-validate-environment@f4e8d971... # v0.3.1+
         with: actions-type: read

      3. id: resolve-sha  (run step)
         分岐は「push / pull_request か否か」で行う
         - push / pull_request ->
             echo "before_sha=" >> $GITHUB_OUTPUT
             echo "after_sha="  >> $GITHUB_OUTPUT
             echo "skip=false"  >> $GITHUB_OUTPUT
             ※ 両方空にして ca-get-changed-files の自動解決に委譲する
         - それ以外 (workflow_dispatch / workflow_call 由来の schedule, release 等):
           git rev-list --parents -n 1 HEAD の先頭行でparent数を取得
           - parent数 >= 1 ->
               echo "before_sha=<第2フィールド>" >> $GITHUB_OUTPUT
               echo "after_sha=<第1フィールド>"  >> $GITHUB_OUTPUT
               echo "skip=false" >> $GITHUB_OUTPUT
           - parent数 == 0 かつ git rev-parse --is-shallow-repository == false
             (真の初回コミット) ->
               echo "skip=true" >> $GITHUB_OUTPUT
               warning log + exit 0
           - parent数 == 0 かつ --is-shallow-repository == true
             (shallow clone で親が未 fetch) ->
               error log + exit non-zero
           - git コマンド失敗 -> exit non-zero

      4. id: changed-files
         if: steps.resolve-sha.outputs.skip != 'true'
         uses: aglabo/ci-platform/.github/actions/ca-get-changed-files@f4e8d971... # v0.3.1+
         with:
           pattern: '**/*.md'
           before-sha: ${{ steps.resolve-sha.outputs.before_sha }}
           after-sha:  ${{ steps.resolve-sha.outputs.after_sha }}

      5. id: setup-repo
         if: steps.resolve-sha.outputs.skip != 'true'
         uses: aglabo/ci-platform/.github/actions/ca-setup-repo@9cc4b15b... # v0.3.3
         with:
           repo: aglabo/agla-doc-tools
           path: .tools/agla-doc-tools
           ref: 65055a58be00ace993489273fe2a037d1ec1468d # v0.2.0
           node-version: "24"
           pnpm-version: "11"

      6. id: lint  (run step)
         if: steps.resolve-sha.outputs.skip != 'true'
         env:
           CHANGED_FILES: ${{ steps.changed-files.outputs.files }}
           CHANGED_COUNT: ${{ steps.changed-files.outputs.count }}
         - CHANGED_COUNT が空または非数値の場合 -> exit non-zero（不正出力として扱う）
         - count == 0 -> warning + exit 0
         - for each file (printf '%s\n' "$CHANGED_FILES" | while IFS= read -r file):
             deleted -> "deleted -> skip" log + continue
             exists  -> textlint -> markdownlint (fail-fast)
```

#### 2.4 Spec Rule Coverage

| Rule       | Implementation                                                                                                                                                                |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| R-001a/b/c | on: push / pull_request / workflow_dispatch / workflow_call トリガー定義                                                                                                      |
| R-001d     | paths フィルターで *.md 以外の push/PR はジョブ起動しない                                                                                                                     |
| R-002a     | SHA 解決ステップ: 非 push/PR イベントで parent が取得できた場合に `before_sha`/`after_sha` を GITHUB_OUTPUT へ出力                                                            |
| R-002b     | SHA 解決ステップ: `git rev-list --parents -n 1 HEAD` で parent 数 == 0 → `skip=true` + warning + exit 0。後続ステップは `if: steps.resolve-sha.outputs.skip != 'true'` で制御 |
| R-002c     | SHA 解決ステップ: その他 git エラー → exit non-zero                                                                                                                           |
| R-002d     | push / PR 時は `before_sha=""`, `after_sha=""` で自動解決を委譲                                                                                                               |
| R-002e     | workflow_call 由来の非 push/PR イベント (schedule / release 等) も自前で SHA を解決する。空文字を渡すと上流が `Unsupported event` で失敗するため                              |
| R-002f     | parent 数 == 0 の場合、`git rev-parse --is-shallow-repository` で真の初回コミットと shallow clone を切り分ける。shallow なら error + exit non-zero（黙ってスキップしない）    |
| R-003      | ca-validate-environment を checkout 直後・他ステップより前に配置                                                                                                              |
| R-004a/b   | ca-get-changed-files に before-sha / after-sha を渡す                                                                                                                         |
| R-004c     | before-sha オールゼロ時のフォールバックは ca-get-changed-files が処理                                                                                                         |
| R-005a     | count == 0 の場合 warning ログ + exit 0                                                                                                                                       |
| R-005b     | outputs.files を展開して各ファイルにループ                                                                                                                                    |
| R-005c     | `[ -f "$file" ]` チェック: false → "deleted -> skip" + continue                                                                                                               |
| R-005d     | `textlint --config configs/textlintrc.yaml $FILES` を実行                                                                                                                     |
| R-005e     | `markdownlint-cli2 --config configs/.markdownlint-cli2.yaml "$file"` を実行                                                                                                   |
| R-005f     | textlint / markdownlint 失敗時は即 exit non-zero (fail-fast)                                                                                                                  |

#### 2.5 Implementation Notes

- uses: パス形式: `aglabo/ci-platform/.github/actions/<action-name>@<SHA>` の形式で step-level で呼び出す
- ステップ間の値の受け渡し: `echo "key=value" >> $GITHUB_OUTPUT` で書き込み、次ステップで `${{ steps.<id>.outputs.<key> }}` として参照する。`GITHUB_ENV` + `${{ env.VAR }}` は使わない — 実行時に生成される変数は静的解析で追えず、VS Code の GitHub Actions 拡張が「Context access might be invalid」を誤検知するため。上流の `ca-get-changed-files` 自身も outputs 方式を採っている
- ca-get-changed-files の outputs 参照: step `id: changed-files` を設定し、lint ステップで `${{ steps.changed-files.outputs.files }}`/`${{ steps.changed-files.outputs.count }}` を `env:` 経由で渡す
- セキュリティ: `actions/checkout` に `persist-credentials: false` を設定する。lint ツールは `textlint` と `markdownlint-cli2` を直接実行するため、PR 内スクリプト変更の影響を受けない
- `ca-setup-repo` の `repo`: `aglabo/agla-doc-tools`、`path`: `.tools/agla-doc-tools`、`ref`: `65055a58be00ace993489273fe2a037d1ec1468d # v0.2.0`
- `ca-setup-repo` は `bin/` を PATH に追加するため、`markdownlint-cli2` コマンドは `ca-setup-repo` 完了後にそのまま呼び出せる
- 初回コミット判定: `git rev-list --parents -n 1 HEAD` の出力を空白で分割し、フィールド数が 1（親なし）なら親が見えないと判定する。exit code 128 による判定は他の git エラーと区別できないため使わない
- shallow clone の切り分け: フィールド数が 1 でも、それが「真の初回コミット」か「shallow clone で親が未 fetch」かは区別できない。`fetch-depth` は `workflow_call` の caller が `"1"` を渡せるため後者は現実に起こる。shallow を初回コミットと誤認して `skip=true` にするとリントが黙って実行されないまま成功扱いになるので、`git rev-parse --is-shallow-repository` で判定し shallow 側は exit non-zero で明示的に失敗させる（fail-first）
- スキップの伝播: resolve-sha ステップが初回コミットを検出した場合、`echo "skip=true" >> $GITHUB_OUTPUT` で出力し、後続の changed-files/setup-repo/lint 各ステップに `if: steps.resolve-sha.outputs.skip != 'true'` を付与してスキップさせる
- outputs.files の展開: `echo "$CHANGED_FILES"` ではなく `printf '%s\n' "$CHANGED_FILES"` を使い、先頭ハイフンやオプション風文字列の誤解釈を防ぐ
- CHANGED_COUNT の型チェック: lint ステップ内で `[[ "$CHANGED_COUNT" =~ ^[0-9]+$ ]]` で数値検証し、不正値の場合は exit non-zero とする
- GitHub Actions の `run:` ブロックは `bash --noprofile --norc -eo pipefail` で実行されるため、fail-fast（R-005f）は `set -e` を明示しなくても動作する

---

## 3. Commit Plan

| # | File                                      | Type   | Message                                                |
| - | ----------------------------------------- | ------ | ------------------------------------------------------ |
| 1 | `.github/workflows/ci-lint-articles.yaml` | `feat` | `feat(ci): migrate lint-articles to composite actions` |

**Commit message body** (Conventional Commits + Deckrd linkage):

```text
feat(ci): migrate lint-articles to composite actions

- Add push trigger for main branch *.md changes
- Add workflow_dispatch trigger with SHA resolution
- Replace inline steps with ca-validate-environment / ca-get-changed-files / ca-setup-repo
- Add deleted-file skip and fail-fast lint execution

Implements: IMPL-001
Spec: SPEC-001
Req: REQ-001
```

---

## 4. Verification Criteria

実装完了の判定条件:

| # | Criterion                                                                        | How to Verify                                                                                                                                                                  |
| - | -------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1 | YAML 構文が正しい                                                                | `actionlint` / `yamllint` でエラーなし                                                                                                                                         |
| 2 | fetch-depth が未指定時に 0 に解決される                                          | `env.FETCH_DEPTH` が `${{ inputs.fetch-depth \|\| '0' }}` であり、checkout がその env を参照していることを目視確認。push 実行時の checkout ログで解決値が `0` になることを確認 |
| 3 | ca-validate-environment が checkout の直後に配置されている                       | ステップ順序を目視確認                                                                                                                                                         |
| 4 | 全 Action が commit SHA で固定されている                                         | `@SHA # vX.Y.Z` コメント形式を目視確認                                                                                                                                         |
| 5 | SHA 解決ステップが R-002a/b/c/d を網羅している                                   | スクリプトロジックを目視確認                                                                                                                                                   |
| 6 | lint ステップが count==0 スキップ・削除済みスキップ・fail-fast を実装している    | スクリプトロジックを目視確認                                                                                                                                                   |
| 7 | push / PR / workflow_dispatch / workflow_call の各トリガーが正しく設定されている | yaml を目視確認                                                                                                                                                                |

---

## 5. Change History

| Date       | Version | Description                                                                                                                                                                                                                                            |
| ---------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 2026-06-23 | 1.0.0   | Initial draft                                                                                                                                                                                                                                          |
| 2026-06-23 | 1.0.1   | explore review 対応: agla-doc-tools SHA 確定 (v0.1.0) 、path `.tools/agla-doc-tools` 追加、markdownlint-cli2 PATH 経路を明記                                                                                                                           |
| 2026-06-23 | 1.0.2   | explore review (2nd) 対応: uses: パス形式・GITHUB_ENV 受け渡し・outputs 参照方式・step id を Section 2.3/2.5 に追記                                                                                                                                    |
| 2026-06-23 | 1.0.3   | Codex risk review 対応: 初回コミット判定を exit code 128 から git rev-list --parents に変更、skip=true による後続ステップ制御、printf '%s\n' 展開、CHANGED_COUNT 数値検証を追加                                                                        |
| 2026-06-23 | 1.0.4   | Codex balanced review 対応: checkout に persist-credentials: false 追加。Composite Action 契約・実行環境検証は自作 action / ca-validate-environment で対応済みとして記録                                                                               |
| 2026-08-07 | 1.0.5   | fetch-depth をパラメータ化: workflow_dispatch / workflow_call の inputs 追加、ジョブレベル env.FETCH_DEPTH 経由で checkout に受け渡し、検証基準 #2 を更新                                                                                              |
| 2026-08-07 | 1.0.6   | SHA 受け渡しを GITHUB_ENV から GITHUB_OUTPUT へ移行 (R-002 全体を改訂)。分岐を push/PR か否かに反転し workflow_call 由来の非 push/PR イベントに対応 (R-002e)。shallow clone を初回コミットと誤認しないよう --is-shallow-repository で切り分け (R-002f) |
