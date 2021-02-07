---
title: "NAS: asustor nasにmariadbをインストールする"
emoji: "💻"
type: "tech" # tech: 技術記事
topics: ["NAS","開発環境","MsriaDB"]
published: false
---

## MariaDBとは

MariaDBはmysqlからf



## MariaDBのインストール、初期設定

1. Web上のAppCentralにアクセスします

   ![AppCentral](https://lh3.googleusercontent.com/pw/ACtC-3dQ0X5mzXPOTn6xP83RqP-ww6dofBiHPMGryWp7J31uAOZt2PMEEOSyWY-kdntuiVWgkGCuzpgj7enxqBk6u4MWT57UUWHvuYVhPQAvD_RO5vHKu_K7lIOGzOGLQuhrGtT6cS4MNwP-a16B2faCBQo0=w1025-h599-no?authuser=0)



2. AppCentralからMariaDBを探し、選択します。![MariaDBペーン](https://lh3.googleusercontent.com/pw/ACtC-3dRotF4_pvpo_mJfrqCdrYN6lM_98Yk-rvI_2dBdIHXhks-ntmL_ImNytX41sDBM7Imk6VS31DBD0GEBqBZZ5b3uEu2atwgKsTCoAtcKcfjzeW5zz197vbhbZkhZ4nZ94FMcDBpni5nZt-ikl2cTz8W=w1027-h600-no?authuser=0) 



3. MariaDBのインストールは終了です

   ![MariaDBペーン](https://lh3.googleusercontent.com/pw/ACtC-3ey8__4FjZZg9wrhJlJ5QDMDt68_dXQUV7rduInI6mfUlnmvfT2lYTgn8WGbZ4dkd4H_56SjGxZmYhBgG64LKQhDKdHrmOU2rPZ-MKIJDrFMvHHzP-WL_OrsPTGhx9djkHNQYYrHw-fGGCqvu659YM6=w1022-h599-no?authuser=0)
   
   
   
   ## MariaDBの起動/終了/再起動
   
   asustor nasでは、MariaDBの起動／終了をWeb上のAppCentralから行います。
   
   1. Web上のAppcentralにアクセスします![AppCentral](https://lh3.googleusercontent.com/pw/ACtC-3dQ0X5mzXPOTn6xP83RqP-ww6dofBiHPMGryWp7J31uAOZt2PMEEOSyWY-kdntuiVWgkGCuzpgj7enxqBk6u4MWT57UUWHvuYVhPQAvD_RO5vHKu_K7lIOGzOGLQuhrGtT6cS4MNwP-a16B2faCBQo0=w1025-h599-no?authuser=0)
   
   2. 左サイドメニューの[インストール済み]を選択し、[MariaDB]を開きます。
   
      ![MariaDB](https://lh3.googleusercontent.com/pw/ACtC-3dLFPvgun4wuo2Uxz4lSGGytv-_-8_07JriNIBNJP7R08y1BqUP32J5vZB0dU1ndSrC4K9HnwBoxuuLXhKuTxFVzGn1yggdvA5Jj25uNLO2bXQhyXA38aEVRGnVrjOCNG_GKkVnPCb-RDfPwgYm3Vwl=w1024-h604-no?authuser=0)
   
   3. [MariaDB]のロゴの下に、実行／終了スライドスイッチがあります。ここを使って、MariaDBを起動／停止します。
   
   4. MariaDBの再起動は、上記のスイッチを使います。MariaDBｂを終了後、再度MariaDBを実行することで再起動します。
   
      