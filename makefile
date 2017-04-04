NAME='fortunereader'
PREFIX='/usr'
INSTALLDIR=$(PREFIX)'/usr/bin'
TEMPDIR := $(shell mktemp -u --suffix .$(THEMENAME))

install:
	install -Dm 755 src/$(NAME).py $(INSTALLDIR)/$(NAME)
uninstall:
	rm $(INSTALLDIR)/$(NAME)
clean:
	rm packages/pacman/PKGBUILD/*.pkg.tar.gz
togit:
	git add .
	git commit -m "Updated from makefile"
	git push origin

pacman:
	mkdir $(TEMPDIR)
	cp packages/pacman/PKGBUILD $(TEMPDIR)/
	cd $(TEMPDIR); makepkg -dr
	cp $(TEMPDIR)/$(NAME)-*.pkg.tar.xz packages/pacman/PKGBUILD/
	@echo Package done!
	@echo You can install it as root with:
	@echo pacman -U $(NAME)-*.pkg.tar.xz
