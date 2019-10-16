if exists("g:loaded_streamline_plugin")
    finish
endif
let g:loaded_streamline_plugin = 1
let g:streamline_show_ale_status = 0

" Always show statusline
set laststatus=2
set statusline=%!StyleStatusline()

function! StyleStatusline()
    let statusline=""
    let statusline.="%#Search#"
    let statusline.="\ %{GetMode()}"
    let statusline.="\ %#diffadd#"
    let statusline.="\%{StatuslineGit()}"
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
    let statusline.="▏☲ %l:%c"             " Show line number and column
    let statusline.="\ %p%% "              " Show percentage
    if g:streamline_show_ale_status == 1
        let statusline.="%#WarningColor#"
        let statusline.="%{GetWarnings()}" " Show ale errors and warnings
        let statusline.="%#ErrorColor#"
        let statusline.="%{GetErrors()}"   " Show ale errors and warnings
    endif
    return statusline
endfunction

hi WarningColor guibg=#DA711A guifg=#FFFFFF ctermbg=DarkBlue ctermfg=White
hi ErrorColor guibg=#B63939 guifg=#FFFFFF ctermbg=Red ctermfg=White

function! GetErrors()
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error

    return l:counts.total == 0 ? '' : '  E:'.l:all_errors.' '
endfunction

function! GetWarnings()
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_warnings = l:counts.total - (l:counts.error + l:counts.style_error)

    return l:counts.total == 0 ? '' : ' W:'.l:all_warnings.' '
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?' '.l:branchname.' ':''
endfunction

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! GetMode()
    let mode=mode()
    if mode == 'n'
        return 'NORMAL'
    elseif mode == 'i'
        return 'INSERT'
    elseif mode == 'v'
        return 'VISUAL'
    elseif mode == 's' || mode == 'S'
        return 'SELECT'
    elseif mode == 'R' ||  mode == 'Rv'
        return 'REPLACE'
    elseif mode == 'c'
        return 'COMMAND'
    else
        return 'NORMAL'
    endif
endfunction
