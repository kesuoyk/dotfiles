# vcs_info で Git ブランチ名をプロンプト表示
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%F{215}[%b]%f'
# macOS のダーク/ライトモードに応じてプロンプトの色を切り替える
# defaults read の呼び出しを3秒間キャッシュして負荷を軽減
zmodload zsh/datetime
_appearance_cache=''
_appearance_checked=0

_get_appearance() {
  local now=$EPOCHSECONDS
  if (( now - _appearance_checked >= 3 )); then
    _appearance_cache="$(defaults read -g AppleInterfaceStyle 2>/dev/null)"
    _appearance_checked=$now
  fi
}

# プロンプトの表示形式と色
# - ローカル: user::cwd[branch]%
# - SSH時:   user@host::cwd[branch]%
precmd() {
  vcs_info
  _get_appearance
  if [[ "$_appearance_cache" == "Dark" ]]; then
    local c_user='%F{208}' c_host='%F{81}' c_sep='%F{244}' c_cwd='%F{223}' c_prompt='%F{82}'
  else
    local c_user='%F{166}' c_host='%F{25}' c_sep='%F{240}' c_cwd='%F{130}' c_prompt='%F{22}'
  fi
  if [[ -n "$SSH_CONNECTION" ]]; then
    PS1="${c_user}%n%f${c_host}@%m%f${c_sep}::%f${c_cwd}%1~%f${vcs_info_msg_0_}${c_prompt} %#%f "
  else
    PS1="${c_user}%n%f${c_sep}::%f${c_cwd}%1~%f${vcs_info_msg_0_}${c_prompt} %#%f "
  fi
}
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
cld() { mkdir -p ~/claude_default_workspace && (cd ~/claude_default_workspace && claude "$@") }

# `trash-cli` はkeg-onlyのため、`trash-put` を明示的にPATHに通す
alias trash-put='/usr/local/opt/trash-cli/bin/trash-put'
alias tr='trash-put'

# 端末固有の上書き設定があれば読み込む
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
