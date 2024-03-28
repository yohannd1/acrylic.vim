" vim: sw=2 et foldenable

if exists("b:current_syntax") | finish | endif
let b:current_syntax = "acrylic"

setlocal foldmethod=syntax
setlocal indentexpr=indent(v:lnum) " dummy indent

" Symbols, tags and builtins {{{
syn match acrSymbol /\v\@(\w+)/ nextgroup=acrSymbol
syn match acrSymbol /\v\\(\w+)/ nextgroup=acrSymbol
syn match acrTag /\v\%(\w+)/

let s:builtins = ["set", "get"]
for builtin_name in s:builtins
  exec 'syn match acrBuiltin /\v\@' .. builtin_name .. '>/'
  exec 'syn match acrBuiltin /\v\\' .. builtin_name .. '>/'
endfor

let s:builtins = ["fold", "id"]
for builtin_name in s:builtins
  exec 'syn match acrBuiltin /\v\%-' .. builtin_name .. '>/'
endfor
" }}}

" Tasks {{{

syn match acrTaskTodo /\v^(\s*)?([*-]+\s+)?(\[ \]|\( \))/
syn match acrTaskDone /\v^(\s*)?([*-]+\s+)?(\[x\]|\(x\))/

" }}}

syn match acrHeaderOption /\v^\s*\%:(\w+)/

syn region acrComment start=/%%/ end=/$/

" Inline regions {{{
" The usual, adapted from VimWiki - code, bold and italic.

syn region acrInlineCode start=/`/ skip=/\\`/ end=/\v(`|$)/
      \ contains=acrSpecialChar

syn region acrInlineBold start=/\c\v\*[0-9a-zÀ-ÿ]/ skip=/\\\*/ end=/\c\v([0-9a-zÀ-ÿ]\*|$)/
      \ contains=acrSpecialChar,acrInlineItalic

syn region acrInlineItalic start=/\c\v<_[0-9a-zÀ-ÿ]/ skip=/\\_/ end=/\c\v([0-9a-zÀ-ÿ]_>|$)/
      \ contains=acrSpecialChar,acrInlineBold

syn match acrSpecialChar /\v\\[*_`\\]/

" }}}

" @code block {{{
syn region acrCodeBlock matchgroup=acrBuiltin
      \ start='\v^(\s*)\\code>\ze(.*):(\s*)$' end='\v^(\s*)\\end>'
syn region acrCodeBlock matchgroup=acrBuiltin
      \ start='\v^(\s*)\@code>\ze(.*):(\s*)$' end='\v^(\s*)\@end>'
" }}}

" Folding + @fold block {{{
" This one is reponsible for @fold foldings and also the highlighting of
" @fold and @end as builtins, because I couldn't get it to do it in any
" other way
syn region acrFoldSym matchgroup=acrBuiltin fold transparent
      \ start='\v^(\s*)\\fold>\ze(.*):(\s*)$' end='\v^(\s*)\\end>'
syn region acrFoldSym matchgroup=acrBuiltin fold transparent
      \ start='\v^(\s*)\@fold>\ze(.*):(\s*)$' end='\v^(\s*)\@end>'

" I'm not fully sure what this means
" Origin: https://www.vim.org/scripts/script.php?script_id=2462
syn region acrFoldTag fold transparent
      \ start="\v\%-fold" end="\ze\%(\s*\n\)\+\%(\z1\s\)\@!."
" }}}

" Refs {{{

syn region acrRefNoTitle matchgroup=acrRefDelimiter contains=acrRefInner
      \ start='\v\@ref>\(' end='\v($|\))'

syn region acrRef matchgroup=acrRefDelimiter contains=acrRefInner
      \ start='\v\@ref>\(.*\)\(' end='\v($|\))'
syn match acrRefInner /\v[^)]*/ contained

syn region acrOldRefNoTitle matchgroup=acrOldRefDelimiter contains=acrOldRefInner
      \ start='\v\[\[' end='\v($|\]\])'

syn region acrOldRef matchgroup=acrOldRefDelimiter contains=acrOldRefInner
      \ start='\v\[\[.*\|' end='\v($|\]\])'
syn match acrOldRefInner /\v[^\]]*/ contained

" }}}

hi def link acrSpecialChar SpecialChar
hi def link acrEscapedBackquote acrSpecialChar

hi def link acrCodeBlock String
hi def link acrInlineCode String
hi def link acrInlineBold Bold
hi def link acrInlineItalic Italic
hi def link acrSymbol Function
hi def link acrComment Comment
hi def link acrBuiltin Keyword
hi def link acrHeaderOption Function
hi def link acrTag Function
hi def link acrTaskDone Comment
hi def link acrUrl Function

hi def link acrRefDelimiter Comment
hi def link acrRefInner Bold
hi def link acrOldRefDelimiter acrRefDelimiter
hi def link acrOldRefInner acrRefInner

let s:URL_CHARS_MATCH = '[a-zA-Z0-9/\-\.%_?#=&+~:]'
call matchadd("acrUrl", '\vhttps?://(' . s:URL_CHARS_MATCH . ')+')

let s:VIMW_URL_REGEX = '\v\[\[(' . s:URL_CHARS_MATCH . '+)(\|.*)?\]\]'
call matchadd("acrDeprecatedRef", s:VIMW_URL_REGEX)
