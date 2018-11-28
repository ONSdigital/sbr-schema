#!/bin/bash

response=$(curl -s -w "%{http_code}" --request POST "$2namespaces/$1")
echo $2namespaces/$1
echo $response
