#!/bin/bash

response=$(curl -k -s -w "%{http_code}" --header "Content-type: text/xml" --request DELETE "$2namespaces/$1")
echo $response
