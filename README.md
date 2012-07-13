Some dotfiles I use:

- dotvim - very simple vim configuration


###To install:

- dotvim

    cd ~
    cp -r /path/to/dotfiles/dotvim/ .vim
    ln -s ~/vim/vimrc ~/.vimrc
    ln -s ~/vim/gvimrc ~/.gvimrc

    for command-t:
        - command-t.vba is located on /dotvim/command-t/command-t.vba
	    - you will need ruby (and a VIM compiled with ruby support) and ruby-dev
	    - $ vim command-t.vba
        - Then run source the vimball to install it:
        :source %
        - Afterwards build the C extension:
        $ cd ~/.vim/ruby/command-t
	    $ ruby extconf.rb      #  (needs ruby-dev)
	    $ make
        - use with <leader>t (leader normally is **\** )

