let s:save_cpo = &cpo
set cpo&vim

let s:instance = operator#tabular#base#new()

function! s:instance.new() "{{{2
  return extend({}, self)
endfunction

function! s:instance.render(lines) "{{{2
  call self.log("preprocess start")
  call self.preprocess(a:lines)
  call self.log("preprocess end")

  let bufs = self.lines()
  call self.log("start", bufs)
  let lines = []
  let head_arr = get(remove(bufs, 0, 0), 0, [])
  call add(lines, "|" . join(self.fill_items(head_arr), "|") . "|h")
  for line in bufs
    call add(lines, "|" . join(self.fill_items(line), "|") . "|")
  endfor
  call self.log("finish", lines)
  " echo lines
  return join(lines, "\n")
endfunction

function! s:instance.restore_from_lines(buflines) "{{{2
  let buflines = map(copy(a:buflines), 'substitute(v:val, "^|\\||[vh]\\?$", "", "g")')

  let lines = map(buflines, 'self.split_and_trim(v:val, "|")')
  return lines
endfunction

" Interface {{{1
function! operator#tabular#backlog#new() "{{{2
  return s:instance.new()
endfunction

function! operator#tabular#backlog#tabularize_tsv(motion_wiseness)
  return s:instance.new().tabularize_tsv(a:motion_wiseness)
endfunction

function! operator#tabular#backlog#untabularize_tsv(motion_wiseness)
  return s:instance.new().untabularize_tsv(a:motion_wiseness)
endfunction

function! operator#tabular#backlog#tabularize_csv(motion_wiseness)
  return s:instance.new().tabularize_csv(a:motion_wiseness)
endfunction

function! operator#tabular#backlog#untabularize_csv(motion_wiseness)
  return s:instance.new().untabularize_csv(a:motion_wiseness)
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
