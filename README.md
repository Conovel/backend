# backend

## dockerで起動する場合

[environment](https://github.com/Conovel/environment)リポジトリのサブモジュールになっているのでenvironmentでDcokerを起動するとfrontendも一緒に起動します

## 単独で使う場合

リモートからリポジトリをクローン
```
$ git clone https://github.com/Conovel/backend.git
```

### rubyのバージョン確認
```
$ ruby -v
```
必要なバージョン: 3.3.4
（ない場合はrbenvでインストールと切り替えが必要）

### Bundlerのバージョン確認
```
$ bundler -v
```
（ない場合はインストール必要）
```
$ gem install bundler -v 2.5.11
```

### mysqlのバージョン確認
```
$ mysql --v
```
必要なバージョン: 8.4.2
（ない場合はインストール必要）

### パッケージのインストール
```
$ bundle install
```
Gemfile.lockが生成される

### ローカルサーバー起動
```
$ rails server
```

----

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
