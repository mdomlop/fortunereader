NAME='fortunereader'
PREFIX='/usr'
INSTALLDIR=$(PREFIX)'/usr/bin'
TEMPDIR := $(shell mktemp -u --suffix .$(NAME))

install:
	install -Dm 755 src/$(NAME).py $(INSTALLDIR)/$(NAME)
uninstall:
	rm -f $(INSTALLDIR)/$(NAME)
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
	@echo Package was in `pwd`/packages/pacman/
