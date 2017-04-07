NAME='fortunereader'
PREFIX='/usr'
TEMPDIR := $(shell mktemp -u --suffix .$(NAME))

install:
	msgfmt src/locale/es.po -o es.mo
	msgfmt src/locale/es_ES.po -o es_ES.mo
	install -Dm 755 src/$(NAME).py $(PREFIX)/bin/$(NAME)
	install -Dm 644 LICENSE $(PREFIX)/share/licenses/$(NAME)/COPYING
	install -Dm 644 README.md $(PREFIX)/share/doc/$(NAME)/README
	install -Dm 644 es.mo $(PREFIX)/share/locale/es/LC_MESSAGES/fortunereader.mo
	install -Dm 644 es_ES.mo $(PREFIX)/share/locale/es_ES/LC_MESSAGES/fortunereader.mo

uninstall:
	rm -f $(PREFIX)/bin/$(NAME)
	rm -f $(PREFIX)/share/licenses/$(NAME)/COPYING
	rm -f $(PREFIX)/share/doc/$(NAME)/README
	rm -f $(PREFIX)/share/locale/es/LC_MESSAGES/fortunereader.mo
	rm -f $(PREFIX)/share/locale/es_ES/LC_MESSAGES/fortunereader.mo

clean:
	rm -f *.mo
	rm -f packages/pacman/$(rAME)-*.pkg.tar.xz

togit: clean
	git add .
	git commit -m "Updated from makefile"
	git push origin

pacman: clean
	mkdir $(TEMPDIR)
	cp packages/pacman/PKGBUILD $(TEMPDIR)/
	cd $(TEMPDIR); makepkg -dr
	cp $(TEMPDIR)/$(NAME)-*.pkg.tar.xz packages/pacman/
	rm -rf $(TEMPDIR)
	@echo Package done!
	@echo Package is in `pwd`/packages/pacman/
