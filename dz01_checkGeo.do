clear
capture log close
set more off

* define paths
include D:\Docs\Myanmar\DryZone\Analysis\Stata\do\dz0000_paths.do


use $rawdir\radz_main, clear 
merge m:1 ea  using $ea_vt_codes
drop if _m==2 
drop _m 

* make useful variables: 
clonevar enumerator = a110 
clonevar vname = a104
clonevar dt = a107 

* make date and time variables: 
gen datetime = clock(dt, "YMD#hms#")
format datetime %tc
lab var datetime "date and time GMT time zone"

* Is EA a proper identifyer? 
isid ea
duplicates tag ea , gen (dupea)
sort ea
list Id tcode eacode vtcode dupea a103*  vname enum date a105__L* 

crash 

list Id tcode eacode vtcode a103*  vname enum date a105__L* if dupea==1

* Is ID a proper identifier? 
isid Id

* Are village tracts properly defined? 
list tcode vtcode vt_4check ea 
gen badcode = (vtcode!=vt_4check) 
list tcode vtcode ea vt_4check badcode enum 
list tcode vtcode ea vt_4check badcode enum  if badcode==1





/*
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