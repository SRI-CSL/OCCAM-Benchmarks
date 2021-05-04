knockd=knockd
knockd_BITCODE=${knockd}.bc
knockd_VERSION=0.5
knockd_NAME=${knockd}-${knockd_VERSION}
knockd_TAR=${knockd_NAME}.tar.gz


knockd_MANIFEST=${knockd}.manifest

OUT_DIR?=slash
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc

all: ${knockd_BITCODE}

.PHONY: ${knockd_BITCODE}
${knockd_BITCODE}: ${knockd_NAME}
	cd ${knockd_NAME} && \
	CC=${BITCODE_WRAPPER} CFLAGS="-Xclang -disable-O0-optnone" ./configure && \
	sed -i 's/-g -Wall -pedantic -fno-exceptions/-Wall -pedantic -fno-exceptions -Xclang -disable-O0-optnone/g' ./Makefile && \
	CC=${BITCODE_WRAPPER} make && \
	${BITCODE_EXTRACT} ${knockd} && \
	mv ${knockd_BITCODE} ../
		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${knockd_NAME}:
	wget https://github.com/shoaibCS/TRIMMER-applications/raw/master/trimmer/knockd/knockd-0.5.tar.gz
	tar -xvzf ./${knockd_TAR}

clean:
	rm -rf ${knockd_NAME} ${knockd_TAR}
	rm -rf *.bc *manifest *slash* *occamized*
	rm -r ${OUT_DIR}