## Install

curl https://raw.github.com/andersoncardoso/dotfiles/master/pyenv/install_pyenv.sh | sh

### manually:

- git clone pyenv

- git clone pyenv-autoenv

- add these lines to your .bashrc or .zshrc:

```
    if [[ -d $HOME/.pyenv ]];then
        export PATH="$HOME/.pyenv/bin:$PATH"
        eval "$(pyenv init -)"
        source ~/.pyenv/plugins/pyenv-autoenv/bin/pyenv-autoenv
    fi
```

### Usage

see: https://github.com/yyuu/pyenv

and: https://github.com/andersoncardoso/pyenv-autoenv

