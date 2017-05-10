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
tab _m 
drop _m

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
list tcode vtcode ea vt_4check qver curstat badcode enum  if badcode==1

* Make a GPS file for csv imports 
preserve 
clonevar latitude = a105__Lat
clonevar longitude = a105__Long
clonevar accuracy = a105__Accur
keep tcode eacode vtcode vname enum latitude longitude accuracy
gen Object_ID = _n 
drop if latitude <0 
drop if longitude <0 
export  delimited using "D:\Docs\Myanmar\DryZone\Analysis\GIS_mapping\gps_coord_autoexport.csv", replace
restore 

* Is EA a proper identifyer?  NO, still not! 
*isid ea
duplicates tag ea , gen (dupea)
sort ea
list inter tcode eacode vtcode dupea curstat a103*  vname enum date a105__L* 
list inter tcode eacode vtcode dupea curstat a103*  vname enum date a105__L* if qv==13
list inter tcode eacode vtcode dupea a103*  curstat vname enum date a105__L*  if dupea>0
crash
 
list inter tcode eacode vtcode a103*  curstat vname enum date a105__L*  if vname=="kyauk oo"
list inter tcode eacode vtcode a103*  curstat vname enum date a105__L*  if vname=="YeHtwat"
  
* Check comments on interviews displaying odd behavior: 
gen tocheck = . 
replace tocheck = 1 if eacode<0
replace tocheck = 1 if dupea>0
replace tocheck = 1 if badcode==1

tempfile tocheck  
save `tocheck'
use  $rawdir\InterviewComments_merged, clear 
merge m:1 interview using `tocheck' 

sort interview Variable Order 
*gen comshort = abbrev(Comment, 20)
*gen comshort = strlen(Comment)
gen comshort = substr(Comment, 1, 50)
list  tcode eacode vtcode dupea badcode qv enum curstat Order Variable comshort if tocheck == 1 , sepby(interview Variable)
list  interview tcode eacode vtcode dupea badcode qv enum curstat Order Variable comshort if tocheck == 1 & Variable=="a102", sepby(interview Variable)



