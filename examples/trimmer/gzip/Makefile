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


test:
	@cp helper_huffman.c huffman.c
	@cd ${GZIP_NAME} && \
        ${GZIP} --keep --force --quiet ../huffman.c
	@mv huffman.c.gz huffman_unspecialized.c.gz
	@cd ..
	@cp helper_huffman.c huffman.c
	./gzip_occamized_stripped huffman.c
	@cp helper_huffman.c huffman.c
	@echo -n "\tSource File Size:\t"
	@stat -L -c %s huffman.c
	@echo -n "\tCompressed File Size:\t"
	@stat -L -c %s huffman.c.gz
	@echo "Output comparison to Baseline:"
	@cmp -i 10 ./huffman_unspecialized.c.gz huffman.c.gz; \
	RETVAL=$$?; \
	if [ $$RETVAL -eq 0 ]; then \
		echo "\tgzip test baseline compare? Passed!"; \
	else \
		echo "\tgzip test baseline compare? Failed!"; \
	fi

.PHONY: ${GZIP_BITCODE}
${GZIP_BITCODE}: ${GZIP_NAME} 
	cp ${GZIP_PATCH} ${GZIP_NAME} && \
	cp helper_huffman.c huffman.c && \
	cd ${GZIP_NAME} && \
	patch -p0 -f -R -i ./${GZIP_PATCH} && \
	CC=${BITCODE_WRAPPER} CFLAGS="-DHAVE_CONFIG_H -DVERSION="\"1.17\"" -Xclang -disable-O0-optnone" ./configure && \
	CC=${BITCODE_WRAPPER} make && \
	${BITCODE_EXTRACT} ${GZIP} && \
	mv ${GZIP_BITCODE} ../ 

${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${GZIP_NAME}:
	wget https://gnu.askapache.com/gzip/gzip-1.3.12.tar.gz
	tar -xvzf ./${GZIP_TAR}

${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}

clean:
	-rm -rf ${GZIP_NAME} ${GZIP_TAR}
	-rm -rf *manifest *.bc *slash* huffman.c huffman_unspecialized.c.gz huffman.c.gz
	-rm -rf ${OUT_DIR}
	-rm *_occamized* 
	-rm gzip_orig
