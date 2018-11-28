#!/bin/bash
if [[ "$3" == r ]] ; then
	url=$(head -n 1 config/Test/Hbase-URL.txt)
else
	url="http://localhost:8080/"
fi
echo "Drop Table"
./HBase_scripts/Drop_Tables.sh $1 $2 $url $3
if [[ "$3" != r ]] ; then
	echo "Drop Namespace"
	bash HBase_scripts/Drop_Namespace.sh $1 $url
	echo "Creating Create_Namespace"
	bash HBase_scripts/Create_Namespace.sh $1 $url
fi
echo "Creating Create_Tables"
bash HBase_scripts/Create_Tables.sh $1 $2 $url $3 
echo "Populating DB"
echo "VAT"
bash HBase_scripts/VAT_Data.sh $1 $2 $url 
echo "PAYE"
bash HBase_scripts/PAYE_Data.sh $1 $2 $url 
echo "Reporting_Unit"
bash HBase_scripts/Reporting_Unit_Data.sh $1 $2 $url 
echo "Local_Unit"
bash HBase_scripts/Local_Unit_Data.sh $1 $2 $url 
echo "Legal_Unit"
bash HBase_scripts/Legal_Unit_Data.sh $1 $2 $url 
echo "Enterprise"
./HBase_scripts/Enterprise_Data.sh $1 $2 $url 
#./RU_Link.sh $1 $2 $url
#Needs fixing for jenkins!
