GZIP=gzip
GZIP_BITCODE=${GZIP}.bc
GZIP_VERSION=1.3.12
GZIP_NAME=${GZIP}-${GZIP_VERSION}
GZIP_TAR=${GZIP_NAME}.tar.gz
GZIP_PATCH=gzip.patch

GZIP_MANIFEST=${GZIP}.manifest

HELPER_SCRIPT=./build.sh
HELPER_TAR=helper_scripts_and_files.tar.gz


OUT_DIR?=slash
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc

all: ${GZIP_BITCODE}

compress: ${OUT_DIR}
	cp ${GZIP_BITCODE} ${OUT_DIR}
	cd ${OUT_DIR} && \
	echo '{"binary": "gzip_fin", "native_libs": [], "name": "gzip", "args": ["--force",  "--quiet",  "huffman.c"], "modules": [], "ldflags": ["-lbz2"], "main": "gzip.bc", "config_files": []}' > ${GZIP_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${GZIP_MANIFEST} ./work_dir 2> ${LOG_FILE}
	cp huffman.c ${OUT_DIR}/work_dir


test_compress: 
	@echo "\t\tTest Compress"
	@echo "File Existence Check:"
	@# Testing if compressed file produced
	@cp helper_huffman.c huffman.c
	@cp huffman.c ${OUT_DIR}/ && \
	cd ${OUT_DIR}/ && \
	./gzip_fin_stripped && \
	test -f /OCCAM-Benchmarks/examples/trimmer/gzip/huffman.c.gz && echo "\tgzip test compress file exist? Passed!" || echo "gzip test compress file exist? Failed!" 
	@echo "Comparing File Sizes:"
	@# Printing File sizes
	@cp helper_huffman.c huffman.c
	@echo -n "\tSource File Size:\t"
	@stat -L -c %s huffman.c
	@echo -n "\tCompressed File Size:\t"
	@stat -L -c %s /OCCAM-Benchmarks/examples/trimmer/gzip/huffman.c.gz
	@echo "Output comparison to Baseline:"
	@cmp -i 10 ./huffman_unspecialized.c.gz /OCCAM-Benchmarks/examples/trimmer/gzip/huffman.c.gz; \
	RETVAL=$$?; \
	if [ $$RETVAL -eq 0 ]; then \
		echo "\tgzip test baseline compare? Passed!"; \
	else \
		echo "\tgzip test baseline compare? Failed!"; \
	fi

	

	
.PHONY: ${GZIP_BITCODE}
${GZIP_BITCODE}: ${GZIP_NAME} 
	cp helper_huffman.c huffman.c && \
	cp ${GZIP_PATCH} ${GZIP_NAME} && \
	cd ${GZIP_NAME} && \
	patch -p0 -f -R -i ./${GZIP_PATCH} && \
	CC=${BITCODE_WRAPPER} CFLAGS="-DHAVE_CONFIG_H -DVERSION="\"1.17\"" -Xclang -disable-O0-optnone" ./configure && \
	CC=${BITCODE_WRAPPER} make && \
	${BITCODE_EXTRACT} ${GZIP} && \
	mv ${GZIP_BITCODE} ../  && \
	${GZIP} --keep --force --quiet ../huffman.c
	mv huffman.c.gz huffman_unspecialized.c.gz	
		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${GZIP_NAME}:
	wget https://gnu.askapache.com/gzip/gzip-1.3.12.tar.gz
	tar -xvzf ./${GZIP_TAR}

${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}

clean:
	rm -rf ${GZIP_NAME} ${GZIP_TAR}
	rm -rf *manifest *.bc *slash* huffman.c huffman_unspecialized.c.gz
	rm -rf ${OUT_DIR}
