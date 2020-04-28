" Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(stdpath('data') . '/plugged')
Plug 'Shougo/neobundle.vim'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'osyo-manga/vim-over'
Plug 'thinca/vim-qfreplace'
Plug 'kshenoy/vim-signature'
Plug 'editorconfig/editorconfig-vim'
Plug 'reedes/vim-pencil'
Plug 'junegunn/goyo.vim'
Plug 'posva/vim-vue'
Plug 'mileszs/ack.vim'
Plug 'airblade/vim-gitgutter'
Plug 'leafgarland/typescript-vim'
Plug 'dense-analysis/ale'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
call plug#end()

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
set tabstop=2
set expandtab
set autoindent smartindent
set softtabstop=2
set shiftwidth=2
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
set updatetime=100 " Keeps gitgutter speedy

" ALE
let g:ale_linters = {'javascript': ['eslint']}
let g:ale_lint_on_save = 1
let g:ale_fixers = ['eslint']
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
let g:airline#extensions#ale#enabled = 1
autocmd BufWritePost *.js ALEFix

" Deoplete
let g:deoplete#enable_at_startup = 1
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

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

" Goyo
nnoremap <leader>m :Goyo<cr>

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

" Buffer management
nnoremap <Leader>ff :CtrlP<CR> " Find a file in the current folder recursively
nnoremap <Leader>d :bd<CR> " Delete current buffer
nnoremap <Leader>D :bd!<CR> " Delete current buffer
nnoremap <Leader>n :bn<CR> " Next buffer
nnoremap <Leader>N :bN<CR> " Previous buffer
nnoremap <Leader>t :enew<CR> " Make a new empty buffer
nnoremap <Tab> :b#<CR> " Tab between buffers

" Eslint
nnoremap <Leader>e :new<Bar>0r!npm run lint<CR> " Run eslint in vue

" Split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Newline Generation
nmap <C-o> O<Esc>
nmap <CR> o<Esc>

nnoremap <Leader>. @: " Repeat last ex command
nnoremap <Leader>r :set relativenumber!<CR> " Toggle relative line numbers

let @s = "* { box-sizing: border-box; } body { align-items: center; background-color: #ddd; background-image: linear-gradient( 0deg, hsla(0, 0%, 100%, 0.9), hsla(0, 0%, 100%, 0.6)), linear-gradient(90deg, hsla(0, 0%, 100%, 0.9), hsla(0, 0%, 100%, 0.6)); background-size: 25px 25px; color: #333; display: flex; font-family: Arial, sans-serif; justify-content: center; margin-top: -5%; min-height: 100vh; } .content-wrapper { width: 100%; } #app { display: flex; width: 300px; h1 { color: #ccc; font-size: 16px; left: 24px; position: absolute; top: 16px; } .days-remaining { border-bottom: 1px solid #ccc; padding: 24px; text-align: center; text-transform: uppercase; width: 100%; span { display: block; font-size: 256px; font-weight: 700; } } .roll-rate, .rolls-remaining { color: #666; } .roll-commands { display: flex; justify-content: space-around; width: 100%; button { background: none; border: none; cursor: pointer; font-size: 64px; padding: 24px; } } }"
let @p = '"cypress-cucumber-preprocessor": { "nonGlobalStepDefinitions": true, "stepDefinitions": "tests/e2e/specs", "commonPath": "tests/e2e/common", "cucumberJson": { "generate": true, "outputFolder": "tests/e2e/cucumber-json", "filePrefix": "", "fileSuffix": ".cucumber" } },'
let @c = '"baseUrl": "http://localhost:8080", "chromeWebSecurity": false, "testFiles": "**/*.{feature,features}"'
let @m = 'Cypress.Commands.add("the", testSelector => cy.get(`[data-test-${testSelector}]`)); Cypress.Commands.add("clickThe", testSelector => { cy.get(`[data-test-${testSelector}]`).click(); }); Cypress.Commands.add("clickTheFirst", testSelector => { cy.get(`[data-test-${testSelector}]`) .eq(0) .click(); }); Cypress.Commands.add("theFirst", testSelector => cy.get(`[data-test-${testSelector}]`).eq(0)); Cypress.Commands.add("fillOutThe", testSelector => cy.get(`[data-test-${testSelector}]`)); Cypress.Commands.add("with", { prevSubject: true }, (form, formData) => { cy.wrap(Object.keys(formData)).each(key => { cy.get(form) .find(`[name=${key}]`) .type(formData[key]); }); cy.get(form).submit(); }); Cypress.Commands.add("getStore", () => { return cy.window().its("app.__vue__.$store"); }); Cypress.Commands.add( "dispatch", { prevSubject: true }, (store, methodToDispatch, ...dispatchArguments) => { return store.dispatch(methodToDispatch, ...dispatchArguments); }); Cypress.Commands.add( "commit", { prevSubject: true }, (store, methodToCommit, ...commitArguments) => { return store.commit(methodToCommit, ...commitArguments); }); Cypress.Commands.add( "setState", { prevSubject: true }, (store, property, value) => { store.state[property] = value; return value; }); Cypress.Commands.add("getState", { prevSubject: true }, (store, property) => { return store.state[property]; });'
let @u = 'const cucumber = require("cypress-cucumber-preprocessor").default; on("file:preprocessor", cucumber());'

