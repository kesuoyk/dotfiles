# ログインシェルでは Apple Silicon 側の Homebrew を優先する。
eval "$(/opt/homebrew/bin/brew shellenv)"

# PATH設定:
# - ~/.local/bin と Homebrew を優先
# - 既存PATHは保持
# - npm global bin は存在時のみ末尾追加
typeset -U path
path=(
  "$HOME/.local/bin"
  /opt/homebrew/bin
  "$path[@]"
)

if command -v npm >/dev/null 2>&1; then
  path+=("$(npm prefix --location=global)/bin")
fi

# keg-only な trash-cli のコマンドを PATH に通す。
[[ -d /usr/local/opt/trash-cli/bin ]] && path=(/usr/local/opt/trash-cli/bin "$path[@]")
[[ -d /opt/homebrew/opt/trash-cli/bin ]] && path=(/opt/homebrew/opt/trash-cli/bin "$path[@]")

export PATH

# 端末固有の上書き設定があれば読み込む。
[ -f ~/.zprofile.local ] && source ~/.zprofile.local
