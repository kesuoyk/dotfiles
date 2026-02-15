export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:/opt/homebrew/bin
export PATH=$PATH:`npm prefix --location=global`/bin

autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%F{215}[%b]%f'
precmd() { vcs_info }
setopt prompt_subst

if [[ -n "$SSH_CONNECTION" ]]; then
  export PS1='%F{208}%n%f%F{81}@%m%f%F{244}::%f%F{223}%1~%f${vcs_info_msg_0_}%F{82} %#%f '
else
  export PS1='%F{208}%n%f%F{244}::%f%F{223}%1~%f${vcs_info_msg_0_}%F{82} %#%f '
fi
