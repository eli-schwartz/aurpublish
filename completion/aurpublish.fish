# aurpublish

set -l local_pkgs "(git ls-tree -d --name-only HEAD :/ 2>/dev/null)"

set -l all_pkgs
# Try to get a pkg list from AUR helpers, otherwise ask pacman for foreign packages
if type -q 'yay'
    set all_pkgs "(yay -Pc)"
else if type -q 'paru'
    set all_pkgs "(paru -Pc | string replace ' ' \t)"
else
    set all_pkgs "(pacman -Qqm)"
end

set -l subcmds setup log
complete -c aurpublish -n "not __fish_seen_subcommand_from $subcmds" -xa $local_pkgs -d 'Push a subtree to the AUR'
complete -c aurpublish -n "not __fish_seen_subcommand_from $subcmds" -a setup \
    -d 'Install githooks to the repository'
complete -c aurpublish -n "__fish_seen_subcommand_from setup" -x
complete -c aurpublish -n "not __fish_seen_subcommand_from $subcmds" -a log \
    -d 'Wrapper for `git log`, substituting a package subtree for the revision/branch.'
complete -c aurpublish -n "__fish_seen_subcommand_from log" -xa $local_pkgs

complete -c aurpublish -s p -ra $all_pkgs -d 'Instead of publishing, pull changes from the AUR'
complete -c aurpublish -s s -l speedup -d 'Speedup future publishing by recording the subtree history during a push'
complete -c aurpublish -s h -l help -d 'Prints a usage page'

