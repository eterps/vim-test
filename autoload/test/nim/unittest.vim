let g:test#nim#unittest#patterns = {
  \ 'test':      ['\v^\s*test\s*%(''|")(.*)%(''|")'],
  \ 'namespace': ['\v^\s*suite\s*%(''|")(.*)%(''|")'],
\}

if !exists('g:test#nim#unittest#file_pattern')
  let g:test#nim#unittest#file_pattern = '\v\.nim$'
endif

" Returns true if the given file belongs to your test runner
function! test#nim#unittest#test_file(file) abort
  return a:file =~# g:test#nim#unittest#file_pattern
  "return test#nim#test_file('unittest', g:test#nim#unittest#file_pattern, a:file)
endfunction

" Returns test runner's arguments which will run the current file and/or line
function! test#nim#unittest#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    "echom '>> ' . name
    if !empty(name)
      return [a:position['file'] . ' "' . substitute(name, "\\", "", "g") . '" ']
    else
      return [a:position['file']]
    endif
    "return [a:position['file'].':'.a:position['line']]
  else
    return [a:position['file']]
  endif
endfunction

function! test#nim#unittest#build_args(args) abort
  return a:args
endfunction

function! test#nim#unittest#executable() abort
  return 'nim c -r --hints:off'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#nim#unittest#patterns)
  "echom name
  let namespace_str = join(name['namespace'], '')
  let test_str = join(name['test'], '')
  return namespace_str . '::' . test_str
endfunction
