MINI_HTTPD=mini_httpd
MINI_HTTPD_BITCODE=${MINI_HTTPD}.bc
MINI_HTTPD_VERSION=1.19
MINI_HTTPD_NAME=${MINI_HTTPD}-${MINI_HTTPD_VERSION}
MINI_HTTPD_TAR=${MINI_HTTPD_NAME}.tar.gz

MINI_HTTPD_MANIFEST=${MINI_HTTPD}.manifest
MINI_HTTPD_PATCH=mini_httpd.patch
MINI_HTTPD_CONF=./mini_httpd.conf

HELPER_SCRIPT=./build.sh
HELPER_TAR=helper_scripts_and_files.tar.gz


OUT_DIR?=slash
LOG_FILE?=logs

BITCODE_WRAPPER?=gclang
BITCODE_EXTRACT?=get-bc

all: ${MINI_HTTPD_BITCODE}

test:
	@echo "\t\tTesting Mini"
	@cp ${MINI_HTTPD_CONF} ${MINI_HTTPD_NAME}
	@cd ${MINI_HTTPD_NAME}  && \
        sed -i 's/8087/8199/g' ${MINI_HTTPD_CONF}
	@test -f workdir && echo "workdir already exists" || mkdir workdir
	@echo '<HTML><HEAD><TITLE>Index of ./</TITLE></HEAD><BODY BGCOLOR="#99cc99" TEXT="#000000" LINK="#2020ff" VLINK="#4040cc"><H4>Index of ./</H4></HTML>' > workdir/index.html
	${MINI_HTTPD_NAME}/mini_httpd -C ${MINI_HTTPD_NAME}/mini_httpd.conf
	wget 127.0.0.1:8199/
	echo '<HTML><HEAD><TITLE>Index of ./</TITLE></HEAD><BODY BGCOLOR="#99cc99" TEXT="#000000" LINK="#2020ff" VLINK="#4040cc"><H4>Index of ./</H4></HTML>' > workdir/index.html && \
        sed -i 's/8199/8087/g' ${MINI_HTTPD_CONF}
	./mini_httpd_occamized_stripped  && \
        wget 127.0.0.1:8087/	
	@cmp -s ./index.html index.html.1; \
        RETVAL=$$?; \
        if [ $$RETVAL -eq 0 ]; then \
                echo "\tmini_httpd test baseline compare? Passed!"; \
        else \
                echo "\tmini_httpd test baseline compare? Failed!"; \
        fi


${MINI_HTTPD_BITCODE}: ${MINI_HTTPD_NAME} 
	cp ${MINI_HTTPD_PATCH} ${MINI_HTTPD_NAME} &&  \
	cd ${MINI_HTTPD_NAME} && \
	sed -i 's/CC =		gcc/CC? = gcc/g' ./Makefile && \
	sed -i 's/-O/ -Xclang -disable-O0-optnone/g' ./Makefile && \
	patch -p1 -f -R -i ./${MINI_HTTPD_PATCH} && \
	CC=${BITCODE_WRAPPER} make && \
	${BITCODE_EXTRACT} ${MINI_HTTPD} && \
	mv ${MINI_HTTPD_BITCODE} ../
		
${OUT_DIR}:
	mkdir -p ${OUT_DIR}

${MINI_HTTPD_NAME}:
	wget https://github.com/shoaibCS/TRIMMER-applications/raw/master/trimmer/mini_httpd/mini_httpd-1.19.tar.gz 
	tar -xvf ./${MINI_HTTPD_TAR}
${HELPER_SCRIPT}:
	tar -xvf ./${HELPER_TAR}

clean:
	rm -rf ${MINI_HTTPD_NAME} ${MINI_HTTPD_TAR}
	rm -rf *.bc mini_httpd *slash* *manifest *occamized*
	rm -rf ${OUT_DIR}
	rm -rf index.html*
	rm -rf workdir
