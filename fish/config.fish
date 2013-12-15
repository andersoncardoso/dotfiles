set -U EDITOR vim

set -x CODE_PATH ~/Projects

set -x PATH $HOME/bin $HOME/.rvm/bin $CODE_PATH/elixir/bin $PATH

# virtualenvwrapper
. $CODE_PATH/virtualfish/virtual.fish
. $CODE_PATH/virtualfish/global_requirements.fish
