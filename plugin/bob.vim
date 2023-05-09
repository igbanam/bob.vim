vim9script noclear

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

if exists("g:loaded_bob")
  finish
endif
g:loaded_bob = 1

import autoload 'bob.vim'

if !hasmapto('<Plug>BuildNearest;')
  map <unique> <leader>bb <Plug>BobBuildNearest;
endif

noremap <unique> <script> <Plug>BobBuildNearest; <SID>BuildNearest
noremenu <script> Plugin.Build\ Nearest          <SID>BuildNearest
noremap <SID>BuildNearest :call <SID>bob.Build(expand("%:h"))<cr>

if !exists(":BobBuild")
  command -nargs=1  BobBuild  :call bob.Build(<q-args>)
endif

if !hasmapto('<Plug>RunNearest;')
  map <unique> <leader>br <Plug>BobRunNearest;
endif

noremap <unique> <script> <Plug>BobRunNearest; <SID>RunNearest
noremenu <script> Plugin.Run\ Nearest          <SID>RunNearest
noremap <SID>RunNearest :call <SID>bob.Run(expand("%:h"))<cr>

if !exists(":BobRun")
  command -nargs=1  BobRun  :call bob.Run(<q-args>)
endif
