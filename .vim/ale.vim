function CheckIfFileExists(filename)
  if filereadable(a:filename)
    return 1
  endif

  return 0
endfunction

" Disable GHC linter if in a Haskell Stack project
if (CheckIfFileExists("./stack.yaml") == 1)
  let g:ale_linters = {
  \   'haskell': ['stack-build'],
  \}
endif

let g:ale_completion_enabled = 1
set omnifunc=ale#completion#OmniFunc
set completeopt=menu,menuone,popup,noselect,noinsert
