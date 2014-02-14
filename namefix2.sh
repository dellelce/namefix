#!/bin/bash
#
# File:         namefix.sh
# Created:      1646 210713
# Description:  description for namefix.sh
#

### FUNCTIONS ###

cleanup()
{
  [ -f "$tmpList" ] && rm -f "$tmpList"
}

### ENV ###

rootDir="$(dirname $0)"
code="$rootDir/namefix.awk"
tmpList="/tmp/namefix.$$.$RANDOM.txt"

trap cleanup INT

### MAIN ###

{
 find . -type f > "$tmpList"

 cat "$tmpList" | while read x
 do
    [ -f "$x" ] && echo "$x";
 done 
} | awk -f $code


rm -f "$tmpList"

### EOF ###
