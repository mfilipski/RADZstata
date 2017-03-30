clear
capture log close
set more off

* define paths
include D:\Docs\Myanmar\DryZone\Analysis\Stata\do\dz0000_paths.do

* CHECK VERSION 13 
*++++++++++++++++++++++++++
use "D:\Docs\Myanmar\DryZone\Questionnaire\SurveyData\RADZ_v13_data_170327\RADZ survey - Dry Zone Community Questionnaire.dta", clear

clonevar vt = a103 
list Id-a104 vt 
replace vt = "." if Id == "f9b8b2f8be8747798aea40a2b24c1b5c"
replace vt = "." if  Id== "4c43bb5e80214b428d7053a7aebd8863"
list Id-a104 vt
destring vt, replace

clonevar ea = a102 
replace ea = . if ea<1 
merge m:1 ea  using $ea_vt_codes
list a101 vt vt_4check ea 
gen badcode = (vt!=vt_4check) 
clonevar enumerator = a110 
list a101 vt vt_4check ea enum badcode 
 

 * * CHECK VERSION 14 
*++++++++++++++++++++++++++
use "D:\Docs\Myanmar\DryZone\Questionnaire\SurveyData\RADZ_v14_data_170327\RADZ survey - Dry Zone Community Questionnaire.dta", clear

clonevar vt = a103 
list Id-a104 vt 
destring vt, replace

clonevar ea = a102 
replace ea = . if ea<1 
merge m:1 ea  using $ea_vt_codes
list a101 vt vt_4check ea 
gen badcode = (vt!=vt_4check) 
clonevar enumerator = a110 
list a101 vt vt_4check ea enum badcode 