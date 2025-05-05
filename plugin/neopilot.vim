if exists('g:loaded_neopilot')
  finish
endif
let g:loaded_neopilot = 1

command! -nargs=? -complete=customlist,neopilot#command#Complete Neopilot exe neopilot#command#Command(<q-args>)

if !neopilot#util#HasSupportedVersion()
    finish
endif

function! s:SetStyle() abort
  if &t_Co == 256
    hi def NeopilotSuggestion guifg=#808080 ctermfg=244
  else
    hi def NeopilotSuggestion guifg=#808080 ctermfg=8
  endif
  hi def link NeopilotAnnotation Normal
endfunction

function! s:MapTab() abort
  if !get(g:, 'neopilot_no_map_tab', v:false) && !get(g:, 'neopilot_disable_bindings')
    imap <script><silent><nowait><expr> <Tab> neopilot#Accept()
  endif
endfunction

augroup neopilot
  autocmd!
  autocmd InsertEnter,CursorMovedI,CompleteChanged * call neopilot#DebouncedComplete()
  autocmd BufEnter     * if neopilot#Enabled()|call neopilot#command#StartLanguageServer()|endif
  autocmd BufEnter     * if mode() =~# '^[iR]'|call neopilot#DebouncedComplete()|endif
  autocmd InsertLeave  * call neopilot#Clear()
  autocmd BufLeave     * if mode() =~# '^[iR]'|call neopilot#Clear()|endif

  autocmd ColorScheme,VimEnter * call s:SetStyle()
  " Map tab using vim enter so it occurs after all other sourcing.
  autocmd VimEnter             * call s:MapTab()
  autocmd VimLeave             * call neopilot#ServerLeave()
augroup END


imap <Plug>(neopilot-dismiss)     <Cmd>call neopilot#Clear()<CR>
imap <Plug>(neopilot-next)     <Cmd>call neopilot#CycleCompletions(1)<CR>
imap <Plug>(neopilot-next-or-complete)     <Cmd>call neopilot#CycleOrComplete()<CR>
imap <Plug>(neopilot-previous) <Cmd>call neopilot#CycleCompletions(-1)<CR>
imap <Plug>(neopilot-complete)  <Cmd>call neopilot#Complete()<CR>

if !get(g:, 'neopilot_disable_bindings')
  if empty(mapcheck('<C-]>', 'i'))
    imap <silent><script><nowait><expr> <C-]> neopilot#Clear() . "\<C-]>"
  endif
  if empty(mapcheck('<M-]>', 'i'))
    imap <M-]> <Plug>(neopilot-next-or-complete)
  endif
  if empty(mapcheck('<M-[>', 'i'))
    imap <M-[> <Plug>(neopilot-previous)
  endif
  if empty(mapcheck('<M-Bslash>', 'i'))
    imap <M-Bslash> <Plug>(neopilot-complete)
  endif
  if empty(mapcheck('<C-k>', 'i'))
    imap <script><silent><nowait><expr> <C-k> neopilot#AcceptNextWord()
  endif
  if empty(mapcheck('<C-l>', 'i'))
    imap <script><silent><nowait><expr> <C-l> neopilot#AcceptNextLine()
  endif
endif

call s:SetStyle()

let s:dir = expand('<sfile>:h:h')
if getftime(s:dir . '/doc/neopilot.txt') > getftime(s:dir . '/doc/tags')
  silent! execute 'helptags' fnameescape(s:dir . '/doc')
endif

function! NeopilotEnable()  " Enable Neopilot if it is disabled
  let g:neopilot_enabled = v:true
  call neopilot#command#StartLanguageServer()
endfun

command! NeopilotEnable :silent! call NeopilotEnable()

function! NeopilotDisable() " Disable Neopilot altogether
  let g:neopilot_enabled = v:false
endfun

command! NeopilotDisable :silent! call NeopilotDisable()

function! NeopilotToggle()
  if exists('g:neopilot_enabled') && g:neopilot_enabled == v:false
      call NeopilotEnable()
  else
      call NeopilotDisable()
  endif
endfunction

command! NeopilotToggle :silent! call NeopilotToggle()

function! NeopilotManual() " Disable the automatic triggering of completions
  let g:neopilot_manual = v:true
endfun

command! NeopilotManual :silent! call NeopilotManual()

function! NeopilotAuto()  " Enable the automatic triggering of completions
  let g:neopilot_manual = v:false
endfun

command! NeopilotAuto :silent! call NeopilotAuto()

function! NeopilotChat()
  call neopilot#Chat()
endfun

command! NeopilotChat :silent! call NeopilotChat()

:amenu Plugin.Neopilot.Enable\ \Neopilot\ \(\:NeopilotEnable\) :call NeopilotEnable() <Esc>
:amenu Plugin.Neopilot.Disable\ \Neopilot\ \(\:NeopilotDisable\) :call NeopilotDisable() <Esc>
:amenu Plugin.Neopilot.Manual\ \Neopilot\ \AI\ \Autocompletion\ \(\:NeopilotManual\) :call NeopilotManual() <Esc>
:amenu Plugin.Neopilot.Automatic\ \Neopilot\ \AI\ \Completion\ \(\:NeopilotAuto\) :call NeopilotAuto() <Esc>
:amenu Plugin.Neopilot.Toggle\ \Neopilot\ \(\:NeopilotToggle\) :call NeopilotToggle() <Esc>
:amenu Plugin.Neopilot.Chat\ \Neopilot\ \(\:NeopilotChat\) :call NeopilotChat() <Esc>
