Some dotfiles I use:

- dotvim - my vim configuration and plugins


##To install:

#### dotvim

```
    cd ~
    cp -r /path/to/dotfiles/dotvim/ .vim
    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/gvimrc ~/.gvimrc
```
  done, pathogen takes care of the plugins

  Obs: for ack.vim in ubuntu you need to link ack -> ack-grep


##Dotvim Usage:

####Mappings:

```
- [n] <F3>       => toggle serach highlighting
- [v] <Tab>      => indent block
- [v] <S-Tab>    => unindent block
- [n] <leader>p  => paste from OS clipboard
- [v] <leader>y  => yank to OS clipboard
- [i] <C-space>  => autocomplete
- [i] <C-o>      => on insert mode open a new line bellow and send the carret there
```

####Usefull:

```
- :Ack _search_term_  => search _search_term_  through code base
- <C-p>               => trigger ctrlP plugin (files fuzzy finder)
```

####RagTag:

```
- [i] div<C-x><space>  => <div> ^ </div>
- [i] div<C-x><CR>     => <div>\n ^ \n</div>
- [i] <C-x>/           => close tag
- [i] <C-x>@           => link tag (css)
- [i] <C-x>$           => script tag (js)
```

