# Neovim

**Plugins:**

- ctrlp
- nerdtree
- bufexplorer
- lightline
- vim-gitbranch
- ale
- lightline-ale
- completor
- tcomment
- vim-easymotion
- vim-yankstack
- ack
- vim-auto-save

**Mappings:**

```
- [n] <ld>[space]      => turn off search highlighting
- [n] <C-o>            => open a new line bellow, but don't change mode
- [n] <space>          => space on normal mode (usefull for rapid formating)
- [n] B                => Begining of the line (first char)
- [n] E                => End of line
- [n] <S>>> | <<       => indent | unindent

- [n] <C-S>t           => new tab
- [n] <S>arrows      => move to left/right tab

- [n] <C-S>arrows        => move to pane (corresponding to the arrow direction)
- [n] \w<arrows>       => move panel to other position
- [n] \ws | \wv        => open split pane (s=horiz, v=vert)

- [i] <tab>            => completor
- [n] <C-p>            => trigger ctrlP plugin (files fuzzy finder)
- [n|i] <leader>l      => ALE Linter Check
- [n|i|v] <leader>c    => tComment

- [n] \be              => open bufexplorer
- [n] \bs | \bv        => open bufexplorer on split pane (s=horiz, x=vert)

- [n] <ld><ld><motion> => fire easymotion for that motion (w, b, j, k, W, B)
- [n] <ld><ld>f<char>  => fire easymotion for that char

- [n] <ld>a            => Ack
- [n] <ld>p | P        => yankstack paste
```

**Features**

- autosave whenever you leave the insert mode
- lint when you save
- uses system clipboard

