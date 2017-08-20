# Manas's Vim setup

This is my personal vim-configuration.
It keeps changing based on my requirements and experience.
Even though well-commented, try not to copy anything without understanding its
need and usage; `:help option` is the way to go.

Minimum compatible version: Vim 7.2+.

## Usage

- Clone repository into `$HOME/.vim`:

    ```
    git clone https://github.com/manasthakur/dotvim.git $HOME/.vim
    ```

- Clone plugins:

    ```
    cd $HOME/.vim
    bash ./setup.sh
    ```

- Generate helptags:

    ```
    vim
    :helptags ALL
    ```

I use the package feature introduced in Vim 8 (an overview is available
[here](https://gist.github.com/manasthakur/ab4cf8d32a28ea38271ac0d07373bb53))
to manage my plugins.
Plugins installed in `.vim/pack/*/start/` get loaded automatically, and
those in `.vim/pack/*/opt/` (if any) can be loaded on-demand using `:packadd
<plugin-name>`.

## License

[MIT](LICENSE)

