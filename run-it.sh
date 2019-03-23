#!/bin/bash

RUBY_PATH="/usr/local/opt/ruby/bin"
PATH="${RUBY_PATH}:${PATH}"

BASEDIR=$(dirname $0)
LOGDIR=${BASEDIR}/log
TIMESTAMP=`date +%Y-%m-%d_%H%M%S`
RUNLOG=${LOGDIR}/run-it_${TIMESTAMP}.log
LOG=${LOGDIR}/autoskipinbox.log

cd ${BASEDIR}
mkdir -p ${LOGDIR}
{
START=`date`
cat <<EOF
START=[${START}]
HOME=[${HOME}]
BASEDIR=[${BASEDIR}]
LOGDIR=[${LOGDIR}]
LOG=[${LOG}]
ruby=[`which ruby`]
================================================================================
EOF

cat <<EOF
================================================================================
run autoskipinbox.rb
================================================================================
EOF
ruby autoskipinbox.rb

cat <<EOF
================================================================================
run get-tofix-from.rb
================================================================================
EOF
ruby get-tofix-from.rb

cat <<EOF
================================================================================
run get-todump-from.rb
================================================================================
EOF
ruby get-todump-from.rb

cat <<EOF
================================================================================
check in the output
================================================================================
EOF

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
    filtercount=`cat ${RUNLOG} | grep "filter.id" | wc -l`
    cat <<EOF
{date:${date}, emailsmoved:${emailsmoved}, filtercount:${filtercount}}
EOF
} >> ${LOG}
