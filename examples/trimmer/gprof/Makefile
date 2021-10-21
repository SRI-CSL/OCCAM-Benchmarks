BINUTILS=binutils
GPROF=gprof
GPROF_BITCODE=${GPROF}.bc
GPROF_VERSION=2.28
GPROF_NAME=${BINUTILS}-${GPROF_VERSION}
GPROF_TAR=${GPROF_NAME}.tar.gz

GPROF_MANIFEST=${GPROF}.manifest
INPUT=$(shell pwd)/name

OUT_DIR?=slash
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc

all: ${GPROF_BITCODE}

test:
	@echo "\t\tTest gprof"	
	./gprof_occamized_stripped > t_out && \
	${GPROF_NAME}/${GPROF}/${GPROF} -q ${INPUT} > o_out
	@echo "Output comparison to Baseline:"
	@cmp -s ./t_out o_out; \
	RETVAL=$$?; \
	if [ $$RETVAL -eq 0 ]; then \
		echo "\tgprof test baseline compare? Passed!"; \
	else \
		echo "\tgprof test baseline compare? Failed!"; \
	fi
	@rm ./o_out
	@rm ./t_out


.PHONY: ${GPROF_BITCODE}
${GPROF_BITCODE}: ${GPROF_NAME}
	cd ${GPROF_NAME} && \
	CC=${BITCODE_WRAPPER} CFLAGS="-DHAVE_CONFIG_H -O0 -fno-inline -fno-inline-functions -Xclang -disable-O0-optnone" ./configure && \
	CC=${BITCODE_WRAPPER} make && \
	cd ${BINUTILS} && \
	cd ../${GPROF} && \
	${BITCODE_EXTRACT} ${GPROF} && \
	cp ${GPROF} ../../name && \
	mv ${GPROF_BITCODE} ../.. 

${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${GPROF_NAME}:
	wget https://github.com/shoaibCS/TRIMMER-applications/raw/master/trimmer/readlelf/binutils-2.28.tar.gz
	#wget ftp://sourceware.org/pub/binutils/snapshots/binutils-2.28.90.tar.bz
	tar -xvzf ./${GPROF_TAR}

clean:
	rm -rf ${GPROF_NAME} ${GPROF_TAR}
	rm -rf *.bc *manifest *slash* *occamized*
	rm -r ${OUT_DIR}
