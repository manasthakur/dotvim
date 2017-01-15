# Manas's vim setup

This is my personal vim-configuration.
It keeps changing based on my needs and experience.
As the current configuration uses the package feature added in Vim 8, it may not
work properly in lower Vim versions of Vim.
In such a case (or if plugin-configurations are not needed), use the included 'vimrc-minimal' instead of `vimrc`.

## Usage

- Clone repository into `$HOME/.vim`
```
git clone --recursive https://manasthakur@bitbucket.org/manasthakur/myvim.git ~/.vim
```

- Symlink `.vimrc`:
```
ln -sf ~/.vim/vimrc ~/.vimrc
```

- Generate helptags
```
vim
:helptags ALL
```

Plugins get installed into `.vim/pack/myplugins/start/`, which is the default
`packpath` to load plugins by vim8's builtin package manager. See `:h packages`.

### Updating plugins

To update all the plugins, go to `.vim` and run `git submodule foreach git pull origin master`.

To update a particular one, go to the plugin's directory inside `pack` and run
`git pull origin master`.

A better workflow:
First `git fetch origin master` a plugin, review changes, and then `git merge`.

On another machine, if a `git pull` for the main repository leads to uncommitted
changes in the submodules (as a few plugins got updated), perform a `git
submodule update` to change the state at which the submodules are.

### Add plugin

Go to `.vim` and run `git submodule add <plugin-url> pack/myplugins/start/plugin-name`.

If a plugin needs to be installed just for testing, it can be installed inside
`pack/myplugins/opt` and loaded using `:packadd plugin-name`.

### Remove plugin

Go to `.vim` and run:
```
git submodule deinit <path-to-plugin>
git rm -r <path-to-plugin>
rm -rf .git/modules/pack/myplugins/start/plugin-name
```

## Current plugins

* [CtrlP](https://github.com/ctrlpvim/ctrlp.vim)
* [Commentary](https://github.com/tpope/vim-commentary)
* [Fugitive](https://github.com/tpope/vim-fugitive)
* [Vinegar](https://github.com/manasthakur/vim-vinegar)
* [UltiSnips](https://github.com/SirVer/ultisnips)
* [Tagbar](https://github.com/majutsushi/tagbar)
* [Sessionist](https://github.com/manasthakur/vim-sessionist)
* [Scratchpad](https://github.com/manasthakur/vim-scratchpad)
* [Seoul](https://github.com/manasthakur/vim-seoul)
* [Cscope](http://cscope.sourceforge.net/cscope_maps.vim)

## License

[MIT](LICENSE)

