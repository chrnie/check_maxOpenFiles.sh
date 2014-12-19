#!/bin/bash

#######################################################
# Monitoring plugin to check number of open files     #
#######################################################

# set defaults:
crit=95
warn=90

usage(){
cat << EOF

usage: $0 -w <percent> -c <percent> -h

OPTIONS:
    -w   Warning treshhold for max files in percent (default 90%)
    -c   Critical treshhold for max files in percent (default 95%)
    -h   this help

This plugin gets MaxOpenFiles from /proc/sys/fs/file-max and current open files from lsof -l

EOF
}

while getopts "h:w:c:" OPTION > /dev/null 2>&1
do
    case $OPTION in
        w)
            warn=$OPTARG
            ;;
        c)
            crit=$OPTARG
            ;;
        h)
            usage
            exit 3
            ;;
        *)
            usage
            exit 3
            ;;
    esac
done

#check numbers of files
FILES=`lsof -l | wc -l`
MAX=`cat /proc/sys/fs/file-max`
#MAX=15555
PERCENTAGE=$(echo "$FILES / $MAX * 100" | bc -l|sed -e 's/\(.\...\).*$/\1/'| sed -e 's/^\.\(...\).*$/0.\1/')
CRITICAL=$(echo "$MAX * 0.$crit" | bc -l|sed -e 's/\..*$//')
WARNING=$(echo "$MAX * 0.$warn" | bc -l|sed -e 's/\..*$//')

## DEBUGGING
#echo Files: $FILES
#echo Max:   $MAX
#echo perc of max: $PERCENTAGE
#echo Crit files:  $CRITICAL
#echo Warn files:  $WARNING


if [ $FILES -lt $WARNING ]; then
  status=0
  statustxt=OK
elif [ $FILES -gt $WARNING ]; then
  status=1
  statustxt=WARNING
elif [ $FILES -gt $CRITICAL ]; then
  status=2
  statustxt=CRITICAL
fi

echo "MaxOpenFiles $statustxt - $PERCENTAGE% files arrived| 'OpenFiles'=$FILES;$WARNING;$CRITICAL;0;$MAX"

exit $status
