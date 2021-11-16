#!/bin/bash

report_file=get-label-report.txt

ruby get-label-report.rb | tee ${report_file}
cat<<EOF
================================================================================
EOF
cat ${report_file} | sed "s/:/,/g" | grep ",inbox," | sort -t , -k 4 -n
