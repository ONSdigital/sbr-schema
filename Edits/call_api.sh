# 1:from 2:to 3:paye/vat_id 4:type(payes/vats) 5:period 6:local/remote (l/r)
d=$(echo '{"parent": {"from": {"id": "'"$1"'","type" : "LEU"},"to": {"id": "'"$2"'","type" : "LEU"}},"audit": { "username": "abcd" }}')
url="$6v1/periods/$5/edit/$4/$3"

response=$(curl -k -s -w "%{http_code}" --header "Content-type: application/json" --request POST --data "$d" "$url")


if [[ $response == "201" || $response == "200" ]] ; then

	echo "passed, data = $1,$2,$3,$4"
	
else

	echo "------------------------------------Failed-------------------------------------------"
	
	echo "$response, from: $1 to: $2 value: $3 type: $4"
	
	echo "-------------------------------------------------------------------------------------"
	
	
fi
