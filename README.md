# Manas's vim setup

This is my personal vim-configuration.
It keeps changing based on my needs and experience.
Nothing should be kept in the vimrc without understanding its need and usage;
`:help option` is the way to go.

There is also a [minimal vimrc](vimrc-minimal) included that should work on most
Vim versions (useful over ssh).

Most of the snippets in [mysnippets](mysnippets) have been taken from [this
repository](https://github.com/honza/vim-snippets).

## Usage

- Clone repository into `$HOME/.vim`:

    ```
    git clone --recursive https://github.com/manasthakur/myvim.git ~/.vim
    ```

- Symlink `.vimrc` (not _needed_ in Vim 7.4+):

    ```
    ln -sf ~/.vim/vimrc ~/.vimrc
    ```

- Generate helptags:

    ```
    vim
    :helptags ALL
    ```

Plugins get installed into `.vim/pack/myplugins/start/`, which is the default
`packpath` to load plugins by Vim 8's builtin package manager. See `:h packages`.

### Updating plugins

To update all the plugins, go to `.vim` and run `git submodule foreach git pull origin master`.

To update a particular one, go to the plugin's directory inside `pack` and run
`git pull origin master`.

A better workflow:
First `git fetch origin master` a plugin, review changes, and then `git merge`.

On another machine, if a `git pull` for the main repository leads to uncommitted
changes in the submodules (as a few plugins got updated), perform `git submodule
update` to change the state of the submodules.

### Adding a plugin

Go to `.vim` and run `git submodule add <plugin-url> pack/myplugins/start/plugin-name`.

A plugin can be loaded on-demand by installing it into
`pack/myplugins/opt/`, and using `:packadd plugin-name` when it is needed.

### Removing a plugin

Go to `.vim` and run:

```
git submodule deinit <path-to-plugin>
git rm -r <path-to-plugin>
rm -rf .git/modules/pack/myplugins/start/plugin-name
```

## License

[MIT](LICENSE)

