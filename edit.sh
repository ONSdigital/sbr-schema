#!/bin/bash

# 1:file_path 2:namespace 3:period 4:l/r (local/remote)

input=$1

if [[ "$4" == r ]] ; then
	url="https://apigw-in-d-01.ons.statistics.gov.uk"	
else
	url="http://localhost"
fi

# Set "," as the field separator using $IFS 
# and read line by line using while read combo 
l=0
while IFS=',' read -r f1 f2 f3 f4
do  
  let "l++"
  re='[a-zA-Z]'
  if [[ $f1 =~ $re ]]  ; then
  	continue
  fi
  
  #creation!
  if [[ -z "$f2" ]] ; then
  	ern=$(sed -n '1p' < ubrn_ent.txt)
  	ubrn=$(sed -n '2p' < ubrn_ent.txt)
  	f2=$ubrn
  	echo $2 $3 $ern $ubrn
	/bin/bash Edits/create_ent.sh $2 $3 $ern $url $4
  	/bin/bash Edits/create_leu.sh $2 $3 $ern $ubrn $url $4
  	let "ern++"
  	let "ubrn++"
	> ubrn_ent.txt
	echo $ern >> ubrn_ent.txt
	echo $ubrn >> ubrn_ent.txt
  	
  fi
  # Get the last character of the row (could be carriage return!)
  temp=$(echo ${f4: -1})
  f4=$(echo "$f4" | tr '[:upper:]' '[:lower:]')
  
  # Check if the character is not a number or is not X
  if ! [[ $temp =~ $re ]]  ; then
  	#Remove the last character which is predictably carriage return
  	f4=$(echo "${f4%?}") 
  	#Remove the remaining white space if present
	f4="$(echo -e "${f4}" | tr -d '[:space:]')"
	if [[ "$temp" != "s" ]] ; then
  		f4="${f4}s"
	fi
  fi
  if [[ $f4 != *"*"* ]]; then
  	/bin/bash Edits/call_api.sh $f1 $f2 $f3 $f4 $3 $4
  fi
done < "$input"