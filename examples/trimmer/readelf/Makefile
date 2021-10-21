BINUTILS=binutils
READELF=readelf
READELF_BITCODE=${READELF}.bc
READELF_VERSION=2.28
READELF_NAME=${BINUTILS}-${READELF_VERSION}
READELF_TAR=${READELF_NAME}.tar.gz

READELF_MANIFEST=${READELF}.manifest

OUT_DIR?=slash
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc

all: ${READELF_BITCODE}

test:
	@echo "\t\tTest Readelf"

	./readelf_occamized_stripped > t_out && \
	${READELF_NAME}/${BINUTILS}/${READELF} -a name > o_out
	@echo "Output comparison to Baseline:"
	@cmp -s ./t_out o_out; \
	RETVAL=$$?; \
	if [ $$RETVAL -eq 0 ]; then \
		echo "\treadelf test baseline compare? Passed!"; \
	else \
		echo "\treadelf test baseline compare? Failed!"; \
	fi
	@rm ./o_out
	@rm ./t_out


.PHONY: ${READELF_BITCODE}
${READELF_BITCODE}: ${READELF_NAME}
	cd ${READELF_NAME} && \
	CC=${BITCODE_WRAPPER} CFLAGS="-DHAVE_CONFIG_H -O0 -fno-inline -fno-inline-functions -Xclang -disable-O0-optnone" ./configure && \
	CC=${BITCODE_WRAPPER} make && \
	cd ${BINUTILS} && \
	${BITCODE_EXTRACT} ${READELF} && \
	mv ${READELF_BITCODE} ../..
		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${READELF_NAME}:
	wget https://github.com/shoaibCS/TRIMMER-applications/raw/master/trimmer/readlelf/binutils-2.28.tar.gz
	#wget ftp://sourceware.org/pub/binutils/snapshots/binutils-2.28.90.tar.bz
	tar -xvzf ./${READELF_TAR}

clean:
	rm -rf ${READELF_NAME} ${READELF_TAR}
	rm -rf *.bc *manifest *slash* *occamized*
	rm -r ${OUT_DIR}
