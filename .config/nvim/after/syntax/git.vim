syn match gitLgLine /^[_\*|\/\\ ]\+ \?\(\(.\+\s\\*\)\+\s*(\d\+ .\+) <\(.\+\s\?\)\+> \?\(\<\w\+\>\)\)\?$/
syn match gitLgInfo /(.*/ contained containedin=gitLgLine

syn match gitLgCommit /^[^(]\+ (\@!/ contained containedin=gitLgLine nextgroup=gitLgDate skipwhite
syn match gitLgRefs /([^)]*)/ contained containedin=gitLgInfo
syn match gitLgDate /(\d\+[^)]* ago)/ contained containedin=gitLgInfo nextgroup=gitLgIdentity skipwhite
syn match gitLgIdentity /<[^>]*>/ contained containedin=gitLgLine nextgroup=gitLgHash skipwhite
syn match gitLgHash /\<\w\+\>$/ contained containedin=gitLgLine

syn match gitLgGraph /^[_\*|\/\\ ]\+/ contained containedin=gitLgCommit nextgroup=gitHashAbbrev skipwhite

hi def link gitLgGraph    Comment
hi def link gitLgRefs     gitReference
hi def link gitLgDate     gitDate
hi def link gitLgIdentity gitIdentity
hi def link gitLgHash     Identifier
