NAME := aurpublish
PREFIX ?= /usr/local
HOOKSDIR ?= $(PREFIX)/share/aurpublish
ZCOMPDIR ?= $(PREFIX)/share/zsh/site-functions
BASHCOMPDIR ?= $(shell pkg-config bash-completion --variable=completionsdir || echo '/usr/share/bash-completion/completions')

edit = sed -e 's|@HOOKSDIR@|$(HOOKSDIR)|g'

all: $(NAME)
$(NAME): $(NAME).in

%: %.in
	@rm -f $@
	$(edit) $< > $@
	@test -x '$@.in' && chmod a-w,+x $@

install: $(NAME)
	install -dm755 '$(DESTDIR)$(PREFIX)/bin'
	install -m755 $(NAME) '$(DESTDIR)$(PREFIX)/bin/$(NAME)'
	install -dm755 '$(DESTDIR)$(HOOKSDIR)'
	install -m755 *.hook '$(DESTDIR)$(HOOKSDIR)/'
	install -dm755 '$(DESTDIR)$(ZCOMPDIR)'
	install -dm755 '$(DESTDIR)$(BASHCOMPDIR)'
	install -m644 completion/_$(NAME) '$(DESTDIR)$(ZCOMPDIR)/_$(NAME)'
	install -m644 completion/$(NAME).bash '$(DESTDIR)$(BASHCOMPDIR)/$(NAME)'
