"==============================================================
"    file: autoflake.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfy@tenfy.cn
" created: 2019-05-28 20:12:36
"==============================================================

function! autoflake#execute(bang, option)
  if &ft != 'python'
    return
  endif

  if !executable('autoflake')
    echohl ErrorMsg
    echom "Please install autoflake first. (pip install autoflake)"
    echohl None
    return
  endif

  noautocmd write
  let filename = expand('%:p')

  if a:bang
    call <SID>execute_diff(filename, a:option)
  else
    call <SID>execute_inplace(filename, a:option)
  endif
endfunction

" dump the current file to a tempfile
" execute autoflake inplace to the tempfile
" delete the content of the current file and then fetch from the tempfile
function! s:execute_inplace(filename, option)
  let saved_cursor = getpos('.')
  let option = '-i ' . a:option
  let tmpfile = tempname()
  call system(printf('cat %s > %s', a:filename, tmpfile))
  let command = printf('autoflake %s %s', option, tmpfile)
  call system(command)
  %d
  execute 'read ' . tmpfile
  1d
  call delete(tmpfile)
  call setpos('.', saved_cursor)
endfunction

function! s:execute_diff(filename, option)
  let command = printf('autoflake %s %s', a:option, a:filename)
  let result = systemlist(command)
  if len(result) > 0 
    call <sid>show(result)
  endif
endfunction

function! s:show(result)
  botright new autoflake
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call append(0, a:result)
  setlocal nomodifiable
  setlocal nonu nornu
  setlocal filetype=diff
endfunction
