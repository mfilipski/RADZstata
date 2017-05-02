********************************************************************************
*** 			RADZ survey - Dry Zone Community Questionnaire	  			 ***
***				Do file for READZ COMMUNITY SURVEY DUMMY TABLES				 ***
***				Generated on Apr. 2017, by Chaoran Hu						 ***
********************************************************************************


********************************************************************************
*** define paths
clear all
capture log close
set more off

*Using Mac
*global rawdata "/Users/Chaoran/Dropbox/READZ_data_analysis/DATA/Community/TempData"
*global workdir "/Users/Chaoran/Dropbox/PhD/Research/Myanmar/READZ_data_analysis/DATA/Community/stata/tables"

* mf data: 
global rawdata "D:\Docs\Myanmar\DryZone\DATA\tempdata\TempSurveyData\Merged_current"
global workdir "D:\Docs\Myanmar\DryZone\Analysis\Stata\do\chaoran\tables"
global tabfile "$workdir\results.xlsx"

cd $workdir 

********************************************************************************
*							Dummy Tables for Section C						   *
********************************************************************************

*C101. in what year was this village formed
use "$rawdata/RADZ_MAIN_merged", clear
tab c101

putexcel set results, sheet(c101) replace

tab c101, matrow(names) matcell(freq)
matrix list names
matrix list freq
putexcel A1=("C101") B1=("Freq.") C1=("Percent")
		
local rows = rowsof(names)
local row = 6
forvalues i = 1/`rows' {
        local val = names[`i',1]
        local val_lab : label (c101) `val'
        local freq_val = freq[`i',1]
        local percent_val = `freq_val'/`r(N)'*100
        local percent_val : display %9.2f `percent_val'
        putexcel A`row'=("`val_lab'") B`row'=(`freq_val') C`row'=(`percent_val')
        local row = `row' + 1
}


gen freq=1 
tabstat freq  , stat(count) by(c101) save 
return list 
matrix res = r(Stat1) \ r(Stat2) \ r(Stat3) \r(StatTotal) 
matrix rownames res = "`r(name1)'" "`r(name2)'"  "`r(name3)'"  "total" 
matrix list res 
putexcel A6 = matrix(res, names)  using $tabfile, sheet("c101mf") modify keepcellformat
