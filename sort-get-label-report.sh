#!/bin/bash

file=log/get-label-report_2022-05-07.log
cat ${file} | grep "count:" | sort -t : -k 3 -n -r
