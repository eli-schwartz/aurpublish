##
#  usage : __in_array( $needle, $haystack )
# return : 0 - found
#          1 - not found
##
## shamelessly borrowed from makepkg
__in_array() {
	local needle=$1; shift
	local item
	for item in "$@"; do
		[[ $item = "$needle" ]] && return 0 # Found
	done
	return 1 # Not Found
}


_aurpublish() {
    local cur prev opts pkgnames
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="-s -p --speedup --pull log"

    if __in_array log "${COMP_WORDS[@]}"; then
        : # TODO: do git wrapping here
        return 0
    fi

    mapfile -td '' pkgnames < <(git ls-tree -dz --name-only HEAD :/)

    case $prev in
        # single-use arguments
        -h|--help|setup)
            return 0
            ;;
        @(${opts/ /|}))
            ;;
        *) if __in_array "$prev" "${pkgnames[@]}"; then
               return 0 # nothing left to do
           else
               COMPREPLY=($(compgen -W "${opts} -h --help setup" -- "${cur}"))
           fi
    esac

    mapfile -td '' -O "${#COMPREPLY[@]}" COMPREPLY < <(printf '%s\0' "${pkgnames[@]}" | grep -zE "^$cur")
}

complete -F _aurpublish aurpublish
