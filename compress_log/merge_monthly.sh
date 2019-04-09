#!/usr/bin/env bash
set -e

# Name: 合并压缩月度日志文件
# Author: Kian
# Date: 20180409

# Default last year
log_year=${1:-`date -d 'last year' +%Y`}
# Default start of January
start_month=1
# Default end of December
end_month=${2:-12}

for i in `seq ${start_month} ${end_month}`
do
    log_day=`echo ${i} | awk '{printf("%02d",$0)}'`
    log_date=${log_year}${log_day}
    log_name_prefix=access_${log_date}
    file_count=`ls ${log_name_prefix}.log 2>/dev/null | wc -l`

    if [[ "$file_count" -gt 0 ]];then
        echo "${log_name_prefix}* total ${file_count}"
        echo "Compress matching file"
        tar zcvf ${log_name_prefix}.tar.gz access_${log_date}*.log
        echo "Delete compressed file"
        rm ${log_name_prefix}*.log
        echo -e "${log_name_prefix}* removed\n"
    else
        echo -e "${log_name_prefix}* not found\n"
    fi
done
