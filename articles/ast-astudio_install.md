---
title: "Android Studio: WindowsにAndroid Studioをインストールする"
emoji: "📱"
type: "tech" 
topics: ["Android", "AndroidStudio",  "開発環境"]
published: false

---

# tl;dr

``Android Studio``をzipアーカイブから展開して、インストールする

# はじめに

``Android Studio``は、Androidアプリを開発するための統合開発環境<sub>(IDE)</sub>です。アプリ開発の他に、``Android SDK``の管理や``Android Emulator``といった機能も備えており、``Android Studio``一つで、複数のAndroid機器に対応したアプリを開発できます。



# ``Android Studio``のダウンロード

``Android Studio``は、``Android ディベロッパー``のサイト( [https://developer.android.com/?hl=ja](https://developer.android.com/?hl=ja) )からダウンロードできます。

次の手順で、``Android Studio``をダウンロードします。



1.  [Android Studioのダウンロード](https://developer.android.com/studio?hl=ja#downloads) ページにアクセスします。

   

2.   ``android-studio-yyyy.mm.dd.zz-windows.zip``ファイルを選択し、ファイルをダウンロードします。

   

3. 以上で、``Android Studio``のダウンロードは終了です。



#  ``Android Studio``のインストール

zipアーカイブの場合は、アーカイブを展開した後のディレクトリを適当なディレクトリに配置することで``Android Studio``をインストールします。

次の手順で、``Android Studio``をインストールします。

1.  7zを使い、zipアーカイブを展開します。

   ```powershell
   C: /Develop > 7z x .\android-studio-2020.3.1.24-windows.zip
   
   7-Zip 19.00 (x64) : Copyright (c) 1999-2018 Igor Pavlov : 2019-02-21
   
   Scanning the drive for archives:
   1 file, 967558484 bytes (923 MiB)
   
   Extracting archive: .\android-studio-2020.3.1.24-windows.zip
   --
   Path = .\android-studio-2020.3.1.24-windows.zip
   Type = zip
   Physical Size = 967558484
   
   
   ```

   

2.   展開したファイルの``android-studio``以下を``c:\apps\Develop\android\``に移動します。

   ```powershell
   C: /Develop > mv .\android-studio\ C:\apps\Develop\android\
   
   ```

   

3.   以上で、Android Studioのインストールは終了です。





# ``Android Studio``の動作確認

インストールした``Android Studio``が正常に動作するか、実際に動かしてみます。

次の手順で、``Android Studio``を起動します。



1.   ``bin/``下の``studio64.exe``を実行します。

   ```powershell
   C: /workspaces >  C:\apps\Develop\android\android-studio\bin\studio64.exe
   
   ```

   

2. スプラッシュ画面が表示された後、Welcome画面が表示されます。

   ![Android Studio - welcome](https://i.imgur.com/E1cOese.jpg)

   

3.   Cancelをクリックし、``Android Studio``を終了します。



以上で、``Android Studio``の動作確認は終了です。





