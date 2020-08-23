set laststatus=2
set statusline=
set statusline+=%#pandocDefinitionTerm#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#ErrorMsg#%{(mode()=='i')?'\ \ INSERT\ ':''}
set statusline+=%#DiffDelete#%{(mode()=='r')?'\ \ RPLACE\ ':''}
set statusline+=%#Cursor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
set statusline+=\ %2M
set statusline+=\ %2F  
"       put things on the right 
set statusline+=%=
set statusline+=\ %2l:%c/%2L
set statusline+=\ %2p%%
set statusline+=\ [%n]
