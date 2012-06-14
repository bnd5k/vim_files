set nocompatible
syntax on

filetype off
call pathogen#infect()
filetype plugin indent on

set history=10000
set number
set showmatch
set incsearch
set hlsearch
set background=dark
set hidden
set backspace=indent,eol,start
set textwidth=0
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set ignorecase smartcase
set cursorline
set wrap
set noswapfile
set bs=2

set winwidth=90
set winminwidth=15
" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
set winheight=5
set winminheight=5
set winheight=999

" Highlight trailing whitespace
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/

" Set up highlight group & retain through colorscheme changes
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
map <silent> <LocalLeader>ws :highlight clear ExtraWhitespace<CR>

" Highlight too-long lines
autocmd BufRead,InsertEnter,InsertLeave * 2match LineLengthError /\%126v.*/
highlight LineLengthError ctermbg=black guibg=black
autocmd ColorScheme * highlight LineLengthError ctermbg=black guibg=black

:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

if &t_Co == 256
  colorscheme Tomorrow-Night
endif

" Keymaps

nmap , \
map <silent> <LocalLeader>nt :NERDTreeToggle<CR>
map <silent> <LocalLeader>nr :NERDTree<CR>
map <silent> <LocalLeader>nf :NERDTreeFind<CR>
map <silent> <LocalLeader>nh :nohls<CR>
map <silent> <LocalLeader>t :CommandT<CR>
map <silent> <LocalLeader>cf :CommandTFlush<CR>
map <silent> <LocalLeader>cb :CommandTBuffer<CR>
map <silent> <LocalLeader>cj :CommandTJump<CR>
map <silent> <LocalLeader>ct :CommandTTag<CR>
imap <C-L> <SPACE>=><SPACE>

function! Trim()
  exe "normal mz"
  %s/\s*$//
  exe "normal `z"
  exe "normal zz"
endfunction

command! -nargs=0 Trim :call Trim()
nnoremap <silent> <Leader>tw :Trim<CR>

let g:CommandTAcceptSelectionSplitMap=['<C-s>']
let g:CommandTAcceptSelectionVSplitMap=['<C-v>']
let g:CommandTCancelMap=['<Esc>', '<C-c>']
let g:CommandTMaxHeight=10

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>r :call RunTestFile()<cr>
map <leader>R :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>
map <leader>c :w\|:!script/features<cr>
map <leader>w :w\|:!script/features --profile wip<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    if match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        if filereadable("script/test")
            exec ":!script/test " . a:filename
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color -f d " . a:filename
        else
            exec ":!rspec --color -f d " . a:filename
        end
    end
endfunction
