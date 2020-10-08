NETSTAT=netstat
NETSTAT_BITCODE=${NETSTAT}.bc
NETSTAT_VERSION=1.60
NETSTAT_NAME=${NETSTAT}-${NETSTAT_VERSION}
NETSTAT_TAR=${NETSTAT_NAME}.tar.gz

NETSTAT_MANIFEST=${NETSTAT}.manifest

HELPER_SCRIPT=./build.sh
HELPER_TAR=helper_scripts_and_files.tar.gz


OUT_DIR?=slash
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc
OPT_NAME=opt
CFLAGS = -mem2reg -loops -lcssa -loop-simplify -loop-rotate -indvars


all: ${NETSTAT_BITCODE}

netstat: ${OUT_DIR}
	cp ${NETSTAT_BITCODE} ${OUT_DIR} && \
	cd ${OUT_DIR} && \
	echo '{"binary": "netstat_fin", "native_libs": [], "name": "netstat", "args": ["-a", "-e","-p","-s"], "modules": [], "ldflags": [], "main": "netstat.bc", "config_files": []}' > ${NETSTAT_MANIFEST} && \
	python ${TRIMMER_HOME}/tool/trimmer.py ${NETSTAT_MANIFEST} ./work_dir  2> ${LOG_FILE}

test_netstat:
	@echo "\t\tTest Netstat" && \
	${NETSTAT_NAME}/netstat -a -e -p -s > o_out && \
	${OUT_DIR}/netstat_fin_stripped > t_out
	@echo "Output comparison to Baseline:"
	@cmp -s ./o_out t_out; \
	RETVAL=$$?; \
	if [ $$RETVAL -eq 0 ]; then \
		echo "\tnetstat test baseline compare? Passed!"; \
	else \
		echo "\tnetstat test baseline compare? Failed!"; \
	fi
	@rm o_out
	@rm t_out



.PHONY: ${NETSTAT_BITCODE}
${NETSTAT_BITCODE}: ${NETSTAT_NAME} 
	cp optnone.patch ${NETSTAT_NAME} && \
	cd ${NETSTAT_NAME} && \
	sed -i 's/CC	= gcc//g' ./Makefile && \
	patch -R Makefile optnone.patch && \
	CC=${BITCODE_WRAPPER} make && \
	${BITCODE_EXTRACT} ${NETSTAT} && \
	${OPT_NAME} ${CFLAGS} ${NETSTAT_BITCODE} -o ${NETSTAT_BITCODE} && \
	mv ${NETSTAT_BITCODE} ../ 
    
		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${NETSTAT_NAME}:
	wget https://github.com/shoaibCS/TRIMMER-applications/raw/master/trimmer/netstat/netstat-1.60.tar.gz
	tar -xvzf ./${NETSTAT_TAR}

${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}


clean:
	rm -rf ${NETSTAT_NAME} ./${NETSTAT_TAR}
	rm -rf *.bc *slash* netstat *manifest
	rm -rf ${OUT_DIR}
