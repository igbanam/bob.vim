vim9script

##############################################################################
#
# File: bob.vim
# Author: @igbanam, https://github.com/igbanam
#
# License:   Permission is hereby granted to use and distribute this code,
#            with or without modifications, provided that this copyright
#            notice is copied with it. Like anything else that's free,
#            fileselect plugin is provided *as is* and comes with no warranty
#            of any kind, either expressed or implied. In no event will the
#            copyright holder be liable for any damages resulting from the use
#            of this software.
#
##############################################################################

if v:version < 802 || !has('patch-8.2.2261')
  finish
endif

import autoload 'utils.vim'

const SELECTION_TITLE = '[bob.vim] Select a build target'
const BUILD_COMMAND = ':Dispatch bazel build '
const RUN_COMMAND = ':Dispatch bazel run '
const REQUIRED = {
  ':Dispatch': 'tpope/vim-dispatch',
}


var garbage = [
  'Starting local Bazel server',
  'Extracting Bazel installation...',
  'checking cached actions',
  'Loading:'
]

export def Build(focus: string)
  if !focus->utils.IsBazelProject()
    echom "BoB says: This is not a Bazel project"
    return
  endif

  var targets = focus->FindTargets()

  targets->WithSelectionStrategy(utils.SelectionStrategy(), ExecuteBuild)
enddef

export def Run(focus: string)
  if !focus->utils.IsBazelProject()
    echom "BoB says: This is not a Bazel project"
    return
  endif

  var targets = focus->FindTargets()

  targets->WithSelectionStrategy(utils.SelectionStrategy(), ExecuteRun)
enddef

def FindTargets(focus: string): list<string>
  var targets = system('bazel query //' .. focus .. '/...')->split('\n')
  for _g in garbage
    targets->filter((i, v) => !v->trim()->StartsWith(_g))
  endfor
  return targets
enddef

def WithSelectionStrategy(targets: list<string>, selection_strategy: number, To_Execute: func(string))
  if selection_strategy == 0
    targets->Interactive(To_Execute)
  elseif selection_strategy == 1
    targets->First(To_Execute)
  else
    echom "BoB says: g:bob_build_only_target should be 0 or 1"
  endif
enddef

def Interactive(targets: list<string>, To_Execute: func(string))
  if exists('g:loaded_fzf')
    call fzf#run({
      source: targets,
      window: {
        'width': 0.9,
        'height': 0.6,
      },
      options: '--border-label="┤ ' .. SELECTION_TITLE .. ' ├"',
      sink: (chosen) => {
        chosen->To_Execute()
      }
    })
  else
  call popup_create(targets, {
    title: SELECTION_TITLE,
    pos: 'center',
    zindex: 200,
    drag: 1,
    wrap: 0,
    border: [],
    cursorline: 1,
    padding: [0, 1, 0, 1],
    filter: 'popup_filter_menu',
    mapping: 0,
    borderchars: ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
    callback: (_, chosen: number) => {
      if chosen > 0
        targets[chosen - 1]->To_Execute()
      endif
    },
  })
  endif
enddef

def First(targets: list<string>, To_Executor: func(string))
  targets[0]->To_Executor()
enddef

def ExecuteBuild(target: string)
  if exists(':Dispatch')
    execute BUILD_COMMAND .. target
  else
    echom '[bob.vim] requires ' .. REQUIRED->get(':Dispatch')
  endif
enddef

def ExecuteRun(target: string)
  if exists(':Dispatch')
    execute RUN_COMMAND .. target
  else
    echom '[bob.vim] requires ' .. REQUIRED->get(':Dispatch')
  endif
enddef

def StartsWith(longer: string, shorter: string): bool
  return longer[0 : len(shorter) - 1] ==# shorter
enddef

defcompile
