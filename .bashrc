alias dmgo='docker-machine start'
alias dmend='docker-machine stop'
alias fiitlog='ssh -c aes192-cbc -oHostKeyAlgorithms=ssh-dss holy17@student.fiit.stuba.sk'
alias winbash='/c/windows/System32/bash.exe'

# Workaround for setting the right shell for nvim.
# https://github.com/neovim/neovim/issues/14605
alias nvim-qt='SHELL="winpty nvim" nvim-qt'
alias nvim='SHELL="winpty nvim" nvim'
