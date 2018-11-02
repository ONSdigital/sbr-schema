# 1:from 2:to 3:paye/vat_id 4:type(payes/vats) 5:period 6:local/remote (l/r)
d=$(echo '{"parent": {"from": {"id": "'"$1"'","type" : "LEU"},"to": {"id": "'"$2"'","type" : "LEU"}},"audit": { "username": "abcd" }}')
if [[ "$6" == r ]] ; then
	url="https://dev-sbr-api.apps.cf1.ons.statistics.gov.uk/v1/periods/$5/edit/$4/$3"
else
	url="localhost:9002/v1/periods/$5/edit/$4/$3"
fi
echo "curl -v -k --noproxy "*" -H 'Content-type: application/json' --request POST --data '"$d"' $url"
curl -v -k --noproxy "*" -H "Content-type: application/json" --request POST --data "$d" $url 
response=$(curl -k -s -i --noproxy "*" --header "Content-type: application/json" --request POST --data "$d" "$url")

# extract the body
HTTP_BODY=$(echo $response | sed -e 's/HTTPSTATUS\:.*//g')
	
# extract the status
HTTP_STATUS=$(echo $response | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

echo $url
echo $d
echo $HTTP_BODY

if [[ $HTTP_STATUS == "201" || $HTTP_STATUS == "200" ]] ; then

	echo "passed, data = $1,$2,$3,$4"
	
else

	echo "------------------------------------Failed-------------------------------------------"
	
	echo "$HTTP_STATUS, from: $1 to: $2 value: $3 type: $4"
	
	echo "-------------------------------------------------------------------------------------"
	
	
fi
