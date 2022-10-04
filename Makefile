#-------------------------------------------------------------------------------
# @author           Jean-David Gadina
# @copyright        (c) 2020, Jean-David Gadina - www.xs-labs.com
#-------------------------------------------------------------------------------

.PHONY: all clean distclean uncrustify_checkout uncrustify_update configure build install

.NOTPARALLEL:

all: uncrustify_checkout uncrustify_update configure build install
	
	@:

local: uncrustify_checkout uncrustify_update configure-local build-local install-local
	
	@:
	
clean:
	
	@echo "*** Cleaning all build files"
	@rm -rf build/*
	@rm -rf build-local/*

distclean: clean
	
	@echo "*** Cleaning all temporary files"
	@rm -rf source/*

uncrustify_checkout:

	@echo "*** Checking out Uncrustify"
	@if [ ! -d source/uncrustify ]; then git clone https://github.com/uncrustify/uncrustify.git source/uncrustify; fi
	
uncrustify_update:
	
	@echo "*** Updating Uncrustify"
	@cd source/uncrustify && git pull

configure:
	
	@echo "*** Configuring Uncrustify"
	@cd build && cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=/usr/local/uncrustify ../source/uncrustify

configure-local:
	
	@echo "*** Configuring Uncrustify"
	@cd build-local && cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=$(realpath dist) ../source/uncrustify

build:
	
	@echo "*** Building Uncrustify"
	@cd build && $(MAKE)
	
build-local:
	
	@echo "*** Building Uncrustify"
	@cd build-local && $(MAKE)

install:
	
	@echo "*** Installing Uncrustify"
	@cd build && $(MAKE) install

install-local:
	
	@echo "*** Installing Uncrustify"
	@cd build-local && $(MAKE) install
	@codesign --sign "Developer ID Application: Jean-David Gadina (326Y53CJMD)" --options runtime dist/bin/uncrustify
