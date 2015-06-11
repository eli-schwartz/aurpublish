#!/bin/bash

usage()
{
	cat <<- _EOF_
		Usage: ./setup.sh [OPTIONS] COMMAND...
		Set up infrastructure for tracking PKGBUILDs.

		OPTIONS
		    -h, --help      show this usage message

		COMMANDS
		    ssh             append ssh-config rules
		    hooks           add commit hooks
_EOF_
}

ssh() {
    echo "Appending ssh-config rules..."
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

if [[ $# -eq 0 ]]; then
    echo "error: No arguments passed."
    echo "Try '${0} --help' for more information."
    exit 1
fi
while [[ "${1}" != "" ]]; do
    case ${1} in
        -h|--help)
            usage
            exit
            ;;
        ssh)
            ssh
            ;;
        hooks)
            hooks
            ;;
        *)
            echo "${0}: unrecognized option '${1}'"
            echo "Try '${0} --help' for more information."
            exit 1
    esac
    shift
done
