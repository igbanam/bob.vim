vim9script

export def IsBazelProject(focus: string): bool
  return ["BUILD", "WORKSPACE"]
    ->map((i, v) => v->findfile(focus .. ';'))
    ->map((i, v) => !v->empty())
    ->reduce((acc, v) => acc || v)
enddef

export def SelectionStrategy(): number
  if exists('g:bob_selection_strategy')
    return g:bob_selection_strategy
  endif

  return 0
enddef
