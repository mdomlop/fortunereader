NAME='fortunereader'
PREFIX='/usr'
INSTALLDIR=$(PREFIX)'/bin'
TEMPDIR := $(shell mktemp -u --suffix .$(THEMENAME))

install:
	install -Dm 755 src/$(NAME).py $(INSTALLDIR)/$(NAME)
uninstall:
	rm $(INSTALLDIR)/$(NAME)
clean:
	rm $(NAME)-*.pkg.tar.gz
togit:
	git add .
	git commit -m "Updated from makefile"
	git push origin

pacman:
	mkdir $(TEMPDIR)
	cp packages/pacman/PKGBUILD $(TEMPDIR)/
	cd $(TEMPDIR); makepkg
	cp $(TEMPDIR)/$(NAME)-*.pkg.tar.xz .
	@echo Package done!
	@echo You can install it as root with:
	@echo pacman -U $(NAME)-*.pkg.tar.xz
