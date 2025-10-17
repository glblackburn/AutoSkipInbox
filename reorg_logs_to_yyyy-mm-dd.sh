#!/bin/bash

BASEDIR=$(dirname $0)
log_dir=${BASEDIR}/log

#./log/run-it_2021-01-01_064501.log
num='([0-9^]+)'
nonum='[^0-9^]+'
file_pattern=${nonnum}_${num}-${num}-${num}_${num}.log

#find . -type f -maxdepth 1 -name "*_201[5-9]*.log" | while read file ; do


find ${log_dir} -type f -maxdepth 2 -name "*_*-*-*_*.log" | while read file ; do
    if [[ ${file} =~ ${file_pattern} ]] ; then
        year=${BASH_REMATCH[1]}
        month=${BASH_REMATCH[2]}
        day=${BASH_REMATCH[3]}
        time=${BASH_REMATCH[4]}

	dir="${log_dir}/${year}/${month}/${day}"
	cat<<EOF
year=[${year}] month=[${month}] day=[${day}] time=[${time}] dir=[${dir}] file=[${file}]
EOF
	mkdir -p ${dir}
	mv "${file}" ${dir}
    else
    cat<<EOF
NO MATCH: file=[${file}]
EOF
    fi
done
