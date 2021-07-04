BINUTILS=binutils
OBJDUMP=objdump
OBJDUMP_BITCODE=${OBJDUMP}.bc
OBJDUMP_VERSION=2.28.90
OBJDUMP_NAME=${BINUTILS}-${OBJDUMP_VERSION}
OBJDUMP_TAR=${OBJDUMP_NAME}.tar.bz2
INPUT=$(shell pwd)/name

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
${OBJDUMP_BITCODE}: ${OBJDUMP_NAME} 
	cd ${OBJDUMP_NAME} && \
	cp ../elflink.patch ../elf64-ppc.patch ./bfd/ && \
	patch ./bfd/elflink.c bfd/elflink.patch && \
	patch  ./bfd/elf64-ppc.c ./bfd/elf64-ppc.patch && \
	CC=${BITCODE_WRAPPER} CFLAGS="-DHAVE_CONFIG_H -O0 -fno-inline -fno-inline-functions -Xclang -disable-O0-optnone" ./configure && \
	CC=${BITCODE_WRAPPER} make -j4 && \
	cd ${BINUTILS} && \
	${BITCODE_EXTRACT} ${OBJDUMP} && \
	cp ${OBJDUMP} ../../name && \
	mv ${OBJDUMP_BITCODE} ../..
		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${OBJDUMP_NAME}:
	wget ftp://sourceware.org/pub/binutils/snapshots/binutils-2.28.90.tar.bz2
	tar -xvf ./${OBJDUMP_TAR}

test:
	@echo "\t\tTest Objdump"
	
	./objdump_slashed_stripped > t_out && \
	${OBJDUMP_NAME}/${BINUTILS}/${OBJDUMP} -D --syms -s -w ${INPUT} > o_out
	@echo "Output comparison to Baseline:"
	@cmp -s ./t_out o_out; \
	RETVAL=$$?; \
	if [ $$RETVAL -eq 0 ]; then \
		echo "\tobjdump test baseline compare? Passed!"; \
	else \
		echo "\tobjdump test baseline compare? Failed!"; \
	fi
	@rm ./o_out
	@rm ./t_out

${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}

clean:
	rm -rf ${OBJDUMP_NAME} ${OBJDUMP_TAR}
	rm -rf *.bc *slash* *manifest name 
	rm -rf ${OUT_DIR}
