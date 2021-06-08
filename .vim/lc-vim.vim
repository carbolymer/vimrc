" two lines for better display of messages
" set cmdheight=2

" HLS
      " \ 'haskell': ['haskell-language-server-wrapper', '--lsp'],
" HIE
      " \ 'haskell': ['hie-wrapper', '-d', '--lsp'],


let g:LanguageClient_serverCommands = {
      \ 'haskell': ['haskell-language-server-wrapper', '--lsp'],
      \ 'python': ['pyls'],
      \ 'bash': ['bash-language-server', 'start']
      \ }
let g:LanguageClient_rootMarkers = ['*.cabal', 'stack.yaml']

function LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>

    nmap <Leader>ac :call LanguageClient#textDocument_codeAction()<CR>
    nmap <Leader>rn :call LanguageClient#textDocument_rename()<CR>
    xmap <Leader>F :call LanguageClient#textDocument_rangeFormatting_sync()<CR>
    nmap <Leader>F :call LanguageClient#textDocument_formatting()<CR>
    map <Leader>lc :call LanguageClient_contextMenu()<CR>
    map <Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>
    map <Leader>rf :call LanguageClient#textDocument_references()<CR>
    " set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
    let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
    let g:LanguageClient_serverStderr = '/tmp/LanguageClient_stderr.log'

    hi link LanguageClientInfo LanguageClientWarning
    hi link LanguageClientWarning Ignore
    hi link LanguageClientError Ignore

  endif
endfunction

autocmd FileType * call LC_maps()
