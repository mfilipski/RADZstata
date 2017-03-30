clear
capture log close
set more off

* make the EA and VT matching geo file
*===================================================================

import excel "D:\Docs\Myanmar\DryZone\DATA\extras\ea_vt_comm.xlsx" , firstrow
rename villagetract vt_4check
rename ea eacode 
save "D:\Docs\Myanmar\DryZone\DATA\extras\ea_vt_codes.dta", replace 


* merge version 13 and 14:
*===================================================================
* paths 
global workdir "D:\Docs\Myanmar\DryZone\Analysis\Stata\do"
global v14dir "D:\Docs\Myanmar\DryZone\DATA\tempdata\TempSurveyData\RADZ_v14_170330"
global v13dir "D:\Docs\Myanmar\DryZone\DATA\tempdata\TempSurveyData\RADZ_v13_170330"
global mergedir "D:\Docs\Myanmar\DryZone\DATA\tempdata\TempSurveyData\Merged_current"
global temp "D:\Docs\Myanmar\DryZone\DATA\tempdata\TempSurveyData\Merged_current\temp"
global outdatafile "$mergedir\radz_main"

cd "$workdir"

* main file: 
use "$v13dir\RADZ survey - Dry Zone Community Questionnaire", clear

* convert village tract code from string to integer: 
clonevar vtcode = a103
clonevar a103_v13 = a103  
list Id-a104 vt 
replace vt = "." if Id == "f9b8b2f8be8747798aea40a2b24c1b5c"
replace vt = "." if  Id== "4c43bb5e80214b428d7053a7aebd8863"
list Id-a104 vt
desc vt 
destring vt, replace
gen qversion = 13 
label var qversion "version of questionnaire 13 or 14"

* recode more stuff to stringi if needed... 

save $temp\v13main, replace 

* Merge with v14 
use "$v14dir\RADZ survey - Dry Zone Community Questionnaire", clear
clonevar vtcode = a103
gen qversion = 14 
label var qversion "version of questionnaire 13 or 14"
append using $temp\v13main, force
list Id a101 a102 a103* vt* a104 a105__L*

clonevar eacode = a102 
clonevar tcode = a101 
label define tcode 1 "Budalin" 2 "Magway" 3 "Pwintbyut" 4 "Myittha"
label values tcode tcode
list Id tcode eacode vtcode a103* a104 a105__L*

save $outdatafile, replace






