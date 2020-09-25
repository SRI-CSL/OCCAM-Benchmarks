MEMCACHED=memcached
MEMCACHED_BITCODE=${MEMCACHED}.bc
MEMCACHED_VERSION=1.4.4
MEMCACHED_NAME=${MEMCACHED}-${MEMCACHED_VERSION}
MEMCACHED_TAR=${MEMCACHED_NAME}.tar.gz

MEMCACHED_MANIFEST=${MEMCACHED}.manifest

HELPER_SCRIPT=./build.sh
HELPER_TAR=helper_scripts_and_files.tar.gz


OUT_DIR?=trimmer
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc
OPT_NAME=opt-10
CFLAGS = -mem2reg -loops -lcssa -loop-simplify -loop-rotate -indvars


all: ${MEMCACHED_BITCODE}

compress: ${OUT_DIR}
	cp ${MEMCACHED_BITCODE} ${OUT_DIR} && \
	cd ${OUT_DIR} && \
	echo '{"binary": "memcached_fin", "native_libs": [], "name": "memcached", "args": ["-m","64","-l","127.0.0.1"], "modules": [], "ldflags": ["-levent","-lpthread"], "main": "memcached.bc", "config_files": []}' > ${MEMCACHED_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${MEMCACHED_MANIFEST} ./  2> ${LOG_FILE}

.PHONY: ${MEMCACHED_BITCODE}
${MEMCACHED_BITCODE}: ${MEMCACHED_NAME} ${HELPER_SCRIPT}
	cd ${MEMCACHED_NAME} && \
	CC=${BITCODE_WRAPPER} ./configure && \
	sed -i 's/CFLAGS = -g -O2 -pthread -Wall -Werror -pedantic -Wmissing-prototypes -Wmissing-declarations -Wredundant-decls/CFLAGS = -Xclang -disable-O0-optnone -O0 -pthread/g' ./Makefile && \
	CC=${BITCODE_WRAPPER} make && \
	${BITCODE_EXTRACT} ${MEMCACHED} && \
	${OPT_NAME} ${CFLAGS} ${MEMCACHED_BITCODE} -o ${MEMCACHED_BITCODE} && \
	mv ${MEMCACHED_BITCODE} ../
		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${MEMCACHED_NAME}:
	tar -xvzf ./${MEMCACHED_TAR}

${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}

clean:
	rm -rf ${MEMCACHED_NAME} memcached
	rm -rf *.bc *slash* build.sh *manifest
	rm -rf ${OUT_DIR}
