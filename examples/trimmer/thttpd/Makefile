THTTPD=thttpd
THTTPD_BITCODE=${THTTPD}.bc
THTTPD_VERSION=2.25b
THTTPD_NAME=${THTTPD}-${THTTPD_VERSION}
THTTPD_TAR=${THTTPD_NAME}.tar.gz
THTTPD_PATCH=thttpd.patch

THTTPD_MANIFEST=${THTTPD}.manifest

HELPER_SCRIPT=./build.sh
HELPER_TAR=helper_scripts_and_files.tar.gz


OUT_DIR?=trimmer
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc

all: ${THTTPD_BITCODE}

compress: ${OUT_DIR}
	cp ${THTTPD_BITCODE} ${OUT_DIR} && \
	cp ${THTTPD}.conf ${OUT_DIR} && \
	cd ${OUT_DIR} && \
	echo '{"binary": "thttpd_fin", "native_libs": [], "name": "thttpd", "args": ["-C",  "thttpd.conf"], "modules": [], "ldflags": ["-lcrypt"], "main": "thttpd.bc", "config_files": ["thttpd.conf"]}' > ${THTTPD_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${THTTPD_MANIFEST} ./ 2> ${LOG_FILE}

.PHONY: ${THTTPD_BITCODE}
${THTTPD_BITCODE}: ${THTTPD_NAME} ${HELPER_SCRIPT}
	cp ${THTTPD_PATCH} ${THTTPD_NAME} && \
	cd ${THTTPD_NAME} && \
	patch -p0 -f < ./${THTTPD_PATCH} && \
	CC=${BITCODE_WRAPPER} CFLAGS="-fno-inline -fno-inline-functions -Xclang -disable-O0-optnone -O0" ./configure && \
	CC=${BITCODE_WRAPPER} make && \
	${BITCODE_EXTRACT} ${THTTPD} && \
	mv ${THTTPD_BITCODE} ../
		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${THTTPD_NAME}:
	tar -xvzf ./${THTTPD_TAR}

${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}

clean:
	rm -rf ${THTTPD_NAME}
	rm -rf *.bc slash *_slashed *_slashed_stripped thttpd *conf *manifest *patch build.sh workdir
	rm -rf ${OUT_DIR}
