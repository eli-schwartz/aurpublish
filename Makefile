NAME := aurpublish
PREFIX ?= /usr/local
HOOKSDIR ?= $(PREFIX)/share/aurpublish

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
