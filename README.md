Some dotfiles I use:

- dotvim - my vim configuration and plugins
- bash - some simple bashrc modifications and aliases
- zsh - configuration for the zshell
- gitconfig - my gitconfig file


##To install:

#### dotvim

```
    cd ~
    cp -r /path/to/dotfiles/dotvim/ .vim
    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/gvimrc ~/.gvimrc
```
  done, pathogen takes care of the plugins

#### bash

#### zsh

#### gitconfig

##Dotvim Usage:

**Plugins:**

- pathogen
- ctrlP
- nerdTree
- tComment
- Syntastic
- supertab
- simple-pairs
- buferexplorer
- sparkup


####Mappings:

```
- [n] <F3>            => toggle search highlighting
- [n] <C-o>           => open a new line bellow, but don't change mode
- [n] <space>         => space on normal mode (usefull for rapid formating)
- [n] <Shift>arrows   => move to pane (corresponding to the arrow direction)
- [n] <Ctrl>t         => new tab
- [n] <Ctrl>arrows    => move to left/right tab
- [n] \w<arrows>      => move panel to other position
- [n] <C-p>           => trigger ctrlP plugin (files fuzzy finder)
- [n|i] <leader>s     => SyntasticCheck
- [n|i|v] <leader>c   => tComment
- [n] \be             => open bufexplorer
- [n] \bs | \bx       => open bufexplorer on split pane (s=horiz, x=vert)
- [i] <Ctrl>e         => trigger sparkup (zen-condig)
```

OBS:
- () [] {} "" ''  => all auto close
- all yanks and pastes work with the system clipboard


####Sparkup:

```
- [i] [sequence]<C-e> => trigger the expansion
ex:
  div#header > span.title + img.logo < +div#content <C-e>
  expands to:

  <div id="header">
      <span class="title"></span>
      <img src="" alt="" class="logo" />
  </div>
  <div id="content"></div>
```

####Syntastic:

```
Use <leader>s to trigger Syntastic check.
Also runs automatically when the file opens or when the buffer is saved.

need external libraries:

    javascript -> JsHint   :  npm install jshint
    python     -> flake8   :  pip install flake8
    json       -> jsonlint :  npm install jsonlint
    csslint    -> csslint  :  npm install csslint
    coffee     -> coffee   :  npm install coffee-script
```


####BufferExplore:

```
<leader>be      -> open buffer explore
<leader>bs      -> horizontal split open
<leader>bv      -> vertical split open
```

####Observations:

On vim, inverting the ESC and CapsLock it's a good idea.
If you are using some Gnome-based UI:
system preferences > keyboard > layout > option > "CapsLock key behavior"
and click on the option "Swap ESC and CapsLock"


