#!/bin/bash

BASEDIR=$(dirname $0)
LOGDIR=${BASEDIR}/log
LOG=${LOGDIR}/autoskipinbox.log

cat ${LOG} | sed "s/^.*emailsmoved: *\([0-9]\{1,2\}\), .*$/\1/" | paste -sd+ - | bc
