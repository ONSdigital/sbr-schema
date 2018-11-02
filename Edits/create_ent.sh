m_table_headers=(ern name address1 postcode sic07 legal_status prn working_props employment region)
if [[ "$5" == r ]] ; then
	url="$4:9443/hbase/$1:enterprise_$2/rowkey"
else
	url="$4:8080/$1:enterprise_$2/rowkey"
fi

for i in "${!m_table_headers[@]}"; do
	rn_64=$(echo -n "$(/bin/bash Edits/rev.sh $3)" | base64)
	header_64=$(echo -n "d:${m_table_headers[i]}" | base64)
	if [[ "$i" == "0" ]] ; then
		val_64=$(echo -n "$3" | base64)
	else
		val_64=$(echo -n "TEMP" | base64)
	fi
	data=$(echo '{"Row":[{"key":"'$rn_64'", "Cell": [{"column":"'$header_64'", "$":"'$val_64'"}]}]}')
	response=$(curl -k -s -w "%{http_code}" --header "Content-type: application/json" --request PUT --data-binary "$data" "$url")
	echo $response
done