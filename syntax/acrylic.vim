" vim: sw=2 et foldenable

if exists("b:current_syntax") | finish | endif
let b:current_syntax = "acrylic"

setlocal foldmethod=syntax
setlocal indentexpr=indent(v:lnum) " dummy indent

" Symbols, tags and builtins {{{

syn match acrMacro /\v(^|\s)\@(\w+)/
syn match acrTag /\v(^|\s)\%(\w+)/

let s:builtins = ["set", "get"]
for builtin_name in s:builtins
  exec 'syn match acrBuiltin /\v\@' .. builtin_name .. '>/'
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

" Math {{{
"
" Note(yohannd1): I tortured myself to make this work. Had to study the
" code in the official rust syntax plugin and it turns out that the
" ORDER of the goddamn OPTIONS matter. Had to put start/end after
" matchgroup... or something. Still don't get why.

syn region acrMathInline
      \ matchgroup=acrMathInline
      \ start=/\v(\${1,2}\{)/ skip=/\\}/ end=/}/
      \ contains=acrMathMacro,acrMathNested

syn region acrMathNested
      \ matchgroup=acrMathInline
      \ start=/{/ skip=/\\}/ end=/}/
      \ contains=acrMathMacro,acrMathNested contained transparent

syn region acrMathToEnd
      \ start=/\v(\${1,2}:)/ end=/\v($)/
      \ contains=acrMathMacro,acrMathNested

syn match acrMathMacro /\v\\(\w+|.)/ contained

" }}}

" Inline regions {{{
"
" Initially adapted from VimWiki

syn region acrInlineCode start=/`/ skip=/\\`/ end=/\v(`)/
      \ contains=acrSpecialChar

syn region acrInlineBold start=/\c\v(^|\s)\*[^ \t]/ skip=/\\\*/ end=/\c\v\*/
      \ contains=acrSpecialChar,acrInlineItalic

syn region acrInlineItalic start=/\c\v(^|\s)_[^ \t]/ skip=/\\_/ end=/\c\v_/
      \ contains=acrSpecialChar,acrInlineBold

syn match acrSpecialChar /\v\\[*_`\\]/

" }}}

" @code block {{{
syn region acrCodeBlock matchgroup=acrBuiltin
      \ start='\v^(\s*)\\code>\ze(.*):(\s*)$' end='\v^(\s*)\\end>'
syn region acrCodeBlock matchgroup=acrBuiltin
      \ start='\v^(\s*)\@code>\ze(.*):(\s*)$' end='\v^(\s*)\@end>'

" TODO: somehow know how many of these are needed to close it,
" dynamically
syn region acrCodeBlock matchgroup=acrBuiltin
      \ start='\v^(\s*)\@code>(.*)#\{(\s*)$' end='\v^(\s*)\}'
syn region acrCodeBlock matchgroup=acrBuiltin
      \ start='\v^(\s*)\@code>(.*)#\{{2}(\s*)$' end='\v^(\s*)\}{2}'
syn region acrCodeBlock matchgroup=acrBuiltin
      \ start='\v^(\s*)\@code>(.*)#\{{3}(\s*)$' end='\v^(\s*)\}{3}'
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
      \ start='\v(^|\s)\@ref>\(' end='\v($|\))'

syn region acrRef matchgroup=acrRefDelimiter contains=acrRefInner
      \ start='\v(^|\s)\@ref>\([^)]*\)\(' end='\v($|\))'
syn match acrRefInner /\v[^)]*/ contained

syn region acrOldRefNoTitle matchgroup=acrOldRefDelimiter contains=acrOldRefInner
      \ start='\v\[\[' end='\v($|\]\])'

syn region acrOldRef matchgroup=acrOldRefDelimiter contains=acrOldRefInner
      \ start='\v\[\[.*\|' end='\v($|\]\])'
syn match acrOldRefInner /\v[^\]]*/ contained

" }}}

" Urls
syn match acrUrl /\v(^|\s)[a-zA-Z]+:\/\/[^ \t]*/

hi def link acrSpecialChar SpecialChar

hi def link acrCodeBlock String
hi def link acrInlineCode String

hi def link acrMathMacro Function

hi def link acrInlineBold Bold
hi def link acrInlineItalic Italic
hi def link acrMacro Function
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
