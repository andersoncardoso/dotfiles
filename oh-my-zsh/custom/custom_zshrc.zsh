# Add yourself some shortcuts to projects you often work on
# Example:
#
# brainstormr=/Users/robbyrussell/Projects/development/planetargon/brainstormr
#
alias l='ls -F'
alias ll='ls -lah'
alias t='tree'
alias g='git'
alias s='svn'

alias wk="workon "

function killalltasks {
    KAT_TMP=`ps -eo pid,args | ack $1 | ack -v ack`
    echo $KAT_TMP
    echo $KAT_TMP | cut -c1-6 | xargs kill
}

# apt-get aliases
alias ag="sudo apt-get "
alias agi="sudo apt-get install -y "
alias agr="sudo apt-get remove "
alias as="apt-cache search "

# clipboard handling
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'


