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
  sh 'brew install nvim'
  sh 'mkdir -p ~/.config/nvim/{autoload,plugged}'
  sh 'curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  sh 'brew install python'
  sh 'brew install python@2'
  sh 'pip3 install --user neovim jedi psutil setproctitle'
  sh 'gem install neovim'
  sh 'npm install -g neovim'
  sh "ln -s #{current_dir}/neovim/init.vim ~/.config/nvim/init.vim"
end

def setup_zsh
  puts 'Configure Zsh'
  sh 'mv ~/.zshrc ~/.zshrc.orig' if File.exist?(home_dir('.zshrc'))
  sh "ln -s #{current_dir}/zsh/ ~/.zsh"
  sh 'ln -s ~/.zsh/zshrc ~/.zshrc'
  sh 'chsh -s /bin/zsh'
end

def setup_bash
  puts 'Configure Bashrc'
  profile = osx? ? '.bash_profile' : '.bashrc'
  sh "cp ~/#{profile} ~/#{profile}.orig" if File.exist?(home_dir(profile))
  sh 'mkdir -p ~/bin'
  sh "cp #{current_dir}/bash/vcprompt ~/bin/vcprompt"
  sh 'chmod 755 ~/bin/vcprompt'
  sh "cat #{current_dir}/bash/#{profile.delete('.')} >> ~/#{profile}"
end

def setup_git
  puts 'Configure git'
  platform = osx? ? 'osx' : 'linux'
  sh "ln -s #{current_dir}/gitconfig/gitconfig_#{platform} ~/.gitconfig"
  sh "ln -s #{current_dir}/gitconfig/gitignore ~/.gitignore"
end

OptionParser.new do |opts|
  opts.banner = 'Usage: setup [options]'
  opts.on('--neovim', 'Neovim config') { setup_neovim }
  opts.on('--git', 'Gitconfig') { setup_git }
  opts.on('--zsh', 'Zsh config') { setup_zsh }
  opts.on('--bash', 'Bash config') { setup_bash }
  opts.on('--all', 'All configs') do
    setup_bash
    setup_zsh
    setup_git
    setup_neovim
  end
end.parse!
