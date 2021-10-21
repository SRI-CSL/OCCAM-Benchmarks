THTTPD=thttpd
THTTPD_BITCODE=${THTTPD}.bc
THTTPD_VERSION=2.25b
THTTPD_NAME=${THTTPD}-${THTTPD_VERSION}
THTTPD_TAR=${THTTPD_NAME}.tar.gz
THTTPD_PATCH=thttpd.patch
THTTPD_CONF=thttpd.conf
THTTPD_MANIFEST=${THTTPD}.manifest

HELPER_SCRIPT=./build.sh
HELPER_TAR=helper_scripts_and_files.tar.gz


OUT_DIR?=slash
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc

all: ${THTTPD_BITCODE}

test:
	@echo "\t\tTesting Thttpd"
	@cd ${OUT_DIR}/ && \
        mkdir -p workdir && \
        echo '<HTML><HEAD><TITLE>Index of ./</TITLE></HEAD><BODY BGCOLOR="#99cc99" TEXT="#000000" LINK="#2020ff" VLINK="#4040cc"><H4>Index of ./</H4></HTML>' > workdir/index.html && \
        ./thttpd_fin_stripped && \
        cd ../ && \
        sleep 1
	wget 127.0.0.1:8087/
	@rm -r slash/workdir
	cp ${THTTPD_CONF} ${THTTPD_NAME}
	sed -i 's/8087/8199/g' ${THTTPD_NAME}/${THTTPD_CONF}
	@mkdir -p ${THTTPD_NAME}/workdir
	@echo '<HTML><HEAD><TITLE>Index of ./</TITLE></HEAD><BODY BGCOLOR="#99cc99" TEXT="#000000" LINK="#2020ff" VLINK="#4040cc"><H4>Index of ./</H4></HTML>' > ${THTTPD_NAME}/workdir/index.html && \
        cd ${THTTPD_NAME} && \
        ./thttpd -C ${THTTPD_CONF}
	sleep 1
	cd ${THTTPD_NAME} && \
        wget 127.0.0.1:8199/
	@cmp -s ${THTTPD_NAME}/index.html.1 index.html; \
        RETVAL=$$?; \
        if [ $$RETVAL -eq 0 ]; then \
                echo "\tthttpd test baseline compare? Passed!"; \
        else \
                echo "\tthttpd test baseline compare? Failed!"; \
        fi
	@rm -r ${THTTPD_NAME}/workdir
	@rm ${THTTPD_NAME}/index.html.1 index.html

.PHONY: ${THTTPD_BITCODE}
${THTTPD_BITCODE}: ${THTTPD_NAME} 
	cp ${THTTPD_PATCH} ${THTTPD_NAME} && \
	cd ${THTTPD_NAME} && \
	patch -p0 -f < ./${THTTPD_PATCH} && \
	CC=${BITCODE_WRAPPER} CFLAGS="-fno-inline -fno-inline-functions -Xclang -disable-O0-optnone -O0" ./configure && \
	CC=${BITCODE_WRAPPER} make && \
	${BITCODE_EXTRACT} ${THTTPD} && \
	mv ${THTTPD_BITCODE} ../
		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${THTTPD_NAME}:
	wget https://github.com/shoaibCS/TRIMMER-applications/raw/master/trimmer/thttpd/thttpd-2.25b.tar.gz
	tar -xvzf ./${THTTPD_TAR}

${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}

clean:
	rm -rf ${THTTPD_NAME} ./${THTTPD_TAR}
	rm -rf *.bc slash *_slashed *_slashed_stripped thttpd *manifest
	rm -rf ${OUT_DIR}
