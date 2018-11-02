---------------------------------------------------------
																 
  SBR HBase Test Data Creation 				
  
  George Rushton							 
  
  George.Rushton1@ons.gov.uk						 	
																	 	
----------------------------------------------------------------------
						1. Download the files 

Download the HBase_scripts and the Dummy_Data files. Place these files 
anywhere on your system, but they must be placed in the same directory. 

----------------------------------------------------------------------
						2. Change the REST URL (Optional)
						
Edit the Run.sh file. You will see the following lines of code

if [[ "$3" == r ]] ; then
	url="https://apigw-in-d-01.ons.statistics.gov.uk:9443/hbase/"	
else
	url="http://localhost:8080/"
fi  

Edit the first line for remote urls or the second for local urls

----------------------------------------------------------------------

						3. Full Teardown and Creation
					
Navigate to the HBase_Scripts directory and run the following command 
"Run.sh" with the following parameters. 

$1 = *Namespace* e.g. sbr_control_db
$2 = *Period* e.g. 201810
$3 = *remote or local* e.g. r = remote, default is local.

This will call the following scripts in this order.

Drop Tables.sh
Drop Namespace.sh
Create Namespace.sh
Create Tables.sh

The tables are then populated asyncronously by calling the follwoing

VAT_Data.sh
PAYE_Data.sh 
Reporting_Unit_Data.sh
Local_Unit_Data.sh 
Legal_Unit_Data.sh 
Enterprise_Data.sh

----------------------------------------------------------------------

						4. Individual Commands 
						
You may call the individual commands at any time if you need to 
rerun sections or tailor the output. 

						
				Drop Tables.sh *Namespace* *Period* *Url*

This will drop the tables with the following names by submitting curl 
commands to *Url*


*Namespace*_vat
*Namespace*_paye 
*Namespace*_reporting_unit_*Period*
*Namespace*_local_unit_*Period*
*Namespace*_legal_unit_*Period*
*Namespace*_enterprise_*Period*

				Drop Namespace.sh *Namespace* *Url*

Will drop the Namespace *Namespace* by submitting a curl command to 
*Url*

				Create Namespace.sh *Namespace* *Url*

Will create the Namespace *Namespace* by submitting a curl command to 
*Url*

				Create Tables.sh *Namespace* *Period* *Url*

This will create the tables with the following names by submitting 
curl commands to *Url*

*Namespace*_vat
*Namespace*_paye 
*Namespace*_reporting_unit_*Period*
*Namespace*_local_unit_*Period*
*Namespace*_legal_unit_*Period*
*Namespace*_enterprise_*Period*

				VAT_Data.sh *Namespace* *Period* *Url*

Reads the CSV file VAT.csv from the Dummy_Data directory populating both
vat and unit links tables. 

				PAYE_Data.sh *Namespace* *Period* *Url*
				
Reads the CSV file PAYE.csv from the Dummy_Data directory populating both
vat and unit links tables. 

				Reporting_Unit_Data.sh *Namespace* *Period* *Url*

Reads the CSV file Complex_RUs.csv from the Dummy_Data directory populating both
vat and unit links tables. 

				Local_Unit_Data.sh *Namespace* *Period* *Url*

Reads the CSV file Complex_LUs.csv from the Dummy_Data directory populating both
vat and unit links tables. 

				Legal_Unit_Data.sh *Namespace* *Period* *Url*

Reads the CSV file Complex_LeU_to_ENT.csv from the Dummy_Data directory populating both
vat and unit links tables. 

				Enterprise_Data.sh *Namespace* *Period* *Url*
				
Reads the CSV file Complex_Ents.csv from the Dummy_Data directory populating both
vat and unit links tables. 
