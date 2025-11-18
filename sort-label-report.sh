#!/usr/bin/env bash
set -euET -o pipefail

script_name=$(basename $0)
script_dir=$(dirname $0)

label=${1:-autoskipinbox}
file=${2:-log/reports/get-label-report_2025-11-18_091723.txt}

grep "label:${label}," ${file} |
awk -F'count:' '{print $2 "\t" $0}'   |
sort -nr   | cut -f2-
