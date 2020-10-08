WGET=wget
WGET_BITCODE=${WGET}.bc
WGET_VERSION=1.17.1
WGET_NAME=${WGET}-${WGET_VERSION}
WGET_TAR=${WGET_NAME}.tar.gz
WGET_RC=wgetrc
WGET_PATCH=wget.patch

WGET_MANIFEST=${WGET}.manifest

HELPER_SCRIPT=./build.sh
HELPER_TAR=helper_scripts_and_files.tar.gz


OUT_DIR?=slash
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc

all: ${WGET_BITCODE}

compress: ${OUT_DIR}
	cp ${WGET_BITCODE} ${OUT_DIR} && \
	cp wgetrc ${OUT_DIR} && \
	cd ${OUT_DIR} && \
  echo '{"binary": "wget_fin", "native_libs":[],"name": "wget", "args": ["--config=wgetrc","_" ], "modules": [], "ldflags": ["-luuid","-lgnutls","-lpcre", "-lnettle", "-lidn", "-lz", "-lpthread"], "main": "wget.bc", "config_files": ["wgetrc"]}' > ${WGET_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${WGET_MANIFEST} ./work_dir useGlob useRegOffset exceedLimit 300 optLevel none 2> ${LOG_FILE}

test_compress:
	@echo "\t\tTest Wget"
	cd ${OUT_DIR}/ && \
	./wget_fin_stripped a https://releases.llvm.org/7.0.0/cfe-7.0.0.src.tar.xz && \
	@echo "File Existence Check" && \
	test -f cfe-7.0.0.src.tar.xz && echo "\twget test file exist? Passed!" || echo "\twget test file exist? Failed!" 
	
	cp wgetrc ${WGET_NAME}/src 
	cd ${WGET_NAME}/src && \
	./wget --config=wgetrc https://releases.llvm.org/7.0.0/cfe-7.0.0.src.tar.xz

	echo "Output comparison to Baseline:"
	@cmp -s ${WGET_NAME}/src/cfe-7.0.0.src.tar.xz ${OUT_DIR}/cfe-7.0.0.src.tar.xz; \
	RETVAL=$$?; \
	if [ $$RETVAL -eq 0 ]; then \
		echo "\twget test baseline compare? Passed!"; \
	else \
		echo "\twget test baseline compare? Failed!"; \
	fi

	
	





.PHONY: ${WGET_BITCODE}
${WGET_BITCODE}: ${WGET_NAME} 
	cp ${WGET_PATCH} ${WGET_NAME} && \
	cd ${WGET_NAME} && \
	patch -p0 -f -R -i ./${WGET_PATCH} && \
	CC=${BITCODE_WRAPPER} CFLAGS="-O0 -Xclang -disable-O0-optnone -fno-inline -fno-inline-functions" ./configure && \
	CC=${BITCODE_WRAPPER} make && \
	cd src && \
	${BITCODE_EXTRACT} ${WGET} && \
	mv ${WGET_BITCODE} ../../
		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${WGET_NAME}:
	wget http://gnu.mirrors.hoobly.com/wget/wget-1.17.1.tar.gz
	tar -xvzf ./${WGET_TAR}

${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}


clean:
	rm -rf ${WGET_NAME} ${WGET_TAR}
	rm -rf *.bc *slash* *manifest 
	rm -rf ${OUT_DIR}
