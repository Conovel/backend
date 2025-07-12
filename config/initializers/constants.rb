# frozen_string_literal: true

# 投稿文字数上限の初期値
DEFAULT_MAX_SENTENCE_LENGTH = 100

# 新しいと見なされる期間（日数）
NEW_PERIOD_DAYS = 30 # 仮番号

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
