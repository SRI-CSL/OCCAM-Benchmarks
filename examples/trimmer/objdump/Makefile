BINUTILS=binutils
OBJDUMP=objdump
OBJDUMP_BITCODE=${OBJDUMP}.bc
OBJDUMP_VERSION=2.28
OBJDUMP_NAME=${BINUTILS}-${OBJDUMP_VERSION}
OBJDUMP_TAR=${OBJDUMP_NAME}.tar.gz


OBJDUMP_MANIFEST=${OBJDUMP}.manifest

HELPER_SCRIPT=./build.sh
HELPER_TAR=helper_scripts_and_files.tar.gz


OUT_DIR?=trimmer
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc

all: ${OBJDUMP_BITCODE}

compress: ${OUT_DIR}
	cp ${OBJDUMP_BITCODE} ${OUT_DIR}
	cd ${OUT_DIR} && \
	echo '{"binary": "readelf_fin", "native_libs": [], "name": "readelf", "args": ["-a", "name"], "modules": [], "ldflags": ["-lz","-ldl"], "main": "readelf.bc", "config_files": []}' > ${OBJDUMP_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${OBJDUMP_MANIFEST} ./work_dir readelf 2> ${LOG_FILE}

.PHONY: ${OBJDUMP_BITCODE}
${OBJDUMP_BITCODE}: ${OBJDUMP_NAME} ${HELPER_SCRIPT}

	cd ${OBJDUMP_NAME} && \
	CC=${BITCODE_WRAPPER} CFLAGS="-DHAVE_CONFIG_H -O0 -fno-inline -fno-inline-functions -Xclang -disable-O0-optnone" ./configure && \
	CC=${BITCODE_WRAPPER} make && \
	cd ${BINUTILS} && \
	${BITCODE_EXTRACT} ${OBJDUMP} && \
	mv ${OBJDUMP_BITCODE} ../..
		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${OBJDUMP_NAME}:
	tar -xvzf ./${OBJDUMP_TAR}

${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}

clean:
	rm -rf ${OBJDUMP_NAME}
	rm -rf *.bc *slash* *manifest build.sh name
	rm -rf ${OUT_DIR}
