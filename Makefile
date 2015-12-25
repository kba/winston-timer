VERSION = $(shell grep version package.json | grep -oE '[0-9\.]+')
PKGNAME = $(shell grep name package.json |/bin/grep -o '[^"]*",'|/bin/grep -o '[^",]*')

PANDOC = pandoc -s -t man 
NPM = npm
COFFEE = coffee -c -p -b

MKDIR = mkdir -p
MKTEMP = mktemp -d --tmpdir "make-$(PKGNAME)-XXXXXXX"
RM = rm -rf
LN = ln -fsrv
CP = cp -r

TARGET = index.js

$(TARGET): src/lib/index.coffee
	$(COFFEE) $< > $(TARGET)

clean:
	$(RM) $(TARGET)
