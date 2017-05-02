********************************************************************************
*** 			RADZ survey - Dry Zone Community Questionnaire	  			 ***
***				Do file for READZ COMMUNITY SURVEY DUMMY TABLES				 ***
***				Generated on Apr. 2017, by Chaoran Hu						 ***
********************************************************************************

********************************************************************************
*							Dummy Tables for Section D						   *
********************************************************************************
*** define paths
clear all
capture log close
set more off

*Using Mac
global rawdata "/Users/Chaoran/Dropbox/READZ_data_analysis/DATA/Community/TempData"
global workdir "/Users/Chaoran/Dropbox/PhD/Research/Myanmar/READZ_data_analysis/DATA/Community/stata"
global tables "/Users/Chaoran/Dropbox/PhD/Research/Myanmar/READZ_data_analysis/DATA/Community/stata/tables"
global madedata "/Users/Chaoran/Dropbox/PhD/Research/Myanmar/READZ_data_analysis/DATA/Community/stata/made"

cd $workdir 
use "$rawdata/RADZ_MAIN_merged", clear

*** First, generate HH # for 2012 and 2014 later.
*** 	   According to Ben, we assume that the HH # for 2012 is the same as ‘5 yrs ago’; and for 2014 is the same as ‘now’ + ‘5 yrs ago’ / 2
gen hhnum_B= c102a
gen hhnum_C=(c102a+c102b)/2
gen hhnum_D= c102b
sum hhnum_* c102a c102b


*** Section D1. FARMERS

*Table D103-106
putexcel set "$tables/results_SectionD", sheet(D103-6) replace
putexcel A1=("D103-106") B1=("2016") C1=("2014") D1=("2012") 
putexcel A2=("% of village with HH growing paddy") A3=("Total HH # growing monsoon season paddy") A4=("% of HH growing monsoon season paddy")

sum d101*
for var d101a d101b d101c: replace X=0 if X~=1
clonevar varB=d101a 
clonevar varC=d101b 
clonevar varD=d101c

local vlist B C D
foreach X of local vlist {
 sum var`X'
 local mean=trim("`: display %9.2f r(mean)*100'")
 putexcel `X'2=(`mean')
 drop var`X'
}

des d103*
clonevar varB=d103a 
clonevar varC=d103b 
clonevar varD=d103c
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'3=`r(sum)'
 gen share=var`X'/hhnum_`X'*100
 sum share
 putexcel `X'4=`r(mean)', nformat("#.##")
 drop share var`X'
}

putexcel A5=("Mean area under monsoon season paddy, all villages w/ zero areas") A6=("Mean area under monsoon season paddy, villages w/ monsoon paddy only") A7=("Total area under monsoon season paddy(acres)")
sum d104*
clonevar varB=d104a 
clonevar varC=d104b 
clonevar varD=d104c
for var var*: replace X=0 if X==.
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'5=`r(mean)', nformat("#")
 replace var`X'=. if var`X'==0
 sum var`X'
 putexcel `X'6=`r(mean)', nformat("#")
 putexcel `X'7=`r(sum)'
 drop var`X'
}

putexcel A8=("Total HH # growing dry season paddy") A9=("% of HH growing dry season paddy")
des d105*
sum d105*
for var d105a d105b d105c: replace X=. if X<0 & X~=.
*Check: one outlier?
clonevar varB=d105a 
clonevar varC=d105b 
clonevar varD=d105c
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'8=`r(sum)'
 gen share=var`X'/hhnum_`X'*100
 sum share
 putexcel `X'9=`r(mean)', nformat("#.##")
 drop share var`X'
}

putexcel A10=("Mean area under dry season paddy, all villages w/ zero areas") A11=("Mean area under dry season paddy, villages w/ dry paddy only") A12=("Total area under dry season paddy(acres)")
sum d106*
clonevar varB=d106a 
clonevar varC=d106b 
clonevar varD=d106c
for var var*: replace X=0 if X==.
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'10=`r(mean)', nformat("#")
 replace var`X'=. if var`X'==0
 sum var`X'
 putexcel `X'11=`r(mean)', nformat("#")
 putexcel `X'12=`r(sum)'
 drop var`X'
}


*Table D107a-c
putexcel set "$tables/results_SectionD", sheet(D107a-c) modify
putexcel A1=("D107a-c") , bold
putexcel B1=("Groundnut") C1=("Green Gram") D1=("Sesame") 
tab d107  //Check: one outlier?  
tab d107, nol
list d107 d107a d107b d107c if d107<0
for var d107a d107b d107c d107: replace X=. if d107<0

putexcel  A2=("Most commonly grown (# villages)") A3=("Most commonly grown (% villages)")
tab d107, matcell(freq)
matrix list freq
local freq_val = freq[1,1]
local percent_val = `freq_val'/`r(N)'*100
local percent_val : display %9.2f `percent_val'
putexcel B2=(`freq_val') B3=(`percent_val')
local freq_val = freq[2,1]
local percent_val = `freq_val'/`r(N)'*100
local percent_val : display %9.2f `percent_val'
putexcel C2=(`freq_val') C3=(`percent_val')
local freq_val = freq[3,1]
local percent_val = `freq_val'/`r(N)'*100
local percent_val : display %9.2f `percent_val'
putexcel D2=(`freq_val') D3=(`percent_val')

putexcel  A4=("# of villages growing in 2016") A5=("% of villages growing in 2016")
putexcel  A6=("# of villages growing in 2014") A7=("% of villages growing in 2014")
putexcel  A8=("# of villages growing in 2012") A9=("% of villages growing in 2012")
des d107a d107b d107c
sum d107a d107b d107c

local i=4
local j=5
foreach X of varlist d107a d107b d107c {
 tab d107 `X', matcell(freq)
 matrix list freq
 local freq_val = freq[1,1]
 local percent_val = `freq_val'/`r(N)'*100
 local percent_val : display %9.2f `percent_val'
 putexcel B`i'=(`freq_val') B`j'=(`percent_val')
 local freq_val = freq[2,1]
 local percent_val = `freq_val'/`r(N)'*100
 local percent_val : display %9.2f `percent_val'
 putexcel C`i'=(`freq_val') C`j'=(`percent_val')
 local freq_val = freq[3,1]
 local percent_val = `freq_val'/`r(N)'*100
 local percent_val : display %9.2f `percent_val'
 putexcel D`i'=(`freq_val') D`j'=(`percent_val')
 local i=`i'+2
 local j=`j'+2
}


*Table D108-109
putexcel set "$tables/results_SectionD", sheet(D108-9) modify
putexcel A1=("D108-109") B1=("2016") C1=("2014") D1=("2012") 
putexcel A2=("Total HH # growing Most commonly grown crop") A3=("% of HH growing Most commonly grown crop")

sum d108a d108b d108c
clonevar varB=d108a 
clonevar varC=d108b 
clonevar varD=d108c
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'2=`r(sum)'
 gen share=var`X'/hhnum_`X'*100
 sum share
 putexcel `X'3=`r(mean)', nformat("#.##")
 drop share var`X'
}

putexcel A4=("Mean area land under most commonly grown crop, w/ all villages") A5=("Mean area land under most commonly grown crop, w/ villages grow **crop** only") A6=("Total area under most commonly grown crop(acres)")
sum d109*
clonevar varB=d109a 
clonevar varC=d109b 
clonevar varD=d109c
for var var*: replace X=0 if X==.
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'4=`r(mean)', nformat("#")
 replace var`X'=. if var`X'==0
 sum var`X'
 putexcel `X'5=`r(mean)', nformat("#")
 putexcel `X'6=`r(sum)'
 drop var`X'
}


*** Section D2. LAND PREPARATION

*Table D201a-202c
putexcel set "$tables/results_SectionD", sheet(D201-8) modify
putexcel A1=("D201a-202c"), bold
putexcel B1=("2016") C1=("2014") D1=("2012") 
putexcel A2=("# of paddy growing villages using draft for paddy land prep") A3=("% of paddy growing village using draft for paddy land prep")
putexcel A4=("# of non-rice crop growing villages using draft for non-rice crop land prep") A5=("% of non-rice crop growing village using draft for non-rice crop land prep")

tab d101a  //only 48 villages growing paddy
sum d201a d201b d201c
tab d101a d201a
tab d101b d201b
tab d101c d201c
for var d201a d201b d201c: replace X=0 if X==2

clonevar varB=d201a 
clonevar varC=d201b 
clonevar varD=d201c
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'2=`r(sum)'
 local mean=trim("`: display %9.2f r(mean)*100'")
 putexcel `X'3=(`mean')
 drop var`X'
}

tab d107a  //73 
sum d202*
tab d107a d202a
tab d107b d202b
tab d107c d202c
for var d202*: replace X=0 if X==2
clonevar varB=d202a 
clonevar varC=d202b 
clonevar varD=d202c
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'4=`r(sum)'
 local mean=trim("`: display %9.2f r(mean)*100'")
 putexcel `X'5=(`mean')
 drop var`X'
}

putexcel A6=("D203a-D208"), bold
putexcel A7=("Total HH # using draft for paddy land prep") A8=("% of farming HH using draft for paddy land prep")
putexcel A12=("Total HH # using draft for non-paddy crop land prep") A13=("% of farming HH using draft for non-paddy crop land prep")
sum d203* d207*

clonevar varB=d203a 
clonevar varC=d203b 
clonevar varD=d203c
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'7=`r(sum)'
 gen share=var`X'/hhnum_`X'*100
 sum share
 putexcel `X'8=`r(mean)', nformat("#.##")
 drop share var`X'
}
clonevar varB=d207a 
clonevar varC=d207b 
clonevar varD=d207c
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'12=`r(sum)'
 gen share=var`X'/hhnum_`X'*100
 sum share
 putexcel `X'13=`r(mean)', nformat("#.##")
 drop share var`X'
}

putexcel A9=("Mean area per village of paddy land prepared with draft, all villages") A10=("Mean area per village of paddy land prepared with draft, villages w/ info only") A11=("Total area of paddy land prepared with draft")
putexcel A14=("Mean area per village of non-paddy crop land prepared with draft, all villages") A15=("Mean area per village of non-paddy crop land prepared with draft, villages w/ info only") A16=("Total area of paddy land prepared with draft")
sum d204* d208*  
list d20*c d204a d204b if d204c<0 
*Check: d204c error input? for now, replacing it by 2014's info
replace d204c=d204b if d204c<0 

clonevar varB=d204a 
clonevar varC=d204b 
clonevar varD=d204c
for var var*: replace X=0 if X==.
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'9=`r(mean)', nformat("#")
 replace var`X'=. if var`X'==0
 sum var`X'
 putexcel `X'10=`r(mean)', nformat("#")
 putexcel `X'11=`r(sum)'
 drop var`X'
}
clonevar varB=d208a 
clonevar varC=d208b 
clonevar varD=d208c
for var var*: replace X=0 if X==.
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'14=`r(mean)', nformat("#")
 replace var`X'=. if var`X'==0
 sum var`X'
 putexcel `X'15=`r(mean)', nformat("#")
 putexcel `X'16=`r(sum)'
 drop var`X'
}


*Table D301-308
putexcel set "$tables/results_SectionD", sheet(D301-8) modify
putexcel A1=("D301"), bold
putexcel B1=("2016") C1=("2014") D1=("2012") 

putexcel A2=("# of paddy farming villages using combine for paddy harvest") A3=("% of paddy farming villages using combine for paddy harvest")
tab d301a  //only 48 villages growing paddy
sum d301a d301b d301c
tab d101a d301a
tab d101b d301b
tab d101c d301c
for var d301a d301b d301c: replace X=0 if X==2

clonevar varB=d301a 
clonevar varC=d301b 
clonevar varD=d301c
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'2=`r(sum)'
 local mean=trim("`: display %9.2f r(mean)*100'")
 putexcel `X'3=(`mean')
 drop var`X'
}

putexcel A4=("D303-304") A10=("D307-308"), bold
putexcel C4=("Monsoon") C10=("Dry Season"), bold
putexcel A5=("Total HH # using combine for paddy harvest")   A6=("% of farming HH using combine for paddy land prep")
putexcel A11=("Total HH # using combine for paddy harvest") A12=("% of farming HH using combine for paddy land prep")
sum d303* d307*
clonevar varB=d303a 
clonevar varC=d303b 
clonevar varD=d303c
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'5=`r(sum)'
 gen share=var`X'/hhnum_`X'*100
 sum share
 putexcel `X'6=`r(mean)', nformat("#.##")
 drop share var`X'
}
clonevar varB=d307a 
clonevar varC=d307b 
clonevar varD=d307c
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'11=`r(sum)'
 gen share=var`X'/hhnum_`X'*100
 sum share
 putexcel `X'12=`r(mean)', nformat("#.##")
 drop share var`X'
}


putexcel A7=("Mean area harvested using combines, all villages") A8=("Mean area harvested using combines, villages w/ info only") A9=("Total area harvested using combines")
putexcel A13=("Mean area harvested using combines, all villages") A14=("Mean area harvested using combines, villages w/ info only") A15=("Total area harvested using combines")
sum d304* d308*  

clonevar varB=d304a 
clonevar varC=d304b 
clonevar varD=d304c
for var var*: replace X=0 if X==.
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'7=`r(mean)', nformat("#")
 replace var`X'=. if var`X'==0
 sum var`X'
 putexcel `X'8=`r(mean)', nformat("#")
 putexcel `X'9=`r(sum)'
 drop var`X'
}
clonevar varB=d308a 
clonevar varC=d308b 
clonevar varD=d308c
for var var*: replace X=0 if X==.
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'13=`r(mean)', nformat("#")
 replace var`X'=. if var`X'==0
 sum var`X'
 putexcel `X'14=`r(mean)', nformat("#")
 putexcel `X'15=`r(sum)'
 drop var`X'
}

*Table D309-311
putexcel A17=("D309-311"), bold
putexcel B17=("2016") C17=("2014") D17=("2012") 
putexcel A18=("Cost/acre for harvesting monsoon paddy by combine, all villages") A19=("Cost/acre for harvesting monsoon paddy by combine, villages w/ info only")
putexcel A20=("Cost/acre for harvesting dry season paddy by combine, all villages") A21=("Cost/acre for harvesting dry season paddy by combine, villages w/ info only") 

sum d309* d310*
clonevar varB=d309a 
clonevar varC=d309b 
clonevar varD=d309c
for var var*: replace X=0 if X==.
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'18=`r(mean)', nformat("#")
 replace var`X'=. if var`X'==0
 sum var`X'
 putexcel `X'19=`r(mean)', nformat("#")
 drop var`X'
}
clonevar varB=d310a 
clonevar varC=d310b 
clonevar varD=d310c
for var var*: replace X=0 if X==.
local vlist B C D
foreach X of local vlist {
 sum var`X'
 putexcel `X'20=`r(mean)', nformat("#")
 replace var`X'=. if var`X'==0
 sum var`X'
 putexcel `X'21=`r(mean)', nformat("#")
 drop var`X'
}

putexcel A22=("Distance (miles) to nearest combine rental service, for villages harvest paddy with a combine harvester only")
sum d311*
clonevar varB=d311a 
clonevar varC=d311b 
clonevar varD=d311c
clonevar checkB=d301a 
clonevar checkC=d301b 
clonevar checkD=d301c
for var varB varC varD: replace X=. if X==9997
local vlist B C D
foreach X of local vlist {
 sum var`X' if check`X'==1
 putexcel `X'22=`r(mean)', nformat("#.##")
 sum var`X' 
 drop var`X' check`X'
}
putexcel A23=("Note: Distance in 2012 is much smaller since only 2 observations harvest paddy with a combine harvester in 2012")


*Table D312
putexcel set "$tables/results_SectionD", sheet(D312) modify
putexcel A1=("D312"), bold
putexcel A2=("Individual") A3=("Group") A4=("Owner") A5=("Other")
putexcel B1=("2016") C1=("2014") D1=("2012") 

clonevar varB=d312a
clonevar varC=d312b
clonevar varD=d312c
for var var*: replace X=4 if X==99

local vlist B C D
foreach X of local vlist {
 tab var`X', matrow(names) matcell(freq)
 matrix list names
 matrix list freq
 local rows = rowsof(names)
 forvalues i = 1/`rows' {
        local val = names[`i',1]
        local freq_val = freq[`i',1]
        local percent_val = `freq_val'/`r(N)'*100
        local percent_val : display %9.2f `percent_val'
		local row = `val' + 1
        putexcel `X'`row'=(`percent_val') 
 }
 drop var`X'
}


*** Section D4. WAGES AND LABOR COST

*Table D401-404
putexcel set "$tables/results_SectionD", sheet(D401-4) modify
putexcel A1=("D401-404"), bold
putexcel B1=("2016") C1=("2014") D1=("2012") 
putexcel A2=("Average daily wage in Kyat (men w/ info only)") A3=("Average daily wage in Kyat(women w/ info only)") A4=("Total labor cost for harvesting one acre of monsoon paddy") A5=("Total labor cost for threshing one acre of monsoon paddy")

sum d401*
for var d401*: replace X=. if X==9997
clonevar varmB=d401ma 
clonevar varmC=d401mb
clonevar varmD=d401mc
clonevar varfB=d401fa 
clonevar varfC=d401fb
clonevar varfD=d401fc
local vlist B C D
foreach X of local vlist {
 sum varm`X'
 putexcel `X'2=`r(mean)', nformat("#")
 sum varf`X'
 putexcel `X'3=`r(mean)', nformat("#")
 drop varm`X' varf`X'
}

sum d403* d404*  //for villages with people growing monsoon paddy only
sum d403* d404* if d401ma==.
clonevar var1B=d403a 
clonevar var1C=d403b
clonevar var1D=d403c
clonevar var2B=d404a 
clonevar var2C=d404b
clonevar var2D=d404c
local vlist B C D
foreach X of local vlist {
 sum var1`X'
 putexcel `X'4=`r(mean)', nformat("#")
 sum var2`X'
 putexcel `X'5=`r(mean)', nformat("#")
 drop var1`X' var2`X'
}
putexcel A6=("Note: Total labor costs include values of villages with people growing monsoon paddy only")


*** Section D5. LABOR AVAILABILITY
*Table D502-509
putexcel set "$tables/results_SectionD", sheet(D502-9) modify
putexcel A1=("D502-509"), bold
putexcel B1=("2016") C1=("2014") D1=("2012") 

putexcel A2=("% of paddy farming villages where majority of farmers hired harvesting labor directly")
putexcel A3=("% of paddy farming villages where majority of farmers hired labor thru broker")
putexcel A4=("% of paddy farming villages where majority of farmers hired labor directly & thru broker")
tab d502a
tab d502a, nol
label list d502a
clonevar varB=d502a
clonevar varC=d502b
clonevar varD=d502c
local vlist B C D
foreach X of local vlist {
 tab var`X', matrow(names) matcell(freq)
 matrix list names
 matrix list freq
 local rows = rowsof(names)
 forvalues i = 1/`rows' {
        local val = names[`i',1]
        local freq_val = freq[`i',1]
        local percent_val = `freq_val'/`r(N)'*100
        local percent_val : display %9.2f `percent_val'
		local row = `val' + 1
        putexcel `X'`row'=(`percent_val') 
 }
 drop var`X'
}

putexcel A5=("% of farmers giving advance payment for harvesting main monsoon crop")
putexcel A6=("Mean days waited to hire 10 men in monsoon harvesting season")
putexcel A7=("Mean days waited to hire 10 women in monsoon harvesting season")
putexcel A8=("Mean days waited by men to find work in monsoon harvesting season")
putexcel A9=("Mean days waited by women to find work in monsoon harvesting season")

sum d503* d504* d505* d508* d509*  
forvalues i=1/3{
 local j=`i'+2
 clonevar var`i'B=d50`j'a 
 clonevar var`i'C=d50`j'b
 clonevar var`i'D=d50`j'c
}
forvalues i=4/5{
 local j=`i'+4
 clonevar var`i'B=d50`j'a 
 clonevar var`i'C=d50`j'b
 clonevar var`i'D=d50`j'c
}

local vlist B C D
forvalue i=1/5{
 local j=`i'+4
 foreach X of local vlist {
  sum var`i'`X'
  putexcel `X'`j'=`r(mean)', nformat("#.##")
  }
}
drop var*






