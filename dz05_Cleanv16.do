clear
capture log close
set more off

* define paths
include D:\Docs\Myanmar\DryZone\Analysis\Stata\do\dz000_paths.do

* Read excel codes and make a dta file.  DONE 
*import excel using $v16codesxl , first
*save $v16codes, replace


* Check that eacodes and vtcodes match in the v16 data:  
use "$tempSurveyDataDir\RADZ_v16_approvedBySuper_170523\RADZ survey - Dry Zone Community Questionnaire"
list Id a101-a104

clonevar eacode = a102
clonevar vtcode16 = a103 

merge 1:1 eacode using $v16codes 
drop if _m==2 
drop _m

list Id eacode vtcode16 vtcode 

* Check that all were properly identified: 
count if vtcode16!=vtcode 

