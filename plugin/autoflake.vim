"==============================================================
"    file: autoflake.vim
"   brief: 
" VIM Version: 8.0
"  author: tenfyzhong
"   email: tenfy@tenfy.cn
" created: 2019-05-28 20:09:14
"==============================================================

if exists('g:autoflake_vim_loaded')
  finish
endif
let g:autoflake_vim_loaded = 1
lockvar g:autoflake_vim_loaded

let saved_cpo = &cpo
set cpo&vim

function! s:arg_complete(arg_lead, cmd_line, cursor_pos)
  let args = [
        \ '--expand-star-imports',
        \ '--remove-all-unused-imports',
        \ '--ignore-init-module-imports',
        \ '--remove-duplicate-keys', 
        \ '--remove-unused-variables'
        \ ]

  return filter(args, 'v:val =~ "^" . a:arg_lead')
endfunction

command! -bang -complete=customlist,<SID>arg_complete -nargs=* Autoflake silent call autoflake#execute(<bang>0, <q-args>)

let &cpo = saved_cpo
