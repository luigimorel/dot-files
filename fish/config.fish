if status is-interactive
    # Interactive-only commands
end

# Aliases
alias vim nvim
alias v nvim

# pipx
set -gx PATH $PATH /home/morel/.local/bin

# pnpm
set -gx PNPM_HOME "/home/morel/.local/share/pnpm"
if not contains $PNPM_HOME $PATH
    set -gx PATH $PNPM_HOME $PATH
end

# rbenv
status --is-interactive; and rbenv init - | source

set -g fish_greeting ""

# ZVM
set -gx ZVM_INSTALL "$HOME/.zvm/self"
set -gx PATH $PATH "$HOME/.zvm/bin"
set -gx PATH $PATH "$ZVM_INSTALL/"
scheme set dracula
