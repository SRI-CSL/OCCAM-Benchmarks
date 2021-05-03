curl=curl
curl_BITCODE=${curl}.bc
curl_VERSION=7.47.0
curl_NAME=${curl}-${curl_VERSION}
curl_TAR=${curl_NAME}.tar.gz


curl_MANIFEST=${curl}.manifest

OUT_DIR?=slash
LOG_FILE?=logs

BITCODE_WRAPPER=gclang
BITCODE_EXTRACT=get-bc

all: ${curl_BITCODE}

.PHONY: ${curl_BITCODE}
${curl_BITCODE}: ${curl_NAME}
	cd ${curl_NAME} && \
	CC=${BITCODE_WRAPPER} CFLAGS=" -Xclang -disable-O0-optnone" ./configure && \
	sed -i 's/CFLAGS = -Xclang -disable-O0-optnone -Qunused-arguments -Os/CFLAGS = -Xclang -disable-O0-optnone/g' src/Makefile && \
	CC=${BITCODE_WRAPPER} make && \
        sudo make install && \
	sudo cp /usr/local/bin/curl  ../ && \
        sudo chmod 777 ../${curl} && \
        ${BITCODE_EXTRACT} ../${curl}

test_curl:
	@echo "\t\tTest Curl"
	
	./curl_occamized_stripped > t_out && \
	curl --compress --http1.1 --ipv4 --ssl http://www.google.com > o_out
	@echo "Output comparison to Baseline:"
	@cmp -s ./t_out o_out; \
	RETVAL=$$?; \
	if [ $$RETVAL -eq 0 ]; then \
		echo "\tcurl test baseline compare? Passed!"; \
	else \
		echo "\tcurl test baseline compare? Failed!"; \
	fi
	#@rm ./o_out
	#@rm ./t_out


		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${curl_NAME}:
	wget https://github.com/shoaibCS/TRIMMER-applications/raw/master/trimmer/curl/curl-7.47.0.tar.gz
	tar -xvzf ./${curl_TAR}

clean:
	rm -rf ${curl_NAME} ${curl_TAR}
	rm -rf *.bc *manifest *slash* *occamized*
	rm -r ${OUT_DIR}