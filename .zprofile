# Homebrew のパスを通す
eval "$(/opt/homebrew/bin/brew shellenv)"

# mise のパスを通す
eval "$(mise activate zsh)"

# mise の shims をパスに追加 (Neovim など非対話的に起動されたプロセスでも
# プロジェクトの .ruby-version / .mise.toml に沿った Ruby などを解決できるようにする)
[[ -d "$HOME/.local/share/mise/shims" ]] && path=("$HOME/.local/share/mise/shims" "$path[@]")

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PATH:$PNPM_HOME/bin" ;;
esac

# 端末固有の上書き設定があれば読み込む
[ -f ~/.zprofile.local ] && source ~/.zprofile.local
