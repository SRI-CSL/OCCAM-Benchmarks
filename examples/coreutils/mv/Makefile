


mv.bc: ../coreutils_source/ ../coreutils_source/coreutils/src/mv
	cp ../coreutils_source/coreutils/src/mv .
	get-bc mv


../coreutils_source/:
	apt-get install git build-essential -y
	cp /etc/apt/sources.list /etc/apt/sources.list~
	sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
	apt-get update
	apt-get build-dep coreutils -y
	apt-get install autoconf automake autopoint bison gettext git gperf gzip texinfo patch perl rsync tar -y
	make -C ../

../coreutils_source/coreutils/src/mv:
	make -C ../coreutils_source/coreutils/ -j4

clean:
	rm -rf *.bc mv slash *_slashed
