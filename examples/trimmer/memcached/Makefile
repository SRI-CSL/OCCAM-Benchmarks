##########
## FIXME: add rule to build memcached with libevent
##########

MEMCACHED=memcached
MEMCACHED_BITCODE=${MEMCACHED}.bc
MEMCACHED_VERSION=1.4.25
MEMCACHED_NAME=${MEMCACHED}-${MEMCACHED_VERSION}
MEMCACHED_TAR=${MEMCACHED_NAME}.tar.gz

MEMCACHED_MANIFEST=${MEMCACHED}.manifest

HELPER_SCRIPT=./build.sh
HELPER_TAR=helper_scripts_and_files.tar.gz


OUT_DIR?=trimmer
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc
OPT_NAME=opt
CFLAGS = -mem2reg -loops -lcssa -loop-simplify -loop-rotate -indvars

# wget https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz

all: ${MEMCACHED_BITCODE}

compress: ${OUT_DIR}
	cp ${MEMCACHED_BITCODE} ${OUT_DIR} && \
	cd ${OUT_DIR} && \
	echo '{"binary": "memcached_fin", "native_libs": [], "name": "memcached", "args": ["-m","64","-l","127.0.0.1"], "modules": [], "ldflags": ["-levent","-lpthread"], "main": "memcached.bc", "config_files": []}' > ${MEMCACHED_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${MEMCACHED_MANIFEST} ./  2> ${LOG_FILE}

.PHONY: ${MEMCACHED_BITCODE}
${MEMCACHED_BITCODE}: ${MEMCACHED_NAME} 
	cd ${MEMCACHED_NAME} && \
	CC=${BITCODE_WRAPPER} ./configure && \
	sed -i 's/CFLAGS = -g -O2 -Wall -Werror -pedantic -Wmissing-prototypes -Wmissing-declarations -Wredundant-decls/CFLAGS = -Xclang -disable-O0-optnone -O0/g' ./Makefile && \
	CC=${BITCODE_WRAPPER} make && \
	${BITCODE_EXTRACT} ${MEMCACHED} && \
	${OPT_NAME} ${CFLAGS} ${MEMCACHED_BITCODE} -o ${MEMCACHED_BITCODE} && \
	mv ${MEMCACHED_BITCODE} ../

${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${MEMCACHED_NAME}:
	wget https://memcached.org/files/memcached-1.4.25.tar.gz
	tar -xvzf ./${MEMCACHED_TAR}

${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}

clean:
	rm -rf ${MEMCACHED_NAME} ${MEMCACHED_TAR} 
	rm -rf ./slash
	rm -rf *manifest
	rm -rf ${OUT_DIR}
	rm -rf memcached_occamized
	rm -rf memcached_occamized_stripped

realclean: clean
	rm -rf *.bc memcached
