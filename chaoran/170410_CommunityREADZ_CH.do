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
global rawdata "/Users/Chaoran/Dropbox/READZ_data_analysis/DATA/Community/TempData"
global workdir "/Users/Chaoran/Dropbox/PhD/Research/Myanmar/READZ_data_analysis/DATA/Community/stata/tables"



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

