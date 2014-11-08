def current_dir
  Dir.pwd
end

def home_dir(path)
  File.join(Dir.home, path)
end

def osx?
  require 'rbconfig'
  !!RbConfig::CONFIG['target_os'].match(/darwin/i)
end

namespace :install do
  task :vim do
    puts 'Configure Vim'
    sh "ln -s #{current_dir}/vim/ ~/.vim"
    sh "ln -s ~/.vim/vimrc ~/.vimrc"
    sh "ln -s ~/.vim/gvimrc ~/.gvimrc"
  end

  task :zsh do
    puts 'Configure Zsh'
    if File.exist? home_dir '.zshrc'
      sh "mv ~/.zshrc ~/.zshrc.orig"
    end
    sh "ln -s #{current_dir}/zsh/ ~/.zsh"
    sh "ln -s ~/.zsh/zshrc ~/.zshrc"
    sh "chsh -s /bin/zsh"
  end

  task :bash do
    puts 'Configure Bashrc'
    profile = osx? ? '.bash_profile' : '.bashrc'
    if File.exist? home_dir profile
      sh "cp ~/#{profile} ~/#{profile}.orig"
    end
    sh "cat #{current_dir}/bash/#{profile.gsub('.', '')} >> ~/#{profile}"
  end

  task :fonts do
    puts 'Install Fonts'
    sh "mkdir -p ~/.fonts"
    sh "cp #{current_dir}/fonts/*.ttf ~/.fonts/"
    sh "sudo fc-cache -f -v"
  end

  task :git do
    puts 'Configure git' 
    platform = osx? ? 'osx' : 'linux'
    sh "ln -s #{current_dir}/gitconfig/gitconfig_#{platform} ~/.gitconfig"
    sh "ln -s #{current_dir}/gitconfig/gitignore ~/.gitignore"
  end

  task :terminator do
    sh "sudo apt-get install terminator -y"
    sh 'mkdir -p ~/.config/terminator'
    sh "ln -s #{current_dir}/terminator/config ~/.config/terminator/config"
  end

  task :rvm do
    sh "curl -#L https://get.rvm.io | bash -s stable --autolibs=3 --ruby"
  end

  task :firefox do
    sh "sudo apt-add-repository ppa:mozillateam/firefox-next"
    sh "sudo apt-get update"
    sh "sudo apt-get upgrade"
  end

  task :apt do
    sh "sudo apt-get update"

    # install packages
    packages = [
      'git', 'vim', 'vim-gtk', 'ack-grep', 'npm',
      'python-dev', 'python-pip', 'curl', 'build-essential',
      'meld', 'chromium-browser', 'vlc', 'xclip',
    #   'zsh'
    ].join(' ')
    sh "sudo apt-get install #{packages} -y"

    # fix ack
    if not File.exist?('/usr/bin/ack')
      sh "sudo ln -s /usr/bin/ack-grep /usr/bin/ack"
    end

  end

  task :linux => [ :apt, :vim, :bash, :fonts, :git, :terminator, :firefox, :rvm ]
  task :osx   => [ :vim, :bash, :git]
end
