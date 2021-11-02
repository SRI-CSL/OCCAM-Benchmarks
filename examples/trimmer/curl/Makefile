curl=curl
curl_BITCODE=${curl}.bc
curl_VERSION=7.47.0
curl_NAME=${curl}-${curl_VERSION}
curl_TAR=${curl_NAME}.tar.gz

curl_MANIFEST=${curl}.manifest

openssl=openssl
openssl_VERSION=1.0.2g
openssl_NAME=${openssl}-${openssl_VERSION}
openssl_TAR=${openssl_NAME}.tar.gz

BUILD_DIR?=build
OUT_DIR?=slash
LOG_FILE?=logs

BITCODE_WRAPPER=gclang
BITCODE_EXTRACT=get-bc

all: ${curl_BITCODE}

openssl_build: ${openssl_NAME}
	cd ${openssl_NAME} && \
	mkdir -p ${BUILD_DIR} && \
	./config --prefix=${PWD}/${BUILD_DIR} shared && \
	make install

.PHONY: ${curl_BITCODE}
${curl_BITCODE}: openssl_build ${curl_NAME}
	cd ${curl_NAME} && \
        mkdir -p ${BUILD_DIR} && \
	CC=${BITCODE_WRAPPER} CFLAGS=" -Xclang -disable-O0-optnone" ./configure --prefix=${PWD}/${BUILD_DIR} --with-ssl=${PWD}/${BUILD_DIR} && \
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
	wget https://github.com/shoaibCS/TRIMMER-applications/raw/master/trimmer/curl/${curl_TAR}
	tar -xvzf ./${curl_TAR}

${openssl_NAME}:
	wget https://www.openssl.org/source/${openssl_TAR} && \
        tar xvfz ./${openssl_TAR}

clean:
	-rm -rf ${curl_NAME} ${curl_TAR} curl
	-rm -rf ${openssl_NAME} ${openssl_TAR} openssl
	-rm -rf *.bc *manifest *slash* *occamized*
	-rm -rf ${OUT_DIR} ${BUILD_DIR}
