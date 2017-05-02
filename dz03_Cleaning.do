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


* Nothing here yet! 



