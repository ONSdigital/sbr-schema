#!/bin/bash
link="Link_Data.txt"
table_headers=(vatref ubrn sic07 turnover record_type legalstatus nameline tradstyle address1 address2 address3 address4 address5 postcode)
m_table_headers=(vatref ubrn sic07 turnover record_type legalstatus nameline tradstyle address1 postcode)
tmth=(${m_table_headers[@]})
fill="yes"
url="$3$1:vat/rowkey"
link_url="$3$1:unit_link_$2/rowkey"
l=0
ern=999
vatref=999
headers=()
input="Dummy_Data/VAT.csv"
# Set "," as the field separator using $IFS 
# and read line by line using while read combo 
IFS=','
while read -a line; do
	h=0
	if [[ "$vatref" != 999 ]] ; then 
		vatref_num=${line[$vatref]}
		rn="$vatref_num"~"$2"
		rn_64=$(echo -n "$rn" | base64)
	fi
    for i in "${!line[@]}"; do
    	temp=${line[i]}
    	if [[ -z "$temp" ]] ; then
    		continue
    	fi
    	lc=$(echo ${temp: -1})
    	if [[ "$lc" == $'\r' ]] ; then
        	temp=$(echo "${temp%?}") 
        fi
        temp="$(echo -e "${temp}" | sed -e 's/[[:space:]]*$//')"
    	if [[ $l == 0 ]] ; then
    		if [[ "$temp" == "vatref" ]] ; then
    			vatref=$i
    		fi
    		for y in ${!tmth[@]}; do
    			if [[ "$temp" == "${tmth[y]}" ]]; then
    				unset tmth[$y]
    			fi
    		done
    		headers+=($temp)
    	else
    	#----------------------------------------
    		if [[ " ${table_headers[@]} " =~ " ${headers[i]} " ]]; then
    			rn_64=$(echo -n "$rn" | base64)
    			header_64=$(echo -n "d:${headers[i]}" | base64)
    			val_64=$(echo -n "$temp" | base64)
    			data=$(echo '{"Row":[{"key":"'$rn_64'", "Cell": [{"column":"'$header_64'", "$":"'$val_64'"}]}]}')
    			/bin/bash HBase_scripts/Call_API.sh "$data" $url &
			    let "h++"
			    if [[ "${headers[i]}" == "ubrn" ]] ; then
			    	rn_64=$(echo -n "VAT~$vatref_num" | base64)
					header_64=$(echo -n "l:p_LEU" | base64)
					val_64=$(echo -n "$temp" | base64)
					data=$(echo '{"Row":[{"key":"'$rn_64'", "Cell": [{"column":"'$header_64'", "$":"'$val_64'"}]}]}')
					/bin/bash HBase_scripts/Call_API.sh "$data" $link_url &
				
					rn_64=$(echo -n "LEU~$temp" | base64)
					header_64=$(echo -n "l:c_$vatref_num" | base64)
					val_64=$(echo -n "VAT" | base64)
					data=$(echo '{"Row":[{"key":"'$rn_64'", "Cell": [{"column":"'$header_64'", "$":"'$val_64'"}]}]}')
					/bin/bash HBase_scripts/Call_API.sh "$data" $link_url &
			    fi
			fi
		#----------------------------------------
    	fi
    done
    if [[ "${#tmth[@]}" != "0" && "$fill" == "0" ]] ; then
    	echo "you missed these mandatory fields"
	    echo ${tmth[@]}
	    echo "Would you like temporary data to fill? yes/no:"
	    read fill </dev/tty
    fi
    if [[ "$fill" == "yes" && "$l" != "0" ]] ; then
    	for x in "${!tmth[@]}"; do
    		rn_64=$(echo -n "$rn" | base64)
    		val_64=$(echo -n "9999" | base64)
    		header_64=$(echo -n "d:${tmth[x]}" | base64)
    		data=$(echo '{"Row":[{"key":"'$rn_64'", "Cell": [{"column":"'$header_64'", "$":"'$val_64'"}]}]}')
    		/bin/bash HBase_scripts/Call_API.sh "$data" $url &
    	done
    elif [[ "$fill" == "no" ]] ; then
    	exit
    fi
    let "l++"
done < "$input"
echo "Completed VAT"