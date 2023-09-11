---
title: "Windows: Windowsの作業用に一時ドライブを作成する"
emoji: "🪟"
type: "tech"
topics: [ "hacks",  "windows", "開発環境", "subst"]
published: false
---

## はじめに

この記事では、Windows の subst コマンドを使用して一時ドライブを作成する方法を説明します。

## 1. subst とは

subst は Windows のコマンドで指定したディレクトリを仮想的なドライブとして扱うコマンドです。

## 1.2 substの使用法

subst は、次の構文で使用します。

```powershell
subst [仮想的ドライブ]: [フルパス]
```

たとえば、以下のように入力すると、`c:\tmp` ディレクトリが Z ドライブとしてマッピングされます。

```powershell
subst z: c:\tmp
```

これにより、Z ドライブを通じて  `c:\tmp` の内容にアクセスできます。
詳細なオプションや使用事例については、[subst の公式ドキュメント](https://learn.microsoft.com/ja-jp/windows-server/administration/windows-commands/subst)を参照してください。

## 2. 一時ドライブ作成スクリプト

このセクションでは、一時ドライブを作成するために使用されるスクリプトについて説明します。

## 2.1 スクリプトの説明

以下のスクリプトは、一時ドライブ用の Z ドライブ内のファイルを削除し、Z ドライブを再設定するバッチファイルです。
また、作業用ディレクトリとして"z:\temp","z:\works"を作成しています。

```powershell: zdrive.cmd
@echo off
rem
rem create Z drive for temporary
rem
rem @Author atsushifx
rem

path c:\windows\system32;%path%

setlocal
set _tmpdrv=C:
set _tmpdir=%tmpdrv%\tmp

rem create tmpdir
if not exist %_tmpdir%\NUL goto endtmpdir
  rmdir /s /q %_tmpdir%
:endtmpdir
mkdir %_tmpdir%

rem create tmpdrive
if exist Z:\NUL goto endtmpdrive
  C:/WINDOWS/system32/subst.exe z: %_tmpdir%
:endtmpdrive

rem Create temporary working dir
mkdir z:\temp
mkdir z:\works

```

このスクリプトは、Windows が呼びだすため"c:\bin\init\zdrive.cmd"という特定の名前で保存しています。

## 3. タスクによる一時ドライブ自動作成

タスクスケジューラにタスクを追加し、2.で作成したスクリプトを Windows が自動的に呼びだすようにします。
こうすることで、Windows を使うときには自動的に一時ドライブ"Zドライブ"が使えるようになります。

### 3.1.  タスクの作成

一時ドライブを自動的に作成するため、次の手順でタスクを作成します。

1. タスクスケジューラの起動:
    スタートメニューから\[タスクスケジューラ]を起動し\[タスクスケジューラ]を開く
    ![タスクスケジューラ](https://i.imgur.com/oGTgTI0.png)

2. タスクの新規作成
    \[操作]-\[タスクの作成](\R)]を選び、\[タスクの作成]ダイアログを開く
    ![タスクの作成](https://i.imgur.com/ljAzJgr.png)

3. タスク名の設定:
    タスクの\[全般]タブを選び、\[名前\]に`zdrive`と入力する。また、"ユーザーがログオンしているかにかかわらず実行する"をチェックする
    ![タスク名の設定](https://i.imgur.com/eOOv4nI.png)

4. トリガーの設定:
    \[トリガー]タブを選び、\[新規\]ボタンをおしてトリガーを作成する。トリガーには、\[スタートアップ時]と\[任意のユーザーのログオン時]を選択する
    ![トリガーの設定](https://i.imgur.com/ukqtS44.png)

5. 操作の設定:
   \[操作]タブに移動し、\[新規\]ボタンをクリックする。スクリプトとして "c:\bin\init\zdrive.cmd"を登録する
   ![操作の設定](https://i.imgur.com/RZQXfE7.png)

6. タスクスケジューラの終了:
    \[OK]をクリックし、各ダイアログを閉じる。その後、\[ファイル\-\[終了]としてタスクスケジューラを閉じる

以上で、タスクの設定は終了です。

### 3.2. タスクのエキスポート

タスクの作成を一気できるように、作成したタスクをエクスポートします。
次の手順で、タスクをエクスポートします。

1. タスクの選択:
    タスクスケジューラの\[タスクスケジューラライブラリ]画面で、作成した"zdrive"を選択する
     ![タスクスケジューラ ライブラリ](https://i.imgur.com/ljAzJgr.png)

2. タスクのエクスポート:
    \[操作]-\[エクスポート]を選択し、タスクをエクスポートする

以上で、タスクのエクスポートは終了です。

### 3.3. タスクのインポート

3.2.で作成した"zdrive.xml"ファイルを使って、タスクをインポートできます。
次の手順で、タスクをインポートします。

1. タスク一覧:
    タスクスケジューラの\[タスクスケジューラライブラリ]画面を開く
    ![タスクスケジューラ ライブラリ](https://i.imgur.com/ljAzJgr.png)

2. タスクのインポート:
    \[操作]-\[タスクのインポート]を選択し、作成した"zdrive.xml"ファイルを選択する

3. タスクの設定:
    \[タスクの作成\]ダイアログが表示されるので、\[OK\]をクリックする
    ![タスク名の設定](https://i.imgur.com/eOOv4nI.png)

以上で、タスクのインポートは終了です。

## おわりに

この記事では、Windows の subst コマンドを使用して一時ドライブを作成する方法を紹介しました。また、タスクスケジューラを使って、一時ドライブを自動的に作成する方法も紹介しました。

ちょっとしたスクリプトやプログラムを一時ドライブで試せるようになりました。
これで、プログラミングや開発作業がよりはかどるでしょう。

それでは、Happy Hacking!

## 参考資料

### Webサイト

- [subst](https://learn.microsoft.com/ja-jp/windows-server/administration/windows-commands/subst)
- [タスクスケジューラ](https://learn.microsoft.com/ja-jp/windows/win32/taskschd/about-the-task-scheduler)
