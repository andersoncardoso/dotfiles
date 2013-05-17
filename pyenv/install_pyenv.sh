cd
git clone git@github.com:andersoncardoso/pyenv.git .pyenv

echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.zshrc

echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

cp ./virtualenv-auto-activate.sh ~/.pyenv/bin/
echo 'source ~/.pyenv/bin/virtualenv-auto-activate.sh' >> ~/.zshrc

