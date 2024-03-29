BZIP=bzip2
BZIP_BITCODE=${BZIP}.bc
BZIP_VERSION=1.0.5
BZIP_NAME=${BZIP}-${BZIP_VERSION}
BZIP_TAR=${BZIP_NAME}.tar.gz

BZIP_MANIFEST=${BZIP}.manifest

HELPER_SCRIPT=./build.sh
HELPER_TAR=helper_scripts_and_files.tar.gz


OUT_DIR?=slash
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc

all: ${BZIP_BITCODE}

compress: ${OUT_DIR} ${BZIP_BITCODE}
	cp ${BZIP_BITCODE} ${OUT_DIR}
	cd ${OUT_DIR} && \
	echo '{"binary": "bzip2_fin", "native_libs": [], "name": "bzip2", "args": ["-fkqs", "huffman.c"], "modules": [], "ldflags": ["-lbz2"], "main": "bzip2.bc", "config_files": []}' > ${BZIP_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${BZIP_MANIFEST} ./work 2> ${LOG_FILE} 

test: 
	@cp helper_huffman.c huffman.c
	@cd ${BZIP_NAME} && \
        ${BZIP} -fkqs ../huffman.c
	@mv huffman.c.bz2 huffman_unspecialized.c.bz2
	@cd ..
	@cp helper_huffman.c huffman.c
	./bzip2_occamized_stripped
	@cp helper_huffman.c huffman.c
	@echo -n "\tSource File Size:\t"
	@stat -L -c %s huffman.c
	@echo -n "\tCompressed File Size:\t"
	@stat -L -c %s huffman.c.bz2
	@echo "Output comparison to Baseline:"
	@cmp -i 10 ./huffman_unspecialized.c.bz2 huffman.c.bz2; \
	RETVAL=$$?; \
	if [ $$RETVAL -eq 0 ]; then \
		echo "\tbzip test baseline compare? Passed!"; \
	else \
		echo "\tbzip test baseline compare? Failed!"; \
	fi

decompress: ${OUT_DIR} ${BZIP_BITCODE}
	cp ${BZIP_BITCODE} ${OUT_DIR}
	cd ${OUT_DIR} && \
	echo '{"binary": "bzip2_fin", "native_libs": [], "name": "bzip2", "args": ["-fdq", "huffman.c.bz2"], "modules": [], "ldflags": ["-lbz2"], "main": "bzip2.bc", "config_files": []}' > ${BZIP_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${BZIP_MANIFEST} ./work 2> ${LOG_FILE}

test_decompress:
	@echo "\t\tTest Decompress"
	@echo "File Existence Check:"
	@# Testing if decompressed file produced
	@cp huffman_unspecialized.c.bz2 ${OUT_DIR}/work && \
	cd ${OUT_DIR}/work && \
	./bzip2_fin_stripped && \
	test -f /OCCAM-Benchmarks/examples/trimmer/bzip2/huffman.c && echo "\tbzip2 test decompress file exist? Passed!" || echo "\tbzip2 test decompress file exist? Failed!" 

	@echo "Comparing File Sizes:"
	@# Printing File sizes
	@
	@echo -n "\tSource File Size:\t"
	@stat -L -c %s huffman.c.bz2
	@echo -n "\tDecompressed File Size:\t"
	@stat -L -c %s ${OUT_DIR}/huffman.c

	@echo "Output comparison to Baseline:"
	@cmp -s ./huffman.c ${OUT_DIR}/huffman.c; \
	RETVAL=$$?; \
	if [ $$RETVAL -eq 0 ]; then \
		echo "\tbzip2 test baseline compare? Passed!"; \
	else \
		echo "\tbzip2 test baseline compare? Failed!"; \
	fi




${BZIP_BITCODE}: ${BZIP_NAME} 
	cd ${BZIP_NAME} && \
	sed -i 's/-O2 -g/ -fno-inline -fno-inline-functions -Xclang -disable-O0-optnone/g' ./Makefile && \
	sed -i 's/CC=gcc/CC?=gcc/g' ./Makefile && \
	CC=${BITCODE_WRAPPER} make && \
	${BITCODE_EXTRACT} ${BZIP} && \
	cp huffman.c ../ && \
	mv ${BZIP_BITCODE} ../

${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${BZIP_NAME}:
	wget https://sourceware.org/pub/bzip2/bzip2-1.0.5.tar.gz
	tar -xvzf ./${BZIP_TAR}

${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}

clean:
	-rm -rf ${BZIP_NAME} ${BZIP_TAR} bzip2
	-rm -rf *.bc *slash* *manifest *occamized* *-orig*
	-rm -rf huffman_unspecialized.c.bz2 huffman.c *.bz2
	-rm -rf ${OUT_DIR}
