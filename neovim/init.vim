" Neovim config.
" Copy or symlink to ~/.config/nvim/init.vim

call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/seoul256.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'morhetz/gruvbox'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'vim-scripts/bufexplorer.zip'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'w0rp/ale'
Plug 'maximbaz/lightline-ale'
Plug 'tomtom/tcomment_vim'
Plug 'easymotion/vim-easymotion'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'mileszs/ack.vim'
Plug 'vim-scripts/vim-auto-save'
Plug 'zah/nim.vim'  " Nim syntax
Plug 'rhysd/vim-crystal'  " Crystal syntax
Plug 'Quramy/tsuquyomi'  " Typescript syntax and completion
call plug#end()

syntax enable                     " enable syntax processing

filetype plugin on                " turn on file type detection
filetype indent on                " load filetype-specific indent files

set showcmd                       " Display incomplete commands.
set noshowmode                    " Display the mode you're in.

set backspace=indent,eol,start    " Intuitive backspacing.

set hidden                        " Handle multiple buffers better.

set wildmenu                      " Enhanced command line completion.
set wildmode=list:longest         " Complete files like a shell.

set ignorecase                    " Case-insensitive searching.
set smartcase                     " But case-sensitive if expression contains a capital letter.

set number                        " Show line numbers.
set ruler                         " Show cursor position.
set nofoldenable                  " disable folding

set incsearch                     " Highlight matches as you type.
set hlsearch                      " Highlight matches.

set wrap linebreak nolist         " Turn on line wrapping
set scrolloff=3                   " Show 3 lines of context around the cursor.

set title                         " Set the terminal's title

set nobackup                      " Don't make a backup before overwriting a file.
set nowritebackup                 " And again.

set lazyredraw                    " redraw only when we need to.
set showmatch                     " highlight matching [{()}]

set termguicolors                 " set true colors

set expandtab                     " Use spaces instead of tabs
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set smarttab
set autoread                      " auto reload file when it changes

set laststatus=2

" specific tab size
augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
                \:call <SID>StripTrailingWhitespaces()
    autocmd FileType java setlocal noexpandtab
    autocmd FileType java setlocal list
    autocmd FileType java setlocal listchars=tab:+\ ,eol:-
    autocmd FileType java setlocal formatprg=par\ -w80\ -T4
    autocmd FileType php setlocal expandtab
    autocmd FileType php setlocal list
    autocmd FileType php setlocal listchars=tab:+\ ,eol:-
    autocmd FileType php setlocal formatprg=par\ -w80\ -T4
    autocmd FileType ruby setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType ruby setlocal commentstring=#\ %s
    autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
    autocmd FileType python setlocal commentstring=#\ %s
    autocmd FileType make setlocal ts=4 sts=4 sw=4 noexpandtab
    autocmd BufEnter *.cls setlocal filetype=java
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter *.sh setlocal ts=2 sts=2 sw=2
augroup END

" automatic trailing whitespace triming
autocmd BufWritePre * :%s/\s\+$//e

" Save on focus lost
au FocusLost * :wa
set autowriteall

"let mapleader=","                " leader is comma

" move to beginning/end of line
" nnoremap B ^
" nnoremap E $

" $/^ doesn't do anything
" nnoremap $ <nop>
" nnoremap ^ <nop>

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" ident/unindent with tabs on visual mode
vmap >  >gv
vmap <  <gv

" Tab mappings.
if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    map <C-S-Left> :tabprev<CR>
    map <C-S-Right> :tabnext<CR>
    map <C-S-t> :tabnew<CR>:tabmove<CR>
  else
    map <C-Left> :tabprev<CR>
    map <C-Right> :tabnext<CR>
    map <C-t> :tabnew<CR>:tabmove<CR>
  endif
endif

" open new split pane
map <leader>ws <ESC>:sp<CR>
map <leader>wv <ESC>:vs<CR>

" navigation through panels
nmap <silent> <S-Up> :wincmd k<CR>
nmap <silent> <S-Down> :wincmd j<CR>
nmap <silent> <S-Left> :wincmd h<CR>
nmap <silent> <S-Right> :wincmd l<CR>

" resize current buffer by +/- 5
nnoremap <leader>w<left> :vertical resize -5<cr>
nnoremap <leader>w<down> :resize +5<cr>
nnoremap <leader>w<up> :resize -5<cr>
nnoremap <leader>w<right> :vertical resize +5<cr>

" paste and copy from clipboard
if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    set clipboard=unnamed
  else
    set clipboard=unnamedplus
  endif
endif

" convenient mappings
nnoremap <C-o> o<ESC>
nmap <space> i <ESC>

" ignore system and auto generated stuff
set wildignore+=*/tmp/*,*.so,*.swp,*.swo,*.zip,*.pyc  " MacOSX/Linux
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$\|public\/assets\/.*\|node_modules\/*'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0

" NERDTree mapping
nnoremap <leader>t :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']

let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [  'linter_errors', 'linter_warnings', 'linter_ok' ],
      \              [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ 'component_expand': {
      \   'linter_warnings': 'lightline#ale#warnings',
      \   'linter_errors': 'lightline#ale#errors',
      \   'linter_ok': 'lightline#ale#ok',
      \ },
      \ 'component_type': {
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ },
      \ }

" let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0     " linters don't run when opening a file
let g:ale_lint_delay = 500
" let g:ale_sign_error = 'X'
" let g:ale_sign_warning = '>'
" let g:ale_lint_on_save = 1
nmap <leader>l :ALELint<CR>

" tcomment plugin remap
map <leader>c :TComment<CR>
imap <leader>c <ESC>:TComment<CR>i

" BufExplorer
nmap <Leader>[ :BufExplorer<CR>

" yankstack mappings
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste

let g:ackprg = 'ack --ignore-dir=coverage --ignore-dir=log --ignore-dir=public/ --ignore-dir=tmp --ignore-dir=app/assets/javascripts/generated --ignore-dir=app/assets/javascripts/vendor '
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

" Autosave
let g:auto_save = 1
let g:auto_save_no_updatetime = 1
let g:auto_save_in_insert_mode = 0
let g:auto_save_silent = 1

" completion
imap <C-space> <C-n>

set background=dark

" let g:seoul256_background = 234
" colorscheme seoul256             " badwolf, nord

" colorscheme jellybeans

" let g:gruvbox_contrast_dark = 'medium'
colorscheme gruvbox

" autocomplete menu colors
highlight Pmenu guibg=#646464
highlight Pmenu guifg=#ebebeb
highlight PmenuSel guibg=#617a7a
