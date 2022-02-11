extract() {
        for archive in $*; do
                if [ -f $archive ]; then
                        case $archive in
                        *.tar.bz2) tar xvjf $archive ;;
                        *.tar.gz) tar xvzf $archive ;;
                        *.tar.xz) tar xvf $archive ;;
                        *.bz2) bunzip2 $archive ;;
                        *.rar) rar x $archive ;;
                        *.gz) gunzip $archive ;;
                        *.tar) tar xvf $archive ;;
                        *.tbz2) tar xvjf $archive ;;
                        *.tgz) tar xvzf $archive ;;
                        *.zip) unzip $archive ;;
                        *.Z) uncompress $archive ;;
                        *.7z) 7z x $archive ;;
                        *) echo "don't know how to extract '$archive'..." ;;
                        esac
                else
                        echo "'$archive' is not a valid file!"
                fi
        done
}

# Git
alias ga="git add -A"
alias gc="git commit -m"
alias gam="git commit --amend --no-edit"
alias gac="git add -A && git commit -m"
alias grm="git rm -r --cached ."
alias gp="git push --tags"
alias gir="git rebase -i HEAD~15"

# List
alias l="ls -lAh"
alias cp="cp -r"
alias mk="mkdir -p"
alias rm="rm -rf --preserve-root"

# Apt-get
alias i="sudo apt-get install -y"
alias update="sudo apt-get update -y && sudo apt-get upgrade -y"

# Mamba
alias mi="mamba install -y -c conda-forge"
alias ma="mamba activate"
# Tmux
alias tm="tmux new -As"
alias tl="tmux ls"
alias tk="tmux kill-session -t"