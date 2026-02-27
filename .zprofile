# ログインシェルでは Apple Silicon 側の Homebrew を優先する。
eval "$(/opt/homebrew/bin/brew shellenv)"

# 端末固有の上書き設定があれば読み込む。
[ -f ~/.zprofile.local ] && source ~/.zprofile.local
