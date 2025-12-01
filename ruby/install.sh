#!/bin/bash

#0,15,30,45 * * * * /Volumes/home2/projects/bin/gmail/g.lee.blackburn/run-it.sh

RUBY_PATH="/usr/local/opt/ruby/bin"
PATH="${RUBY_PATH}:${PATH}"

BASEDIR=$(dirname $0)
PARENTDIR=$(dirname ${BASEDIR})
CONFIGDIR=${PARENTDIR}/config
LOGDIR=${PARENTDIR}/log
TIMESTAMP=`date +%Y-%m-%d_%H%M%S`
INSTALLLOG=${LOGDIR}/install_${TIMESTAMP}.log

CRONTAB=${CONFIGDIR}/crontab
CRONTABOLD=${LOGDIR}/crontab_${TIMESTAMP}_old
CRONTABNEW=${LOGDIR}/crontab_${TIMESTAMP}_new

RUBY=`which ruby`

mkdir -p ${LOGDIR}
{
START=`date`
cat <<EOF
START=[${START}]
HOME=[${HOME}]
BASEDIR=[${BASEDIR}]
LOGDIR=[${LOGDIR}]
INSTALLLOG=[${INSTALLLOG}]
CONFIGDIR=[${CONFIGDIR}]
PATH=[${PATH}]
ruby=[${RUBY}]
ruby version=[`${RUBY} --version`]
================================================================================
EOF

mkdir -p ${CONFIGDIR}

cat <<EOF
================================================================================
gem install google-api-client -v '~> 0.8'
================================================================================
EOF
gem install google-api-client -v '~> 0.8'

cat <<EOF
================================================================================
install auth file for Google API goto:
https://developers.google.com/gmail/api/quickstart/ruby Click
"DOWNLOAD CLIENT CONFIGURATION" BUTTON AND save the json file as
'config/client_secret.json'
================================================================================
EOF

#echo "EXIT BEFORE INSTALL CRONTAB"
#exit

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