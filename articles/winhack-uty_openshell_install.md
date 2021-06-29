---
title: "Windowsにopen-shellをインストールする"
emoji: "🪟"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [Windows,個人開発,開発環境,カスタマイズ,hack]
published: false
---

# WindowsにOpen-Shellをインストールする
## Open-Shellについて

Open-Shellは、Windows 8,Windows 10などの環境でWindows XPやWindows 7スタイルのスタートメニューを追加するツールです。  

元々は、Classic Shellというツールでしたが、Classic Shellは開発が止まったため、新たにOpen-Shellという名前でOSSとして開発されました、
現在は、[GitHub](https://github.com/Open-Shell/Open-Shell-Menu)上で開発が続けられています。

## Open-Shellのインストール

### Open-Shellをダウンロードする

Open-ShellはGitHubのOpen-Shell/Open-Shell-Menuからダウンロードできます。次の手順で、Open-Shellをダウンロードします。

1. [GitHub/Open-Shell](https://github.com/Open-Shell/Open-Shell-Menu)にアクセスします。
    ![Open-Shell](https://i.imgur.com/cEeOFaP.jpg)

2. ![Downloads](https://i.imgur.com/EEKgI1h.png)をクリックし、Open-Shellをダウンロードします。

3. 以上で、Open-Shellのダウンロードは終了です。

### Open-Shellをインストールする

次の手順でOpen-Shellをインストールします。

1. Open-Shellインストーラを起動します

   ![Open-Shell Setup](https://i.imgur.com/GO8GBZS.jpg)

2. ライセンスを下までスクロールし、**License Agreement**に同意します。

   ![End-User License Agreement](https://i.imgur.com/eNpzGOu.jpg)

3. Custom Setupを選択し、Classic IEのチェックを外します。また、インストール先を"C:\Program Files\Apps\Open-Shell"に変更します。

   ![Custom Setup](https://i.imgur.com/rrBGHen.jpg)

4. Open-Shellをインストールします。終了ダイアログが表示されるので、**Finish**をクリックします

   ![Open-Shellセットアップ](https://i.imgur.com/GO8GBZS.jpg)

5. 以上でインストールは終了です。以後、**Windows**アイコンをクリックするとWindows 7スタイルのメニューを表示します。

   <sub>Windows 11ではアイコンをクリックしてもメニューは表示されません。**Windowsキー**を押下すると表示されます</sub>  



## Open-Shellのカスタマイズ

### Open-Shellをカスタマイズする



Open-ShellはOpen-Shell Menu settingsアプリでカスタマイズします。

次の手順で、Open-Shellをカスタマイズします。

1. スタートメニューから、**[Open-Shell Menu Setting]**を開きます。

   ![Settings for Open-Shell Menu](https://i.imgur.com/clJ0E71.jpg)

2. [Start Menu Styke]では、***[Windows 7 Style]***を選びます。同様に、[Replace Start Button]をチェックします。


3. 必要であれば、そのほかの項目も設定します。[Show all settings]をチェックすると、さらに細かい設定も出来ます


4. [OK]をクリックし、設定を**"Open-Shell Menu"**に適用します。



以上で、Open-Shellのカスタマイズは終了です。設定した項目は、XMLファイルとしてバックアップできます。

参考用に、自分の設定を下記に載せておきます。

[Menu-Settings.xml](https://gist.github.com/atsushifx/a58d47175ee91a0d9375b2ab179cd730)

<script src="https://gist.github.com/atsushifx/a58d47175ee91a0d9375b2ab179cd730.js"></script>

