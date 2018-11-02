m_table_headers=(ubrn name address1 postcode sic07 legal_status birth_date)
if [[ "$6" == r ]] ; then
	url="$5:9443/hbase/$1:enterprise_$2/rowkey"
else
	url="$5:8080/$1:enterprise_$2/rowkey"
fi
ern_rev=$(echo "$(/bin/bash Edits/rev.sh $3)")
rn_64=$(echo -n "$ern_rev~$4" | base64)
for i in "${!m_table_headers[@]}"; do
	header_64=$(echo -n "d:${m_table_headers[i]}" | base64)
	if [[ "$i" == "0" ]] ; then
		val_64=$(echo -n "$4" | base64)
	else
		val_64=$(echo -n "TEMP" | base64)
	fi
	data=$(echo '{"Row":[{"key":"'$rn_64'", "Cell": [{"column":"'$header_64'", "$":"'$val_64'"}]}]}')
	response=$(curl -k -s -w "%{http_code}" --header "Content-type: application/json" --request PUT --data-binary "$data" "$url")
	echo $data
	echo $response
done
	url="$5:9443/hbase/$1:unit_link_$2/rowkey"
	rn_64=$(echo -n "LEU~$4" | base64)
	header_64=$(echo -n "l:p_ENT" | base64)
	val_64=$(echo -n "$3" | base64)
	data=$(echo '{"Row":[{"key":"'$rn_64'", "Cell": [{"column":"'$header_64'", "$":"'$val_64'"}]}]}')
	response=$(curl -k -s -w "%{http_code}" --header "Content-type: application/json" --request PUT --data-binary "$data" "$url")

	rn_64=$(echo -n "ENT~$3" | base64)
	header_64=$(echo -n "l:c_$4" | base64)
	val_64=$(echo -n "LEU" | base64)
	data=$(echo '{"Row":[{"key":"'$rn_64'", "Cell": [{"column":"'$header_64'", "$":"'$val_64'"}]}]}')
	response=$(curl -k -s -w "%{http_code}" --header "Content-type: application/json" --request PUT --data-binary "$data" "$url")
	
	#echo "put '$1:unit_link_$2', 'LEU~$ubrn_num', 'l:p_ENT', '$temp'" >> $link
	#echo "put '$1:unit_link_$2', 'ENT~$temp', 'l:c_$ubrn_num', 'LEU'" >> $link