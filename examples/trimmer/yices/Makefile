YICES=yices
YICES_BITCODE=${YICES}_main.bc
YICES_VERSION=2.6.1
YICES_NAME=${YICES}-${YICES_VERSION}
YICES_TAR=${YICES_NAME}.tar.gz

YICES_MANIFEST=${YICES}.manifest

LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc



all: ${YICES_BITCODE}

test:
	@echo "\t\tTest Yices"
	./yices_occamized_stripped > t_out && \
	${YICES_NAME}/build/x86_64-pc-linux-gnu-release/bin/yices_main --logic=QF_AUFBV ./yices-2.6.1/examples/bool_eqs.ys > o_out
	@echo "Output comparison to Baseline:"
	@cmp -s ./t_out o_out; \
	RETVAL=$$?; \
	if [ $$RETVAL -eq 0 ]; then \
		echo "\tyices test baseline compare? Passed!"; \
	else \
		echo "\tyices test baseline compare? Failed!"; \
	fi
	@rm ./o_out
	@rm ./t_out

${YICES_BITCODE}: ${YICES_NAME}
	cd ${YICES_NAME} && \
	./configure CC=gclang && \
	sed -i 's/gcc/gclang -fno-inline -fno-inline-functions -Xclang -disable-O0-optnone -O2/g' src/Makefile && \
	CC=${BITCODE_WRAPPER} make && \
	${BITCODE_EXTRACT} build/x86_64-pc-linux-gnu-release/bin/${YICES}_main && \
	mv build/x86_64-pc-linux-gnu-release/bin/${YICES_BITCODE} ../ && \
	cp build/x86_64-pc-linux-gnu-release/lib/libyices.a ../

${YICES_NAME}:
	wget https://github.com/SRI-CSL/yices2/archive/refs/tags/Yices-2.6.1.tar.gz && \
	mv Yices-2.6.1.tar.gz ${YICES_TAR} && \
	tar -xvzf ${YICES_TAR} && \
	mv yices2-Yices-2.6.1 ${YICES_NAME} && \
	cd ${YICES_NAME} && autoconf && \
	cd ..


clean:
	-rm *.bc *.a
	-rm yices.manifest
	-rm -f yices_occamized yices_occamized_stripped yices_main_orig
	-rm -rf slash
	-rm -f ${YICES_TAR}

realclean: clean
	-rm -rf ${YICES_NAME}
