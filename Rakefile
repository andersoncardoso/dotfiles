# taks :default => :install:all

$current_dir = Dir.pwd

namespace :install do
    task :vim do
        puts 'Installing Vim configuration files'
        sh "ln -s #{$current_dir}/dotvim/ ~/.vim"
        sh "ln -s ~/.vim/vimrc ~/.vimrc"
        sh "ln -s ~/.vim/gvimrc ~/.gvimrc"

        # code linters
        sh "sudo npm install -g jshint jsonlint csslint coffee-script"
        sh "sudo pip install flake8"
    end

    task :zsh do
        puts 'Installing Zsh configuration files'
        sh "mv ~/.zshrc ~/.zshrc.orig"
        sh "ln -s #{$current_dir}/zsh/ ~/.zsh"
        sh "ln -s ~/.zsh/zshrc ~/.zshrc"
    end

    task :bash do
        puts 'Installing Bashrc'
        sh "mv ~/.bashrc ~/.bashrc.orig"
        sh "ln -s #{$current_dir}/bash/bashrc ~/.bashrc"
    end

    task :git do
        sh "ln -s #{$current_dir}/gitconfig/gitconfig ~/.gitconfig"
    end

    task :terminator do
        sh "ln -s #{$current_dir}/terminator/config ~/.config/terminator/config"
    end

    task :virtualenv do
        sh "sudo pip install virtualenvwrapper"
        sh "rm ~/.virtualenvs/postactivate ~/.virtualenvs/postdeactivate"
        sh "ln -s #{$current_dir}/virtualenvwrapper/postactivate ~/.virtualenvs/postactivate"
        sh "ln -s #{$current_dir}/virtualenvwrapper/postdeactivate ~/.virtualenvs/postdeactivate"
    end

    task :rvm do
        sh "curl -#L https://get.rvm.io | bash -s stable --autolibs=3 --ruby"
    end

    task :ubuntu do
        ppas = ['ppa:mozillateam/firefox-next', 'ppa:gnome3-team/gnome3']
        ppas.each do |ppa|
            sh "sudo apt-add-repository #{ppa}"
            sh "sudo apt-get update"
        end
        sh "sudo apt-get upgrade"

        # install packages
        packages = [
            'tree', 'git', 'vim', 'vim-gtk', 'terminator', 'ack-grep', 'npm',
            'python-dev', 'python-pip', 'zsh', 'curl', 'build-essential',
            'meld', 'chromium-bowser', 'vlc', 'gnome-shell', 'gnome-do',
            'gnome-tweak-tool'
        ].join(' ')
        sh "sudo apt-get install #{packages} -y"

        # fix ack
        sh "sudo ln -s /usr/bin/ack-grep /usr/bin/ack"
    end

    task :all => [:ubuntu, :bash, :zsh, :git, :rvm, :virtualenv, :vim,
                  :terminator,]
end
