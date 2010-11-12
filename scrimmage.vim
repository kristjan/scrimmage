" scrimmage.vim - Scrimmage
" Author:       Kristján Pétursson <kristjan@gmail.com>
" Version:      1.0

" Distributable under the same terms as Vim itself (see :help license)

if (exists("g:loaded_scrimmage") && g:loaded_scrimmage)
    finish
endif
let g:loaded_scrimmage = 1

let g:scrimmage_default_lang = 'ruby'

function! Run()
  let curpos = getpos('.')
  execute ":b".s:filebuf
  if (s:ran)
    execute 'u'
  endif
  execute ":".s:startline.",".s:endline."!".s:filename
  execute ":b".s:scriptbuf
  execute ":set syntax=".g:scrimmage_default_lang
  call cursor(curpos[1], curpos[2])
  let s:ran = 1
endfunction

function! Scrimmage() range
  let s:ran = 0
  let s:filebuf = bufnr('%')
  let s:startline = a:firstline
  let s:endline = a:lastline

  let s:filename = tempname()
  silent execute ":!touch ".s:filename
  silent execute ":!chmod u+x ".s:filename
  execute ":vs ".s:filename
  execute ":r !which ".g:scrimmage_default_lang
  execute "normal I#!"
  execute "normal kddo"
  execute ":set syntax=".g:scrimmage_default_lang
  let s:scriptbuf = bufnr("%")
  autocmd BufWritePost <buffer> :silent call Run()
endfunction

map <Leader>s :call Scrimmage()<CR>
map <Leader>e :v:errmsg<CR>
map <Leader>q :qa!<CR>
