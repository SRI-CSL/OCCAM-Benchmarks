NETPERF=netperf
NETPERF_BITCODE=${NETPERF}.bc
NETPERF_VERSION=2.4.3
NETPERF_NAME=${NETPERF}-${NETPERF_VERSION}
NETPERF_TAR=${NETPERF_NAME}.tar.gz

NETPERF_MANIFEST=${NETPERF}.manifest

HELPER_SCRIPT=./build.sh
HELPER_TAR=helper_scripts_and_files.tar.gz


OUT_DIR?=trimmer
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc
OPT_NAME=opt
CFLAGS = -mem2reg -loops -lcssa -loop-simplify -loop-rotate -indvars


all: ${NETPERF_BITCODE}

.PHONY: ${NETPERF_BITCODE}
${NETPERF_BITCODE}: ${NETPERF_NAME} 

	cd ${NETPERF_NAME} && \
	CC=${BITCODE_WRAPPER} ./configure --enable-demo=yes && \
	sed -i 's/CC = gcc//g' ./Makefile && \
	sed -i 's/CC = gcc//g' ./src/Makefile && \
	sed -i 's/-g -O2/-g -Xclang -disable-O0-optnone -O0/g' src/Makefile && \
	sed -i 's/-g -O2/-g -Xclang -disable-O0-optnone -O0/g' Makefile && \
	cp ../netlib.patch src/ && \
	patch src/netlib.c src/netlib.patch && \
	CC=${BITCODE_WRAPPER} make && \
	${BITCODE_EXTRACT} src/${NETPERF} && \
	${OPT_NAME} ${CFLAGS} src/${NETPERF_BITCODE} -o src/${NETPERF_BITCODE} && \
	mv src/${NETPERF_BITCODE} ../ 
    
		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${NETPERF_NAME}:
	wget https://github.com/HewlettPackard/netperf/archive/netperf-2.4.3.tar.gz
	tar -xvzf ./${NETPERF_TAR}
	mv netperf-netperf-2.4.3 netperf-2.4.3

${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}

test:
	python test_netperf.py

clean:
	rm -rf ${NETPERF_NAME} ${NETPERF_TAR}
	rm -rf *.bc *slash* *manifest 
	rm -rf ${OUT_DIR}
