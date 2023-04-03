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

  targets->BuildWithSelectionStrategy(utils.SelectionStrategy())
enddef

export def Run(focus: string)
  if !focus->utils.IsBazelProject()
    echom "BoB says: This is not a Bazel project"
    return
  endif

  var targets = focus->FindTargets()

enddef

def FindTargets(focus: string): list<string>
  var targets = system('bazel query //' .. focus .. '/...')->split('\n')
  for _g in garbage
    targets->filter((i, v) => !v->trim()->StartsWith(_g))
  endfor
  return targets
enddef

def BuildWithSelectionStrategy(targets: list<string>, selection_strategy: number)
  if selection_strategy == 0
    targets->BuildInteractive()
  elseif selection_strategy == 1
    targets->BuildFirst()
  else
    echom "BoB says: g:bob_build_only_target should be 0 or 1"
  endif
enddef

def BuildInteractive(targets: list<string>)
  if exists('g:loaded_fzf')
    call fzf#run({
      source: targets,
      window: {
        'width': 0.9,
        'height': 0.6,
      },
      options: '--border-label="┤ ' .. SELECTION_TITLE .. ' ├"',
      sink: (chosen) => {
        execute BUILD_COMMAND .. chosen
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
        execute BUILD_COMMAND .. targets[chosen - 1]
      endif
    },
  })
  endif
enddef

def BuildFirst(targets: list<string>)
  execute BUILD_COMMAND .. targets[0]
enddef

def StartsWith(longer: string, shorter: string): bool
  return longer[0 : len(shorter) - 1] ==# shorter
enddef

defcompile
