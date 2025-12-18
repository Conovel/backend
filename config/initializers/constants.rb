# frozen_string_literal: true

# main sentence省略時の割合と記号
MAIN_SENTENCE_TRUNCATE_RATIO = 0.6
MAIN_SENTENCE_OMISSION_SUFFIX = '…（以下省略）'

# 投稿文字数上限の初期値
DEFAULT_MAX_SENTENCE_LENGTH = 100

# 新しいと見なされる期間（日数）
NEW_PERIOD_DAYS = 30 # 仮番号

# 表示用の匿名文字列（複数箇所で使うためここで一元定義）
ANONYMOUS_DISPLAY = '匿名'

# 評価が有名と見なされるための最小件数
FAMOUS_EVALUATION_THRESHOLD = 5 # 仮番号

# アイコン画像サイズ
PROFILE_ICON_IMAGE_SIZE = 112 # アイコンは56pxで表示したいがRetina対応で倍のサイズにした方が良い？

# タイムアウト時間（秒）
TIMEOUT_SECONDS = 5

# JWTの有効期間（時間）
JWT_EXPIRATION_HOURS = 1

# リフレッシュトークンの有効期間（日数）
REFRESH_TOKEN_EXPIRATION_DAYS = 30

# 利用規約の最新バージョン
LATEST_TERMS_VERSION = 1 # 必要に応じて更新
