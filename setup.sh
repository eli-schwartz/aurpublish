#!/bin/bash

ssh() {
	cat <<- _EOF_ >> ~/.ssh/config
		Host aur
		    User aur
		    Hostname aur4.archlinux.org
		    IdentityFile ~/.ssh/keys/aur
_EOF_
}

hooks() {
    echo "Adding commit hooks..."
    shopt -s nullglob
    for hook in *.hook; do
        ln -sf "$(pwd)/${hook}" ".git/hooks/${hook%.hook}"
    done
}

${1}
