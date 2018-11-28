#!/bin/bash
file="Edits/test_edits.txt"
input="Dummy_Data/VAT.csv"
> $file
# Set "," as the field separator using $IFS 
# and read line by line using while read combo 
IFS=','
l=0
headers=()
while read -a line; do
    for i in "${!line[@]}"; do
    	if [[ $l == 0 ]] ; then
    		headers+=(${line[i]})
    		continue
    	fi
    	if [[ "${headers[i]}" == "ubrn" ]] ; then
    		ubrn=${line[i]}
    	elif [[ "${headers[i]}" == "vatref" ]] ; then
    		vatref=${line[i]}
    	fi
    done
    if [[ $l > 1 ]] ; then
    	echo "$ubrn,$prev_ubrn,$vatref,vats" >> $file
    fi
    prev_ubrn=$ubrn
    let "l++"
    
done < "$input"

input="Dummy_Data/PAYE.csv"
# Set "," as the field separator using $IFS 
# and read line by line using while read combo 
IFS=','
l=0
headers=()
while read -a line; do
    for i in "${!line[@]}"; do
    	if [[ $l == 0 ]] ; then
    		headers+=(${line[i]})
    		continue
    	fi
    	if [[ "${headers[i]}" == "ubrn" ]] ; then
    		ubrn=${line[i]}
    	elif [[ "${headers[i]}" == "payeref" ]] ; then
    		payeref=${line[i]}
    	fi
    done
    if [[ $l > 1 ]] ; then
    	echo "$ubrn,$prev_ubrn,$payeref,payes" >> $file
    fi
    prev_ubrn=$ubrn
    let "l++"
    
done < "$input"