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

# fzf のシェル連携（存在する場合のみ）
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# プロンプトの表示形式と色
# - ローカル: user::cwd[branch]%
# - SSH時:   user@host::cwd[branch]%
if [[ -n "$SSH_CONNECTION" ]]; then
  export PS1='%F{208}%n%f%F{81}@%m%f%F{244}::%f%F{223}%1~%f${vcs_info_msg_0_}%F{82} %#%f '
else
  export PS1='%F{208}%n%f%F{244}::%f%F{223}%1~%f${vcs_info_msg_0_}%F{82} %#%f '
fi

# 右側プロンプトは使用しない
RPROMPT=''
RPS1=''

alias g='git'

alias git-prune-branches='git fetch --prune && git branch -vv | grep ": gone]" | awk "{print \$1}" | xargs git branch -D'

git-new-branch-from-default() {
  local default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
  git switch -c "$1" "origin/${default_branch}"
}

alias cl="claude"
alias cld="mkdir -p ~/claude_default_workspace && cd ~/claude_default_workspace && claude"

# `trash-cli` はkeg-onlyのため、`trash-put` を明示的にPATHに通す
alias trash-put='/usr/local/opt/trash-cli/bin/trash-put'
alias tr='trash-put'

# 端末固有の上書き設定があれば読み込む
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
