" vim: sw=2 et foldenable

if exists("b:current_syntax") | finish | endif
let b:current_syntax = "acrylic"

setlocal foldmethod=syntax
setlocal indentexpr=indent(v:lnum) " dummy indent

" Symbols, tags and builtins {{{
syn match acrSymbol /\v\@(fold|end)@!(\w+)/ nextgroup=acrSymbol
syn match acrTag /\v\%(\w+)/

let s:builtins = ["set", "get", "ref"]
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

" Inline regions {{{
" The usual, adapted from VimWiki - code, bold and italic.

syn region acrInlineCode start=/`/ skip=/\\`/ end=/\v(`|$)/
      \ contains=acrSpecialChar

syn region acrInlineBold start=/\*/ skip=/\\\*/ end=/\v(\*|$)/
      \ contains=acrSpecialChar,acrInlineItalic

syn region acrInlineItalic start=/_/ skip=/\\_/ end=/\v(_|$)/
      \ contains=acrSpecialChar,acrInlineBold

syn match acrSpecialChar /\v\\[*_`\\]/

" }}}

" Folding + @fold/@end {{{
" This one is reponsible for @fold foldings and also the highlighting of
" @fold and @end as builtins, because I couldn't get it to do it in any
" other way
syn region acrFoldSym matchgroup=acrBuiltin fold transparent
      \ start='\v^\@fold>\ze(.*):(\s*)$' end='\v^\@end>'

" I'm not fully sure what this means
" Origin: https://www.vim.org/scripts/script.php?script_id=2462
syn region acrFoldTag fold transparent
      \ start="\v\%-fold" end="\ze\%(\s*\n\)\+\%(\z1\s\)\@!."
" }}}

hi def link acrSpecialChar SpecialChar
hi def link acrEscapedBackquote acrSpecialChar

hi def link acrInlineCode String
hi def link acrInlineBold Bold
hi def link acrInlineItalic Italic
hi def link acrSymbol Function
hi def link acrComment Comment
hi def link acrBuiltin Keyword
hi def link acrHeaderOption Function
hi def link acrTag Function
hi def link acrTaskDone Comment

let s:URL_CHARS_MATCH = '[a-zA-Z0-9/\-\.%_?#=&+~:]'
let s:VIMW_URL_REGEX = '\v\[\[(' . s:URL_CHARS_MATCH . '+)(\|.*)?\]\]'
call matchadd("acrDeprecatedRef", s:VIMW_URL_REGEX)

hi link acrDeprecatedRef Function
