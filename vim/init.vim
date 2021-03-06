" a nice lil' (neo)vim config
" (requires python3 install)

" safety first
set secure

nnoremap nf :NERDTreeFind<CR>

" This creates a quick fix window of recently used buffers to search on and
" select
command! Qbuffers call setqflist(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '{"bufnr":v:val}'))

nnoremap gb :Qbuffers<CR>:copen<CR>
" Close the window after I select a file
:autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>
" install vim plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall!
endif

" project root
function! FindGitRoot()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

" file cleanup
function! StripTrailingWhitespace()
  if exists('b:noStripWhitespace')
    return
  endif
  %s/\s\+$//e
endfunction

" `dd` removes line in quickfix window
function! RemoveQFItem()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  execute curqfidx + 1 . "cfirst"
  copen
endfunction


"""""""""""""""""""""""" PLUGINS
set runtimepath^=~/.vim/plugin
set runtimepath^=~/.opam/system/share/ocp-indent/vim
call plug#begin('~/.vim/plugged')
  " notetaking in vim
  Plug 'vimwiki/vimwiki'

  " fuzzy finder 
  Plug 'junegunn/fzf'

  " quote/bracket/tags
  Plug 'tpope/vim-surround'

  " autoclose
  Plug 'townk/vim-autoclose'

  " commenting
  Plug 'tomtom/tcomment_vim'

  " isolated view
  Plug 'chrisbra/NrrwRgn'

  " highlighting
  Plug 'kien/rainbow_parentheses.vim'

  " git gutter
  Plug 'airblade/vim-gitgutter'

  " git fugitive & line helpers
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  Plug 'ruanyl/vim-gh-line'

  " byobu-esque
  Plug 'bling/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  " smart '/' search
  Plug 'pgdouyon/vim-evanesco'

  " fuzzy file search
  " if has('nvim')
  "   Plug 'ctrlpvim/ctrlp.vim', { 'do': ':UpdateRemotePlugins' }
  " endif

  " word search
  Plug 'mileszs/ack.vim'

  " buffer manipulation
  Plug 'schickling/vim-bufonly'

  " nerdtree
  Plug 'scrooloose/nerdtree'

  " supertab (for autocompletion)
  Plug 'ervandew/supertab'

  " autocompletion
  if has('nvim')
    silent !pip3 install pynvim
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    " Plug 'fishbullet/deoplete-ruby'
  else
    silent !pip3 install pynvim
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif

  " python
  Plug 'davidhalter/jedi-vim'

  " closing html tags
  Plug 'alvan/vim-closetag'

  " javascript
  Plug 'MaxMEllon/vim-jsx-pretty'
  Plug 'digitaltoad/vim-pug'
  Plug 'jparise/vim-graphql'
  Plug 'leafgarland/typescript-vim'
  Plug 'moll/vim-node'
  Plug 'pangloss/vim-javascript'
  Plug 'peitalin/vim-jsx-typescript'
  Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }

  " prettier for typescript
  Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

  " tmux
  Plug 'christoomey/vim-tmux-navigator'

  " buffer deletion w/ layout preservation
  Plug 'qpkorr/vim-bufkill'

  " linting
  Plug 'w0rp/ale'

  " testing
  Plug 'janko-m/vim-test'

call plug#end()

nnoremap <C-p> :FZF<CR>

" allow autocompletion on all filetypes except txt
let g:deoplete#enable_at_startup=1
augroup deoplete_configs
  autocmd FileType tex call deoplete#custom#buffer_option('auto_complete', v:false)
augroup END
" Enter maps to completion
let g:SuperTabCrMapping = 1
let g:SuperTabDefaultCompletionType = "<c-n>"

" allow closetags
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.xml,*.php,*.jsx,*.tsx"
let g:closetag_xhtml_filenames = "*.xhtml,*.jsx,*.tsx"

" tmux
let g:tmux_navigator_save_on_switch = 1
let g:tmux_navigator_disable_when_zoomed = 1

" ctrl-P configs - silver searcher override later
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = 'find %s -type f'
let g:ctrlp_root_markers = ['\.ctrlp$', '\.git$']
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.yardoc\|log\|node_modules',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$\|\.ctrlp$'
  \ }

" nerdtree configs
let NERDTreeRespectWildIgnore=1
augroup nerdtree_configs
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
augroup END

" rainbow parentheses
augroup parentheses_configs
  autocmd VimEnter * RainbowParenthesesToggle
  autocmd Syntax * RainbowParenthesesLoadRound
  autocmd Syntax * RainbowParenthesesLoadSquare
  autocmd Syntax * RainbowParenthesesLoadBraces
augroup END

" byobu style
let g:airline_theme="base16"
let g:airline#extensions#tabline#formatter='jsformatter'

" gitgutter
highlight clear SignColumn
highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=yellow
highlight GitGutterDelete ctermfg=red
highlight GitGutterChangeDelete ctermfg=red
let g:gitgutter_max_signs = 500  " keep vim snappy
let g:gitgutter_sign_modified_removed = '≈'
let g:gitgutter_sign_removed_first_line = '↑'

" silver searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in ctrlp for listing files.
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " fast enough to not cache
  let g:ctrlp_use_caching = 0
  " configure ack.vim to use ag
  let g:ackprg = 'ag --vimgrep --smart-case'
endif

" tern
augroup tern_js_config
  au!
  au CompleteDone * pclose
augroup END

" linting & formatting
let g:ale_fixers = { 
  \'javascript': ['eslint'],
  \'typescript': ['eslint', 'tslint', 'prettier', 'remove_trailing_lines', 'trim_whitespace'],
  \'typescriptreact': ['eslint', 'tslint', 'prettier', 'remove_trailing_lines', 'trim_whitespace'],
  \'javascriptreact': ['eslint'],
  \'python': ['black'],
  \'ruby': ['rubocop']
\}

let g:ale_fix_on_save = 1
" let g:ale_linter_aliases = {
"   \'jsx': ['javascript', 'javascriptreact']
" \}

augroup making
  au BufWritePre * silent! :Prettier<CR>
augroup END

let g:ale_linters = {
  \'javascript': ['eslint'],
  \'typescript': ['eslint', 'tslint', 'tsserver', 'typecheck'],
  \'javascriptreact': ['eslint','stylelint'],
  \'typescriptreact': ['eslint', 'tslint', 'tsserver', 'typecheck'],
  \'less': ['stylelint'],
  \'python': ['flake8'],
  \'ruby': ['rubocop']
\}
let g:ale_linters_explicit = 1
let g:ale_set_highlights = 0
let g:airline#extensions#ale#enabled = 1
" let g:ale_sign_error = '😡'
" let g:ale_sign_warning = '🤔'
highlight clear ALEErrorSign
highlight clear ALEWarningSign

" testing strategy
let test#strategy = 'vimux'

" vim-javascript style
let g:javascript_plugin_jsdoc = 1

"""""""""""""""""""""""" CONFIGS
" safety first
set nocompatible
" make redraw quick
set ttyfast
" enable mouse!
set mouse=a
" enable line numbers
set number
" keep at least one line above cursor
set scrolloff=1
" copy+paste
set clipboard=unnamed
" ignore case when searching except when search includes uppercase
set ignorecase
set smartcase
" detect when file is changed
set autoread
" ignore
set wildignore+=.DS_Store
set wildignore+=*.bmp,*.png,*.jpg,*.jpeg,*.gif
set wildignore+=*.so,*.swp,*.zip,*.bz2
" allow unsaved buffers to go into the background
set hidden
" real-time replacement
set inccommand=nosplit

" don't clutter cwd with backup and swap files
set backupdir^=~/.vim/.backup
" '//' incorporate full path into swap filenames
set dir ^=~/.vim/.backup//
" persistent undo (through file)
silent !mkdir ~/.vim/.undo > /dev/null 2>&1
set undodir=~/.vim/.undo
set undofile
" prevent creation of backup & swap files
set nobackup
set noswapfile
set nowb

" default replace tab with 2 spaces
filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
" automatic config on filetype
augroup filetype_configs
  " ... not for makefiles tho
  autocmd FileType make setlocal noexpandtab
  autocmd FileType makefile setlocal noexpandtab
  " .txt
  autocmd FileType text setlocal autoindent expandtab softtabstop=2
  " .help
  autocmd FileType help setlocal nospell
  " turn off autocomment
  autocmd FileType * set fo-=r fo-=o
augroup END

" split panes lookin nice
hi VertSplit cterm=NONE ctermbg=NONE ctermfg=NONE
set fillchars=vert:\ 
set splitbelow
set splitright

" colors in this bitch
syntax on
highlight LineNr ctermfg=yellow
highlight Comment ctermfg=grey

" cursor
set cursorline
highlight CursorLine cterm=NONE
highlight Visual cterm=NONE ctermfg=blue ctermbg=black
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175
" terminal cursor is red
highlight TermCursor ctermfg=red

" NerdTree
highlight NERDTreeCWD ctermfg=yellow

" tabs
highlight TabLineFill ctermfg=black ctermbg=black
highlight TabLine ctermfg=grey ctermbg=black
highlight TabLineSel ctermfg=blue ctermbg=NONE
highlight Title ctermfg=blue ctermbg=NONE

" keywords
augroup vimrc_todo
  autocmd!
  autocmd Syntax * syntax match vimrc_todo /\v\_.<(TODO|FIXME|NOTE|OPTIMIZE|XXX).*/hs=s+1 containedin=.*Comment
augroup END
highlight link vimrc_todo Todo

" automatic commands run on sys task
augroup sys_tasks
  " remove trailing space on save unless b:noStripWhitespace
  autocmd FileType vim let b:noStripWhitespace=1
  autocmd BufWritePre * call StripTrailingWhitespace()
  " resize splits on window resize
  autocmd VimResized * wincmd =
augroup END

" quickfix window context
command! RemoveQFItem :call RemoveQFItem()
augroup qf_window
  autocmd FileType qf nnoremap <buffer> dd :call RemoveQFItem()<CR>
augroup END

" Refresh syntax highlighting on buffer enter
augroup refreshsyntax_highlighting
  autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
  autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
augroup END

"""""""""""""""""""""""" MACROS + REMAPS
" leader key
let g:mapleader = "\<SPACE>"

" F2 key shows tabs and trailing chars
nnoremap <F2> :<C-U>setlocal lcs=tab:>-,trail:-,eol:$ list! list? <CR>

" vertical split quick open/close
nnoremap <silent> vv <C-w>v
nnoremap <silent> qq <C-w>q

" pane switches
" vertical
nnoremap <C-J> <C-W><C-W>
nnoremap <C-K> <C-W><C-W>
" horizontal
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" go to definition
nnoremap gkd :ALEGoToDefinition<CR>

" buffer switches
nnoremap <Tab> :bprevious<CR>
nnoremap <S-Tab> :bnext<CR>
" buffer kill
nnoremap <leader>bk :bprevious <BAR> bdelete #<CR>
" close all other buffers
nnoremap <leader>bo :BufOnly<CR>

" zoom into new tab
nnoremap zz :tabedit %<CR>

" press spacebar to remove highlight from current search
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" search for word under the cursor from git root
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
" bind "\" and Ag to grep -> ag shortcut from project root
command! -nargs=1 Ag execute "Ack! <args> " . FindGitRoot()
nnoremap \ :Ag -i<SPACE>

" open file path in a split
nnoremap vgf <C-W>v<C-W>lgf
nnoremap sgf <C-W>s<C-W>jgf

" scm_breeze git w/ fugitive
nnoremap gs :Gstatus<CR>
nnoremap gbl :Gblame<CR>

" toggle directory view sidebar
map <C-n> :NERDTreeToggle<CR>

nnoremap <leader>t :TestNearest<CR>
nnoremap <leader>tf :TestFile<CR>
nnoremap <leader>ts :TestSuite<CR>
nnoremap <leader>tl :TestLast<CR>
nnoremap <leader>tgf :TestVisit<CR>

" neovim
if has('nvim')
  " terminal
  tnoremap <Esc> <C-\><C-n>
  augroup terminal_tasks
    " remove line numbers in terminal
    autocmd TermOpen * setlocal nonumber norelativenumber
    autocmd TermOpen * startinsert
  augroup END
endif

" macvim
if has("gui_macvim")
  " don't remap anything
  let macvim_skip_cmd_opt_movement=1
  " visual defualts
  set guioptions=egmt
  set antialias
  set fuoptions=maxvert,maxhorz
endif

" for posterity
nnoremap <leader>vimrc :tabedit $MYVIMRC
