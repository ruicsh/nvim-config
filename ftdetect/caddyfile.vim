au BufNewFile,BufRead Caddyfile,*.Caddyfile,Caddyfile.* if expand('%:e') != 'vim' && expand('%:e') != 'lua' | set filetype=caddyfile | endif

