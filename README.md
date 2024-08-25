# backend

## dockerで起動する場合

[environment](https://github.com/Conovel/environment)リポジトリのサブモジュールになっているのでenvironmentでDcokerを起動するとbackendも一緒に起動します

## 単独で使う場合

リモートからリポジトリをクローン
```
$ git clone https://github.com/Conovel/backend.git
```

※Windows環境だと改行コードが変換されてしまう可能性があります。その場合は`git clone`を実行する前に下記のコマンドを実行してください。
```
$ git config --global core.autocrlf input
```

### rubyのバージョン確認
```
$ ruby -v
```
- ない場合はrubyのインストールが必要
- nodeのバージョンは3.3.4想定（ない場合はrbenvでインストールと切り替えが必要）

### Bundlerのバージョン確認
```
$ bundler -v
```
ない場合はインストールが必要
```
$ gem install bundler -v 2.5.11
```

### mysqlのバージョン確認
```
$ mysql --v
```
- 必要なバージョン: 8.4.2
- ない場合はインストールが必要

### パッケージのインストール
```
$ bundle install
```
Gemfile.lockが生成される

### ローカルサーバー起動
```
$ rails server
```