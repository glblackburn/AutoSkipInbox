#!/usr/bin/env bash
set -euET -o pipefail

script_name=$(basename $0)
script_dir=$(dirname $0)

label=${1:-autoskipinbox}
file=${2:-$(find log/reports -type f -name "get-label-report_*.txt" | sort | tail -1)}

cat<<EOF
================================================================================
label=[${label}]
file=[${file}]]
================================================================================
EOF
grep "label:${label}," ${file} |
awk -F'count:' '{print $2 "\t" $0}'   |
sort -nr   | cut -f2-
