


make-prime-list.bc: ../coreutils_source/ ../coreutils_source/coreutils/src/make-prime-list
	cp ../coreutils_source/coreutils/src/make-prime-list .
	get-bc make-prime-list


../coreutils_source/:
	apt-get install git build-essential -y
	cp /etc/apt/sources.list /etc/apt/sources.list~
	sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
	apt-get update
	apt-get build-dep coreutils -y
	apt-get install autoconf automake autopoint bison gettext git gperf gzip texinfo patch perl rsync tar -y
	make -C ../

../coreutils_source/coreutils/src/make-prime-list:
	make -C ../coreutils_source/coreutils/ -j4

clean:
	rm -rf *.bc make-prime-list slash *_slashed
