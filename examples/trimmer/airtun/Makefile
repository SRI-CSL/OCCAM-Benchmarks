AIRCRACK-NG=aircrack-ng
AIRTUN-NG=airtun-ng
AIRCRACK-NG_BITCODE=${AIRCRACK-NG}.bc
AIRTUN-NG_BITCODE=${AIRTUN-NG}.bc
AIRCRACK-NG_VERSION=1.1
AIRCRACK-NG_NAME=${AIRCRACK-NG}-${AIRCRACK-NG_VERSION}
AIRCRACK-NG_TAR=${AIRCRACK-NG_NAME}.tar.gz

AIRCRACK-NG_MANIFEST=${AIRCRACK-NG}.manifest
AIRTUN-NG_MANIFEST=${AIRTUN-NG}.manifest

HELPER_SCRIPT=./build.sh
HELPER_TAR=helper_scripts_and_files.tar.gz


OUT_DIR?=trimmer
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc
OPT_NAME=opt
CFLAGS = -mem2reg -loops -lcssa -loop-simplify -loop-rotate -indvars


all: ${AIRCRACK-NG_BITCODE}

aircrack: ${OUT_DIR}
	cp ${AIRCRACK-NG_BITCODE} ${OUT_DIR} && \
	cd ${OUT_DIR} && \
	echo '{"binary": "aircrack-ng_fin", "native_libs": [], "name": "aircrack-ng", "args": ["-b", "00:0c:29:52:aa:56","-a","wpa","-s","-w","dictionary.lst","chargen-tcp.pcap"], "modules": [], "ldflags": ["-lssl","-lcrypto","-lpthread","sha1-sse2.S"], "main": "aircrack-ng.bc", "config_files": []}' > ${AIRCRACK-NG_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${AIRCRACK-NG_MANIFEST} ./  2> ${LOG_FILE}

airtun: ${OUT_DIR}
	cp ${AIRTUN-NG_BITCODE} ${OUT_DIR} && \
	cd ${OUT_DIR} && \
	echo '{"binary": "airtun-ng_fin", "native_libs": [], "name": "airtun-ng", "args": ["-a", "00:0c:29:52:aa:56","-w","1234567890","eth0"], "modules": [], "ldflags": ["-lssl","-lcrypto"], "main": "airtun-ng.bc", "config_files": []}' > ${AIRTUN-NG_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${AIRTUN-NG_MANIFEST} ./  2> ${LOG_FILE}

.PHONY: ${AIRTUN-NG_BITCODE}
${AIRCRACK-NG_BITCODE}: ${AIRCRACK-NG_NAME} 
	cp crypto.patch ${AIRCRACK-NG_NAME}/src/ && \
	patch ${AIRCRACK-NG_NAME}/src/crypto.c crypto.patch && \
	cd ${AIRCRACK-NG_NAME} && \
	sed -i 's/CC            = gcc/CC=gclang/g' ./Makefile && \
	sed -i 's/wllvm/gclang/g' src/osdep/Makefile && \
	sed -i 's/CC		= gcc/CC=gclang/g' ./src/Makefile && find ./ -type f -exec sed -i -e s/"\-D_FILE_OFFSET_BITS"/"\-Xclang \-disable\-O0\-optnone \-O0 \-D_FILE_OFFSET_BITS"/g {} \; && make clean && \
	CC=${BITCODE_WRAPPER} make && \
    ${BITCODE_EXTRACT} src/${AIRTUN-NG} && \
	${OPT_NAME} ${CFLAGS} src/${AIRTUN-NG_BITCODE} -o src/${AIRTUN-NG_BITCODE} && \
	mv src/${AIRTUN-NG_BITCODE} ../

		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${AIRCRACK-NG_NAME}:
	wget https://github.com/shoaibCS/TRIMMER-applications/raw/master/trimmer/aircrack/aircrack-ng-1.1.tar.gz
	tar -xvf ./${AIRCRACK-NG_TAR}

${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}


clean:
	rm -rf ${AIRCRACK-NG_NAME} airtun-ng ${AIRCRACK-NG_TAR}
	rm -rf *manifest *.bc *slash* 
	rm -rf ${OUT_DIR}
