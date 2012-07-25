" Generated by Color Theme Generator at Sweyla
" http://themes.sweyla.com/seed/934648/

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

" Set environment to 256 colours
set t_Co=256

let colors_name = "sweyla934648"

if version >= 700
  hi CursorLine     guibg=#000000 ctermbg=16
  hi CursorColumn   guibg=#000000 ctermbg=16
  hi MatchParen     guifg=#90FF9E guibg=#000000 gui=bold ctermfg=121 ctermbg=16 cterm=bold
  hi Pmenu          guifg=#FFFFFF guibg=#323232 ctermfg=255 ctermbg=236
  hi PmenuSel       guifg=#FFFFFF guibg=#6E986D ctermfg=255 ctermbg=65
endif

" Background and menu colors
hi Cursor           guifg=NONE guibg=#FFFFFF ctermbg=255 gui=none
hi Normal           guifg=#FFFFFF guibg=#000000 gui=none ctermfg=255 ctermbg=16 cterm=none
hi NonText          guifg=#FFFFFF guibg=#0F0F0F gui=none ctermfg=255 ctermbg=233 cterm=none
hi LineNr           guifg=#FFFFFF guibg=#191919 gui=none ctermfg=255 ctermbg=234 cterm=none
hi StatusLine       guifg=#FFFFFF guibg=#161E15 gui=italic ctermfg=255 ctermbg=234 cterm=italic
hi StatusLineNC     guifg=#FFFFFF guibg=#282828 gui=none ctermfg=255 ctermbg=235 cterm=none
hi VertSplit        guifg=#FFFFFF guibg=#191919 gui=none ctermfg=255 ctermbg=234 cterm=none
hi Folded           guifg=#FFFFFF guibg=#000000 gui=none ctermfg=255 ctermbg=16 cterm=none
hi Title            guifg=#6E986D guibg=NONE	gui=bold ctermfg=65 ctermbg=NONE cterm=bold
hi Visual           guifg=#878FB1 guibg=#323232 gui=none ctermfg=103 ctermbg=236 cterm=none
hi SpecialKey       guifg=#B084FF guibg=#0F0F0F gui=none ctermfg=141 ctermbg=233 cterm=none
"hi DiffChange       guibg=#4C4C00 gui=none ctermbg=58 cterm=none
"hi DiffAdd          guibg=#25254C gui=none ctermbg=235 cterm=none
"hi DiffText         guibg=#663266 gui=none ctermbg=241 cterm=none
"hi DiffDelete       guibg=#3F0000 gui=none ctermbg=52 cterm=none
 
hi DiffChange       guibg=#4C4C09 gui=none ctermbg=234 cterm=none
hi DiffAdd          guibg=#252556 gui=none ctermbg=17 cterm=none
hi DiffText         guibg=#66326E gui=none ctermbg=22 cterm=none
hi DiffDelete       guibg=#3F000A gui=none ctermbg=0 ctermfg=196 cterm=none
hi TabLineFill      guibg=#5E5E5E gui=none ctermbg=235 ctermfg=228 cterm=none
hi TabLineSel       guifg=#FFFFD7 gui=bold ctermfg=230 cterm=bold


" Syntax highlighting
hi Comment guifg=#6E986D gui=none ctermfg=65 cterm=none
hi Constant guifg=#B084FF gui=none ctermfg=141 cterm=none
hi Number guifg=#B084FF gui=none ctermfg=141 cterm=none
hi Identifier guifg=#ADFFFF gui=none ctermfg=159 cterm=none
hi Statement guifg=#90FF9E gui=none ctermfg=121 cterm=none
hi Function guifg=#8389B9 gui=none ctermfg=103 cterm=none
hi Special guifg=#C8FFFF gui=none ctermfg=195 cterm=none
hi PreProc guifg=#C8FFFF gui=none ctermfg=195 cterm=none
hi Keyword guifg=#90FF9E gui=none ctermfg=121 cterm=none
hi String guifg=#878FB1 gui=none ctermfg=103 cterm=none
hi Type guifg=#95FFF2 gui=none ctermfg=123 cterm=none
hi pythonBuiltin guifg=#ADFFFF gui=none ctermfg=159 cterm=none
hi TabLineFill guifg=#363946 gui=none ctermfg=237 cterm=none
