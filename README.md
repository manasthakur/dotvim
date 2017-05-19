# Manas's vim setup

This is my personal vim-configuration.
It keeps changing based on my requirements and experience.
Even though well-commented, try not to copy anything without understanding its
need and usage; `:help option` is the way to go.

There is also a [minimal vimrc](vimrc-minimal) included that should work on most
Vim versions (useful for remote machines).

## Usage

- Clone repository into `$HOME/.vim`:

    ```
    git clone --recursive https://github.com/manasthakur/dotvim.git ~/.vim
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

Plugins installed in `.vim/pack/bundle/start/` get loaded automatically, and
those in `.vim/pack/bundle/opt/` (if any) can be loaded on-demand using `:packadd
<plugin-name>`.
The last section of [this
article](https://gist.github.com/manasthakur/ab4cf8d32a28ea38271ac0d07373bb53)
describes Vim 8's package feature in detail, and [this
article](https://gist.github.com/manasthakur/d4dc9a610884c60d944a4dd97f0b3560)
provides help on managing plugins using git submodules.

## License

[MIT](LICENSE)

