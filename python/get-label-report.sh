#!/usr/bin/env bash
set -euET -o pipefail

script_name=$(basename $0)
script_dir=$(dirname $0)

################################################################################
# CLI Parameters
################################################################################

################################################################################
# default values
################################################################################
report_dir=${script_dir}/../log/reports
ts=`date +%Y-%m-%d_%H%M%S`
report_file=${report_dir}/get-label-report_${ts}.txt

mkdir -p ${report_dir}

python3 get_label_report.py | tee ${report_file}
