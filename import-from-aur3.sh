#!/bin/bash

### Declare usage.

usage()
{
	cat <<- _EOF_
		Usage: ./import-from-aur3.sh [OPTIONS] PACKAGE
		Import a non-migrated AUR3 package with history from the aur-mirror.

		Accepts the name of an AUR3 package and downloads the commit history
		from the aur-mirror, then formats each commit to include .SRCINFO and
		adds it to a new subfolder of your pkgbuilds repo.

		OPTIONS
		    -h, --help      show this usage message
_EOF_
}

# colors!

export RED="\e[01;31m" \
	BLU="\e[01;34m" \
	NRM="\e[00m"

msg() {
    printf "${BLU}==> $1\n${NRM}" >&2
}

error() {
    printf "${RED}==> ERROR: $1\n${NRM}" >&2
    exit 1
}

#### Do the great option check

if [[ $# -eq 0 ]]; then
    echo "${0#./}: No arguments passed. ${0#./} needs a package to download."
    echo "Try '${0} --help' for more information."
    exit 1
fi
case "${1}" in
    -h|--help)
        usage
        exit
        ;;
    *)
        package="${1}"
esac

if [[ ! -z "$(git status --porcelain --untracked-files=no)" ]]; then
    error "working tree not clean, ${0#./} requires a clean working tree to run."
fi

mkdir -p .patches

# Commit log of aur-mirror subfolder
if [[ ! -f ".patches/${package}.log" ]]; then
    msg "Downloading commit log..."
    wget -O .patches/${package}.log "http://pkgbuild.com/git/aur-mirror.git/log/${package}"
fi
# These are the commit hashes.
sed -nr 's@.*aur-mirror\.git/commit/'${package}'\?id=([a-z0-9]+).*@\1@p' .patches/${package}.log | tac > .patches/${package}.commits

# Download each commit in turn, with predictable names.
number=0
while read commit; do
    number=$((number+=1))
    patchnum="$(printf "%04d" ${number})"
    if [[ ! -f .patches/${patchnum}-${package}.patch ]]; then
        msg "Downloading ${package} patch #${number}..."
        wget -O .patches/${patchnum}-${package}.patch "http://pkgbuild.com/git/aur-mirror.git/patch/${package}?id=${commit}"
    fi
done < .patches/${package}.commits

# Fix buggy "create-a-file" patch output ???
sed -i -r "s@(a|b)/dev/null@/dev/null@g" .patches/*.patch

git am patches/*-${package}.patch
msg "Finished importing from aur-mirror."

msg "Running filter-tree to add .SRCINFO files and cleanup .AURINFO ..."
git filter-branch \
    --original refs/pre-import-${package} \
    --tree-filter 'mksrcinfo -o '${package}'/.SRCINFO '${package}'/PKGBUILD; rm -f '${package}'/.AURINFO' \
    --msg-filter 'echo "Imported old history from aur-mirror:"; cat; echo -e "\nfilter-branch: add .SRCINFO"' \
    -- HEAD~${number}..HEAD

msg "Some commits may be deletions (buggy mirroring scripts???) which will require manual cleanup. If you saw"
msg "\"ERROR: PKGBUILD not found in current directory\""
msg "above, that is a deletion."
msg "Try \`git log --name-status --pretty=oneline HEAD~${number}..HEAD\` to find and delete them."
