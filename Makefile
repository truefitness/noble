APPNAME=noble
VERSION := $(shell cd ./$(APPNAME); git describe --abbrev=0 --tags | sed 's/v//g' )
APPDIR=${APPNAME}_${VERSION}
#APPDIR=${APPNAME}_0.3.1
APPDIR=${APPNAME}_0.3.4
TARNAME=${APPDIR}.orig.tar.bz2


LIBS=bluetooth

PREFIX=/usr/local/bin
DESTDIR=
TOPDIR=$(DESTDIR)$(PREFIX)/truetouch/qml/BlueTooth/$(APPNAME)
BINDIR=$(TOPDIR)/build/Release
TMPDIR=debian/tmp

TARGET=./build/Release

DEPLOY=$(INSTALL)/$(APPNAME)/$(BIN)
SRCDIR=${APPNAME}/src
all: hci-ble l2cap-ble

show:
	@echo $(VERSION) $(APPDIR)
clean:
	rm -rf $(TMPDIR)

dist-clean: clean
	rm -rf $(APPDIR)
	rm -f $(TARNAME)


hci-ble:	$(SRCDIR)/hci-ble.c
	mkdir -p $(TMPDIR)
	$(CC) $< -l $(LIBS) -o $(TMPDIR)/hci-ble

l2cap-ble:	$(SRCDIR)/l2cap-ble.c
	mkdir -p $(TMPDIR)
	$(CC) $< -l $(LIBS) -o $(TMPDIR)/l2cap-ble

install: all
	mkdir -p $(BINDIR)
	cp -r ./${APPNAME}/* $(TOPDIR)
	cp $(TMPDIR)/* $(BINDIR)
tarball:
	@echo copying sourcetree
	@echo version $(VERSION)
	mkdir -p $(APPDIR)
	cp -a ./$(APPNAME) $(APPDIR)
	rm -rf $(APPDIR)/.git
	cp Makefile $(APPDIR)
	cp README.md $(APPDIR)
	@echo creating tar archive
	tar cjf ${TARNAME} ${APPDIR} --exclude-vcs

.PHONY : clean install dist-clean tarball
