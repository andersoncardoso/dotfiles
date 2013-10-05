$current_dir = Dir.pwd

def home_dir(path)
  File.join(Dir.home, path)
end

namespace :install do
  task :vim do
    puts 'Installing Vim'
    sh "sudo apt-get install vim vim-gtk -y"
    sh "ln -s #{$current_dir}/vim/ ~/.vim"
    sh "ln -s ~/.vim/vimrc ~/.vimrc"
    sh "ln -s ~/.vim/gvimrc ~/.gvimrc"
  end

  task :zsh do
    puts 'Installing Zsh'
    sh "shudo apt-get install zsh -y"
    if File.exist? home_dir '.zshrc'
      sh "mv ~/.zshrc ~/.zshrc.orig"
    end
    sh "ln -s #{$current_dir}/zsh/ ~/.zsh"
    sh "ln -s ~/.zsh/zshrc ~/.zshrc"
    sh "chsh -s /bin/zsh"
  end

  task :bash do
    puts 'Installing Bashrc'
    if File.exist? home_dir '.bashrc'
      sh "cp ~/.bashrc ~/.bashrc.orig"
    end
    sh "cat #{$current_dir}/bash/bashrc >> ~/.bashrc"
  end

  task :fonts do
    puts 'Installing Fonts'
    sh "mkdir -p ~/.fonts"
    sh "cp #{$current_dir}/fonts/*.ttf ~/.fonts/"
    sh "sudo fc-cache -f -v"
  end

  task :git do
    sh "ln -s #{$current_dir}/gitconfig/gitconfig ~/.gitconfig"
    sh "ln -s #{$current_dir}/gitconfig/gitignore ~/.gitignore"
  end

  task :terminator do
    sh "sudo apt-get install terminator -y"
    sh 'mkdir -p ~/.config/terminator'
    sh "ln -s #{$current_dir}/terminator/config ~/.config/terminator/config"
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
    ].join(' ')
    sh "sudo apt-get install #{packages} -y"

    # fix ack
    if not File.exist?('/usr/bin/ack')
      sh "sudo ln -s /usr/bin/ack-grep /usr/bin/ack"
    end

  end

  task :st2 do
    puts "Install sublime-text2"

    sh "sudo apt-add-repository ppa:webupd8team/sublime-text-2"
    sh "sudo apt-get update"
    sh "sudo apt-get install sublime-text"
    sh "mkdir -p ~/.config/sublime-text-2/Packages/User/"
    sh "cp #{current_dir}/st2/Packages/User/Preferences.sublime-settings ~/.config/sublime-text-2/Packages/User/"
    sh "cp #{current_dir}/st2/Installed\ Packages/Package\ Control.sublime-settings ~/.config/sublime-text-2/Installed\ Packages/"
  end

  task :fish do
    puts "Install fish shell settings"
    sh "sudo apt-get install fish"
    sh "mkdir -p ~/.config/fish/"
    sh "ln -s #{current_dir}/fish/config.fish ~/.config/fish/config.fish"
    sh "ln -s #{current_dir}/fish/functions ~/.config/fish/functions"

    sh "git clone https://github.com/adambrenecki/virtualfish.git #{current_dir}/../virtualfish"
  end

  task :all => [:apt, :vim, :bash, :fonts, :git, :terminator, :firefox, :st2, :fish, :rvm ]
end
