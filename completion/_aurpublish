#compdef aurpublish

local curcontext="$curcontext" state line libs idx
local -a pkg_dirs
typeset -A descs opt_args

# [keys]=commands 'vals'=description
descs[setup]='Install githooks to the repository.'
descs[log]='Wrap `git log` and substitute a package subtree for the revision/branch.'

# leverage --help option parsing
_arguments -C -s \
	":COMMANDS:((setup\\:'$descs[setup]' log\\:'$descs[log]'))" \
	":PACKAGES:->pkgs" \
	-- && ret=0

# only complete package directories
case $state in
pkgs)
	pkg_dirs=(${(M)${(@0)$(git ls-tree -dz --name-only HEAD :/ 2>/dev/null)}:#?*})
	_wanted files expl 'PACKAGES' compadd -a pkg_dirs && ret=0;
esac
