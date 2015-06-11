# PKGBUILDs for [Arch User Repository](https://aur.archlinux.org)
Includes control scripts for managing AUR packages.
Requires @falconindy's [pkgbuild-introspection](https://www.archlinux.org/packages/community/any/pkgbuild-introspection) tools to auto-generate .SRCINFO

## How it works
Commit PKGBUILDs in named subdirectories. Export them to the AUR with the included `aurpublish` script, using the subtree push stratagem.
This preserves an independent history for third-party hosting, pull requests... ;)


## Commands
* `./setup.sh ssh`
> Append ssh-config rules for accessing the AUR.

* `./setup.sh hooks`
> Install [githooks](#hooks).

* `./aurpublish PACKAGE`
> Push PACKAGE to the AUR. With "--new", registers the package.

## Hooks
* pre-commit
> Reject whitespace errors, and auto-generate .SRCINFO for all changed PKGBUILDs.

* prepare-commit-msg
> Prefill the commit message with a list of updated packages + versions (if any).

* post-commit
> Clear aurballs and generate a new, up-to-date aurball for all changed PKGBUILDs.
