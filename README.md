# BoB — Building on Bazel

Ever found yourself in a repository managed by Bazel and be completely stumped,
you have to either go back into the command line, or — even worse — IntelliJ?
Build on Bazel allows Vim feel™ like an IDE when in such repositories.

## Installation

I recommend using [`junegunn/vim-plug`](https://github.com/junegunn/vim-plug)


    Plug 'igbanam/bob.vim'

## Usage

In any file in the Bazel project you want to build, use these keystrokes

    <leader>bb

## Configuration

| knob                     | reason                          |
| ---                      | ---                             |
| g:bob_selection_strategy | To choose how you want to build |

## Roadmap

- [x] Build selected target
- [ ] Delegate selector to FZF
- [ ] Test target
- [ ] …what else does one do with Bazel?
