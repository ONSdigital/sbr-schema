#!/bin/bash
link_url="$3$1:unit_link_$2/rowkey"
input="Link_Data.txt"
array=()
# Set "," as the field separator using $IFS 
# and read line by line using while read combo 
IFS=','
while read -a line; do
	if [[ "${line[3]}" == *"REU"* ]] ; then
		temp="${line[2]}"
		reu=${temp:6}
		reu=${reu%?}
		temp="${line[1]}"
		ent=${temp:6}
		ent=${ent%?}
		array[$ent]=$reu
	elif [[ "${line[3]}" == *"LOU"* && "${line[1]}" == *"ENT"* ]] ; then
		temp="${line[2]}"
		lou=${temp:6}
		lou=${lou%?}
		temp="${line[1]}"
		ent=${temp:6}
		ent=${ent%?}
		rn_64=$(echo -n "LOU~$lou" | base64)
		header_64=$(echo -n "l:p_REU" | base64)
		val_64=$(echo -n "${array[$ent]}" | base64)
		data=$(echo '{"Row":[{"key":"'$rn_64'", "Cell": [{"column":"'$header_64'", "$":"'$val_64'"}]}]}')
		/bin/bash ../HBase_scripts/Call_API.sh "$data" $link_url &
				
		rn_64=$(echo -n "REU~${array[$ent]}" | base64)
		header_64=$(echo -n "l:c_$lou" | base64)
		val_64=$(echo -n "LOU" | base64)
		data=$(echo '{"Row":[{"key":"'$rn_64'", "Cell": [{"column":"'$header_64'", "$":"'$val_64'"}]}]}')
		/bin/bash ../HBase_scripts/Call_API.sh "$data" $link_url &
	fi
	
done < "$input"