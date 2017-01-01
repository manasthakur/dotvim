# Manas's vim setup

This is my personal vim-configuration.
It keeps changing based on my needs and experience.
As the current configuration uses the package feature added in Vim 8, it may not
work properly in lower Vim versions of Vim.

## Usage

- Clone repository
```
git clone https://manasthakur@bitbucket.org/manasthakur/myvim.git
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

Go to `.vim` and run `./plug.sh update`.

### Add plugin

Go to `.vim` and run `git submodule add <plugin-url>`.

### Remove plugin

Go to `.vim` and run:
```
git submodule deinit <path-to-plugin>
git rm -r <path-to-plugin>
```

## Current plugins (as listed in `myvim/plug.sh`)

* [CtrlP](https://github.com/ctrlpvim/ctrlp.vim)
* [Commentary](https://github.com/tpope/vim-commentary)
* [Fugitive](https://github.com/tpope/vim-fugitive)
* [Dispatch](https://github.com/tpope/vim-dispatch)
* [MuComplete](https://github.com/lifepillar/vim-mucomplete)
* [UltiSnips](https://github.com/SirVer/ultisnips)
* [Tagbar](https://github.com/majutsushi/tagbar)
* [Sessionist](https://github.com/manasthakur/vim-sessionist)
* [Scratchpad](https://github.com/manasthakur/vim-scratchpad)
* [Seoul](https://github.com/manasthakur/vim-seoul)
* [Cscope](http://cscope.sourceforge.net/cscope_maps.vim)

## License

[MIT](LICENSE)

