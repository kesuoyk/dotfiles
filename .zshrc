# vcs_info で Git ブランチ名をプロンプト表示
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%F{215}[%b]%f'
precmd() { vcs_info }
setopt prompt_subst

# zsh 補完の有効化と補完体験の改善
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload -Uz bashcompinit
bashcompinit

# git ショートカット
alias g='git'

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

# 右側プロンプトは使用しない
RPROMPT=''
RPS1=''

# .zshrc.local が存在する場合は読み込む
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# trash-cli is keg-only; expose trash-put explicitly.
alias trash-put='/usr/local/opt/trash-cli/bin/trash-put'
alias tr='trash-put'
