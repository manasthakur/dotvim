# Manas's vim setup

This is my personal vim-configuration.
It keeps changing based on my needs and experience.
As the current configuration uses the package feature added in Vim 8, it may not
work properly in lower Vim versions of Vim.
In such a case, simply use the included 'vimrc-pluginless' as `.vimrc`.

## Usage

- Clone repository
```
git clone --recursive https://manasthakur@bitbucket.org/manasthakur/myvim.git
```

- Symlink `.vim`:
```
ln -sf <path-to-myvim> ~/.vim
```

- Symlink `.vim`:
```
ln -sf <path-to-myvim>/vimrc ~/.vimrc	" Use <path-to-myvim>/mac_vimrc on macOS
```

- Generate helptags
```
vim
:helptags ALL
```

Plugins get installed into `.vim/pack/myplugins/start/`, which is the default
`packpath` to load plugins by vim8's builtin package manager. See `:h packages`.

### Updating plugins

To update all the plugins, go to `.vim` and run `git submodule foreach git pull`.

To update a particular one, go to the plugin's directory inside `pack` and run
`git pull`.

A better workflow:
First `git fetch` a plugin, review changes, and then `git merge`.

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
* [Vinegar](https://github.com/tpope/vim-vinegar)
* [MuComplete](https://github.com/lifepillar/vim-mucomplete)
* [UltiSnips](https://github.com/SirVer/ultisnips)
* [Tagbar](https://github.com/majutsushi/tagbar)
* [Sessionist](https://github.com/manasthakur/vim-sessionist)
* [Scratchpad](https://github.com/manasthakur/vim-scratchpad)
* [Seoul](https://github.com/manasthakur/vim-seoul)
* [Cscope](http://cscope.sourceforge.net/cscope_maps.vim)

## License

[MIT](LICENSE)

