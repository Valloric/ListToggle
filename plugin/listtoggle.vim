" Copyright (C) 2012  Strahinja Val Markovic  <val@markovic.io>
"
" This file is part of ListToggle.
"
" ListToggle is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" ListToggle is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with ListToggle.  If not, see <http://www.gnu.org/licenses/>.
"
"
" See ':help listtoggle' for more information.

if exists('g:loaded_listtoggle')
  finish
endif
let g:loaded_listtoggle = 1

let g:lt_height = get( g:, 'lt_height', 10 )
let g:lt_location_list_toggle_map =
      \ get( g:, 'lt_location_list_toggle_map', '<leader>l' )
let g:lt_quickfix_list_toggle_map =
      \ get( g:, 'lt_quickfix_list_toggle_map', '<leader>q' )

" If the user has explicitly set some mappings, then we don't use <unique> when
" creating the mappings; the user obviously wants to use them
if g:lt_location_list_toggle_map != '<leader>l' ||
      \ g:lt_quickfix_list_toggle_map != '<leader>q'
  let s:unique = ''
else
  let s:unique = '<unique>'
endif

execute "nnoremap " . s:unique . " <silent> " .
      \ g:lt_location_list_toggle_map . " :LToggle<CR>"
execute "nnoremap " . s:unique . " <silent> " .
      \ g:lt_quickfix_list_toggle_map . " :QToggle<CR>"

command!  QToggle call s:QListToggle()
command!  LToggle call s:LListToggle()

function! s:LListToggle() abort
    let buffer_count_before = s:BufferCount()
    " Location list can't be closed if there's cursor in it, so we need 
    " to call lclose twice to move cursor to the main pane
    silent! lclose
    silent! lclose

    if s:BufferCount() == buffer_count_before
        execute "silent! lopen " . g:lt_height
    endif
endfunction

function! s:QListToggle() abort
    let buffer_count_before = s:BufferCount()
    silent! cclose

    if s:BufferCount() == buffer_count_before
        execute "silent! botright copen " . g:lt_height
    endif
endfunction

function! s:BufferCount() abort
    return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
endfunction
