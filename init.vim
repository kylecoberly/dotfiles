" Install Plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(stdpath('data') . '/plugged')

" Global Config
Plug 'tpope/vim-vinegar' " Better defaults for netrw
Plug 'tpope/vim-repeat' " Fix . repeats
set nocompatible
set nowrap
set noerrorbells
set spelllang=en_us
set autoread " Auto update on change
augroup auto_read
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
    \ if mode() == 'n' && getcmdwintype() == '' | checktime | endif
augroup END
set title " Adds file to window title
set termguicolors " More colors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
filetype plugin on
filetype indent on
let mapleader=" " " Leader

" Performance
set updatetime=100 " Keeps gitgutter speedy
set history=999
set undolevels=999
set lazyredraw " Don't update display during macros
set hidden " Puts buffer in the background without writing
set ttyfast " Send more characters at once
set nobackup
set noswapfile

"" Custom Shortcuts
Plug 'tpope/vim-surround' " Manipulate surrounding characters
Plug 'tpope/vim-commentary' " Comment toggling
Plug 'tpope/vim-unimpaired' " Pair shortcuts
inoremap jj <ESC>
inoremap jk <ESC>
nmap <C-o> O<Esc>
nmap <CR> o<Esc>
command! E Ex " Disambiguates E
vnoremap <Leader>s :sort<CR> " Sort lines alphabetically
nnoremap <Leader>. @: " Repeat last ex command

" Theme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
set background=dark
let g:gruvbox_contrast_dark='soft'
let g:gruvbox_contrast_light='soft'
let g:gruvbox_improved_strings=1
let g:gruvbox_improved_warnings=1
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1
let g:airline_theme='gruvbox'
autocmd vimenter * ++nested colorscheme gruvbox
autocmd vimenter * ++nested let g:airline_theme='base16_gruvbox_dark_hard'
let g:airline_section_c=''
let g:airline_section_y=''
let g:airline_section_z=''
let g:airline_skip_empty_sections = 1 " Skip empty sections

syntax enable
set listchars=trail:·,nbsp:⚋ " Character used for extra whitespace
set fillchars=fold:- " Character used for extra whitespace in the statusline

" Indentation
Plug 'nathanaelkane/vim-indent-guides'
nnoremap <Leader>i :IndentGuidesToggle<CR>
let g:indent_guides_enable_on_vim_startup=0
let g:indent_guides_auto_colors=1
set expandtab
set autoindent smartindent
set tabstop=2 " Default tab size
set softtabstop=2
set shiftwidth=2 " How far to indent successive lines

" Scrolling
Plug 'yuttie/comfortable-motion.vim'
let g:comfortable_motion_no_default_key_mappings = 1
let g:comfortable_motion_friction = 400.0
let g:comfortable_motion_air_drag = 4.0
nnoremap <silent> <C-d> :call comfortable_motion#flick(200)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(-200)<CR>
" nnoremap <silent> <C-f> :call comfortable_motion#flick(400)<CR>
" nnoremap <silent> <C-b> :call comfortable_motion#flick(-400)<CR>
set scrolloff=5
set sidescrolloff=7

" Gutter
Plug 'kshenoy/vim-signature' " View marks in the gutter
set number
set norelativenumber
nnoremap <Leader>r :set relativenumber!<CR> " Toggle relative line numbers

" Pane Management
Plug 'christoomey/vim-tmux-navigator'
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-/> :TmuxNavigatePrevious<cr>
let g:tmux_navigator_save_on_switch=2

" Buffer Management
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_use_caching=0
let g:ctrlp_custom_ignore = 'bin$\|build$\|node_modules$\|tmp$\|dist$\|.git|.bak|.swp|.pyc|.class'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_max_files=0
let g:ctrlp_max_height = 18
nnoremap <Leader>ff :CtrlP<CR> " Find a file in the current folder recursively
nnoremap <Leader>d :bd<CR> " Delete current buffer
nnoremap <Leader>D :bd!<CR> " Delete current buffer
nnoremap <Leader>n :bn<CR> " Next buffer
nnoremap <Leader>N :bN<CR> " Previous buffer
nnoremap <Leader>t :enew<CR> " Make a new empty buffer
nnoremap <Tab> :b#<CR> " Tab between buffers
nnoremap <Leader>bw :bufdo bwipeout<CR> " Close all buffers

" Search
Plug 'osyo-manga/vim-over' " Preview in buffer
set ignorecase smartcase
function! VisualFindAndReplace()
    :OverCommandLine%s/
endfunction
function! VisualFindAndReplaceWithSelection() range
    :'<,'>OverCommandLine s/
endfunction
nnoremap <Leader>fr :call VisualFindAndReplace()<CR>
xnoremap <Leader>fr :call VisualFindAndReplaceWithSelection()<CR>

" Debugging
Plug 'thinca/vim-quickrun'
function! ExecuteLines() range
    :'<,'>QuickRun
endfunction
xnoremap <Leader>x :call ExecuteLines()<CR>

" Diff
set diffopt=filler " Hide identical lines when diffing
set diffopt+=iwhite " Ignore changes to whitespace when diffing

" Tab Completion for ex commands
set wildmenu
set wildchar=<TAB>
set wildmode=full
set wildignore+=*.DS_STORE,*.db,node_modules/**,*.jpg,*.png,*.gif

"" Language Support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets' " Loads snippets collection
let g:coc_global_extensions = [
  \ 'coc-angular',
  \ 'coc-css',
  \ 'coc-git',
  \ 'coc-html',
  \ 'coc-java',
  \ 'coc-markdownlint',
  \ 'coc-jedi',
  \ 'coc-json',
  \ 'coc-spell-checker',
  \ 'coc-sql',
  \ 'coc-svg',
  \ 'coc-tabnine',
  \ 'coc-tsserver',
  \ 'coc-vetur',
  \ 'coc-xml',
  \ 'coc-yaml',
\ ]

" Omnicomplete
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)
nmap <silent> gd <Plug>(coc-definition) " Go to definition
nmap <silent> gy <Plug>(coc-type-definition) " Go to type definition
nmap <silent> gr <Plug>(coc-references) " Go to references
nmap <silent> [g <Plug>(coc-diagnostic-prev) " Go to previous error
nmap <silent> ]g <Plug>(coc-diagnostic-next) " Go to next error
nmap <leader>do <Plug>(coc-codeaction) " Apply automatic fix
nmap <leader>rn <Plug>(coc-rename) " Bulk rename
" Use K to show documentation in preview window
nnoremap <silent> gt :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
autocmd FileType ts User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

" Scroll hint window
nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

" JavaScript
Plug 'pangloss/vim-javascript'

" TypeScript
Plug 'leafgarland/typescript-vim'

" HTML/CSS
Plug 'mattn/emmet-vim'
let g:user_emmet_install_global = 0 " Only HTML and CSS
let g:user_emmet_mode='i' " Only in insert mode
autocmd FileType html,css EmmetInstall

" JSON
Plug 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0 " Keep double quotes

" YAML
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Text
Plug 'junegunn/goyo.vim'
Plug 'reedes/vim-pencil'
Plug 'plasticboy/vim-markdown'
let g:goyo_width=60
nnoremap <leader>m :Goyo<cr>
let g:pencil#wrapModeDefault = 'soft'
augroup pencil
    autocmd!
    autocmd FileType markdown,mkd call pencil#init()
augroup END
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_strikethrough = 1
let g:pencil#conceallevel = 0

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter' " Git line status in gutter
Plug 'sodapopcan/vim-twiggy' " Fugitive plugin for branch management
Plug 'junegunn/gv.vim' " Fugitive plugin for commit management
Plug 'samoshkin/vim-mergetool' " Vimdiff replacement for git merges
nnoremap <Leader>ga :Git add %:p<CR><CR>
nnoremap <Leader>gs :Git status<CR> " Views status, use `-` and `p` to add/remove files
nnoremap <Leader>gd :Git diff<CR>
nnoremap <Leader>gb :Git branch<Space>
nnoremap <Leader>go :Git checkout<Space>
nnoremap <Leader>gc :Git commit -v -q<CR>
nnoremap <Leader>gg :Git commit -v -q %:p<CR> " Commits current file
nnoremap <Leader>gp :Git push<CR>
nnoremap <Leader>gm :Git merge<CR>
nnoremap <Leader>gn :Git next<CR>
nnoremap <Leader>gN :Git prev<CR>
nnoremap <Leader>g0 :Git first<CR>
nnoremap <Leader>g$ :Git last<CR>
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
nmap <Leader>hs <Plug>(GitGutterStageHunk)
nmap <Leader>hu <Plug>(GitGutterUndoHunk)
nmap <leader>mt <plug>(MergetoolToggle)
nmap <leader>dg :diffget<CR>
nmap <leader>dp :diffput<CR>
let g:mergetool_layout = 'mr'
let g:mergetool_prefer_revision = 'local'

" TMUX
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-obsession'

call plug#end()
