#!/bin/bash

#0,15,30,45 * * * * /Volumes/home2/projects/bin/gmail/g.lee.blackburn/run-it.sh

PATH="/usr/local/bin:${PATH}"
BASEDIR=$(dirname $0)
CONFIGDIR=${BASEDIR}/config
LOGDIR=${BASEDIR}/log
TIMESTAMP=`date +%Y-%m-%d_%H%M%S`
INSTALLLOG=${LOGDIR}/install_${TIMESTAMP}.log

CRONTAB=${CONFIGDIR}/crontab
CRONTABOLD=${LOGDIR}/crontab_${TIMESTAMP}_old
CRONTABNEW=${LOGDIR}/crontab_${TIMESTAMP}_new

mkdir -p ${LOGDIR}
{
START=`date`
cat <<EOF
START=[${START}]
HOME=[${HOME}]
BASEDIR=[${BASEDIR}]
LOGDIR=[${LOGDIR}]
INSTALLLOG=[${INSTALLLOG}]
PATH=[${PATH}]
ruby=[`which ruby`]
================================================================================
EOF

cat <<EOF
================================================================================
crontab before install
================================================================================
EOF
crontab -l > ${CRONTABOLD}
cat ${CRONTABOLD}

STARTDIR=`pwd`
cd ${BASEDIR}
RUNIT="`pwd`/run-it.sh"
cd ${STARTDIR}
cat <<EOF
================================================================================
RUNIT=[${RUNIT}
================================================================================
EOF

crontab -l | grep -v ${RUNIT} > ${CRONTAB}
echo "0,15,30,45 * * * * ${RUNIT}" >> ${CRONTAB}
crontab ${CRONTAB}

cat <<EOF
================================================================================
crontab after install
================================================================================
EOF
crontab -l > ${CRONTABNEW}
cat ${CRONTABNEW}


} | tee ${INSTALLLOG}