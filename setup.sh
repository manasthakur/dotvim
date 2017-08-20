mkdir -p pack/mine/start pack/mine/opt pack/others/start pack/others/opt

cd pack/mine/start/
git clone https://github.com/manasthakur/vim-commentor.git
git clone https://github.com/manasthakur/vim-minisnip.git

cd ../../others/start/
git clone https://github.com/tpope/vim-surround.git
git clone https://github.com/tpope/vim-fugitive.git
git clone -b job https://github.com/tpope/vim-dispatch.git
git clone https://github.com/justinmk/vim-dirvish.git

cd ~
ln -s ~/.vim/vimrc .vimrc
