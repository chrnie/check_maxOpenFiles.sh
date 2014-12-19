check_maxOpenFiles.sh
=====================

simple bash script for checking maxOpenFiles on a linux system in nagios/icinga/shinken/naemon . . .

# call
    ./check_maxOpenFiles.sh 
    MaxOpenFiles OK - 7.14% files arrived| 'OpenFiles'=57109;719231;759188;0;799146

# help

    ./check_maxOpenFiles.sh --help
    
    usage: ./check_maxOpenFiles.sh -w <percent> -c <percent> -h
    
    OPTIONS:
        -w   Warning treshhold for max files in percent (default 90%)
        -c   Critical treshhold for max files in percent (default 95%)
        -h   this help
    
    This plugin gets MaxOpenFiles from /proc/sys/fs/file-max and current open files from lsof -l

