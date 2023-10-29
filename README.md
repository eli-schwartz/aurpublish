# archosaur

A package management framework for the [Arch User Repository](https://aur.archlinux.org)

## Meaning

### Etymology

From translingual Archosauria (“taxonomic division of extinct reptiles”), from
Ancient Greek ἄρχων (árkhōn, “leader”) + σαύρα (saúra, “lizard”).

### Noun

**archosaur** (plural archosaurs)

1. A reptile of the taxon Archosauria, which includes modern crocodilians and
birds, as well as the extinct pterosaurs, non-avian dinosaurs and other taxa.
2. Certainly, definitely, absolutely, not `Arch OS AUR`.

## Install

The standard `make && sudo make install` routine is used. The following
additional variables are supported:

* `DESTDIR` -- staged installs for distro packaging
* `PREFIX` -- where to install generated script, defaults to /usr/local
* `HOOKSDIR` -- where to install [githooks](#hooks), defaults to `<PREFIX>/share/archosaur`

## How it works

Commit PKGBUILDs in named subdirectories. Export them to the AUR with the `archosaur`
command, using the subtree push stratagem. This preserves an independent history
for third-party hosting, pull requests, etc.

## Commands

* `archosaur setup`

> Initialize a new repository with [githooks](#hooks).

* `archosaur PACKAGE`

> Push PACKAGE to the AUR. With "--speedup", merges the split history back in.

* `archosaur -p PACKAGE`

> Pull package from the AUR (if you adopted an existing package, or have a co-maintainer).

* `archosaur log PACKAGE`

> View the git log of a package subtree.

* `import-from-aur3.sh PACKAGE`

> Experimental. Download the history of a non-migrated AUR3 package, and commit
it to a new subtree.

## Hooks

* pre-commit

> Warn about whitespace errors, fail if checksums don't match, and auto-generate
.SRCINFO for all changed PKGBUILDs.

* prepare-commit-msg

> Prefill the commit message with a list of added/updated/deleted packages + versions
(if any).

* post-commit.hook

> Prevents .SRCINFO file rollbacks in the worktree caused by using `git commit --only`.

## License

This repository is licensed under `GPL-3.0-or-later`.

## Credits

Thanks to [eli-schwartz](https://github.com/eli-schwartz) for
[aurpublish](https://github.com/eli-schwartz/aurpublish), and to the
[#archlinux-aur](ircs://irc.libera.chat:6697/#archlinux-aur) community on Libera!
