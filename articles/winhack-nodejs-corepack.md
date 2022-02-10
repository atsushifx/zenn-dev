---
title: "nodejs : Windowsでcorepackを使う"
emoji: "💭"
type: "tech"
topics: ["Windows", "nodejs", "npm", "corepack"]
published: false
---

## tl;dr

- [corepack でモジュールごとに npm クライアントを指定する](https://zenn.dev/mizchi/articles/use-corepack)を読んだので、Windows 上で試してみました。
- 基本、上記の記事のままで問題ありません。Windows にあわせて、いくつか環境設定を変更します。

## corepackを使う

### 環境変数の設定

デフォルトでは、corepack 管理下のパッケージマネージャーは`$HOME/.node/corepack`下に配置されます。そこで、環境変数 COREPACK_HOME にディレクトリを設定します。

``` powershell
  COREPACK_HOME=%USERPROFILE%/app/corepack
```

### corepackを使う

``` powershell
# Windowsでは、nodeのインストールにscoopを使う
> scoop install nodejs

# 既存のパッケージマネージャーをuninstall
> npm uninstall -g npm pnpm yarn

# corepack で各パッケージマネージャをenable
> corepack enable npm pnpm yarn

# yarnをバージョンアップする
> corepack prepare  yarn@3.1.1

# yarn -v
3.1.1
```

これで、corepack 管理下で`npm`や`yarn`が使えます。

後は、元記事のように`package.json`に`packageManager`の記述を書けば OK です。

例えば、zenn-cli 用だと次のようになります。

``` package.json
{
  "name": "zenn-cli",
  "description": "artcles, books manager for zenn.dev with github",
  "author": "Furukawa, Atsushi <atsushifx@gmail.com>",
  "packageManager": "pnpm@6.30.0",
  "version": "1.0.0",
  "license": "MIT",
  "dependencies": {
    "zenn-cli": "^0.1.106"
  }
}
```

## さいごに

`npm`以外の`pnpm`や`yarn`を使いこなすには、それぞれの設定をする必要があります。
とりあえずは、これで使えるようになります。

それでは、happy hacking。
