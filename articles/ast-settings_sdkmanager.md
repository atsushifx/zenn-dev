---
title: "Android Studio: SDK Managerを設定する"
emoji: "📱"
type: "tech" 
topics: ["Android", "AndroidStudio",  "環境構築",]
published: false

---

## はじめに

`Android Studio`には`SDK Manager`が組み込まれています。これを使うことで、Android の複数の環境に簡単に対応できます。

## SDK Managerの使い方

### SDK Managerの起動

次の手順で、SDK Manager を起動します。

1. `Android Studio`を起動します
  ![Android Studio](https://i.imgur.com/PaHfB84.jpg)

1. 起動画面から、[More Actions]-[SDK Manager]とし、`SDK Manager`を起動します
  ![Android SDK](https://i.imgur.com/wgmqBmR.jpg)

以上で、`SDK Manager`の起動は終了です。

### Android SDK Locationの設定

次の手順で、`Android SDK`を配置するフォルダを設定します。

1. [System Settings - Android SDK]画面で[Edit]をクリックします
  ![Android SDK](https://i.imgur.com/wgmqBmR.jpg)

1. [SDK Setup]画面が表示されます。[Android SDK Location]が環境変数"`Android_SDK_ROOT`"と違うので、変更します
  ![SDK Setup](https://i.imgur.com/0Nhksru.jpg)

1. コンポーネントをダウンロードします
  ![Download](https://i.imgur.com/DbS2fwM.jpg)

1. [OK]をクリックし、起動画面に戻ります
  ![Android Studio](https://i.imgur.com/PaHfB84.jpg)

以上で、Android SDK Location の設定は終了です。
