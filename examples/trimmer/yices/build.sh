#!/usr/bin/env bash

# Make sure we exit if there is a failure
set -e

function usage() {
    echo "Usage: $0 [--with-musllvm] [--disable-inlining] [--ipdse] [--use-crabopt] [--use-pointer-analysis] [--inter-spec VAL] [--intra-spec VAL] [--enable-config-prime] [--use-dynamic-args] [--help]"
    echo "       VAL=none|aggressive|nonrec-aggressive|onlyonce"
}

#default values
INTER_SPEC="none"
INTRA_SPEC="onlyonce"
USE_MUSLLVM="false"
OPT_OPTIONS=""
USE_DYN_ARGS="false"

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -inter-spec|--inter-spec)
	INTER_SPEC="$2"
	shift # past argument
	shift # past value
	;;
    -intra-spec|--intra-spec)
	INTRA_SPEC="$2"
	shift # past argument
	shift # past value
	;;
    -disable-inlining|--disable-inlining)
	OPT_OPTIONS="${OPT_OPTIONS} --disable-inlining"
	shift # past argument
	;;
    -enable-config-prime|--enable-config-prime)
	OPT_OPTIONS="${OPT_OPTIONS} --enable-config-prime"
	shift # past argument
	;;
    -with-musllvm|--with-musllvm)
	USE_MUSLLVM="true" 
	shift # past argument
	;;
    -use-dynamic-args|--use-dynamic-args)
	USE_DYN_ARGS="true" 
	shift # past argument
	;;            
    -ipdse|--ipdse)
	OPT_OPTIONS="${OPT_OPTIONS} --ipdse"
	shift # past argument
	;;
    -use-crabopt|--use-crabopt)
	OPT_OPTIONS="${OPT_OPTIONS} --use-crabopt"
	shift # past argument
	;;
    -use-pointer-analysis|--use-pointer-analysis)
	OPT_OPTIONS="${OPT_OPTIONS} --use-pointer-analysis"	
	shift # past argument
	;;    
    -help|--help)
	usage
	exit 0
	;;
    *)    # unknown option
	POSITIONAL+=("$1") # save it in an array for later
	shift # past argument
	;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

YICES_LIB=`realpath libyices.a`
#check that the require dependencies are built
declare -a bitcode=("yices_main.bc" $YICES_LIB)

for bc in "${bitcode[@]}"
do
    if [ -a  "$bc" ]
    then
        echo "Found $bc"
    else
        echo "Error: $bc not found. Try \"make\"."
        exit 1
    fi
done


#apt-get install libpcap-dev lzip -y
#make clean
#rm -rf slash
#make
#cp ./yices-2.6.1/build/x86_64-pc-linux-gnu-release/lib/libyices.a .

MANIFEST=yices.manifest

if [ $USE_DYN_ARGS == "true" ];
then
cat > ${MANIFEST} <<EOF    
{"binary": "yices_occamized",
 "native_libs":[],
 "name": "yices_main",
 "modules": [],
 "static_args": ["--logic=QF_BV"],
 "dynamic_args": "1",
 "ldflags": ["-lgmp","$YICES_LIB"],
 "main": "yices_main.bc"
 }
EOF
else
EXAMPLE=`realpath ./yices-2.6.1/examples/bool_eqs.ys`
cat > ${MANIFEST} <<EOF    
{"binary": "yices_occamized",
 "native_libs":[],
 "name": "yices_main",
 "modules": [],
 "static_args": ["--logic=QF_BV", "$EXAMPLE"],
 "ldflags": ["-lgmp","$YICES_LIB"],
 "main": "yices_main.bc"
 }
EOF
fi


export OCCAM_LOGLEVEL=INFO
export OCCAM_LOGFILE=${PWD}/slash/occam.log


# OCCAM
SLASH_OPTS="--inter-spec-policy=${INTER_SPEC} --intra-spec-policy=${INTRA_SPEC}   --stats $OPT_OPTIONS"
echo "============================================================"
echo "Running with options ${SLASH_OPTS}"
echo "============================================================"
slash ${SLASH_OPTS} --work-dir=slash ${MANIFEST}

status=$?
if [ $status -eq 0 ]
then
    cp ./slash/yices_occamized ./
    cp yices-2.6.1/build/x86_64-pc-linux-gnu-release/bin/yices_main ./yices_main_orig
    strip yices_occamized -o yices_occamized_stripped
else
    echo "Something failed while running slash"
fi    




