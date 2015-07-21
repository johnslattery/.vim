" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
"runtime! debian.vim

" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tmhedberg/matchit'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-scripts/dbext.vim'
Plugin 'oplatek/conque-shell'

call vundle#end()

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the
" following enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" http://tedlogan.com/techblog3.html
" http://vim.wikia.com/wiki/Indenting_source_code
set expandtab shiftwidth=2 softtabstop=2 tabstop=2

set hlsearch

set modeline

set statusline=%F%m%r%h%w\ %{&ff}%(\ %Y%)\ \%03.3b/\%02.2B\ %04l,%04v\ %p%%\ %L\ %o/\%O
set laststatus=2

function MaxLineLen()
	return max(map(getline(1,'$'), 'len(v:val)'))
endfunction

function MaxLineLenVirtual()
	return max(map(range(1, line('$')), "virtcol([v:val, '$'])-1"))
endfunction

function! PadFileLines(length)
    let l:maxLineLen = max(map(getline(1, '$'), 'len(v:val)')) 
    if a:length < l:maxLineLen
        let l:message = 'Longest line is ' . printf("%d", maxLineLen) . '. Data will be lost.'
        let l:choice = confirm(l:message, "&OK\n&Cancel", 1)
        if l:choice != 1
            return
        endif
    endif
    call setline(1, map(getline(1, '$'), 'strpart(v:val . repeat(" ", a:length), 0, a:length)'))
endfunction

function UnformPsql()
	%s/[\n\t]/ /g
	%s/ \{2,}/ /g
	%s/ \+)/)/g
	%s/( \+/(/g
	%s/ ;/;/g
	%s/; $/;/g
endfunction

command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 	\ | wincmd p | diffthis

command ScratchBuf setlocal buftype=nofile bufhidden=hide noswapfile
