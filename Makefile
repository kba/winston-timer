VERSION = $(shell grep version package.json | grep -oE '[0-9\.]+')
PKGNAME = $(shell grep name package.json |/bin/grep -o '[^"]*",'|/bin/grep -o '[^",]*')

PANDOC = pandoc -s -t man 
NPM = npm
COFFEE = coffee -c

MKDIR = mkdir -p
MKTEMP = mktemp -d --tmpdir "make-$(PKGNAME)-XXXXXXX"
RM = rm -rf
LN = ln -fsrv
CP = cp -r

BIN_TARGETS = $(shell find src/bin -type f -name "*.*" |sed 's,src/,,'|sed 's,\.[^\.]\+$$,,')
MAN_TARGETS = $(shell find src/man -type f -name "*.md"|sed 's,src/,,'|sed 's,\.md$$,.gz,')
COFFEE_TARGETS = $(shell find src/lib -type f -name "*.coffee"|sed 's,src/,,'|sed 's,\.coffee,\.js,')

lib: ${COFFEE_TARGETS}

lib/%.js: src/lib/%.coffee
	$(COFFEE) -o lib $<
