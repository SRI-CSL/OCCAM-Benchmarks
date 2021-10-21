httping=httping
httping_BITCODE=${httping}.bc
httping_VERSION=2.4
httping_NAME=${httping}-${httping_VERSION}
httping_TAR=${httping_NAME}.tar.gz


httping_MANIFEST=${httping}.manifest

OUT_DIR?=slash
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc

all: ${httping_BITCODE}

test:
	@echo "\t\tTest Httping"

	./httping_occamized_stripped http://www.csl.sri.com/ | grep "connected to" | awk '{print $$3, $$9}' > t_out  &
	${httping_NAME}/${httping} -G -s -X -b -B http://www.csl.sri.com/ | grep "connected to" | awk '{print $$3, $$9}' > o_out &
	@sleep 6
	@echo "Output comparison to Baseline:"
	@cmp -s ./t_out o_out; \
	RETVAL=$$?; \
	if [ $$RETVAL -eq 0 ]; then \
		echo "\thttping test basic ping compare? Passed!"; \
	else \
		echo "\thttping test basic ping compare? Failed!"; \
	fi
	@rm ./o_out
	@rm ./t_out

.PHONY: ${httping_BITCODE}
${httping_BITCODE}: ${httping_NAME}
	cd ${httping_NAME} && \
	sed -i 's/WFLAGS=-Wall -W -Wextra -pedantic -D_FORTIFY_SOURCE=2/WFLAGS=-Xclang -disable-O0-optnone/g' ./Makefile && \
	sed -i 's/DEBUG=yes/DEBUG=no/g' ./Makefile && \
	CC=${BITCODE_WRAPPER} make && \
	${BITCODE_EXTRACT} ${httping} && \
	mv ${httping_BITCODE} ../
		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${httping_NAME}:
	wget https://github.com/shoaibCS/TRIMMER-applications/raw/master/trimmer/httping/httping-2.4.tar.gz
	tar -xvzf ./${httping_TAR}

clean:
	rm -rf ${httping_NAME} ${httping_TAR}
	rm -rf *.bc *manifest *slash* *occamized*
	rm -r ${OUT_DIR}
