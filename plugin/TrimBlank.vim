" File: plugin/TrimBlank.vim
" Version: 0.3.1
" GetLatestVimScripts: 3301 1 :AutoInstall: TrimBlank.zip
" see doc/TrimBlank.txt for more information


if v:version < 700
    finish
endif

" check whether this script is already loaded
if exists("g:loaded_TrimBlank")
    finish
endif
let g:loaded_TrimBlank = 1

if !exists( 'g:TrimBlank_BlankCharacters' )
    let g:TrimBlank_BlankCharacters = " \t"
endif

let s:saved_cpo = &cpo
set cpo&vim



" commands {{{1
command -range TBTrimTrailing 
            \echo TrimBlank#TrimTrailingBlank( g:TrimBlank_BlankCharacters, <line1>, <line2> ).' line(s) trimmed.'
command -range TBTrimBlankLines 
            \echo TrimBlank#TrimBlankLines( g:TrimBlank_BlankCharacters, <line1>, <line2> ).' blank line(s) removed.'
command -range TBTrimAllBlank 
            \let TrimBlank_temp = TrimBlank#TrimAllBlank( g:TrimBlank_BlankCharacters, <line1>, <line2> ) |
            \echo TrimBlank_temp[0].' line(s) trimmed and '.TrimBlank_temp[1].' blank line(s) removed.'

" maps {{{1
nmap <Leader>ttb :TBTrimTrailing<CR>
vmap <Leader>ttb :TBTrimTrailing<CR>
nmap <Leader>tbl :TBTrimBlankLines<CR>
vmap <Leader>tbl :TBTrimBlankLines<CR>
nmap <Leader>tab :TBTrimAllBlank<CR>
vmap <Leader>tab :TBTrimAllBlank<CR>

" menus {{{1


if has('gui_running') && has('menu')
    " get the leader
    if exists('g:mapleader')
        let s:leader = g:mapleader
    else
        let s:leader = '\'
    endif
    let s:leader = escape(s:leader, '\')

    nnoremenu PopUp.-TrimBlankSep- :
    vnoremenu PopUp.-TrimBlankSep- :
    inoremenu PopUp.-TrimBlankSep- :
    for menuroot in ['Plugin.TrimBlank', 'PopUp.TrimBlank']
        exec 'nnoremenu  '.menuroot.'.Trim\ Trailing\ Blank\ &Characters<tab>'.s:leader.'ttb :TBTrimTrailing<cr>'
        exec 'nnoremenu  '.menuroot.'.Trim\ Blank\ &Lines<tab>'.s:leader.'tbl :TBTrimBlankLines<cr>'
        exec 'nnoremenu  '.menuroot.'.Trim\ &All\ Blanks<tab>'.s:leader.'tab :TBTrimAllBlank<cr>'
        exec 'vnoremenu  '.menuroot.'.Trim\ Trailing\ Blank\ &Characters<tab>'.s:leader.'ttb :TBTrimTrailing<cr>'
        exec 'vnoremenu  '.menuroot.'.Trim\ Blank\ &Lines<tab>'.s:leader.'tbl :TBTrimBlankLines<cr>'
        exec 'vnoremenu  '.menuroot.'.Trim\ &All\ Blanks<tab>'.s:leader.'tab :TBTrimAllBlank<cr>'
        exec 'inoremenu  '.menuroot.'.Trim\ Trailing\ Blank\ &Characters<tab>'.s:leader.'ttb <C-O>:TBTrimTrailing<cr>'
        exec 'inoremenu  '.menuroot.'.Trim\ Blank\ &Lines<tab>'.s:leader.'tbl <C-O>:TBTrimBlankLines<cr>'
        exec 'inoremenu  '.menuroot.'.Trim\ &All\ Blanks<tab>'.s:leader.'tab <C-O>:TBTrimAllBlank<cr>'
    endfor

    unlet! s:leader
endif


" }}}

let &cpo = s:saved_cpo
unlet! s:saved_cpo

" vim:fdm=marker et
