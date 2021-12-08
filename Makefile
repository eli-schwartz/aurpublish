NAME := aurpublish
PREFIX ?= /usr/local
HOOKSDIR ?= $(PREFIX)/share/aurpublish
ZCOMPDIR ?= $(PREFIX)/share/zsh/site-functions
MANS = doc/aurpublish.1
BASHCOMPDIR ?= $(shell pkg-config bash-completion --variable=completionsdir || echo '/usr/share/bash-completion/completions')
FISHCOMPDIR ?= $(PREFIX)/share/fish/vendor_completions.d

edit = sed -e 's|@HOOKSDIR@|$(HOOKSDIR)|g'

all: $(NAME) man
man: $(MANS)
$(NAME): $(NAME).in

%: %.in
	@rm -f $@
	$(edit) $< > $@
	@test -x '$@.in' && chmod a-w,+x $@

doc/%: doc/%.asciidoc doc/asciidoc.conf
	a2x --no-xmllint --asciidoc-opts="-f doc/asciidoc.conf" -d manpage -f manpage -D doc $<

install: all
	install -dm755 '$(DESTDIR)$(PREFIX)/bin'
	install -m755 $(NAME) '$(DESTDIR)$(PREFIX)/bin/$(NAME)'
	install -dm755 '$(DESTDIR)$(HOOKSDIR)'
	install -m755 *.hook '$(DESTDIR)$(HOOKSDIR)/'
	install -dm755 '$(DESTDIR)$(ZCOMPDIR)'
	install -dm755 '$(DESTDIR)$(BASHCOMPDIR)'
	install -dm755 '$(DESTDIR)$(FISHCOMPDIR)'
	install -m644 completion/$(NAME).zsh '$(DESTDIR)$(ZCOMPDIR)/_$(NAME)'
	install -m644 completion/$(NAME).bash '$(DESTDIR)$(BASHCOMPDIR)/$(NAME)'
	install -m644 completion/$(NAME).fish '$(DESTDIR)$(FISHCOMPDIR)/$(NAME).fish'
	for manfile in $(MANS); do \
		install -Dm644 $$manfile -t $(DESTDIR)$(PREFIX)/share/man/man$${manfile##*.}; \
	done
