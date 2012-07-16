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

**Plugins:**

- pathogen
- ack
- ctrlP
- surround
- snipMate
- snipmate-snippets
- fugitive
- sparkup
- tComment
- Syntastic


####Mappings:

```
- [n] <F3>           => toggle serach highlighting
- [v] <Tab>          => indent block
- [v] <S-Tab>        => unindent block
- [n] <leader>p      => paste from OS clipboard
- [v] <leader>y      => yank to OS clipboard
- [i] <C-space>      => autocomplete
- [n] <C-o>          => open a new line bellow, but don't change mode (keep in normal)
- [i] ( { [ " '      => they all auto closes.
- [n] <Alt>arrows    => move to pane (corresponding to the arrow direction)
```

####Usefull:

```
- :Ack _search_term_  => search _search_term_  through code base
- [n] <C-p>           => trigger ctrlP plugin (files fuzzy finder)
- :Git                => runs git commands inside vim
- [n|i] <leader>s     => SyntasticCheck
- [n|i|v] <leader>c   => tComment
```


####Surround:

```
- [v] [select]S[surround]
ex: hello world!  -> v2wS"  -> "hello world!"
- [i] <C-o>v[select]S[surround]   => <C-o>v on i mode enter in visual i mode.
- [n] csw'            => he*llo -> 'he*llo'
- [n] cst<pre>        => <span>hello</span> -> <pre>hello</pre>
- [n] dst             => <pre>hello</pre> -> hello
```

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
He will automatically run when file opens or when the buffer it saved.

need external libraries:

    javascript -> JsHint   :  npm install jshint
    python     -> flake8   :  pip install flake8
    json       -> jsonlint :  npm install jsonlint
    csslint    -> csslint  :  npm install csslint
    coffee     -> coffee   :  npm install coffee-script
```



####Observations:

I invert <ESC> and <CapsLock> keys. I find easier since in vim we have to hit
<ESC> all the time. If using Gnome (some GNU/linux or *BSD) go to:
system preferences > keyboard > layout > option > "CapsLock key behavior"
and click on the option "Swap ESC and CapsLock"


