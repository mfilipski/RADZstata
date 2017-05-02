********************************************************************************
*** 			RADZ survey - Dry Zone Community Questionnaire	  			 ***
***				Do file for READZ COMMUNITY SURVEY DUMMY TABLES				 ***
***				Generated on Apr. 2017, by Chaoran Hu						 ***
********************************************************************************

********************************************************************************
*						Dummy Tables for Sections E-I						   *
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

********************************************************************************
*** Section E. AG BUSINESS INVENTORY
********************************************************************************

*** Section E1. VILLAGE LEVEL AGRICULTURE BUSINESS INVENTORY
*Table E101-104
putexcel set "$tables/results_SectionE-I", sheet(E101-2) replace
putexcel A1=("E101-102"), bold
putexcel B1=("# of villages with … during the past ten years") C1=("% of villages") 
putexcel A2=("Rice mill (Huller)")
putexcel A3=("Oil mill (Small)")
putexcel A4=("Thresher (Peanut)")
putexcel A5=("Thresher (Paddy & Pulses)")
putexcel A6=("Households with two wheel tractors for hire")
putexcel A7=("Households with four wheel tractors for hire")
putexcel A8=("Households with combine harvesters for hire")
putexcel A9=("Households with trawlerji for hire")
putexcel A10=("Truck transport services for hire")
putexcel A11=("Tree nursery")
putexcel A12=("Fishfarm")
putexcel A13=("Commercial Melon Farm")
putexcel A14=("Piglet rearing")
putexcel A15=("Bee keeping")
putexcel A16=("Agricultural inputs shop")
sum e101*
for var e101*: replace X=0 if X~=1

forvalues i=1/15 {
 local j=`i'+1
 sum e101__`i'
 local mean=trim("`: display %9.2f r(mean)*100'")
 putexcel  B`j'=`r(sum)' C`j'=(`mean')
}

putexcel A18=("Note: variables e102* are missing in the MAIN_merged.dta file")
**Check: missing variable e102* & e104e?

putexcel set "$tables/results_SectionE-I", sheet(E103-4) modify
putexcel A1=("E103-104"), bold
putexcel B1=("# of villages with … operating in the nearest urban during the past ten years") C1=("% of villages") 

putexcel A2=("Rice mill (medium/large)")
putexcel A3=("Oil mill (Medium/Large)")
putexcel A4=("Agricultural machinery supplier")

sum e103*
forvalues i=15/17 {
 local j=`i'-13
 sum e103__`i'
 local mean=trim("`: display %9.2f r(mean)*100'")
 putexcel  B`j'=`r(sum)' C`j'=(`mean')
}
putexcel A6=("Note: variables e104* are missing in the MAIN_merged.dta file")



********************************************************************************
*** Secion F. LAND OWNERSHIP
********************************************************************************

*Table F100
putexcel set "$tables/results_SectionE-I", sheet(F100-1) modify
putexcel A1=("F100"), bold
putexcel A2=("villages with farms operated by outsiders") B1=("# of villages") C1=("% of villages")

tab f100
replace f100=0 if f100==2
sum f100
local mean=trim("`: display %9.2f r(mean)*100'")
putexcel  B2=`r(sum)' C2=(`mean')

*Table F101-102
putexcel A4=("F101-102, Only for villages with farms operated by outsiders"), bold
putexcel B4=("Now")  C4=("5 yrs ago") A5=("observations(N)")
putexcel A6=("Total # farms operated by outsiders")		
putexcel A7=("Mean # farms/village operated by outsiders")		
putexcel A8=("Total area land operated by outsiders")		
putexcel A9=("Mean area land operated by outsiders")		

sum f101a 
local mean=trim("`: display %9.0f r(mean)'")
putexcel  B5=`r(N)' B6=`r(sum)' B7=(`mean')
replace f101b=. if f101b==0
sum f101b
local mean=trim("`: display %9.0f r(mean)'")
putexcel  C5=`r(N)' C6=`r(sum)' C7=(`mean')
sum f102a
local mean=trim("`: display %9.0f r(mean)'")
putexcel  B8=`r(sum)' B9=(`mean')
sum f102b
local mean=trim("`: display %9.0f r(mean)'")
putexcel  C8=`r(sum)' C9=(`mean')


*Table F103
putexcel set "$tables/results_SectionE-I", sheet(F103) modify
putexcel A1=("F103"), bold
putexcel B2=("Melon") C2=("Cucumber") D2=("Bottle gourd") E2=("Sweetcorn") F2=("Other vegetables") G2=("Groundnut") H2=("Paddy") I2=("Other")
putexcel A3=("Rank 1") A4=("Rank 2") A5=("Rank 3") A6=("Rank 4") A8=("Rank 1") A9=("Rank 2") A10=("Rank 3") A11=("Rank 4")
putexcel B1=("Frequency of ranking NOW") B7=("Frequency of ranking 5 yrs ago")
*now
clonevar varB=f103a__1
clonevar varC=f103a__2
clonevar varD=f103a__3
clonevar varE=f103a__4
clonevar varF=f103a__5
clonevar varG=f103a__6
clonevar varH=f103a__7
clonevar varI=f103a__99
for var var*: replace X=. if X==0

local vlist B C D E F G H I
foreach X of local vlist {
 tab var`X', matrow(names) matcell(freq)
 return list
 if `r(N)'>0 { 
 matrix list names
 matrix list freq
 local rows = rowsof(names)
  forvalues i = 1/`rows' {
   local val=names[`i',1]  
   local freq_val = freq[`i',1] 
   local j=`val'+2
   putexcel `X'`j'=(`freq_val') 
   }
 }
 else {
   putexcel `X'`j'=(" ") 
 }
} 
drop var*

*5 yrs ago
clonevar varB=f103b__1
clonevar varC=f103b__2
clonevar varD=f103b__3
clonevar varE=f103b__4
clonevar varF=f103b__5
clonevar varG=f103b__6
clonevar varH=f103b__7
clonevar varI=f103b__99
sum var*
for var var*: replace X=. if X==0

local vlist B C D E F G H I
foreach X of local vlist {
 tab var`X', matrow(names) matcell(freq)
 return list
 if `r(N)'>0 { 
 matrix list names
 matrix list freq
 local rows = rowsof(names)
  forvalues i = 1/`rows' {
   local val=names[`i',1]  
   local freq_val = freq[`i',1] 
   local j=`val'+7
   putexcel `X'`j'=(`freq_val') 
   }
 }
 else {
   putexcel `X'`j'=(" ") 
 }
} 
drop var*


*Table F104
putexcel set "$tables/results_SectionE-I", sheet(F104) modify
putexcel A1=("F104, for villages with ag. land operated by people outside the village"), bold
putexcel A2=("Mandalay") A3=("Magwe") A4=("Monywa") A5=("China") A6=("Nearby village") A7=("Other") A8=("Don’t know")
putexcel B1=("Total # of farm operators from …") C1=("% of farm operators from …")
des f104__*
sum f104__*

tab f100
for var f104__*: replace X=0 if X~=1 & f100==1
clonevar var1=f104__1
clonevar var2=f104__2
clonevar var3=f104__3
clonevar var4=f104__4
clonevar var5=f104__5
clonevar var6=f104__99
clonevar var7=f104__97

forvalues i=1/7 {
 sum var`i' 
 local mean=trim("`: display %9.2f r(mean)*100'")
 local j=`i' +1
 putexcel  B`j'=`r(sum)' C`j'=(`mean')
 drop var`i' 
}


********************************************************************************
*** Secion G. CREDIT
********************************************************************************

*Table G100-101
putexcel set "$tables/results_SectionE-I", sheet(G100-1) modify
putexcel A1=("G100-101"), bold
putexcel B1=("# of villages EVER access credit from … ") C1=("% of villages EVER access credit from …") 

putexcel A2=("Myanmar Ag. Dev. Bank")
putexcel A3=("Private banks")
putexcel A4=("Micro finance inst./NGOs")
putexcel A5=("Cooperatives")
putexcel A6=("Revolving fund")
putexcel A7=("Private money lenders")
putexcel A8=("Gold shop/pawn shop")
putexcel A9=("Ag. produce traders")
putexcel A10=("Friends/Relatives")
putexcel A11=("Other")

clonevar var1=g101__1
clonevar var2=g101__2
clonevar var3=g101__3
clonevar var4=g101__4
clonevar var5=g101__5
clonevar var6=g101__6
clonevar var7=g101__7
clonevar var8=g101__8
clonevar var9=g101__9
clonevar var10=g100s
sum var*
for var var*: replace X=0 if X==2

forvalues i=1/10 {
 sum var`i' 
 local mean=trim("`: display %9.2f r(mean)*100'")
 local j=`i' +1
 putexcel  B`j'=`r(sum)' C`j'=(`mean')
 drop var`i' 
}

putexcel A13=("Note: variables g102*-g107* are missing in the MAIN_merged.dta file")
*Check: variables g102*-g107* are missing in the "MAIN_merged.dta" file



********************************************************************************
*** Secion H. NON-FARM BUSINESS INVENTORY
********************************************************************************

*Table H
putexcel set "$tables/results_SectionE-I", sheet(H) modify
putexcel A1=("H"), bold

putexcel A2=("Village shop(food, soap, etc)")
putexcel A3=("Electronic shop")
putexcel A4=("Hardware shop")
putexcel A5=("Paddy Trader")
putexcel A6=("Pulses/oilseeds trader")
putexcel A7=("Vegetables/fruits trader")
putexcel A8=("Livestock, poultry or meat trader")
putexcel A9=("Timber/bamboo seller")
putexcel A10=("Charcoal/firewood selling")
putexcel A11=("Teashop")
putexcel A12=("Betel nut kiosk")
putexcel A13=("Prepared food stall(mohinga, bbq, snacks)")
putexcel A14=("Restaurant/bar")
putexcel A15=("Bus/minibus/car taxi service")
putexcel A16=("Motorcycle taxi service")
putexcel A17=("Horsecart/bullock cart taxi service")
putexcel A18=("Carpenter/mason")
putexcel A19=("Thatcher/matmaking")
putexcel A20=("Weaver/spinning")
putexcel A21=("Metal worker(blacksmith, tinsmith)")
putexcel A22=("Other handicraft production")
putexcel A23=("Ceremony decoration/music service")
putexcel A24=("Hairdresser/beauty saloon")
putexcel A25=("Construction business owner")
putexcel A26=("Mechanic")
putexcel A27=("Phone service/internet cafe")
putexcel A28=("Labour broker")
putexcel A29=("Other")

putexcel B1=("# of villages with… In last 10 yrs") C1=("% of villages with… In last 10 yrs")
sum h101__*
for var h101__*: replace X=0 if X~=1

forvalues i=1/28{
 sum h101__`i'
 local mean=trim("`: display %9.2f r(mean)*100'")
 local j=`i' +1
 putexcel  B`j'=`r(sum)' C`j'=(`mean') 
}
putexcel A31=("Note: variables h102* are missing in the MAIN_merged.dta file")
*Check: variables h102* are missing in the "MAIN_merged.dta" file



********************************************************************************
*** Secion I. FARMER ASSOCIATIONS
********************************************************************************

*Table I
putexcel set "$tables/results_SectionE-I", sheet(I) modify
putexcel A1=("I"), bold

putexcel A2=("Central Cooperative Society")
putexcel A3=("NGO farmer group")
putexcel A4=("Myanmar Farmers' Association")
putexcel A5=("Ag. and Farmers' Federation")
putexcel A6=("Sector organizations (rice federation, livestock federation, etc)")
putexcel A7=("Other")

putexcel B1=("# of villages with… association") C1=("% of villages with… association")
sum i101__*
for var i101__*: replace X=0 if X~=1

forvalues i=1/6{
 sum i101__`i'
 local mean=trim("`: display %9.2f r(mean)*100'")
 local j=`i' +1
 putexcel  B`j'=`r(sum)' C`j'=(`mean') 
}
putexcel A9=("Note: variables i102*-i103* are missing in the MAIN_merged.dta file")
*Check: variables i102*-i103* are missing in the "MAIN_merged.dta" file



































