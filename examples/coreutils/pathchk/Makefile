


pathchk.bc: ../coreutils_source/ ../coreutils_source/coreutils/src/pathchk
	cp ../coreutils_source/coreutils/src/pathchk .
	get-bc pathchk


../coreutils_source/:
	apt-get install git build-essential -y
	cp /etc/apt/sources.list /etc/apt/sources.list~
	sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
	apt-get update
	apt-get build-dep coreutils -y
	apt-get install autoconf automake autopoint bison gettext git gperf gzip texinfo patch perl rsync tar -y
	make -C ../

../coreutils_source/coreutils/src/pathchk:
	make -C ../coreutils_source/coreutils/ -j4

clean:
	rm -rf *.bc pathchk slash *_slashed
