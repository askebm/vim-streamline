if exists("g:loaded_streamline_plugin")
    finish
endif
let g:loaded_streamline_plugin = 1

if !exists("g:streamline_show_ale_status")
		let	g:streamline_show_ale_status = 0
endif

function! StyleStatusline()
    let statusline=""
    let statusline.="%#Search#"
    let statusline.=" %{GetMode()} "
    let statusline.="%#diffadd#"
    let statusline.="%{GitBranch()}"
    let statusline.="%#CursorlineNr#"
    let statusline.="\ %f"                 " Show filename
    let statusline.="\ %m"                 " Show modified tag
    let statusline.="%="                   " Switch elements to the right
    let statusline.="%#StatuslineNC#"
    let statusline.="▏%y"                  " Show filetype
    " Show encoding and file format
    let statusline.="\ %{&fileencoding?&fileencoding:&encoding}"
    let statusline.="[\%{&fileformat}\] "
    let statusline.="%#TermCursor#"
    let statusline.="▏ %l:%c"             " Show line number and column
    let statusline.=" %p%% "               " Show percentage
    if g:streamline_show_ale_status == 1
        let statusline.="%#WarningColor#"
        let statusline.="%{GetWarnings()}"
        let statusline.="%#ErrorColor#"
        let statusline.="%{GetErrors()}"
    endif
    return statusline
endfunction

function! StyleInactiveStatusline()
    let statusline=""
    let statusline.="%#Whitespace#"
    let statusline.=" %{GetMode()} "
    let statusline.="%{GitBranch()}"
    let statusline.="\▏%f"
    let statusline.="\ %m"
    let statusline.="%="
    let statusline.="▏%y"
    let statusline.="\ %{&fileencoding?&fileencoding:&encoding}"
    let statusline.="[\%{&fileformat}\] "
    let statusline.="▏ %l:%c"
    let statusline.=" %p%% "
    if g:streamline_show_ale_status == 1
        let statusline.="%{GetWarnings()}"
        let statusline.="%{GetErrors()}"
    endif
    return statusline
endfunction

set laststatus=2
set statusline=%!StyleStatusline()
augroup status
  autocmd!
  autocmd WinEnter * setlocal statusline=%!StyleStatusline()
  autocmd WinLeave * setlocal statusline=%!StyleInactiveStatusline()
augroup END

hi WarningColor guibg=#DA711A guifg=#FFFFFF ctermbg=DarkBlue ctermfg=White
hi ErrorColor guibg=#B63939 guifg=#FFFFFF ctermbg=Red ctermfg=White

function! GitBranch()
  return '▏'.system("cd " . expand('%:p:h') . " && git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'").' '
endfunction

function! GetErrors()
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error

    return l:all_errors == 0 ? '' : '  E:'.l:all_errors.' '
endfunction

function! GetWarnings()
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_warnings = l:counts.total - (l:counts.error + l:counts.style_error)

    return l:all_warnings == 0 ? '' : ' W:'.l:all_warnings.' '
endfunction

function! GetMode()
    let mode=mode()
    if mode == 'i'
        return 'INSERT'
    elseif mode == 'v'
        return 'VISUAL'
    elseif mode == 'R' ||  mode == 'Rv' || mode == 'r'
        return 'REPLACE'
    else
        return 'NORMAL'
    endif
endfunction
