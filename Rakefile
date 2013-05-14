# taks :default => :install:all

$current_dir = Dir.pwd

def home_dir(path)
  File.join(Dir.home, path)
end

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
    if File.exist? home_dir '.zshrc'
      sh "mv ~/.zshrc ~/.zshrc.orig"
    end
    sh "ln -s #{$current_dir}/zsh/ ~/.zsh"
    sh "ln -s ~/.zsh/zshrc ~/.zshrc"
    sh "chsh -s /bin/zsh"
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
    if not File.exist? home_dir ".config/terminator"
      sh 'mkdir ~/.config/terminator'
    end
    sh "ln -s #{$current_dir}/terminator/config ~/.config/terminator/config"
  end

  task :virtualenv do
    sh "sudo pip install virtualenvwrapper"
    if File.exist? home_dir ".virtualenvs"
      sh "rm ~/.virtualenvs/postactivate ~/.virtualenvs/postdeactivate"
    else
      sh "mkdir ~/.virtualenvs"
    end
    sh "ln -s #{$current_dir}/virtualenvwrapper/postactivate ~/.virtualenvs/postactivate"
    sh "ln -s #{$current_dir}/virtualenvwrapper/postdeactivate ~/.virtualenvs/postdeactivate"
  end

  task :rvm do
    sh "curl -#L https://get.rvm.io | bash -s stable --autolibs=3 --ruby"
  end

  task :gnome_shell do
    sh "sudo apt-add-repository ppa:gnome3-team/gnome3"
    sh "sudo apt-get upgrade"
    sh "sudo apt-get install gnome-shell gnome-tweak-tool -y"
  end

  task :themes do
    sh "sudo cp -r #{$current_dir}/themes/* /usr/share/themes/"
    sh "cp -r #{$current_dir}/gnome-shell/* ~/.local/share/gnome-shell/extensions/"
  end

  task :ubuntu do
    sh "sudo apt-add-repository ppa:mozillateam/firefox-next"
    sh "sudo apt-get update"
    sh "sudo apt-get upgrade"

    # install packages
    packages = [
      'tree', 'git', 'vim', 'vim-gtk', 'terminator', 'ack-grep', 'npm',
      'python-dev', 'python-pip', 'zsh', 'curl', 'build-essential',
      'meld', 'chromium-browser', 'vlc', 'gnome-do', 'xclip',
    ].join(' ')
    sh "sudo apt-get install #{packages} -y"

    # fix ack
    if not File.exist?('/usr/bin/ack')
      sh "sudo ln -s /usr/bin/ack-grep /usr/bin/ack"
    end

  end

  task :all => [:ubuntu, :bash, :zsh, :git, :rvm, :virtualenv, :vim,
                :terminator,]
end
