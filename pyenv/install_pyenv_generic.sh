git clone git://github.com/andersoncardoso/pyenv.git ~/.pyenv
git clone git://github.com/andersoncardoso/pyenv-autoenv.git ~/.pyenv/plugins/pyenv-autoenv

SHELL_NAME=`basename $( ps h p $$ | awk '{ print $NF }' )`
if [ "$SHELL_NAME" = "zsh" ];then
    FNAME="$HOME/.zshrc"
else
    FNAME="$HOME/.bashrc"
fi

cat >> $FNAME << EOL
if [[ -d \$HOME/.pyenv ]]; then
    export PATH="\$HOME/.pyenv/bin:\$HOME/.pyenv/shims:\$PATH"
    eval "\$(pyenv init -)"
    pyenv rehash 2>/dev/null
    source ~/.pyenv/plugins/pyenv-autoenv/bin/pyenv-autoenv
fi

# virtualenvwrapper
export WORKON_HOME=\$HOME/.virtualenvs
source ~/.pyenv/versions/\$(pyenv global)/bin/virtualenvwrapper.sh
EOL

# source "$FNAME"
