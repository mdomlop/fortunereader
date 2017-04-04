NAME='fortunereader'
PREFIX='/usr'
INSTALLDIR=$(PREFIX)'/usr/bin'
TEMPDIR := $(shell mktemp -u --suffix .$(THEMENAME))

install:
	install -Dm 755 src/$(NAME).py $(INSTALLDIR)/$(NAME)
uninstall:
	rm -f $(INSTALLDIR)/$(NAME)
clean:
	rm -f packages/pacman/PKGBUILD/*.pkg.tar.gz
togit: clean
	git add .
	git commit -m "Updated from makefile"
	git push origin

pacman:
	mkdir $(TEMPDIR)
	cp packages/pacman/PKGBUILD $(TEMPDIR)/
	cd $(TEMPDIR); makepkg -dr
	pwd
	ls
	cp $(TEMPDIR)/$(NAME)-*.pkg.tar.xz ./packages/pacman/PKGBUILD/
	@echo Package done!
	@echo You can install it as root with:
	@echo pacman -U $(NAME)-*.pkg.tar.xz
