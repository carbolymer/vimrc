scriptencoding utf-8
set encoding=utf-8
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-endwise'
Plug 'airblade/vim-gitgutter'
Plug 'nelstrom/vim-visual-star-search'
Plug 'majutsushi/tagbar'
Plug 'chrisbra/Colorizer'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'godlygeek/tabular'

" LSP clients
" Plug 'w0rp/ale'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }


" Language-specific plugins
Plug 'neovimhaskell/haskell-vim'
Plug 'alx741/vim-stylishask'
Plug 'aklt/plantuml-syntax'
Plug 'lnl7/vim-nix'
Plug 'google/vim-jsonnet'
Plug 'chrisbra/Colorizer'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
" TODO for python: https://www.vimfromscratch.com/articles/vim-for-python/

call plug#end()


if has('gui_running')
    set guifont=Source\ Code\ Pro\ Regular\ 9
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar
    set guioptions-=T  " no toolbar
endif

" Fix for mouse not working after 220 column in tmux
" https://stackoverflow.com/a/19253251/1608594
if !has('nvim') && !has('gui_running')
  if has("mouse_sgr")
      set ttymouse=sgr
  else
      set ttymouse=xterm2
  endif
endif

colorscheme adventurous_fixed
set cursorline
set cursorcolumn
set fillchars+=vert:\▏

" enable comments in json
autocmd FileType json syntax match Comment +\/\/.\+$+


let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='jellybeans'
if &t_Co > 255
  let g:airline_powerline_fonts = 1
endif

" enable relative numbering
set number relativenumber
" auto toggle relative numbering
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Return to last edit position when opening files
 autocmd BufReadPost * silent!
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"zv" |
     \ endif

set list
set swapfile
set dir=~/.vim/tmp

" enable moving away from modified files
set hidden

" write swap file every mseconds
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" disable preview window on autocompletion
set completeopt-=preview

" :Rg with default search for cword
function! s:p(bang, ...)
  let preview_window = get(g:, 'fzf_preview_window', a:bang && &columns >= 80 || &columns >= 120 ? 'right': '')
  if len(preview_window)
    return call('fzf#vim#with_preview', add(copy(a:000), preview_window))
  endif
  return {}
endfunction

function! s:callRipgrep(txt)
  if empty(a:txt)
    let l:searchString = expand('<cword>')
  else
    let l:searchString = a:txt
  endif
  call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(l:searchString), 1, s:p(!0), !0)
endfun

command! -bang -nargs=* Rg call s:callRipgrep(<q-args>)

" FZF settings
nmap <leader>f :Files<cr>|     " fuzzy find files in the working directory (where you launched Vim from)
nmap <leader>/ :BLines<cr>|    " fuzzy find lines in the current file
nmap <leader>b :Buffers<cr>|   " fuzzy find an open buffer
nmap <leader>r :Rg |           " fuzzy find text in the working directory
nmap <leader>c :Commands<cr>|  " fuzzy find Vim commands (like Ctrl-Shift-P in Sublime/Atom/VSC)
nmap <leader>t :Tags<cr>|      " fuzzy find tags

" Git gutter
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

" Tagbar configuration
nmap <F8> :TagbarToggle<CR>
let g:tagbar_width = 60
let g:tagbar_type_haskell = {
    \ 'ctagsbin'    : 'hasktags',
    \ 'ctagsargs'   : '-x -c -o-',
    \ 'kinds'       : [
        \  'm:modules:0:1',
        \  'd:data:0:1',
        \  'd_gadt:data gadt:0:1',
        \  'nt:newtype:0:1',
        \  'c:classes:0:1',
        \  'i:instances:0:1',
        \  'cons:constructors:0:1',
        \  'c_gadt:constructor gadt:0:1',
        \  'c_a:constructor accessors:1:1',
        \  't:type names:0:1',
        \  'pt:pattern types:0:1',
        \  'pi:pattern implementations:0:1',
        \  'ft:function types:0:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'          : '.',
    \ 'kind2scope'   : {
        \ 'm'        : 'module',
        \ 'd'        : 'data',
        \ 'd_gadt'   : 'd_gadt',
        \ 'c_gadt'   : 'c_gadt',
        \ 'nt'       : 'newtype',
        \ 'cons'     : 'cons',
        \ 'c_a'      : 'accessor',
        \ 'c'        : 'class',
        \ 'i'        : 'instance'
    \ },
    \ 'scope2kind'   : {
        \ 'module'   : 'm',
        \ 'data'     : 'd',
        \ 'newtype'  : 'nt',
        \ 'cons'     : 'c_a',
        \ 'd_gadt'   : 'c_gadt',
        \ 'class'    : 'ft',
        \ 'instance' : 'ft'
    \ }
\ }

au FileType python setlocal formatprg=autopep8\ -

" source ~/.vim/coc.vim
" source ~/.vim/ale.vim
source ~/.vim/lc-vim.vim

