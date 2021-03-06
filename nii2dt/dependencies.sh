# Get a random number to avoid naming conflicts
RAN=$RANDOM

# Source the pipedream dependency file 
source ${0%/*}/../config/pipedream_config.sh

# Now check that everything is OK, and attempt to recover if not


# Sun Java stupidly prints version info on stderr
`${JAVAPATH}/java -Xmx100M -version > /dev/null 2> /tmp/dicom2dt.$RAN`

if [[ `cat /tmp/dicom2dt.$RAN | grep HotSpot` == "" ]]; then
    
    `java -Xmx1000M -version > /dev/null 2> /tmp/dicom2dt.$RAN`
    
    if [[ `cat /tmp/dicom2dt.$RAN | grep HotSpot` == "" ]]; then
	    echo "Cannot find Sun java executable"
	    echo "On cluster, you often need 3 slots or this will fail"
	    return 1
    fi

    echo "Cannot find Sun Java at Pipedream default path $JAVAPATH"
    echo "Using version on system path"

else
    # Need to modify PATH here, since Camino programs need 
    # to have Java on the PATH
    export PATH=$JAVAPATH:$PATH
fi

`rm -f /tmp/dicom2dt.$RAN`


# Look for Perl
if [[ `which perl 2> /dev/null` == "" ]] ; then
    echo "Cannot find Perl executable"
    return 1
fi

# Look for ANTS
if [[ `which ${ANTSPATH}/ANTS 2> /dev/null` == "" ]] ; then
    
    if [[ `which ANTS 2> /dev/null` == "" ]] ; then
	echo "Cannot find ANTS executable"
	return 1
    fi

    echo "Cannot find ANTS at Pipedream default path $ANTSPATH"
    echo "Using version on system path"

    string=`which ANTS`
    export ANTSPATH=${string%ANTS} 

else
    export ANTSPATH
fi


if [[ `which  ${CAMINOPATH}/dtfit 2> /dev/null` == "" ]] ; then

    if [[ `which dtfit 2> /dev/null` == "" ]] ; then
	echo "Cannot find Camino bin dir"
	return 1
    fi

    echo "Cannot find Camino at Pipedream default path $CAMINOPATH"
    echo "Using version on system path"
  
    string=`which dtfit`
    export CAMINOPATH=${string%/dtfit}
    
else 
    export CAMINOPATH
fi


return 0
