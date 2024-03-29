#!/usr/bin/env bash

# Make sure we exit if there is a failure
set -e

function usage() {
    echo "Usage: $0 [--with-musllvm] [--disable-inlining] [--ipdse] [--use-crabopt] [--use-pointer-analysis] [--inter-spec VAL] [--intra-spec VAL] [--enable-config-prime] [--use-dynamic-args] [--help]"
    echo "       VAL=none|aggressive|nonrec-aggressive|onlyonce"
}

function manifest_static_with_musllvm() {
    MANIFEST=$1
    SAMPLE=$2
    cat <<EOF > ${MANIFEST} 
    { "main" : "readelf.bc"
    , "binary"  : "readelf_occamized"
    , "modules"    : ["libc.a.bc"]
    , "native_libs" : [ "/usr/lib/libiconv.dylib", "libc.a" ]
    , "ldflags" : [ "-O2" ]
    , "name"    : "readelf"
    , "static_args" : ["-s", "$SAMPLE"]
    }
EOF
}

function manifest_static() {
    MANIFEST=$1
    SAMPLE=$2    
    cat <<EOF > ${MANIFEST} 
    { "main" : "readelf.bc"
    , "binary"  : "readelf_occamized"
    , "modules"    : []
    , "native_libs" : [ "/usr/lib/libiconv.dylib" ]
    , "ldflags" : [ "-O2", "-lz" ]
    , "name"    : "readelf"
    , "static_args" : ["-s","$SAMPLE"]
    }
EOF
}

function manifest_dynamic_with_musllvm() {
    MANIFEST=$1
    cat > ${MANIFEST} <<EOF    
    { "main" : "readelf.bc"
    , "binary"  : "readelf_occamized"
    , "modules"    : ["libc.a.bc"]
    , "native_libs" : [ "/usr/lib/libiconv.dylib", "libc.a" ]
    , "ldflags" : [ "-O2" ]
    , "name"    : "readelf"
    , "static_args" : ["-s"]
    , "dynamic_args" : "1"
    }
EOF
}

function manifest_dynamic() {
    MANIFEST=$1
    cat > ${MANIFEST} <<EOF    
    { "main" : "readelf.bc"
    , "binary"  : "readelf_occamized"
    , "modules"    : []
    , "native_libs" : [ "/usr/lib/libiconv.dylib" ]
    , "ldflags" : [ "-O2", "-lz" ]
    , "name"    : "readelf"
    , "static_args" : ["-s"]
    , "dynamic_args" : "1"
    }
EOF
}

#default values
INTER_SPEC="onlyonce"
INTRA_SPEC="onlyonce"
OPT_OPTIONS=""
USE_MUSLLVM="false"
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

#check that the require dependencies are built
if [ $USE_MUSLLVM == "true" ];
then
    declare -a bitcode=("readelf.bc" "libc.a.bc" "libc.a")
else
    declare -a bitcode=("readelf.bc")
fi    

for bc in "${bitcode[@]}"
do
    if [ -a  "$bc" ]
    then
        echo "Found $bc"
    else
	if [ "$bc" == "libc.a.bc" ];
	then
	    echo "Error: $bc not found. You need to compile musllvm and copy $bc to ${PWD}."
	else
            echo "Error: $bc not found. Try \"make\"."
	fi
        exit 1
    fi
done


MANIFEST=readelf.manifest

if [ $USE_DYN_ARGS == "true" ];
then
    if [ $USE_MUSLLVM == "true" ];
    then
	manifest_dynamic_with_musllvm $MANIFEST
    else
	manifest_dynamic $MANIFEST	
    fi    
else
    SAMPLE=`realpath sample-small`    
    if [ $USE_MUSLLVM == "true" ];
    then
	manifest_static_with_musllvm $MANIFEST $SAMPLE      
    else
	manifest_static $MANIFEST $SAMPLE      	
    fi    
fi

export OCCAM_LOGLEVEL=INFO
export OCCAM_LOGFILE=${PWD}/slash/occam.log

rm -rf slash

SLASH_OPTS="--inter-spec-policy=${INTER_SPEC} --intra-spec-policy=${INTRA_SPEC}  --no-strip --stats $OPT_OPTIONS"
echo "============================================================"
echo "Running readelf without libraries"
echo "slash options ${SLASH_OPTS}"
echo "============================================================"
slash ${SLASH_OPTS} --work-dir=slash ${MANIFEST}
status=$?
if [ $status -eq 0 ]
then
    ## runbench needs _orig and _slashed versions
    cp slash/readelf_occamized ./
    cp binutils-install/bin/readelf ./readelf_orig
else
    echo "Something failed while running slash"
fi    
