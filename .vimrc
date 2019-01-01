" Plugins
let iCanHazNeoBundle=1
let neobundle_readme=expand($HOME.'/.vim/bundle/neobundle.vim/README.md')
if !filereadable(neobundle_readme)
    echo "Installing NeoBundle.."
    echo ""
    silent !mkdir -p $HOME/.vim/bundle
    silent !git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
    let iCanHazNeoBundle=0
endif
if has('vim_starting')
    set rtp+=$HOME/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand($HOME.'/.vim/bundle/'))

NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'tpope/vim-vinegar'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'vim-airline/vim-airline'
NeoBundle 'vim-airline/vim-airline-themes'
NeoBundle 'tpope/vim-commentary'
NeoBundle 'osyo-manga/vim-over'
NeoBundle 'thinca/vim-qfreplace'
NeoBundle 'kshenoy/vim-signature'
NeoBundle 'editorconfig/editorconfig-vim'
NeoBundle 'mattn/gist-vim', {'depends': 'mattn/webapi-vim'}
NeoBundle 'Valloric/YouCompleteMe', {'build': './install.sh --clang-completer --tern-completer --system-libclang --omnisharp-completer'}
NeoBundle 'reedes/vim-pencil'
NeoBundle 'junegunn/goyo.vim'
NeoBundle 'posva/vim-vue'
NeoBundle 'mileszs/ack.vim'

call neobundle#end()
if iCanHazNeoBundle == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :NeoBundleInstall
endif
NeoBundleCheck

" General config
inoremap jj <ESC>
inoremap jk <ESC>
syntax enable
command E Ex " Disambiguates E
filetype plugin on
filetype indent on
set encoding=utf-8
set laststatus=2
set nocompatible
set nowrap
set ignorecase smartcase
set t_Co=256
set number
set tabstop=4
set expandtab
set autoindent smartindent
set softtabstop=4
set shiftwidth=4
set nobackup
set noswapfile
set noerrorbells
set spelllang=en_us
set hidden " Puts buffer in the background without writing
set lazyredraw " Don't update display during macros
set ttyfast " Send more characters at once
set history=999
set undolevels=999
set autoread
set title
set scrolloff=5
set sidescrolloff=7
set relativenumber
set wildmenu
set wildchar=<TAB>
set wildmode=full
set wildignore+=*.DS_STORE,*.db,node_modules/**,*.jpg,*.png,*.gif
set diffopt=filler
set diffopt+=iwhite
set listchars=trail:·,nbsp:⚋
set fillchars=fold:-

" vim.ack
let g:ackprg = 'ag --nogroup --nocolor --column'

" Pencil
let g:pencil#wrapModeDefault = 'soft'
augroup pencil
    autocmd!
    autocmd FileType markdown,mkd,md call pencil#init()
    autocmd FileType text call pencil#init({'wrap': 'hard'})
augroup END

" Goyo
let g:goyo_width=60

" Airline
let g:airline_theme='molokai'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" Status line
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Colors
colorscheme solarized
let g:solarized_termcolors = &t_Co
let g:solarized_termtrans = 1
let g:solarized_termcolors=256
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
set background=dark
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" Ctrlp
let g:ctrlp_use_caching=0
let g:ctrlp_custom_ignore = 'bin$\|build$\|node_modules$\|tmp$\|dist$\|.git|.bak|.swp|.pyc|.class'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_max_files=0
let g:ctrlp_max_height = 18

" Custom key commands
let mapleader=" "

" Find and replace
function! VisualFindAndReplace()
    :OverCommandLine%s/
endfunction
function! VisualFindAndReplaceWithSelection() range
    :'<,'>OverCommandLine s/
endfunction
nnoremap <Leader>fr :call VisualFindAndReplace()<CR>
xnoremap <Leader>fr :call VisualFindAndReplaceWithSelection()<CR>

" Fugitive
nnoremap <Leader>ga :Git add %:p<CR><CR>
nnoremap <Leader>gs :Gstatus<CR> " Views status, use `-` and `p` to add/remove files
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>gb :Git branch<Space>
nnoremap <Leader>go :Git checkout<Space>
nnoremap <Leader>gc :Gcommit -v -q<CR>
nnoremap <Leader>gg :Gcommit -v -q %:p<CR> " Commits current file
nnoremap <Leader>gp :Git push<CR>
nnoremap <Leader>gm :Git merge<CR>

" Goyo
nnoremap <Leader>m :Goyo<CR>

" Buffer management
nnoremap <Leader>ff :CtrlP<CR> " Find a file in the current folder recursively
nnoremap <Leader>d :bd<CR> " Delete current buffer
nnoremap <Leader>n :bn<CR> " Next buffer
nnoremap <Leader>N :bN<CR> " Previous buffer
nnoremap <Leader>t :enew<CR> " Make a new empty buffer
nnoremap <Tab> :b#<CR> " Tab between buffers

" Split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Newline Generation
nmap <C-o> O<Esc>
nmap <CR> o<Esc>
