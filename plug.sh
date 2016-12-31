#!/bin/bash

declare -a plugins=("ctrlpvim/ctrlp.vim"
					"tpope/vim-commentary"
					"tpope/vim-fugitive"
					"tpope/vim-dispatch"
					"lifepillar/vim-mucomplete"
					"SirVer/ultisnips"
					"majutsushi/tagbar"
					"manasthakur/vim-sessionist"
					"manasthakur/vim-scratchpad"
					"manasthakur/vim-seoul"
					)

if [[ $1 == "init" ]]; then
	for repo in "${plugins[@]}"
	do
		echo "Installing ${repo}"
		git submodule add https://github.com/${repo}.git pack/myplugins/start/${repo#*/}
		echo
	done
elif [[ $1 == "install" ]]; then
	git submodule add https://github.com/${2}.git pack/myplugins/start/${2#*/}
elif [[ $1 == "update" ]]; then
	git submodule foreach git pull
elif [[ $1 == "remove" ]]; then
	echo "Removing ${2}"
	git submodule deinit pack/myplugins/start/${2}
	git rm ${2}
fi

