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

export PATH

# vcs_info で Git ブランチ名をプロンプト表示
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%F{215}[%b]%f'
precmd() { vcs_info }
setopt prompt_subst

# プロンプトの表示形式と色:
# - ローカル: user::cwd[branch]%
# - SSH時:   user@host::cwd[branch]%
if [[ -n "$SSH_CONNECTION" ]]; then
  export PS1='%F{208}%n%f%F{81}@%m%f%F{244}::%f%F{223}%1~%f${vcs_info_msg_0_}%F{82} %#%f '
else
  export PS1='%F{208}%n%f%F{244}::%f%F{223}%1~%f${vcs_info_msg_0_}%F{82} %#%f '
fi

# fzf のシェル連携（存在する場合のみ）
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi
