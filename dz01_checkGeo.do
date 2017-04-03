clear
capture log close
set more off

* define paths
include D:\Docs\Myanmar\DryZone\Analysis\Stata\do\dz000_paths.do


use $rawdir\RADZ_MAIN_merged, clear 
merge m:1 ea  using $ea_vt_codes
drop if _m==2 
drop _m 

* add interview status
merge 1:1 interview using $rawdir\CurrentStatus

* make useful variables: 
clonevar enumerator = a110 
clonevar vname = a104
clonevar dt = a107 

* make date and time variables: 
gen datetime = clock(dt, "YMD#hms#")
format datetime %tc
lab var datetime "date and time GMT time zone"

* Is interview a proper identifier? 
isid inter

* Are village tracts properly defined? 
list tcode vtcode vt_4check ea 
gen badcode = (vtcode!=vt_4check) 
list tcode vtcode ea vt_4check badcode enum 
list tcode vtcode ea vt_4check curstat badcode enum  if badcode==1

* Is EA a proper identifyer? 
isid ea
duplicates tag ea , gen (dupea)
sort ea
list inter tcode eacode vtcode dupea curstat a103*  vname enum date a105__L* 
list inter tcode eacode vtcode dupea curstat a103*  vname enum date a105__L* if qv==13
list inter tcode eacode vtcode a103*  vname enum date a105__L* if dupea==1
