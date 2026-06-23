---
id: IMPL-001
title: "Implementation: ci-lint-articles Composite Action Migration"
spec: SPEC-001
req: REQ-001
status: Draft
version: 1.0.4
created: "2026-06-23"
---

<!-- textlint-disable
  ja-technical-writing/sentence-length
  -->
<!-- markdownlint-disable line-length -->

## 1. Overview

本ドキュメントは `ci-lint-articles.yaml` を composite actions ベースに全面置き換えする実装単位を定義する。

**対象ドキュメント**:

- Spec: `specifications/specifications.md` v1.0.5
- Req: `requirements/requirements.md` v1.0.6

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

| Action                    | Repository           | SHA                                        | Comment     |
| ------------------------- | -------------------- | ------------------------------------------ | ----------- |
| `actions/checkout`        | `actions/checkout`   | `df4cb1c069e1874edd31b4311f1884172cec0e10` | `# v6.0.3`  |
| `ca-validate-environment` | `aglabo/ci-platform` | `f4e8d971ee9093901df0255154e643fd1f2ee10d` | `# v0.3.1+` |
| `ca-get-changed-files`    | `aglabo/ci-platform` | `f4e8d971ee9093901df0255154e643fd1f2ee10d` | `# v0.3.1+` |
| `ca-setup-repo`           | `aglabo/ci-platform` | `f4e8d971ee9093901df0255154e643fd1f2ee10d` | `# v0.3.1+` |

`ca-setup-repo` の `ref` (agla-doc-tools のチェックアウト SHA):

| Repository              | SHA                                        | Comment    |
| ----------------------- | ------------------------------------------ | ---------- |
| `aglabo/agla-doc-tools` | `bec772fc1d22fbf43fd57ef3a71f7972b83b3e24` | `# v0.1.1` |

#### 2.3 Workflow Structure

```text
triggers:
  - push: branches=[main], paths=['**/*.md']
  - pull_request: branches=[main], paths=['**/*.md']
  - workflow_dispatch

jobs:
  lint-on-github:
    runs-on: ubuntu-latest
    timeout-minutes: 10
    permissions:
      contents: read

    steps:
      1. id: checkout
         uses: actions/checkout@df4cb1c... # v6.0.3
         with:
           fetch-depth: 0
           persist-credentials: false

      2. id: validate-env
         uses: aglabo/ci-platform/.github/actions/ca-validate-environment@f4e8d971... # v0.3.1+
         with: actions-type: read

      3. id: resolve-sha  (run step)
         初回コミット判定: git rev-list --parents -n 1 HEAD でparent数を取得
         - workflow_dispatch + parent数 == 0 (初回コミット) ->
             echo "skip=true" >> $GITHUB_OUTPUT
             warning log + exit 0
         - workflow_dispatch + parent数 >= 1 ->
             echo "BEFORE_SHA=$(git rev-parse HEAD^1)" >> $GITHUB_ENV
             echo "AFTER_SHA=$(git rev-parse HEAD)"    >> $GITHUB_ENV
             echo "skip=false" >> $GITHUB_OUTPUT
         - workflow_dispatch + git コマンド失敗 -> exit non-zero
         - push / pull_request ->
             echo "BEFORE_SHA=" >> $GITHUB_ENV
             echo "AFTER_SHA="  >> $GITHUB_ENV
             echo "skip=false" >> $GITHUB_OUTPUT

      4. id: changed-files
         if: steps.resolve-sha.outputs.skip != 'true'
         uses: aglabo/ci-platform/.github/actions/ca-get-changed-files@f4e8d971... # v0.3.1+
         with:
           pattern: '**/*.md'
           before-sha: ${{ env.BEFORE_SHA }}
           after-sha:  ${{ env.AFTER_SHA }}

      5. id: setup-repo
         if: steps.resolve-sha.outputs.skip != 'true'
         uses: aglabo/ci-platform/.github/actions/ca-setup-repo@f4e8d971... # v0.3.1+
         with:
           repo: aglabo/agla-doc-tools
           path: .tools/agla-doc-tools
           ref: bec772fc1d22fbf43fd57ef3a71f7972b83b3e24 # v0.1.1

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
| R-001a/b/c | on: push / pull_request / workflow_dispatch トリガー定義                                                                                                                      |
| R-001d     | paths フィルターで *.md 以外の push/PR はジョブ起動しない                                                                                                                     |
| R-002a     | SHA 解決ステップ: `git rev-parse HEAD^1` 成功時に環境変数セット                                                                                                               |
| R-002b     | SHA 解決ステップ: `git rev-list --parents -n 1 HEAD` で parent 数 == 0 → `skip=true` + warning + exit 0。後続ステップは `if: steps.resolve-sha.outputs.skip != 'true'` で制御 |
| R-002c     | SHA 解決ステップ: その他 git エラー → exit non-zero                                                                                                                           |
| R-002d     | push / PR 時は BEFORE_SHA="", AFTER_SHA="" で自動解決を委譲                                                                                                                   |
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
- ステップ間の環境変数受け渡し: `echo "VAR=value" >> $GITHUB_ENV` で書き込み、次ステップで `${{ env.VAR }}` として参照する
- ca-get-changed-files の outputs 参照: step `id: changed-files` を設定し、lint ステップで `${{ steps.changed-files.outputs.files }}` / `${{ steps.changed-files.outputs.count }}` を `env:` 経由で渡す
- セキュリティ: `actions/checkout` に `persist-credentials: false` を設定する。lint ツールは `textlint` と `markdownlint-cli2` を直接実行するため、PR 内スクリプト変更の影響を受けない
- `ca-setup-repo` の `repo`: `aglabo/agla-doc-tools`、`path`: `.tools/agla-doc-tools`、`ref`: `bec772fc1d22fbf43fd57ef3a71f7972b83b3e24 # v0.1.1`
- `ca-setup-repo` は `bin/` を PATH に追加するため、`markdownlint-cli2` コマンドは `ca-setup-repo` 完了後にそのまま呼び出せる
- 初回コミット判定: `git rev-list --parents -n 1 HEAD` の出力を空白で分割し、フィールド数が 1（親なし）なら初回コミットと判定する。exit code 128 による判定は他の git エラーと区別できないため使わない
- スキップの伝播: resolve-sha ステップが初回コミットを検出した場合、`echo "skip=true" >> $GITHUB_OUTPUT` で出力し、後続の changed-files / setup-repo / lint 各ステップに `if: steps.resolve-sha.outputs.skip != 'true'` を付与してスキップさせる
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

| # | Criterion                                                                     | How to Verify                          |
| - | ----------------------------------------------------------------------------- | -------------------------------------- |
| 1 | YAML 構文が正しい                                                             | `actionlint` / `yamllint` でエラーなし |
| 2 | fetch-depth が 0 に設定されている                                             | yaml 内を目視確認                      |
| 3 | ca-validate-environment が checkout の直後に配置されている                    | ステップ順序を目視確認                 |
| 4 | 全 Action が commit SHA で固定されている                                      | `@SHA # vX.Y.Z` コメント形式を目視確認 |
| 5 | SHA 解決ステップが R-002a/b/c/d を網羅している                                | スクリプトロジックを目視確認           |
| 6 | lint ステップが count==0 スキップ・削除済みスキップ・fail-fast を実装している | スクリプトロジックを目視確認           |
| 7 | push / PR / workflow_dispatch の各トリガーが正しく設定されている              | yaml を目視確認                        |

---

## 5. Change History

| Date       | Version | Description                                                                                                                                                                     |
| ---------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 2026-06-23 | 1.0.0   | Initial draft                                                                                                                                                                   |
| 2026-06-23 | 1.0.1   | explore review 対応: agla-doc-tools SHA 確定 (v0.1.0) 、path `.tools/agla-doc-tools` 追加、markdownlint-cli2 PATH 経路を明記                                                    |
| 2026-06-23 | 1.0.2   | explore review (2nd) 対応: uses: パス形式・GITHUB_ENV 受け渡し・outputs 参照方式・step id を Section 2.3/2.5 に追記                                                             |
| 2026-06-23 | 1.0.3   | Codex risk review 対応: 初回コミット判定を exit code 128 から git rev-list --parents に変更、skip=true による後続ステップ制御、printf '%s\n' 展開、CHANGED_COUNT 数値検証を追加 |
| 2026-06-23 | 1.0.4   | Codex balanced review 対応: checkout に persist-credentials: false 追加。Composite Action 契約・実行環境検証は自作 action / ca-validate-environment で対応済みとして記録        |
