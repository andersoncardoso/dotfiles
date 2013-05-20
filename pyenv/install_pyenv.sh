git clone git@github.com:andersoncardoso/pyenv.git ~/.pyenv
git clone git@github.com:andersoncardoso/pyenv-autoenv.git ~/.pyenv/plugins/pyenv-autoenv

SHELL_NAME=`basename $( ps h p $$ | awk '{ print $NF }' )`
if [ "$SHELL_NAME" = "zsh" ];then
    FNAME="$HOME/.zshrc"
else
    FNAME="$HOME/.bashrc"
fi

echo "Adding settings to $FNAME"
echo "" >> $FNAME
echo "# settings up PYENV" >> $FNAME
echo "if [[ -d \$HOME/.pyenv ]];then" >> $FNAME
echo "    export PATH=\"\$HOME/.pyenv/bin:\$PATH\"" >> $FNAME
echo "    eval \"\$(pyenv init -)\"" >> $FNAME
echo "    source ~/.pyenv/plugins/pyenv-autoenv/bin/pyenv-autoenv" >> $FNAME
echo "fi" >> $FNAME
