mkdir -p pack/mine/start pack/mine/opt pack/others/start pack/others/opt .sessions .swap

cd pack/mine/start/
git clone https://github.com/manasthakur/vim-commentor.git

cd ../opt/
git clone https://github.com/manasthakur/vim-asyncmake.git

cd ../../others/start/
git clone https://github.com/tpope/vim-surround.git
git clone https://github.com/tpope/vim-fugitive.git
git clone https://github.com/joereynolds/vim-minisnip.git

cd ../opt/
git clone https://github.com/majutsushi/tagbar
git clone https://github.com/romainl/vim-qf

cd ~
ln -s ~/.vim/vimrc .vimrc
