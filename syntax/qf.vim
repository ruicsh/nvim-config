if exists('b:current_syntax')
  finish
endif

syn match qfDirectory "^[^/]*" nextgroup=qfFileName
syn match qfFileName "/[^│]*" nextgroup=qfSeparatorLeft
syn match qfSeparatorLeft "│" contained nextgroup=qfLineNr
syn match qfLineNr "[^│]*" contained nextgroup=qfSeparatorRight
syn match qfSeparatorRight "│" contained nextgroup=qfSnippet
syn match qfSnippet ".*$" contained

hi def link qfSeparator WinSeparator
hi def link qfSeparatorLeft qfSeparator
hi def link qfSeparatorRight qfSeparator
hi def link qfLineNr LineNr

let b:current_syntax = 'qf'
