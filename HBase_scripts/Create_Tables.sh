#!/bin/bash
file="Create_Tables.txt"

response=$(curl -k -s -w "%{http_code}" --header "Content-type: text/xml" --request POST -d "<?xml version='1.0' encoding='UTF-8'?><TableSchema name='$1:enterprise_$2'><ColumnSchema name='d' /></TableSchema>" "$3$1:enterprise_$2/schema")
response=$(curl -k -s -w "%{http_code}" --header "Content-type: text/xml" --request POST -d "<?xml version='1.0' encoding='UTF-8'?><TableSchema name='$1:legal_unit_$2'><ColumnSchema name='d' /></TableSchema>" "$3$1:legal_unit_$2/schema")
response=$(curl -k -s -w "%{http_code}" --header "Content-type: text/xml" --request POST -d "<?xml version='1.0' encoding='UTF-8'?><TableSchema name='$1:local_unit_$2'><ColumnSchema name='d' /></TableSchema>" "$3$1:local_unit_$2/schema")
response=$(curl -k -s -w "%{http_code}" --header "Content-type: text/xml" --request POST -d "<?xml version='1.0' encoding='UTF-8'?><TableSchema name='$1:reporting_unit_$2'><ColumnSchema name='d' /></TableSchema>" "$3$1:reporting_unit_$2/schema")
response=$(curl -k -s -w "%{http_code}" --header "Content-type: text/xml" --request POST -d "<?xml version='1.0' encoding='UTF-8'?><TableSchema name='$1:unit_link_$2'><ColumnSchema name='l' /></TableSchema>" "$3$1:unit_link_$2/schema")
if [[ "$4" != r ]] ; then
	response=$(curl -k -s -w "%{http_code}" --header "Content-type: text/xml" --request POST -d "<?xml version='1.0' encoding='UTF-8'?><TableSchema name='$1:vat'><ColumnSchema name='d' /></TableSchema>" "$3$1:vat/schema")
	response=$(curl -k -s -w "%{http_code}" --header "Content-type: text/xml" --request POST -d "<?xml version='1.0' encoding='UTF-8'?><TableSchema name='$1:paye'><ColumnSchema name='d' /></TableSchema>" "$3$1:paye/schema")
fi
