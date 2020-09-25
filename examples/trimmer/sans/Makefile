SANS=sans
SANS_BITCODE=${SANS}.bc
SANS_NAME=${SANS}
SANS_TAR=${SANS_NAME}.tar.gz

SANS_MANIFEST=${SANS}.manifest

HELPER_SCRIPT=./build.sh
HELPER_TAR=helper_scripts_and_files.tar.gz

OUT_DIR?=trimmer
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc

all: ${SANS_BITCODE}

udp: ${OUT_DIR}
	cp ${SANS_BITCODE} ${OUT_DIR} && \
	cp sans.conf ${OUT_DIR} && \
	cd ${OUT_DIR} && \
	echo '{"binary": "sans_fin",  "native_libs": [], "name": "sans", "args": ["-c", "sans.conf"], "modules": [], "ldflags": [], "main": "sans.bc", "config_files":["sans.conf"] }' > ${SANS_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${SANS_MANIFEST} ./ 2> ${LOG_FILE}

socks5: ${OUT_DIR}
	cp ${SANS_BITCODE} ${OUT_DIR} && \
	cp sans2.conf ${OUT_DIR} && \
	cd ${OUT_DIR} && \
	echo '{"binary": "sans_fin",  "native_libs": [], "name": "sans", "args": ["-c", "sans2.conf"], "modules": [], "ldflags": [], "main": "sans.bc", "config_files":["sans2.conf"] }' > ${SANS_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${SANS_MANIFEST} ./ 2> ${LOG_FILE}

tcp: ${OUT_DIR}
	cp ${SANS_BITCODE} ${OUT_DIR} && \
	cp sanss.conf ${OUT_DIR} && \
	cd ${OUT_DIR} && \
	echo '{"binary": "sans_fin",  "native_libs": [], "name": "sans", "args": ["-c", "sanss.conf"], "modules": [], "ldflags": [], "main": "sans.bc", "config_files":["sanss.conf"] }' > ${SANS_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${SANS_MANIFEST} ./ 2> ${LOG_FILE}


.PHONY: ${SANS_BITCODE}
${SANS_BITCODE}: ${SANS_NAME} ${HELPER_SCRIPT}
	cd ${SANS_NAME} && \
	CC=${BITCODE_WRAPPER} CFLAGS="-O0 -fno-inline -fno-inline-functions -Xclang -disable-O0-optnone" ./configure && \
	CC=${BITCODE_WRAPPER} make && \
	cd src/ && \
	${BITCODE_EXTRACT} ${SANS} && \
	mv ${SANS_BITCODE} ../../
		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${SANS_NAME}:
	tar -xvzf ./${SANS_TAR}
${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}
clean:
	rm -rf ${SANS_NAME}
	rm -rf *.bc *_slashed *_slashed_stripped build.sh *conf* *manifest*
	rm -rf ${OUT_DIR}
	rm -rf slash
	rm -rf sans_slashed
