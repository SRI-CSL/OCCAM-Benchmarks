curl=curl
curl_BITCODE=${curl}.bc
curl_VERSION=7.47.0
curl_NAME=${curl}-${curl_VERSION}
curl_TAR=${curl_NAME}.tar.gz


curl_MANIFEST=${curl}.manifest

BUILD_DIR?=build
OUT_DIR?=slash
LOG_FILE?=logs

BITCODE_WRAPPER=gclang
BITCODE_EXTRACT=get-bc

all: ${curl_BITCODE}

.PHONY: ${curl_BITCODE}
${curl_BITCODE}: ${curl_NAME}
	cd ${curl_NAME} && \
        mkdir ${BUILD_DIR} && \
	CC=${BITCODE_WRAPPER} CFLAGS=" -Xclang -disable-O0-optnone" ./configure --prefix=${PWD}/${BUILD_DIR} && \
	sed -i 's/CFLAGS = -Xclang -disable-O0-optnone -Qunused-arguments -Os/CFLAGS = -Xclang -disable-O0-optnone/g' src/Makefile && \
	CC=${BITCODE_WRAPPER} make && \
        make install && \
        ${BITCODE_EXTRACT} ../${BUILD_DIR}/bin/${curl} && \
	mv ../${BUILD_DIR}/bin/${curl_BITCODE} ../

test:
	@echo "\t\tTest Curl"

	./curl_occamized_stripped https://www.sri.com > t_out && \
	./curl --compress --http1.1 --ipv4 --ssl https://www.sri.com > o_out
	@echo "Output comparison to Baseline:"
	@cmp -s ./t_out o_out; \
	RETVAL=$$?; \
	if [ $$RETVAL -eq 0 ]; then \
		echo "\tcurl test baseline compare? Passed!"; \
	else \
		echo "\tcurl test baseline compare? Failed!"; \
	fi
	@rm ./o_out
	@rm ./t_out

${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${curl_NAME}:
	wget https://github.com/shoaibCS/TRIMMER-applications/raw/master/trimmer/curl/curl-7.47.0.tar.gz
	tar -xvzf ./${curl_TAR}

clean:
	-rm -rf ${curl_NAME} ${curl_TAR} curl
	-rm -rf *.bc *manifest *slash* *occamized*
	-rm -r ${OUT_DIR} ${BUILD_DIR}
