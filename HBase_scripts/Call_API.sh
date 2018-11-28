#!/bin/bash
response=$(curl -k -s -w "%{http_code}" --header "Content-type: application/json" --request PUT --data-binary "$1" "$2")
if [[ "$response" != "200" ]] ; then
	echo "------------------------------------------------"
	echo $response
	echo $1
	echo $2
	echo "------------------------------------------------"
fi
