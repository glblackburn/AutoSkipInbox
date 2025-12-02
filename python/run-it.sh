#!/bin/bash

PYTHON_PATH="python3"
PATH="${PYTHON_PATH}:${PATH}"

BASEDIR=$(dirname $0)
PARENTDIR=$(dirname ${BASEDIR})
LOGDIR=${PARENTDIR}/log
TIMESTAMP=`date +%Y-%m-%d_%H%M%S`
RUNLOG=${LOGDIR}/run-it_${TIMESTAMP}.log
FILTERSLOG=${LOGDIR}/filters_${TIMESTAMP}.log
LOG=${LOGDIR}/autoskipinbox.log

cd ${BASEDIR}
mkdir -p ${LOGDIR}
{
START=`date`
cat <<EOF
START=[${START}]
HOME=[${HOME}]
BASEDIR=[${BASEDIR}]
PARENTDIR=[${PARENTDIR}]
LOGDIR=[${LOGDIR}]
LOG=[${LOG}]
python=[`which python3`]
================================================================================
EOF

cat <<EOF
================================================================================
run autoskipinbox.py
================================================================================
EOF
python3 autoskipinbox.py

cat <<EOF
================================================================================
run get_tofix_from.py
================================================================================
EOF
python3 get_tofix_from.py

cat <<EOF
================================================================================
run get_todump_from.py
================================================================================
EOF
python3 get_todump_from.py

cat <<EOF
================================================================================
run get_filters.py
================================================================================
EOF
python3 get_filters.py > ${FILTERSLOG}

cat <<EOF
================================================================================
git status check
================================================================================
EOF

cd ${PARENTDIR}
git status
#git add .
#git commit -m "run ${TIMESTAMP}"
#git status


STOP=`date`
cat <<EOF
================================================================================
START=[${START}]
STOP =[${STOP}]
================================================================================
EOF
} > ${RUNLOG} 2>&1


{
    date=`date`
    emailsmoved=`cat ${RUNLOG} | grep "move email:" | wc -l`
    filtercount=`cat ${FILTERSLOG} | grep "filter.id" | wc -l`
    cat <<EOF
{date:${date}, emailsmoved:${emailsmoved}, filtercount:${filtercount}}
EOF
} >> ${LOG}
