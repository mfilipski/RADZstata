clear
capture log close
set more off

* define paths
include D:\Docs\Myanmar\DryZone\Analysis\Stata\do\dz000_paths.do
cd $workdir

use $rawdir\RADZ_MAIN_merged, clear 
merge m:1 ea  using $ea_vt_codes
drop if _m==2 
drop _m 


* ACREAGE
*===============================================

* Area under monsoon paddy 
clonevar n_mp12 = d103c  
clonevar n_mp14= d103b 
clonevar n_mp16 = d103a 
lab var n_mp16 "farms growing monsoon paddy in 2016"
lab var n_mp14 "farms growing monsoon paddy in 2014"
lab var n_mp12 "farms growing monsoon paddy in 2012"

clonevar a_mp12 = d104c  
clonevar a_mp14= d104b 
clonevar a_mp16 = d104a 

lab var n_mp16 "area of monsoon paddy in 2016"
lab var n_mp14 "area of monsoon paddy in 2014"
lab var n_mp12 "area of monsoon paddy in 2012"

* Area under dry season paddy 
clonevar n_dp12 = d105c  
clonevar n_dp14= d105b 
clonevar n_dp16 = d105a 
                       
clonevar a_dp12 = d106c  
clonevar a_dp14= d106b 
clonevar a_dp16 = d106a 

* Area under other crop: 
clonevar ocrop = d107 
tab d107 
list d* if ocrop <0
replace ocrop = . if ocrop<0 
clonevar n_oc12 = d108c  
clonevar n_oc14= d108b 
clonevar n_oc16 = d108a 
                       
clonevar a_oc12 = d109c  
clonevar a_oc14= d109b 
clonevar a_oc16 = d109a 

* search for 97 997 etc. 
sum n_* a_*
foreach v of varlist  n_* a_* { 
	replace `v' = . if `v' < 0 
	count if inlist(`v', 97,997,9997,98,998,999998)
	}

* make a graph of crop trends: 
* Not much change in acreage: 
graph bar (sum) a_mp*  a_dp* a_oc* 
* 
graph bar (sum) n_mp*  n_dp* n_oc* 
list n_*

graph bar (sum) n_oc* , by(ocrop)
	

* DRAFT ANIMALS 
*===============================================

* number and acreage using draft animals 
clonevar nan_p12 = d203c  	
clonevar nan_p14= d203b 
clonevar nan_p16 = d203a 
clonevar aan_p12 = d204c  	
clonevar aan_p14= d204b 
clonevar aan_p16 = d204a 

clonevar nan_oc12 = d207c
clonevar nan_oc14= d207b 
clonevar nan_oc16 = d207a 
clonevar aan_oc12 = d208c  	
clonevar aan_oc14= d208b 
clonevar aan_oc16 = d208a 


* search for 97 997 etc. 
sum nan_* aan_*
foreach v of varlist  nan_* aan_* { 
	replace `v' = . if `v' < 0 
	count if inlist(`v', 97,997,9997,98,998,999998)
	}
	
graph bar (sum) nan_p*   nan_oc* 
graph bar (sum) aan_p*   aan_oc* 
* 
  	

* COMBINES 
*===============================================
* number and acreage using combine
clonevar nch_mp12 = d303c  	
clonevar nch_mp14= d303b 
clonevar nch_mp16 = d303a 
clonevar ach_mp12 = d304c  	
clonevar ach_mp14= d304b 
clonevar ach_mp16 = d304a 

clonevar nch_dp12 = d307c
clonevar nch_dp14= d307b 
clonevar nch_dp16 = d307a 
clonevar ach_dp12 = d308c  	
clonevar ach_dp14= d308b 
clonevar ach_dp16 = d308a 
	
sum nch_* ach_*
foreach v of varlist  nch_* ach_* { 
	replace `v' = . if `v' < 0 
	count if inlist(`v', 97,997,9997,98,998,999998)
	}

graph bar (sum) nch_mp* nch_dp*  , /// 
		legend(rows(3) order(1 4 2 5 3 6) label(1 "monsoon 12") label(2 "monsoon 14") label(3 "monsoon 16")  ///
		label(4 "dry 12") label(5 "dry 14") label(6 "dry 16")) /// 
		title("total number of paddy farmers using combine harvester")
graph export  $graphs\combine_use_number.png, replace 
		
graph bar (sum) ach_mp*  ach_dp* , /// 
		legend(rows(3) order(1 4 2 5 3 6) label(1 "monsoon 12") label(2 "monsoon 14") label(3 "monsoon 16")  ///
		label(4 "dry 12") label(5 "dry 14") label(6 "dry 16")) /// 
		title("total paddy area using combine harvester")
graph export  $graphs\combine_use_area.png, replace 
	
* Change in wages: 
crash 


* Use of draft animals for paddy 

* Use of draft animals for other crop 