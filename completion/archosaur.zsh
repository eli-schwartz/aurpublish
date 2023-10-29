#compdef archosaur

local curcontext="$curcontext" state line libs idx
local -a pkg_dirs packages
typeset -A descs opt_args

# [keys]=commands 'vals'=description
descs[setup]='Install githooks to the repository.'
descs[log]='Wrapper for `git log`, substituting a package subtree for the revision/branch.'
pkg_dirs=(${${(M)${(@0)$(git ls-tree -dz --name-only HEAD :/ 2>/dev/null)}:#?*}/%/\/})

# leverage --help option parsing
_arguments -C -s \
	":COMMANDS/PACKAGES:((setup\\:'$descs[setup]' log\\:'$descs[log]' $pkg_dirs[*]))" \
	"*:PACKAGES:->pkgs" \
	-- && ret=0

# only complete package directories
case $state in
pkgs)
	packages=()
	if [[ ! $words[*] =~ (^|[[:blank:]])(setup)([[:blank:]]|$) ]]; then
		packages=($pkg_dirs)
	fi
	_wanted files expl 'ARGUMENTS' compadd -a packages && ret=0;
esac
