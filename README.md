# backend

## dockerで起動する場合

[environment](https://github.com/Conovel/environment)リポジトリのサブモジュールになっているのでenvironmentでDcokerを起動するとbackendも一緒に起動します

## 単独で使う場合

リモートからリポジトリをクローン
```sh
$ git clone https://github.com/Conovel/backend.git
```

※Windows環境だと改行コードが変換されてしまう可能性があります。その場合は`git clone`を実行する前に下記のコマンドを実行してください。
```sh
$ git config --global core.autocrlf input
```

### rubyのバージョン確認
```sh
$ ruby -v
```
- ない場合はrubyのインストールが必要
- nodeのバージョンは3.3.4想定（ない場合はrbenvでインストールと切り替えが必要）

### Bundlerのバージョン確認
```sh
$ bundler -v
```
ない場合はインストールが必要
```sh
$ gem install bundler -v 2.5.11
```

### mysqlのバージョン確認
```sh
$ mysql --v
```
- 必要なバージョン: 8.4.2
- ない場合はインストールが必要

### パッケージのインストール
```sh
$ bundle install
```
Gemfile.lockが生成される

### ローカルサーバー起動
```sh
$ rails server
```

※データベースは外部のmysql環境のため、データベースにアクセスするためには[environment](https://github.com/Conovel/environment)でDockerを起動する必要があります。


### RuboCop

#### RuboCopの実行
RuboCopを実行して、コードのスタイルをチェックします。
```sh
$ bundle exec rubocop
```

#### RuboCopの自動修正
自動修正可能なスタイル違反を修正するには、以下のコマンドを実行します。
```sh
$ bundle exec rubocop -A
```