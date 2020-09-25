BINUTILS=binutils
READELF=readelf
READELF_BITCODE=${READELF}.bc
READELF_VERSION=2.28
READELF_NAME=${BINUTILS}-${READELF_VERSION}
READELF_TAR=${READELF_NAME}.tar.gz

OBJDUMP=objdump
OBJDUMP_BITCODE=${OBJDUMP}.bc



READELF_MANIFEST=${READELF}.manifest
OBJDUMP_MANIFEST=${OBJDUMP}.manifest


HELPER_SCRIPT=./build.sh
HELPER_TAR=helper_scripts_and_files.tar.gz


OUT_DIR?=slash
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc

CHECK_READELF=$(shell cd ${OUT_DIR}/ && ./readelf_fin_stripped | grep 'ELF Header')


all: ${READELF_BITCODE}

readelf: ${OUT_DIR}
	cp ${READELF_BITCODE} ${OUT_DIR}
	cd ${OUT_DIR} && \
	echo '{"binary": "readelf_fin", "native_libs": [], "name": "readelf", "args": ["-a", "name"], "modules": [], "ldflags": ["-lz","-ldl"], "main": "readelf.bc", "config_files": []}' > ${READELF_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${READELF_MANIFEST} ./work_dir readelf 2> ${LOG_FILE}

test_readelf:
	@echo "\t\tTest Readelf"
	@echo "Checking if readelf producing valid file"
	@cd ${OUT_DIR}/ && \
	cp readelf_fin name
ifeq ('$(CHECK_READELF)',)
	@echo "\treadelf test valid? Failed!"
else
	@echo "\treadelf test valid? Passed!"
endif
	@cp ${READELF_NAME}/${BINUTILS}/${READELF} ./name && \
	${OUT_DIR}/readelf_fin_stripped > t_out && \
	${READELF_NAME}/${BINUTILS}/${READELF} -a ./name > o_out
	@echo "Output comparison to Baseline:"
	@cmp -s ./t_out o_out; \
	RETVAL=$$?; \
	if [ $$RETVAL -eq 0 ]; then \
		echo "\treadelf test baseline compare? Passed!"; \
	else \
		echo "\treadlef test baseline compare? Failed!"; \
	fi
	@rm ./o_out
	@rm ./t_out
	@rm ./name





objdump: ${OUT_DIR}
	cp ${OBJDUMP_BITCODE} ${OUT_DIR}
	cd ${OUT_DIR} && \
	echo '{"binary": "objdump_fin", "native_libs": [], "name": "objdump", "args": ["-D","--syms","-s","-w","name"], "modules": [], "ldflags": ["-ldl"], "main": "objdump.bc", "config_files": []}' > ${OBJDUMP_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${OBJDUMP_MANIFEST} ./objdump  exceedLimit 200 2> ${LOG_FILE}



.PHONY: ${READELF_BITCODE}
${READELF_BITCODE}: ${READELF_NAME} ${HELPER_SCRIPT}

	cd ${READELF_NAME} && \
	CC=${BITCODE_WRAPPER} CFLAGS="-DHAVE_CONFIG_H -O0 -fno-inline -fno-inline-functions -Xclang -disable-O0-optnone" ./configure && \
	CC=${BITCODE_WRAPPER} make && \
	cd ${BINUTILS} && \
	${BITCODE_EXTRACT} ${READELF} && \
	mv ${READELF_BITCODE} ../.. && \
	${BITCODE_EXTRACT} ${OBJDUMP} && \
	mv ${OBJDUMP_BITCODE} ../..
		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${READELF_NAME}:
	tar -xvzf ./${READELF_TAR}

${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}

clean:
	rm -rf ${READELF_NAME}
	rm -rf *.bc build.sh *slash* *manifest
	rm -r ${OUT_DIR}
