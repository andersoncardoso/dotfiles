# taks :default => :install:all

namespace :install do
    task :vim do
        puts 'Installing Vim configuration files'
        current_dir = Dir.pwd
        sh "ln -s #{current_dir}/dotvim/ ~/.vim"
        sh "ln -s ~/.vim/vimrc ~/.vimrc"
        sh "ln -s ~/.vim/gvimrc ~/.gvimrc"
    end

    task :zsh do
        puts 'Installing Zsh configuration files'
        current_dir = Dir.pwd
        sh "ln -s #{current_dir}/zsh/ ~/.zsh"
        sh "ln -s ~/.zsh/zshrc ~/.zshrc"
    end

    task :bash do
        puts 'hi from bash task'
    end

    task :all => [:bash, :zsh, :vim]
end
