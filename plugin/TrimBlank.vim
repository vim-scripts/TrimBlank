" Version: 0.2
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


function s:TrimTrailingBlank( blank_characters, first_line, last_line )  " trim trailing blank characters {{{1
    for i in range( a:first_line, a:last_line, 1 )
        let l:curline_string = getline( i )

        if strlen(l:curline_string) == 0
            continue
        endif

        " trim trailing blank characters
        for j in range( strlen(l:curline_string)-1, 0, -1 )
            if match( a:blank_characters, strpart( l:curline_string, j, 1 ) ) == -1
                call setline( i, strpart( l:curline_string, 0, j+1 ) )
                break
            endif

            " if j is zero, which means current line comprises only blank characters, then set current line to empty
            if j == 0
                call setline( i, '' )
            endif
        endfor
    endfor
endfunction

function s:TrimBlankLines( blank_characters, first_line, last_line ) " trim blank lines {{{1
    let l:lines_to_remove = []
    for i in range( a:first_line, a:last_line, 1 )
        let l:curline_string = getline( i )
        let l:is_blank = 1

        for j in range( 0, strlen( l:curline_string ) - 1, 1 )
            " if this is not a blank line
            if match( a:blank_characters, strpart( l:curline_string, j, 1 ) ) == -1
                let l:is_blank = 0
                break
            endif
        endfor

        if l:is_blank
            let l:lines_to_remove = add( l:lines_to_remove, i )
        endif
    endfor

    for i in reverse( l:lines_to_remove )
        exec i.'d'
    endfor
endfunction

function s:TrimAllBlank( blank_characters, first_line, last_line ) " trim both blank lines and trailing blank characters {{{1
    call s:TrimTrailingBlank( a:blank_characters, a:first_line, a:last_line )
    call s:TrimBlankLines( a:blank_characters, a:first_line, a:last_line )
endfunction

" commands {{{1
command -range TBTrimTrailing call s:TrimTrailingBlank( g:TrimBlank_BlankCharacters, <line1>, <line2> )
command -range TBTrimBlankLines call s:TrimBlankLines( g:TrimBlank_BlankCharacters, <line1>, <line2> )
command -range TBTrimAllBlank call s:TrimAllBlank( g:TrimBlank_BlankCharacters, <line1>, <line2> )

" maps {{{1
nmap <Leader>ttb :TBTrimTrailing<CR>
vmap <Leader>ttb :TBTrimTrailing<CR>
nmap <Leader>tbl :TBTrimBlankLines<CR>
vmap <Leader>tbl :TBTrimBlankLines<CR>
nmap <Leader>tab :TBTrimAllBlank<CR>
vmap <Leader>tab :TBTrimAllBlank<CR>


" }}}

let &cpo = s:saved_cpo
unlet s:saved_cpo

" vim:fdm=marker et
