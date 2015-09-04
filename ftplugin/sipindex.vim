" Language:	Sip Index
" Maintainer:	Emrah Soytekin (emrahsoytekin@gmail.com)
" URL:		
" Last Change: 03.09.2015_08.56
"
"if !has('python')
    "finish
"endif

if exists("g:loaded_sipindex_plugin")
    finish
endif
let g:loaded_sipindex_plugin = 1

function! s:alignFields() abort
    "set modifiable
    AddTabularPattern! sipArrow /^[^<-]*\zs[<-]/r1c0l0
    Tabularize sipArrow
    AlignCtrl lWC : :
    Align 
    set nonu
    vertical resize 25
    "w
    "set nomodifiable
endfunction

function! s:goto_win(winnr, ...) abort
    let cmd = type(a:winnr) == type(0) ? a:winnr . 'wincmd w'
                                     \ : 'wincmd ' . a:winnr
    let noauto = a:0 > 0 ? a:1 : 0

    if noauto
        noautocmd execute cmd
    else
        execute cmd
    endif
endfunction

if exists(':Tabularize')
    "call s:alignFields()
endif

function! sipindex#SwitchAndGotoLine(linePattern) abort
 if(!empty(a:linePattern))
    let currLine = split(a:linePattern,':')[1]
    call s:goto_win('h')
    execute currLine
    execute "normal! zz"
 endif
endfunction

function! sipindex#DeleteSipMessage() abort
    let save_cursor = getpos(".")
    let line = getline('.')
    let deleteLines = matchstr(line,'\v.*\{\zs.*\ze\}')
    call s:goto_win(1)
    execute deleteLines.'d'
    "execute 'w'
    call s:goto_win('l')
    call sipindex#ReloadIndex()
    call setpos('.', save_cursor)
endfunction

fun sipindex#UndoDeleted() abort
    let save_cursor = getpos(".")
    call s:goto_win(1)
    execute 'normal! u'
    "execute 'w'
    call s:goto_win('l')
    call sipindex#ReloadIndex()
    call setpos('.', save_cursor)
    " code
endf

"nmap <buffer> <silent><CR> :call sipindex#SwitchAndGotoLine(getline('.'))<CR> 
"nmap <buffer> <silent><2-LeftMouse> :call sipindex#SwitchAndGotoLine(getline('.'))<CR> 
"nmap <buffer> <silent>r :call sipindex#ReloadIndex()<CR> 
