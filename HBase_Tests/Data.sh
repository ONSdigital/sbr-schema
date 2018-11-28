#!/bin/bash
function get_xml () {
	val_64=$(echo -n "$1" | base64)
	xml='<Scanner batch="1000"> <filter> { "type": "ColumnPrefixFilter", "value": "'$val_64'" } </filter> </Scanner>'
}

function create_scanner () {
	response=$(curl -k -s -i --header "Content-type: text/xml" --request PUT --data-binary "$1" "$url$2/scanner" | grep -Fi Location)
	location=${response:10}
}

function scan () {
	if [[ -z $location ]] ; then
		echo "No scanner location"
		return 0
	fi
	location=$(echo "${location%?}") 
	response=$(curl -s --write-out "HTTPSTATUS:%{http_code}" -X GET $location)
	# extract the body
	HTTP_BODY=$(echo $response | sed -e 's/HTTPSTATUS\:.*//g')
	
	# extract the status
	HTTP_STATUS=$(echo $response | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
	
	#echo "$HTTP_BODY"
	
	# example using the status
	if [ ! $HTTP_STATUS -eq 200  ]; then
	  echo "Error [HTTP status: $HTTP_STATUS]"
	fi
}

function test_table () {
	get_xml "$2"
	create_scanner "$xml" "$1"
	scan
	> "temp.txt"
	echo $HTTP_BODY >> "temp.txt"
	rows=$(grep -o 'column' temp.txt | wc -l)
	rows="$(echo -e "${rows}" | tr -d '[:space:]')"
	if [[ $rows == $3 ]] ; then
		echo "$1 has correct count of $3"
	else
		echo "$1 has incorrect count of $rows"
		failed=1;
	fi
}

failed=0;

if [[ "$3" == r ]] ; then
	url="https://apigw-in-d-01.ons.statistics.gov.uk:9443/hbase/"	
else
	url="http://localhost:8080/"
fi

echo $url
test_table $1:legal_unit_$2 "ubrn" 70
test_table $1:local_unit_$2 "lurn" 98 
test_table $1:reporting_unit_$2 "rurn" 8
test_table $1:enterprise_$2 "ern" 8
test_table $1:unit_link_$2 "p_LEU" 153
test_table $1:paye "payeref" 50
test_table $1:vat "vatref" 103

if [[ $failed == 1 ]] ; then
	echo "Failed!"
	exit 1
fi








