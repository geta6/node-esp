# ESP

Express + Sequelize + Passport


## About

独自のログイン認証機能を持った何かを製作するテンプレートです。

相当部分を`passport-*`に差し替えれば認証機構は外部化可能です。

DB情報に関しては`config/`以下を参照してください。

ルーターが肥大化したら適宜外部化してください。


## Requirements

* node.js
* MySQL
* MongoDB


## Dependencies

* express
* connect-flash
* connect-assets
* connect-mongo
* sequelize
* consolable
* passport
* passport-local
* coffee-script
* stylus
* nib
* jade


## Scripts

Start Server:

```
npm start
```


## Features

* assets enabled
* logger enabled


## Assets

* See [TrevorBurnham/connect-assets](https://github.com/TrevorBurnham/connect-assets)

