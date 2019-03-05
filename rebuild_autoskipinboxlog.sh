#!/bin/bash


BASEDIR=$(dirname $0)
LOGDIR=${BASEDIR}/log
#TIMESTAMP=`date +%Y-%m-%d_%H%M%S`
#RUNLOG=${LOGDIR}/run-it_${TIMESTAMP}.log
LOG=${LOGDIR}/autoskipinbox.log

cat<<EOF
LOGDIR=[${LOGDIR}]
LOG=[${LOG}]

EOF

{
for file in `ls -1 ${LOGDIR}` ; do
    RUNLOG="${LOGDIR}/${file}"
    date=`cat ${RUNLOG} | grep START | head -1 | sed "s/START=\[\(.*\)\]/\1/"`
    emailsmoved=`cat ${RUNLOG} | grep "move email:" | wc -l`
    filtercount=`cat ${RUNLOG} | grep "filter.id" | wc -l`
    cat <<EOF
{date:${date}, emailsmoved:${emailsmoved}, filtercount:${filtercount}}
EOF
done
} > ${LOG}
