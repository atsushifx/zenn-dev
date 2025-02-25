---
title: "troubleshoot: git commit で invalid size of lockfile がでたときの対処法"
emoji: "🛠️"
type: "tech"
topics: [ "トラブルシューティング", "エラー", "GnuPG", "git" ]
published: false
---

## はじめに

この記事は、`git`で署名付きコミットをしたときに`gpg: invalid size of lockfile'というエラーが発生した場合のトラブルシューティング記事です。

## エラーメッセージ

この記事は、下記のエラーメッセージの場合に対応しています。

```powershell
error: gpg failed to sign the data:
gpg: invalid size of lockfile 'C:\\Users\\atsushifx\\AppData\\Roaming\\gnupg'C:\\Users\\atsushifx\\AppData\\Roaming\\gnupg_spawn_keyboxd_sentinel.lock'
gpg: cannot read lockfile
gpg: can't connect to the keyboxd: Invalid argument
gpg: error opening key DB: No Keybox daemon running
gpg: skipped "atsushifx@gmail.com": Input/output error
[GNUPG:] INV_SGNR 0 atsushifx@gmail.com
[GNUPG:] FAILURE sign 33587249
gpg: signing failed: Input/output error
```

## エラーの原因と対策

`git`で署名付きコミットをすると、`GnuPG`バイナリ`gpg.exe`が呼び出されます。
このとき、実行パス、または検索パスに空白が含まれていると、上記のエラーが発生します。

## トラブルシューティング

以下の手順で、トラブルに対処します。

1. `gpg.exe`の対象パスを確認する:
   (例: `C:\app\develop\util\gnupg\gpg.exe`)

2. `gpg.conf`に`gpg.exe`を設定する:
   `gpg.conf`に`gpg.exe`をフルパスで設定します。
   このとき、空白をエスケープするために、`"`で囲います。

   ```gpg.conf
   [gpg]
     program = "c:\app\develop\util\gnupg.gpg.exe"

   ```

3. `git commit`を確認する:
   `git commit`を実行し、正常に終了することを確認します。

## おわりに

この記事では、署名付きコミットを実行した際に `invalid size of lockfile` エラーの原因と、対策について解説しました。
`gpg.exe`のパスを確認し、`gpg.conf`に適切なパスを設定することで、エラーが解消できます。
`gpg.conf`で`gpg.exe`と設定した場合もエラーが発生するので、注意が必要です。

この記事が、エラーの対策のさんこうになったら幸いです。

それでは、Happy Hacking!
