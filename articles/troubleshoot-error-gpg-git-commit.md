---
title: "troubleshoot: 'git commit' で 'invalid size of lockfile' が発生したときの対処法"
emoji: "🛠️"
type: "tech"
topics: [ "トラブルシューティング", "エラー", "GnuPG", "git" ]
published: true
---

## はじめに

atsushifx です。

`GnuPG`をインストールして、`Git`で署名付きコミットを実行したのですが、エラーが発生しました。
エラーの解消に半日ほどかかり、ちょっとはまったので知見を共有します。

## エラーメッセージ

この記事は、下記のエラーメッセージの場合に対応しています。

```powershell
error: gpg failed to sign the data:

gpg: invalid size of lockfile 'C:\Users\atsushifx\AppData\Roaming\gnupg\gnupg_spawn_keyboxd_sentinel.lock'
gpg: cannot read lockfile
gpg: can't connect to the keyboxd: Invalid argument
gpg: error opening key DB: No Keybox daemon running
gpg: skipped "atsushifx@gmail.com": Input/output error
[GNUPG:] INV_SGNR 0 atsushifx@gmail.com
[GNUPG:] FAILURE sign 33587249
gpg: signing failed: Input/output error

fatal: failed to write commit object

```

## エラーの原因と対策

`git`で署名付きコミットの実行時、`GnuPG`バイナリである `gpg.exe` が呼び出されます。
このとき、`C:\Program Files\GnuPG\gpg.exe` のようにパスに空白が含まれていると、エラーが発生します。
また、設定がフルパスで指定されていない場合も、同様にエラーが発生します。

## トラブルシューティング

以下の手順で、トラブルに対処します。

1. パスの確認:
   `gpg.exe`の実行パスを確認します。
   (例: `C:\app\develop\util\gnupg\gpg.exe`)

2. `gpg.conf`の設定:
   `gpg.conf`の該当項目に`gpg.exe`をフルパスを設定します。
   フルパス内の空白をエスケープするために、パス全体を`"`で囲います。

   ```gpg.conf
   [gpg]
     program = "c:\app\develop\util\gnupg\gpg.exe"

   ```

3. `git commit`を確認する:
   `git commit`を実行し、正常に終了することを確認します。

## おわりに

この記事では、署名付きコミットを実行した際に `invalid size of lockfile` エラーの原因と、対策について解説しました。
`gpg.exe`のパスを確認し、`gpg.conf`に正しくパスを設定することで、エラーが解消できます。
`gpg.conf`で`gpg.exe`と設定した場合もエラーが発生するので、注意が必要です。

この記事の手順と注意点が、エラー対策に役立てば幸いです。

それでは、Happy Hacking!
