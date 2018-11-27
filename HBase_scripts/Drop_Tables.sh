#!/bin/bash
#file="Drop_Tables.txt"

echo "$3$1:enterprise_$2/schema"
response=$(curl -k -s -w "%{http_code}" --header "Content-type: text/xml" --request DELETE "$3$1:enterprise_$2/schema")
response=$(curl -k -s -w "%{http_code}" --header "Content-type: text/xml" --request DELETE "$3$1:legal_unit_$2/schema")
response=$(curl -k -s -w "%{http_code}" --header "Content-type: text/xml" --request DELETE "$3$1:local_unit_$2/schema")
response=$(curl -k -s -w "%{http_code}" --header "Content-type: text/xml" --request DELETE "$3$1:reporting_unit_$2/schema")
response=$(curl -k -s -w "%{http_code}" --header "Content-type: text/xml" --request DELETE "$3$1:unit_link_$2/schema")
if [[ "$4" != r ]] ; then
	response=$(curl -k -s -w "%{http_code}" --header "Content-type: text/xml" --request DELETE "$3$1:vat/schema")
	response=$(curl -k -s -w "%{http_code}" --header "Content-type: text/xml" --request DELETE "$3$1:paye/schema")
fi
