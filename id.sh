#!/bin/bash
source ../conf/config.sh

#awk '!a[$2]++' info.txt>1.txt
awk 'BEGIN{!a[$2]++}{a[substr($1,1,2)]+=1}END{for(i in a)printf("%s %d\n",i,a[i])}' 1.txt|sort -rn -k2|head -5>province.txt
