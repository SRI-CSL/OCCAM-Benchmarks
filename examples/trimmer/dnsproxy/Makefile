DNSPROXY=dnsproxy
DNSPROXY_BITCODE=${DNSPROXY}.bc
DNSPROXY_VERSION=1.17
DNSPROXY_NAME=${DNSPROXY}-${DNSPROXY_VERSION}
DNSPROXY_TAR=${DNSPROXY_NAME}.tar.gz

DNSPROXY_MANIFEST=${DNSPROXY}.manifest
DNSPROXY_CONF=./dnsproxy.conf

HELPER_SCRIPT=./build.sh
HELPER_TAR=helper_scripts_and_files.tar.gz


OUT_DIR?=trimmer
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc

all: ${DNSPROXY_BITCODE}

dns: ${OUT_DIR} ${DNSPROXY_BITCODE}
	cp ${DNSPROXY_BITCODE} ${OUT_DIR} 
	cp ${DNSPROXY_CONF} ${OUT_DIR}
	cd ${OUT_DIR} && \echo '{"binary": "dnsproxy_fin", "native_libs": [], "name": "dnsproxy", "args": ["-c", "dnsproxy.conf"], "modules": [], "ldflags": ["-levent"], "main": "dnsproxy.bc", "config_files": ["dnsproxy.conf"]}' > ${DNSPROXY_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${DNSPROXY_MANIFEST} ./ 2> ${LOG_FILE}


${DNSPROXY_BITCODE}: ${DNSPROXY_NAME} ${HELPER_SCRIPT}
	cd ${DNSPROXY_NAME} && \
	CC=${BITCODE_WRAPPER} CFLAGS="-DHAVE_CONFIG_H -DVERSION="\"1.17\"" -Xclang -disable-O0-optnone " ./configure && \
	CC=${BITCODE_WRAPPER} make && \
	${BITCODE_EXTRACT} ${DNSPROXY} && \
	mv ${DNSPROXY_BITCODE} ../
		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${DNSPROXY_NAME}:
	tar -xvzf ./${DNSPROXY_TAR}

${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}

clean:
	rm -rf ${DNSPROXY_NAME} dnsproxy
	rm -rf *.bc *slash* build.sh *conf *manifest
	rm -rf ${OUT_DIR}
