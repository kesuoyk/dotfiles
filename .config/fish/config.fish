export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export DOCKER_CONTENT_TRUST=1

eval (/opt/homebrew/bin/brew shellenv)

set -x PATH ./vendor/bin $PATH

alias lla='ls -la'
alias python='python3'

alias d='docker'
alias dc='docker-compose'
alias dce='docker-compose exec'

alias g='git'
alias gco='git branch | fzf | xargs git checkout'
alias git-delete-merged-branch='git branch --merged | egrep -v "\*" | xargs git branch -d'

function fish_prompt --description 'Write out the prompt'
    printf '%s %s' (set_color green)(prompt_pwd) (set_color yellow)"(*´∀`) < "
end

# function hybrid_bindings --description "Vi-style bindings that inherit emacs-style bindings in all modes"
#     for mode in default insert visual
#         fish_default_key_bindings -M $mode
#     end
#     fish_vi_key_bindings --no-erase
# end
# set -g fish_key_bindings hybrid_bindings

function vagrant -d "Wrapper for vagrant command"
    switch $argv[1]
        case 'ssh'
            ~/bin/vagrant-ssh-with-changing-profile.sh
        case '*'
            command vagrant $argv
     end
end

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
