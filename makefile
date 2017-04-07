NAME='fortunereader'
PREFIX='/usr'
TEMPDIR := $(shell mktemp -u --suffix .$(NAME))

install:
	install -Dm 755 src/$(NAME).py $(PREFIX)/bin/$(NAME)
	install -Dm 644 LICENSE $(PREFIX)/share/licenses/$(NAME)/COPYING
	install -Dm 644 README.md $(PREFIX)/share/doc/$(NAME)/README
	msgfmt src/locale/en.po -o $(PREFIX)/share/en/LC_MESSAGES/fortunereader.mo
	msgfmt src/locale/es.po -o $(PREFIX)/share/es/LC_MESSAGES/fortunereader.mo
	msgfmt src/locale/es_ES.po $(PREFIX)/share/es_ES/LC_MESSAGES/fortunereader.mo
	chmod 644 $(PREFIX)/share/en/LC_MESSAGES/fortunereader.mo
	chmod 644 $(PREFIX)/share/es/LC_MESSAGES/fortunereader.mo
	chmod 644 $(PREFIX)/share/es_ES/LC_MESSAGES/fortunereader.mo

uninstall:
	rm -f $(PREFIX)/bin/$(NAME)
	rm -f $(PREFIX)/share/licenses/$(NAME)/COPYING
	rm -f $(PREFIX)/share/doc/$(NAME)/README
	rm -f $(PREFIX)/share/en/LC_MESSAGES/fortunereader.mo
	rm -f $(PREFIX)/share/es/LC_MESSAGES/fortunereader.mo
	rm -f $(PREFIX)/share/es_ES/LC_MESSAGES/fortunereader.mo

clean:
	rm -f packages/pacman/$(NAME)-*.pkg.tar.xz

togit: clean
	git add .
	git commit -m "Updated from makefile"
	git push origin

pacman:
	mkdir $(TEMPDIR)
	cp packages/pacman/PKGBUILD $(TEMPDIR)/
	cd $(TEMPDIR); makepkg -dr
	cp $(TEMPDIR)/$(NAME)-*.pkg.tar.xz packages/pacman/
	rm -rf $(TEMPDIR)
	@echo Package done!
	@echo Package is in `pwd`/packages/pacman/
