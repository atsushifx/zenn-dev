---
title: "Windows: Windowsの作業用に一時ドライブを作成する"
emoji: "🪟"
type: "tech"
topics: [ "hacks", "SUBST", "MS-DOS"]
published: false
---

## はじめに

この記事では、Windows の subst コマンドを使用して一時ドライブを作成する方法を説明します。

## 1. subst とは

subst は Windows のコマンドで指定したディレクトリを仮想的なドライブとして扱うコマンドです。

## 1.2 substの使用法

subst は、次の構文で使います。

```powershell
subst [仮想的ドライブ]: [フルパス]
```

たとえば、

```powershell
subst z: c:\tmp
```

と入力すると、c:\tmp ディレクトリが Z ドライブとしてマッピングされます。
これにより、Z ドライブを通じて  `c:\tmp` の内容にアクセスできます。

## 2. 一時ドライブ作成スクリプト

一時ドライブの作成には、下記のようなスクリプトを用います。

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
if exist %_tmpdir%\NUL goto endtmpdir
  mkdir %_tmpdir%

:endtmpdir

rem create tmpdrive
if exist Z:\NUL goto endtmpdrive
  C:/WINDOWS/system32/subst.exe z: %_tmpdir%
:endtmpdrive

rem Create temporary working dir
mkdir z:\temp
mkdir z:\works

```

このスクリプトを使うと、Zドライブが一時ドライブとして使用できるようになになります。
また、作業用に`z:\temp`, `z:\works`が利用可能になります。

## 3. タスクによる一時ドライブ自動作成

## おわりに

## 参考資料

### Webサイト
