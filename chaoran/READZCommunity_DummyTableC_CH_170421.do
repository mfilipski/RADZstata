********************************************************************************
*** 			RADZ survey - Dry Zone Community Questionnaire	  			 ***
***				Do file for READZ COMMUNITY SURVEY DUMMY TABLES				 ***
***				Generated on Apr. 2017, by Chaoran Hu						 ***
********************************************************************************

********************************************************************************
*							Dummy Tables for Section C						   *
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

*** Section C1 & C2. POPULATION AND SCHOOLS

*C101. in what year was this village formed
putexcel set "$tables/results_SectionC", sheet(c101) replace
tab c101
tab c101, nol
label list c101 //1-6 options

tab c101, matrow(names) matcell(freq)
matrix list names
matrix list freq
putexcel A1=("C101"), bold
putexcel B1=("Freq.") C1=("Percent")
	
local rows = rowsof(names)
forvalues i = 1/`rows' {
        local val = names[`i',1]
        local val_lab : label (c101) `val'
        local freq_val = freq[`i',1]
        local percent_val = `freq_val'/`r(N)'*100
        local percent_val : display %9.2f `percent_val'
		local row = `val' + 1
        putexcel A`row'=("`val_lab'") B`row'=(`freq_val') C`row'=(`percent_val')   
}
putexcel A2=("Less than 10 years ago")
putexcel A3=("10-19 years ago")
putexcel A4=("20-29 years ago")          


*Table C102-C105. 
*C102. # HH (total) & Average per village, by years
putexcel set "$tables/results_SectionC", sheet(c102-5) modify
putexcel A1=("C102-105"), bold
putexcel B1=("10 yrs ago") C1=("5 yrs ago") D1=("Now") A2=("# HH(total)") A3=("# HH(mean)")

des c102*
sum c102*

sum c102c
return list
local total=r(sum) 
local mean=trim("`: display %9.2f r(mean)'")
putexcel  B2=(`total') B3=(`mean')
sum c102b
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)'")
putexcel  C2=(`total') C3=(`mean')
sum c102a
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)'")
putexcel  D2=(`total') D3=(`mean')

***Notes: we need HH # for 2012 and 2014 later.
*** 	  According to Ben, we assume that the HH # for 2012 is the same as ‘5 yrs ago’; and for 2014 is the same as ‘now’ + ‘5 yrs ago’ / 2
gen hhnum_2016= c102a
gen hhnum_2014=(c102a+c102b)/2
gen hhnum_2012= c102b
sum hhnum_* c102a c102b

*C103. How many hhs have migrated into the village during the past 5 years?  //only one period is available
des c103 
putexcel A4=("# inward migrant HH (total)") A5=("# inward migrant HH (mean per village)") A6=("Inward migrant HH as % resident HH (D4/D2)")
sum c103
return list
local total=r(sum)
local mean=trim("`: display %9.0f r(mean)'")
putexcel  D4=(`total') D5=(`mean') E4=("Note: during the past 5 years")
sum c102a
return list
local total2=r(sum)
local share=100*`total'/`total2'
local share: display %9.2f `share'
putexcel  D6=(`share')

*C104. How many households have permanently moved away in the past 5 years?  //only one period is available
putexcel A7=("# outward migrant HH (total)") A8=("# outward migrant HH (mean per village)") A9=("Outward migrant HH as % resident HH")
des c104 
sum c104
return list
local total=r(sum)
local mean=trim("`: display %9.0f r(mean)'")
putexcel  D7=`total' D8=(`mean') E7=("Note: during the past 5 years")
sum c102a
return list
local total2=r(sum)
local share=100*`total'/`total2'
local share: display %9.2f `share'
putexcel  D9=(`share')

*C105. How many households own agricultural land in this village now?
des c105
putexcel A10=("# Landed HH (total)") A11=("# Landed HH (mean per village)") A12=("Landed HH as % resident HH")
sum c105
return list
local total=r(sum)
local mean=trim("`: display %9.0f r(mean)'")
putexcel  D10=`total' D11=(`mean')
sum c102a
return list
local total2=r(sum)
local share=100*`total'/`total2'
local share: display %9.2f `share'
putexcel  D12=(`share')

*Table C106.
*C106. # of HH had a long-term migrant (>6 mo)? 2012, 2014, 2016
putexcel set "$tables/results_SectionC", sheet(c106) modify
putexcel A1=("C106"), bold
putexcel B1=("2012") C1=("2014") D1=("2016") 
putexcel A2=("# of HH with migrant (total)") A3=("# of HH with migrant (mean per village)") A4=("HH with migrant as % resident HH")

des c106a c106b c106c  
sum c106c c106b c106a

sum c106c
return list
local total=r(sum) 
local mean=trim("`: display %9.0f r(mean)'")
putexcel  B2=(`total') B3=(`mean')
sum c106b
return list
local total=r(sum)
local mean=trim("`: display %9.0f r(mean)'")
putexcel  C2=`total' C3=(`mean')
sum c106a
return list
local total=r(sum)
local mean=trim("`: display %9.0f r(mean)'")
putexcel  D2=`total' D3=(`mean')

gen var1=c106c/hhnum_2012*100
gen var2=c106b/hhnum_2014*100
gen var3=c106a/hhnum_2016*100
sum var1
local mean=trim("`: display %9.2f r(mean)'")
putexcel  B4=(`mean')
sum var2
local mean=trim("`: display %9.2f r(mean)'")
putexcel  C4=(`mean')
sum var3
local mean=trim("`: display %9.2f r(mean)'")
putexcel  D4=(`mean')
drop var*

*Table C201-C206. 
putexcel set "$tables/results_SectionC", sheet(c201-6) modify
putexcel A1=("C201-6"), bold
putexcel B1=("Primary") C1=("Junior 2ndry") D1=("Upper 2ndry") 
putexcel A2=("# villages with ** school") A3=("% villages with ** school")

tab c201 
tab c203 
tab c205
for var c201 c203 c205: replace X=0 if X~=1
sum c201
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  B2=(`total') B3=(`mean')
sum c203
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  C2=(`total') C3=(`mean')
sum c205
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  D2=(`total') D3=(`mean')

putexcel A4=("Mean year ** school first opened, for villages with ** schools only") 
sum c202
return list
local mean=trim("`: display %9.0f r(mean)'")
putexcel  B4=(`mean')
sum c204
return list
local mean=trim("`: display %9.0f r(mean)'")
putexcel  C4=(`mean')
sum c206
return list
local mean=trim("`: display %9.0f r(mean)'")
putexcel D4=(`mean')

*** Section C3.-C5. INFRASTRUCTURE
*Table C301, Primary mode of access
putexcel set "$tables/results_SectionC", sheet(c301) modify
putexcel A1=("C301.village with primary access"), bold
tab c301
tab c301, nol
label list c301 //1-road, 2-waterway, 3-railway, 99-others  
clonevar c301_new = c301
replace c301_new=4 if c301_new==99
tab c301_new

tab c301_new, matrow(names) matcell(freq)
matrix list names
matrix list freq
local rows = rowsof(names)
forvalues i = 1/`rows' {
        local val = names[`i',1]
        local val_lab : label (c301_new) `val'
        local freq_val = freq[`i',1]
        local percent_val = `freq_val'/`r(N)'*100
        local percent_val : display %9.2f `percent_val'
		local row = `val' + 1
        putexcel A`row'=("`val_lab'") B`row'=(`freq_val') C`row'=(`percent_val')   
}
putexcel B1=("# villages") C1=("% villages")
putexcel A3=("Waterway") A5=("Other") 
drop c301_new

*Table C302-C310. information by townships
putexcel set "$tables/results_SectionC", sheet(c302-10) modify
putexcel A1=("C302-310"), bold
*C302, Is there a paved road leading to this village?
tab a101
tab a101, nol
label list a101 
putexcel A2=("# of villages with paved road in…") A3=("% of villages with paved road in…")	
putexcel B1=("Budalin") C1=("Magway") D1=("Pwintbyu") E1=("Myittha") F1=("All") 	

tab c302
clonevar c302_new = c302
replace c302_new=0 if c302_new~=1
tab c302_new
sum c302_new if a101==1
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  B2=(`total') B3=(`mean')

sum c302_new if a101==2
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  C2=(`total') C3=(`mean')

sum c302_new if a101==3
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  D2=(`total') D3=(`mean')

sum c302_new if a101==4
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  E2=(`total') E3=(`mean')

sum c302_new
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  F2=(`total') F3=(`mean')

drop c302_new

*C303. In what year did the village receive a paved road? 
tab c303
putexcel  A4=("Mean year road received(for villages w/ this info)")
replace c303=. if c303==9997

sum c303 if a101==1
local mean=trim("`: display %9.0f r(mean)'")
putexcel  B4=(`mean')
sum c303 if a101==2
local mean=trim("`: display %9.0f r(mean)'")
putexcel  C4=(`mean')
sum c303 if a101==3
local mean=trim("`: display %9.0f r(mean)'")
putexcel  D4=(`mean')
sum c303 if a101==4
local mean=trim("`: display %9.0f r(mean)'")
putexcel  E4=(`mean')
sum c303
local mean=trim("`: display %9.0f r(mean)'")
putexcel  F4=(`mean')

*C304. How far is the nearest paved road (miles)?
tab c304
putexcel  A5=("Mean distance (miles) to nearest paved road(for villages w/ paved road)")
sum c304 if a101==1
local mean=trim("`: display %9.2f r(mean)'")
putexcel  B5=(`mean')
sum c304 if a101==2
local mean=trim("`: display %9.2f r(mean)'")
putexcel  C5=(`mean')
sum c304 if a101==3
local mean=trim("`: display %9.2f r(mean)'")
putexcel  D5=(`mean')
sum c304 if a101==4
local mean=trim("`: display %9.2f r(mean)'")
putexcel  E5=(`mean')
sum c304
local mean=trim("`: display %9.2f r(mean)'")
putexcel  F5=(`mean')

*c305/6. accessible by car in the dry/monsoon season?
tab c305
tab c306
for var c305 c306: replace X=0 if X~=1
clonevar c305_new = c305
clonevar c307_new = c306

putexcel  A6=("#  villages accessible by car in dry season") 	 A7=("% villages accessible by car in dry season")
putexcel  A8=("#  villages accessible by car in monsoon season") A9=("% villages accessible by car in monsoon season")
forvalue i=5(2)7 {
 local j=`i'+1
 local k=`j'+1
 sum c30`i'_new if a101==1
 return list
 local total=r(sum)
 local mean=trim("`: display %9.2f r(mean)*100'")
 putexcel  B`j'=(`total') B`k'=(`mean')
 sum c30`i'_new if a101==2
 return list
 local total=r(sum)
 local mean=trim("`: display %9.2f r(mean)*100'")
 putexcel  C`j'=(`total') C`k'=(`mean')
 sum c30`i'_new if a101==3
 return list
 local total=r(sum)
 local mean=trim("`: display %9.2f r(mean)*100'")
 putexcel  D`j'=(`total') D`k'=(`mean')
 sum c30`i'_new if a101==4
 return list
 local total=r(sum)
 local mean=trim("`: display %9.2f r(mean)*100'")
 putexcel  E`j'=(`total') E`k'=(`mean')
 sum c30`i'_new
 return list
 local total=r(sum)
 local mean=trim("`: display %9.2f r(mean)*100'")
 putexcel  F`j'=(`total') F`k'=(`mean')
}
drop c305_new c307_new

*c307. Is there publicly provided electricity in  the village?
tab c307
replace c307=0 if c307~=1
putexcel  A10=("#  villages with public electricity") A11=("% villages with public electricity")
sum c307 if a101==1
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  B10=(`total') B11=(`mean')
sum c307 if a101==2
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  C10=(`total') C11=(`mean')
sum c307 if a101==3
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  D10=(`total') D11=(`mean')
sum c307 if a101==4
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  E10=(`total') E11=(`mean')
sum c307
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  F10=(`total') F11=(`mean')

*c308.
tab c308
putexcel  A12=("Mean year electricity received(for villages w/ this info)")
replace c308=. if c308==9997
sum c308 if a101==1
local mean=trim("`: display %9.0f r(mean)'")
putexcel  B12=(`mean')
sum c308 if a101==2
local mean=trim("`: display %9.0f r(mean)'")
putexcel  C12=(`mean')
sum c308 if a101==3
local mean=trim("`: display %9.0f r(mean)'")
putexcel  D12=(`mean')
sum c308 if a101==4
local mean=trim("`: display %9.0f r(mean)'")
putexcel  E12=(`mean')
sum c308
local mean=trim("`: display %9.0f r(mean)'")
putexcel  F12=(`mean')

*c309. How many households in this village have access to public electricity?
tab c309
putexcel  A13=("Mean # of HH with electricity (for villages w/ this info)")
putexcel  A14=("% of HH with electricity (for villages w/ this info)")

clonevar var13 = c309
gen 	 var14 = var13/c102a*100
sum var13 var14
forvalue i=13/14 {
 sum var`i' if a101==1
 local mean=trim("`: display %9.2f r(mean)'")
 putexcel  B`i'=(`mean')
 sum var`i' if a101==2
 local mean=trim("`: display %9.2f r(mean)'")
 putexcel  C`i'=(`mean')
 sum var`i' if a101==3
 local mean=trim("`: display %9.2f r(mean)'")
 putexcel  D`i'=(`mean')
 sum var`i' if a101==4
 local mean=trim("`: display %9.2f r(mean)'")
 putexcel  E`i'=(`mean')
 sum var`i'
 local mean=trim("`: display %9.2f r(mean)'")
 putexcel  F`i'=(`mean') 
 drop var`i' 
}

*c310. Is this electricity supplied via a transformer that the community paid for
tab c310
replace c310=0 if c310~=1
putexcel  A15=("# villages with electricity community paid for transformer(for villages w/ this info)")
putexcel  A16=("% of villages with electricity community paid for transformer(for villages w/ this info)")
sum c310 if a101==1
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  B15=(`total') B16=(`mean')
sum c310 if a101==2
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  C15=(`total') C16=(`mean')
sum c310 if a101==3
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  D15=(`total') D16=(`mean')
sum c310 if a101==4
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  E15=(`total') E16=(`mean')
sum c310
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  F15=(`total') F16=(`mean')



*Table C400-410. distance to nearest town/city
putexcel set "$tables/results_SectionC", sheet(c400-1) modify

*c400-401
putexcel  A1=("C400-401"), bold
putexcel  A2=("Mean distance to nearest town (miles)")
putexcel  A3=("Mean distance to nearest city (miles)")
sum c401a 
local mean=trim("`: display %9.2f r(mean)'")
putexcel  B2=(`mean')
sum c401b
local mean=trim("`: display %9.2f r(mean)'")
putexcel  B3=(`mean')
	
*c402-405
putexcel set "$tables/results_SectionC", sheet(c402-5) modify
putexcel  A1=("C402-405"), bold
putexcel  B1=("Hours to reach in dry season now")
putexcel  C1=("Hours to reach in dry season 5 yrs ago")
putexcel  D1=("Change 5yrs-now")
putexcel  E1=("Hours to reach in monsoon now")
putexcel  F1=("Hours to reach in monsoon 5 yrs ago")
putexcel  G1=("Change 5yrs-now")

tab c402a
tab c402a, nol
label list c402a //1-motocycle, 2-Ox cart, 3-Trawelerji, 4-Boat, 5-Bus, 6-Car, 7 Bicycle, 8 Truck, 99 Other (specify)
tab c404a
tab c404a, nol
label list c404a
tab c402b 
tab c404b
label list c402b
label list c404b

putexcel A2 =("Nearest town") A12=("Nearest city"), bold
putexcel A3 =("Motocycle")  A4=("Ox Cart")  A5=("Trawelerji")  A6=("Boat")  A7=("Bus")  A8=("Car")  A9=("Bicycle") A10=("Truck") A11=("Other")
putexcel A13=("Motocycle") A14=("Ox Cart") A15=("Trawelerji") A16=("Boat") A17=("Bus") A18=("Car") A19=("Bicycle") A20=("Truck") A21=("Other")

tab c403a1 
list interview c400a c402a c403a1 c403a2 c404a c405a1 c405a2 c402b c403b1 c403b2 c405b1 c405b2 if  c403a2=="45:00"
//*Check: might be an error?
for var c403a1 c403a2 c403b1 c403b2: replace X="00:45" if X=="45:00"
for var c405a1 c405a2 c405b1 c405b2: replace X="00:30" if X=="30:00"

foreach X of varlist c403a1 c403a2 c405a1 c405a2 c403b1 c403b2 c405b1 c405b2 {
 split `X', parse(:)
 destring `X'1, gen(var1)
 destring `X'2, gen(var2)
 gen hour_`X'=var1+var2/60
 drop `X'1 `X'2 var1 var2
}

tab c402a c404a
tab c402b c404b

for var c402a c404a c402b c404b: replace X=9 if X==99
 
forvalue i=1/9 {
 local j=`i'+2
 sum hour_c403a1 if c402a==`i'  //to town, now, dry
 local mean=trim("`: display %9.2f r(mean)'")
 putexcel  B`j'=(`mean')
 sum hour_c405a1 if c404a==`i'  //to town, five-year ago, dry
 local mean=trim("`: display %9.2f r(mean)'")
 putexcel  C`j'=(`mean')
 sum hour_c403a2 if c402a==`i'  //to town, now, wet
 local mean=trim("`: display %9.2f r(mean)'")
 putexcel  E`j'=(`mean')
 sum hour_c405a2 if c404a==`i'  //to town, five-year ago, wet
 local mean=trim("`: display %9.2f r(mean)'")
 putexcel  F`j'=(`mean')
} 


forvalue i=1/9 {
 local j=`i'+12
 sum hour_c403b1 if c402b==`i'  //to city, now, dry
 local mean=trim("`: display %9.2f r(mean)'")
 putexcel  B`j'=(`mean')
 sum hour_c405b1 if c404b==`i'  //to city, five-year ago, dry
 local mean=trim("`: display %9.2f r(mean)'")
 putexcel  C`j'=(`mean')
 sum hour_c403b2 if c402b==`i'  //to city, now, wet
 local mean=trim("`: display %9.2f r(mean)'")
 putexcel  E`j'=(`mean')
 sum hour_c405b2 if c404b==`i'  //to city, five-year ago, wet
 local mean=trim("`: display %9.2f r(mean)'")
 putexcel  F`j'=(`mean')
} 

putexcel  A23=("Note: values for villages with information only, observation # changes by years")


*c501-520
putexcel set "$tables/results_SectionC", sheet(c501-20) modify
putexcel A1 =("C510-520"), bold
putexcel B1 =("Dam") C1=("River pumping") D1=("Pvt. Tubewell") E1=("Public Tubewell") F1=("Comm. Tubewell")
putexcel A2=("# villages with") A3=("% villages with") A4=("Mean yr received") A5=("Med. yr received") 
*
sum c501 c505 c509 c513 c517
for var c501 c505 c509 c513 c517: replace X=0 if X~=1
sum c501
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  B2=(`total') B3=(`mean')
sum c505
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  C2=(`total') C3=(`mean')
sum c509
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  D2=(`total') D3=(`mean')
sum c513
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  E2=(`total') E3=(`mean')
sum c517
return list
local total=r(sum)
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  F2=(`total') F3=(`mean')
*year received
sum c502 c506 c510 c514 c518
for var c502 c506 c510 c514 c518: replace X=. if X==9997
sum c502, detail
return list
putexcel  B4=(`r(mean)') B5=(`r(p50)'), nformat("#")
sum c506, detail
return list
local med=r(p50)
local mean=trim("`: display %9.0f r(mean)'")
putexcel  C4=(`r(mean)') C5=(`r(p50)'), nformat("#")
sum c510, detail
return list
local med=r(p50)
local mean=trim("`: display %9.0f r(mean)'")
putexcel  D4=(`r(mean)') D5=(`r(p50)'), nformat("#")
sum c514, detail
return list
local med=r(p50)
local mean=trim("`: display %9.0f r(mean)'")
putexcel  E4=(`r(mean)') E5=(`r(p50)'), nformat("#")
sum c518, detail
return list
local med=r(p50)
local mean=trim("`: display %9.0f r(mean)'")
putexcel  F4=(`r(mean)') F5=(`r(p50)'), nformat("#")

*HH access
putexcel A6=("Total HH # with access now") A7=("Total HH # with access 5yrs ago") A8=("% HH with access now") A9=("% HH with access 5yrs ago") A10=("% change 5yrs-now")

for var c503 c504 c507 c508 c511 c512 c515 c516 c519 c520: clonevar X_new=X 
rename (c503_new-c520_new) var#, addnumber
for var var1 var3 var5 var7 var9:  gen X_sh=X/c102a*100  //hh share, now
for var var2 var4 var6 var8 var10: gen X_sh=X/c102b*100  //hh share, five year ago
sum var*
list c504 c102b c503 c102a if var2_sh>100 & var2_sh~=.
for var var*_sh: replace X=100 if X>100 & X~=.
gen var12sh_change =100*(var1_sh -var2_sh)/var2_sh
gen var34sh_change =100*(var3_sh -var4_sh)/var4_sh
gen var56sh_change =100*(var5_sh -var6_sh)/var6_sh
gen var78sh_change =100*(var7_sh -var8_sh)/var8_sh
gen var910sh_change=100*(var9_sh-var10_sh)/var10_sh
*Dam 	
sum var1
return list
putexcel  B6=`r(sum)'
sum var2
putexcel  B7=`r(sum)'
sum var1_sh
local mean=trim("`: display %9.2f r(mean)'")
putexcel  B8=(`mean')
sum var2_sh
local mean=trim("`: display %9.2f r(mean)'")
putexcel  B9=(`mean')
sum var12sh_change
local mean=trim("`: display %9.2f r(mean)'")
putexcel  B10=(`mean')
*River pumping	
sum var3
return list
putexcel  C6=`r(sum)'
sum var4
putexcel  C7=`r(sum)'
sum var3_sh
local mean=trim("`: display %9.2f r(mean)'")
putexcel  C8=(`mean')
sum var4_sh
local mean=trim("`: display %9.2f r(mean)'")
putexcel  C9=(`mean')
sum var34sh_change
local mean=trim("`: display %9.2f r(mean)'")
putexcel  C10=(`mean')
*Pvt. Tubewell	
sum var5
return list
putexcel  D6=`r(sum)'
sum var6
putexcel  D7=`r(sum)'
sum var5_sh
local mean=trim("`: display %9.2f r(mean)'")
putexcel  D8=(`mean')
sum var6_sh
local mean=trim("`: display %9.2f r(mean)'")
putexcel  D9=(`mean')
sum var56sh_change
local mean=trim("`: display %9.2f r(mean)'")
putexcel  D10=(`mean')
*Public Tubewell	
sum var7
return list
putexcel  E6=`r(sum)'
sum var8
putexcel  E7=`r(sum)'
sum var7_sh
local mean=trim("`: display %9.2f r(mean)'")
putexcel  E8=(`mean')
sum var8_sh
local mean=trim("`: display %9.2f r(mean)'")
putexcel  E9=(`mean')
sum var78sh_change
local mean=trim("`: display %9.2f r(mean)'")
putexcel  E10=(`mean')
*Comm. Tubewell
sum var9
return list
putexcel  F6=`r(sum)'
sum var10
putexcel  F7=`r(sum)'
sum var9_sh
local mean=trim("`: display %9.2f r(mean)'")
putexcel  F8=(`mean')
sum var10_sh
local mean=trim("`: display %9.2f r(mean)'")
putexcel  F9=(`mean')
sum var910sh_change
local mean=trim("`: display %9.2f r(mean)'")
putexcel  F10=(`mean')
drop var*
putexcel A11=("Note: change is negative or HH # with access in 5yrs ago is larger is because total HH # in 5yrs ago is fewer")





