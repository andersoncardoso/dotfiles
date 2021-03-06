#!/usr/bin/env ruby

require 'optparse'

def current_dir
  Dir.pwd
end

def home_dir(path)
  File.join(Dir.home, path)
end

def osx?
  require 'rbconfig'
  RbConfig::CONFIG['target_os'].match(/darwin/i)
end

def setup_neovim
  puts 'Configure neovim'
  # `brew install nvim`
  `mkdir -p ~/.config/nvim/{autoload,plugged}`
  `curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`
  # `brew install python`
  # `brew install python@2`
  # `pip3 install --user neovim jedi psutil setproctitle`
  # `gem install neovim`
  # `npm install -g neovim`
  #
  # `gem install rubocop`
  # `npm install -g eslint sass-lint`
  `ln -s #{current_dir}/neovim/init.vim ~/.config/nvim/init.vim`
end

def setup_zsh
  puts 'Configure Zsh'
  `brew install zsh`
  `mv ~/.zshrc ~/.zshrc.orig' if File.exist?(home_dir('.zshrc')`
  `ln -s #{current_dir}/zsh/ ~/.zsh`
  `ln -s ~/.zsh/zshrc ~/.zshrc`
  # `chsh -s /bin/zsh`
end

def setup_bash
  puts 'Configure Bashrc'
  profile = osx? ? '.bash_profile' : '.bashrc'
  `cp ~/#{profile} ~/#{profile}.orig" if File.exist?(home_dir(profile)`
  `mkdir -p ~/bin`
  `cp #{current_dir}/bash/vcprompt ~/bin/vcprompt`
  `chmod 755 ~/bin/vcprompt`
  `cat #{current_dir}/bash/#{profile.delete('.')} >> ~/#{profile}`
end

def setup_git
  puts 'Configure git'
  `ln -s #{current_dir}/gitconfig/gitconfig ~/.gitconfig`
  `ln -s #{current_dir}/gitconfig/gitignore ~/.gitignore`
end

def setup_terminator
  `mkdir -p ~/.config/terminator`
  `ln -s #{current_dir}/terminator/config ~/.config/terminator/config`
end

def setup_tilix
  `dconf load /com/gexperts/Terminix/ < tilix.dconf`
end

OptionParser.new do |opts|
  opts.banner = 'Usage: setup [options]'
  opts.on('--neovim', 'Neovim config') { setup_neovim }
  opts.on('--git', 'Gitconfig') { setup_git }
  opts.on('--zsh', 'Zsh config') { setup_zsh }
  opts.on('--bash', 'Bash config') { setup_bash }
  opts.on('--term', 'Terminator config') { setup_terminator }
  opts.on('--tilix', 'Tilix config') { setup_tilix }
  opts.on('--all', 'All configs') do
    setup_bash
    setup_git
    setup_neovim
  end
end.parse!
