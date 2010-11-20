" File: autoload/TrimBlank.vim
" Version: 0.3.1
" see doc/TrimBlank.txt for more information

if v:version < 700
    finish
endif

let s:saved_cpo = &cpo
set cpo&vim

function!TrimBlank#GetVersion() " get the version of TrimBlank {{{1
    return 30
endfunction


function! TrimBlank#TrimTrailingBlank( blank_characters, first_line, last_line )  " trim trailing blank characters {{{1
    let l:total_trimmed_count = 0 " the total count of lines that are trimmed

    for i in range( a:first_line, a:last_line, 1 )
        let l:curline_string = getline( i )

        if strlen(l:curline_string) == 0
            continue
        endif

        " trim trailing blank characters
        for j in range( strlen(l:curline_string)-1, 0, -1 )
            if match( a:blank_characters, strpart( l:curline_string, j, 1 ) ) == -1
                if j != strlen(l:curline_string)-1 " that j does not equal to strlen(l:curline_string-1) means there is trailing blank characters
                    let l:total_trimmed_count += 1
                    call setline( i, strpart( l:curline_string, 0, j+1 ) )
                endif
                break
            endif

            " if j is zero, which means current line comprises only blank characters, then set current line to empty
            if j == 0
                call setline( i, '' )
            endif
        endfor
    endfor

    return l:total_trimmed_count
endfunction

function! TrimBlank#TrimBlankLines( blank_characters, first_line, last_line ) " trim blank lines {{{1
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

    return len( l:lines_to_remove )
endfunction

function! TrimBlank#TrimAllBlank( blank_characters, first_line, last_line ) " trim both blank lines and trailing blank characters {{{1
    let l:trailingCount = TrimBlank#TrimTrailingBlank( a:blank_characters, a:first_line, a:last_line )
    let l:blankLineCount = TrimBlank#TrimBlankLines( a:blank_characters, a:first_line, a:last_line )

    return [l:trailingCount, l:blankLineCount]
endfunction


" }}}



let &cpo = s:saved_cpo
unlet! s:saved_cpo

" vim: fdm=marker et
