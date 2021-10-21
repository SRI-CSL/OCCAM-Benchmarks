TOTD=totd
TOTD_BITCODE=${TOTD}.bc
TOTD_VERSION=1.5.3
TOTD_NAME=${TOTD}-${TOTD_VERSION}
TOTD_TAR=${TOTD_NAME}.tar.gz

TOTD_MANIFEST=${TOTD}.manifest
TOTD_CONF1=./totdipv6.conf
TOTD_CONF2=./totdipv4.conf

HELPER_SCRIPT=./build.sh
HELPER_TAR=helper_scripts_and_files.tar.gz

OUT_DIR?=trimmer
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc

all: ${TOTD_BITCODE}

ipv6: ${OUT_DIR} ${TOTD_BITCODE}
	cp ${TOTD_BITCODE} ${OUT_DIR} 
	cp ${TOTD_CONF1} ${OUT_DIR}
	cd ${OUT_DIR} && \echo '{"binary": "totd_fin", "native_libs": [], "name": "totd", "args": ["-c", "totdipv6.conf", "-d2"],"modules": [], "ldflags": [], "main": "totd.bc","config_files":["totdipv6.conf"]}' > ${TOTD_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${TOTD_MANIFEST} ./ no-optimization 2> ${LOG_FILE}


ipv4: ${OUT_DIR} ${TOTD_BITCODE}
	cp ${TOTD_BITCODE} ${OUT_DIR} 
	cp ${TOTD_CONF2} ${OUT_DIR}
	cd ${OUT_DIR} && \echo '{"binary": "totd_fin", "native_libs": [], "name": "totd", "args": ["-c", "totdipv4.conf", "-d2"],"modules": [], "ldflags": [], "main": "totd.bc","config_files":["totdipv4.conf"]}' > ${TOTD_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${TOTD_MANIFEST} ./ no-optimization 2> ${LOG_FILE}

test:
	python3 test_totd.py

${TOTD_BITCODE}: ${TOTD_NAME} 
	cd ${TOTD_NAME} && \
	sed -i 's/-g -O2/ -Xclang -disable-O0-optnone -O0/g' ./Makefile && \
	sed -i 's/CC = gcc/CC? = gcc/g' ./Makefile && \
	CC=${BITCODE_WRAPPER} make && \
	${BITCODE_EXTRACT} ${TOTD} && \
	mv ${TOTD_BITCODE} ../

${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${TOTD_NAME}:
	wget https://github.com/shoaibCS/TRIMMER-applications/raw/master/trimmer/totd/totd-1.5.3.tar.gz
	tar -xvf ./${TOTD_TAR}

${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}

clean:
	rm -rf ${TOTD_NAME} totd ${TOTD_TAR}
	rm -rf *.bc *slash* *manifest *occamized* totd-orig
	rm -rf ${OUT_DIR}
