
AIRCRACK-NG=aircrack-ng
AIRTUN-NG=airtun-ng
AIRCRACK-NG_BITCODE=${AIRCRACK-NG}.bc
AIRTUN-NG_BITCODE=${AIRTUN-NG}.bc
AIRCRACK-NG_VERSION=1.1
AIRCRACK-NG_NAME=${AIRCRACK-NG}-${AIRCRACK-NG_VERSION}
AIRCRACK-NG_TAR=${AIRCRACK-NG_NAME}.tar.gz

AIRCRACK-NG_MANIFEST=${AIRCRACK-NG}.manifest

HELPER_SCRIPT=./build.sh
HELPER_TAR=helper_scripts_and_files.tar.gz


OUT_DIR?=slash
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc
OPT_NAME=opt
CFLAGS = -mem2reg -loops -lcssa -loop-simplify -loop-rotate -indvars


all: ${AIRCRACK-NG_BITCODE}

.PHONY: ${AIRCRACK-NG_BITCODE}
${AIRCRACK-NG_BITCODE}: ${AIRCRACK-NG_NAME}
	cp crypto.patch ${AIRCRACK-NG_NAME}/src/ && \
	patch ${AIRCRACK-NG_NAME}/src/crypto.c crypto.patch && \
	cd ${AIRCRACK-NG_NAME} && \
	sed -i 's/CC		= gcc/CC=gclang/g' ./Makefile && \
	sed -i 's/wllvm/gclang/g' src/osdep/Makefile &&\
	sed -i 's/CC		= gcc/CC=gclang/g' ./src/Makefile && find ./ -type f -exec sed -i -e s/"\-D_FILE_OFFSET_BITS"/"\-Xclang \-disable\-O0\-optnone \-O0 \-D_FILE_OFFSET_BITS"/g {} \; && make clean && \
	CC=${BITCODE_WRAPPER} make && \
	${BITCODE_EXTRACT} src/${AIRCRACK-NG} && \
	${OPT_NAME} ${CFLAGS} src/${AIRCRACK-NG_BITCODE} -o src/${AIRCRACK-NG_BITCODE} && \
	mv src/${AIRCRACK-NG_BITCODE} ../ 
	cp ${AIRCRACK-NG_NAME}/test/password.lst ./ 
	cp ${AIRCRACK-NG_NAME}/test/wpa.cap ./

${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${AIRCRACK-NG_NAME}:
	wget https://github.com/shoaibCS/TRIMMER-applications/raw/master/trimmer/aircrack/aircrack-ng-1.1.tar.gz 
	tar -xvf ./${AIRCRACK-NG_TAR}

CHECK_AIRCRACK=$(shell ./aircrack-ng_occamized_stripped | grep 'biscotte')


test:
	@echo "\t\tTest Aircrack-ng"
	@echo "Checking if aircrack output valid:"
ifeq ('$(CHECK_AIRCRACK)',)
	@echo "\taircrack test valid? Failed!"
else
	@echo "\taircrack test valid? Passed!"
endif

${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}

clean:
	rm -Rf ${OUT_DIR}
	rm -rf *manifest *.lst *.cap
	rm -rf *occamized* *orig *.bc
	rm -rf ${AIRCRACK-NG_NAME} ${AIRCRACK-NG_TAR}

realclean: clean
	rm -rf *.bc
