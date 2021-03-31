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

${YICES_BITCODE}: ${YICES_NAME}
	cd ${YICES_NAME} && \
	./configure CC=gclang && \
	sed -i 's/gcc/gclang -fno-inline -fno-inline-functions -Xclang -disable-O0-optnone -O2/g' src/Makefile && \
	CC=${BITCODE_WRAPPER} make && \
	${BITCODE_EXTRACT} build/x86_64-pc-linux-gnu-release/bin/${YICES}_main && \
	mv build/x86_64-pc-linux-gnu-release/bin/${YICES_BITCODE} ../
	cp build/x86_64-pc-linux-gnu-release/lib/libyices.a ../

${YICES_NAME}:
	tar -xvzf ./${YICES_TAR}

clean:
	rm *.bc
	rm -f yices_main_fin
	rm yices.manifest
	rm -f ${YICES_TAR}

realclean: clean
	rm -rf ${YICES_NAME}
