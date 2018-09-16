" Vim syntastic plugin
" Language:   Rust
" Maintainer: Vincent Tavernier
"
" Based on Syntastic guide located at
" https://github.com/scrooloose/syntastic/wiki/Syntax-Checker-Guide#external

if exists('g:loaded_syntastic_rust_clippy_checker')
  finish
endif
let g:loaded_syntastic_rust_clippy_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_rust_clippy_IsAvailable() dict
  return executable(self.getExec())
endfunction

function! SyntaxCheckers_rust_clippy_GetLocList() dict
  " From rust.vim
  " Ignored patterns, and blank lines
  let errorformat  =
        \ '%-G,' .
        \ '%-Gerror: aborting %.%#,' .
        \ '%-Gerror: Could not compile %.%#,'

  " Meaningful lines (errors, notes, warnings, contextual information)
  let errorformat .=
        \ '%Eerror: %m,' .
        \ '%Eerror[E%n]: %m,' .
        \ '%Wwarning: %m,' .
        \ '%Inote: %m,' .
        \ '%C %#--> %f:%l:%c'

  " TODO: Turn this into options
  let args_before =
        \ [
        \   '--all-features',
        \   '--all-targets',
        \ ]

  let args = [ '--' ]
  let args_after = [  ]

  let makeprg = self.makeprgBuild({
        \ 'exe': self.getExec(),
        \ 'exe_after': 'clippy',
        \ 'args_before': args_before,
        \ 'args': args,
        \ 'args_after': args_after,
        \ 'fname': '' })

  return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
      \ 'filetype': 'rust',
      \ 'name': 'clippy',
      \ 'exec': 'cargo' })

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: sw=2:ts=2:et
