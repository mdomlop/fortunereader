NAME='fortunereader'
PREFIX='/usr'
DESTDIR=''
TEMPDIR := $(shell mktemp -u --suffix .$(NAME))

all: mo doc

install:
	install -Dm 755 src/$(NAME).py $(DESTDIR)/$(PREFIX)/bin/$(NAME)
	install -Dm 644 LICENSE $(DESTDIR)/$(PREFIX)/share/licenses/$(NAME)/COPYING
	install -Dm 644 README.md $(DESTDIR)/$(PREFIX)/share/doc/$(NAME)/README
	install -Dm 644 resources/$(NAME).desktop $(DESTDIR)/$(PREFIX)/share/applications/$(NAME).desktop
	install -Dm 644 resources/$(NAME).svg $(DESTDIR)/$(PREFIX)/share/pixmaps/$(NAME).svg
	install -Dm 644 po/es.mo $(DESTDIR)/$(PREFIX)/share/locale/es/LC_MESSAGES/fortunereader.mo
	install -Dm 644 po/es_ES.mo $(DESTDIR)/$(PREFIX)/share/locale/es_ES/LC_MESSAGES/fortunereader.mo

uninstall:
	rm -f $(PREFIX)/bin/$(NAME)
	rm -f $(PREFIX)/share/licenses/$(NAME)/COPYING
	rm -f $(PREFIX)/share/doc/$(NAME)/README
	rm -f $(PREFIX)/share/locale/es/LC_MESSAGES/fortunereader.mo
	rm -f $(PREFIX)/share/locale/es_ES/LC_MESSAGES/fortunereader.mo

togit: purge doc
	git add .
	git commit -m "Update from makefile"
	git push origin

clean:
	rm -rf $(NAME)-*.pkg.tar.xz *.md *.mo

purge: clean
	rm -rf /tmp/tmp.*.$(NAME) makefile
	@echo makefile deleted. Execute configure script to generate it again.

pacman-remote: clean
	mkdir $(TEMPDIR)
	cp packages/pacman/git/PKGBUILD $(TEMPDIR)/
	cd $(TEMPDIR); makepkg
	cp $(TEMPDIR)/$(NAME)-*.pkg.tar.xz .
	@echo Package done!
	@echo You can install it as root with:
	@echo pacman -U $(NAME)-*.pkg.tar.xz

pacman: clean
	mkdir $(TEMPDIR)
	tar cf $(TEMPDIR)/$(NAME).tar ../$(NAME)
	cp packages/pacman/local/PKGBUILD $(TEMPDIR)/
	cd $(TEMPDIR); makepkg
	cp $(TEMPDIR)/$(NAME)-*.pkg.tar.xz .
	@echo Package done!
	@echo You can install it as root with:
	@echo pacman -U $(NAME)-*.pkg.tar.xz
