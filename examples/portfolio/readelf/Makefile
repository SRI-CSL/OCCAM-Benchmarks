
COMPILER=gclang
EXTRACT_BC=get-bc
CURDIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))
ROOT_DIR=$(PWD)
INSTALL_DIR=$(ROOT_DIR)/binutils-install

all: readelf.bc 

binutils:
	@echo "Downloading binutils. It may take a while ..."
	git clone git://sourceware.org/git/binutils-gdb.git binutils


### ----- BUILD binutils: objdump, readelf, size, ... ------###
# The binutils need bfd, libiberty, opcodes. We try to disable the rest of stuff
binutils/binutils/readelf: binutils
	cd binutils; CC=${COMPILER} ./configure --disable-gdb --disable-libdecnumber --disable-readline --disable-sim --disable-ld --disable-as --disable-intl --disable-zlib --disable-gprof --disable-gnulib --disable-libctf --disable-gas --disable-gdbserver --disable-etc --disable-gnulib --disable-gdbsupport --prefix=${INSTALL_DIR} ; make -j ; make install
###---------------------------------------------------------###

readelf.bc: binutils/binutils/readelf
	cd ${INSTALL_DIR}/bin; ${EXTRACT_BC} readelf; mv readelf.bc ${ROOT_DIR}

.PHONY: slash
slash:
	${CURDIR}/build.sh

clean:
	rm -rf slash
	rm -rf readelf.manifest
	rm -rf readelf_orig
	rm -rf readelf_occamized

distclean: clean
	rm -rf binutils readelf.bc readelf

spotless: distclean
	rm -rf binutils-install

