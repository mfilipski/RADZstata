clear
capture log close
set more off

*  1. make the EA and VT matching geo file
*===================================================================
*===================================================================
/*
import excel "D:\Docs\Myanmar\DryZone\DATA\extras\ea_vt_comm.xlsx" , firstrow
rename villagetract vt_4check
rename ea eacode 
save "D:\Docs\Myanmar\DryZone\DATA\extras\ea_vt_codes.dta", replace 
*/


* 2. merge version 13 and 14:
*===================================================================
*===================================================================
* paths 
global workdir "D:\Docs\Myanmar\DryZone\Analysis\Stata\do"
global v14dir "D:\Docs\Myanmar\DryZone\DATA\tempdata\TempSurveyData\RADZ_v14_170403"
global v13dir "D:\Docs\Myanmar\DryZone\DATA\tempdata\TempSurveyData\RADZ_v13_170403"
global mergedir "D:\Docs\Myanmar\DryZone\DATA\tempdata\TempSurveyData\Merged_current"
global temp "D:\Docs\Myanmar\DryZone\DATA\tempdata\TempSurveyData\Merged_current\temp"
global outdatafile "$mergedir\RADZ_MAIN_merged"

cd "$workdir"

* 2.1 MAIN FILE :
* @@@@@@@@@@@@@@@@@@@ 
use "$v13dir\RADZ survey - Dry Zone Community Questionnaire", clear

* convert village tract code from string to integer: 
clonevar vtcode = a103
clonevar a103_v13 = a103  
list Id-a104 vt 
 
* replace vt = "." if Id == "f9b8b2f8be8747798aea40a2b24c1b5c" // seems was corrected
replace vt = "726" if  Id== "4c43bb5e80214b428d7053a7aebd8863" // was corrected but with quotes for some reason.
list Id-a104 vt
desc vt 
destring vt, replace
gen qversion = 13 

* recode more stuff to stringi if needed... 

save $temp\v13main, replace 

* Merge with v14 
use "$v14dir\RADZ survey - Dry Zone Community Questionnaire", clear
clonevar vtcode = a103
gen qversion = 14 
label var qversion "version of questionnaire 13 or 14"
append using $temp\v13main, force
list Id a101 a102 a103* vt* a104 a105__L*

clonevar eacode = a102 
clonevar tcode = a101 
label define tcode 1 "Budalin" 2 "Magway" 3 "Pwintbyut" 4 "Myittha"
label values tcode tcode
list Id tcode eacode vtcode a103* a104 a105__L*

rename Id interview 
label var interview "interview ID"
save $outdatafile, replace



* 2.2 : Section B, respondents: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v13dir\B_Respondents", clear
list
gen qversion = 13 
tempfile B
save `B'

use "$v14dir\B_Respondents", clear
list 
label var b101 "b101. Respondent name"
gen qversion = 14 
label var qversion "version of questionnaire 13 or 14"
append using `B'
rename ParentId interview 
label var interview "interview ID"
save $mergedir\B_Respondents_merged, replace



* 2.2 : Section E1, Business 1: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v13dir\E_AgBus1", clear
list
gen qversion = 13 
tempfile E1
save `E1'

use "$v14dir\E_AgBus1", clear
list 
gen qversion = 14 
label var qversion "version of questionnaire 13 or 14"
append using `E1'
rename Id bustype
#delimit ; 
label define bustype
1 "Rice mill (Huller)" 
2 "Oil mill (Small)" 
3 "Thresher (Peanut)" 
4 "Thresher (Paddy & Pulses)" 
5 "Households with two wheel tractors for hire" 
6 "Households with four wheel tractors for hire" 
7 "Households with combine harvesters for hire"
8 "Households with trawlerji for hire" 
9 "Truck transport services for hire" 
10 "Tree nursery" 
11 "Fish farm" 
12 "Commercial Melon Farm" 
13 "Piglet rearing" 
14 "Bee keeping" 
15 "Agricultral inputs shop"  ; 
#delimit cr 
label values bustype bustype
label var bustype "type of business"
list 
rename ParentId interview 
label var interview "interview ID"
save $mergedir\E_AgBus1_merged, replace



* 2.2 : Section E2, Business 2: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v13dir\E_AgBus2", clear
list
gen qversion = 13 
tempfile E2
save `E2'
use "$v14dir\E_AgBus2", clear
list 
gen qversion = 14 
label var qversion "version of questionnaire 13 or 14"
append using `E2'
rename Id bustype
label define bustype 15 "Rice Mill (Medium/Large)" 16 "Oil Mill (Medium/Large)" 17 "Agricultural machinery supplier"
label values bustype bustype
label var bustype "type of business"
list 
rename ParentId interview 
label var interview "interview ID"
save $mergedir\E_AgBus2_merged, replace

* 2.3 : Section G1, Credit 1: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v13dir\G_Credit1", clear
list
gen qversion = 13 
tempfile G1
save `G1'
use "$v14dir\G_Credit1", clear
list 
gen qversion = 14 
label var qversion "version of questionnaire 13 or 14"

append using `G1'
rename Id fintype
#delimit ;
label define fintype 
1 "Myanmar Agricultural Development Bank (MADB)"
2 "Private banks"
3 "Microfinance institutions/ NGOs"
4 "Cooperatives (through Ministry of Cooperatives)"
5 "Revolving fund"
6 "Private moneylenders"
7 "Gold shop/pawn shop"
8 "Agriculture produce traders"
9 "Friends / Relatives" ;
#delimit cr
label values fintype fintype
label var fintype "type of financial institution"
list 
rename ParentId interview 
label var interview "interview ID"
save $mergedir\G_Credit1_merged, replace

* 2.3 : Section G2, Credit 2: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v13dir\G_Credit2", clear
list
gen qversion = 13 
tempfile G2
save `G2'
use "$v14dir\G_Credit2", clear
list 
gen qversion = 14 
label var qversion "version of questionnaire 13 or 14"
append using `E2'
label var g101s "specify the other type of financial institution"
rename ParentId interview 
label var interview "interview ID"
save $mergedir\G_Credit2_merged, replace



* 2.4 : Section H, Nonfarm: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v13dir\H_Nonfarm", clear
list
gen qversion = 13 
tempfile H
save `H'
list
use "$v14dir\H_Nonfarm", clear
list 
gen qversion = 14 
label var qversion "version of questionnaire 13 or 14"
append using `H'

rename Id bustype
#delimit ;
label define bustype 
1 "Village shop (food, soap, etc)"
2 "Electronic shop"
3 "Hardware shop"
4 "Paddy Trader"
5 "Pulses/oilseeds trader"
6 "Vegetables/fruits trader"
7 "Livestock, poultry or meat trader"
8 "Timber/bamboo seller"
9 "Charcoal/firewood selling"
10 "Fish processing (drying, paste making)"
11 "Teashop"
12 "Betel nut kiosk"
13 "Prepared food stall (mohinga, bbq, snacks)"
14 "Restaurant/bar"
15 "Bus/ minibus/ car taxi service"
16 "Motorcycle taxi service"
17 "Horsecart/ bullock cart taxi service"
18 "Carpenter / mason"
19 "Thatcher/ matmaking"
20 "Weaver/ spinning"
21 "Metal worker (blacksmith, tinsmith)"
22 "Other handicraft production"
23 "Ceremony decoration/ music service"
24 "Hairdresser/ beauty saloon"
25 "Construction business owner"
26 "Mechanic"
27 "Phone service/ internet cafe"
28 "Labour broker" ;
#delimit cr
label values bustype bustype
label var bustype "type of non-farm business"
list 
rename ParentId interview 
label var interview "interview ID"
save $mergedir\H_Nonfarm_merged, replace


* 2.4 : Section I, FarmAssoc: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v13dir\I_FarmAssoc", clear
list
gen qversion = 13 
tempfile I
save `I'
list

use "$v14dir\I_FarmAssoc", clear
list 
gen qversion = 14 
label var qversion "version of questionnaire 13 or 14"
append using `I'
list 
rename ParentId interview 
label var interview "interview ID"
save  $mergedir\I_FarmAssoc_merged, replace



* 2.5 : Section J, Prices: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v13dir\J_PricesUnits", clear
list
gen qversion = 13 
tempfile J
save `J'
list
 
use "$v14dir\J_PricesUnits", clear
list 
gen qversion = 14 
label var qversion "version of questionnaire 13 or 14"
append using `J', force
list 
rename ParentId interview 
label var interview "interview ID"
save  $mergedir\J_PricesUnits_merged, replace

* 2.6 : Section K1 Climate: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v13dir\K1_Climate", clear
list
gen qversion = 13 
tempfile K1
save `K1'
list

use "$v14dir\K1_Climate", clear
list 
gen qversion = 14 
label var qversion "version of questionnaire 13 or 14"
append using `K1', force
list 
rename ParentId interview 
label var interview "interview ID"
save  $mergedir\K1_Climate_merged, replace


* 2.7 : Section K2 Climate Crops: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v13dir\K2_ClimateCrops", clear
list
gen qversion = 13 
tempfile K2
save `K2'
list
 
use "$v14dir\K2_ClimateCrops", clear
list 
gen qversion = 14 
label var qversion "version of questionnaire 13 or 14"
append using `K2', force
rename Id crop
#delimit ;
label define crop 
1 "Sesame"
2 "Monsoon Rice"
3 "Summer Rice"
4 "Groundnut"
5 "Green-gram"
6 "Black-gram"
7 "Pigeon Peas" ;
#delimit cr
label values crop crop
label var crop "crop name"
list 
rename ParentId interview 
label var interview "interview ID"
save  $mergedir\K2_ClimateCrops_merged, replace


* 2.8: Interview actions : 
* @@@@@@@@@@@@@@@@@@@ 
use "$v13dir\interview_actions", clear
gen qversion = 13 
tempfile ia
save `ia'
use "$v14dir\interview_actions", clear
gen qversion = 14 
append using `ia' 
list, sepby(Inter)
rename InterviewId interview 
label var interview "interview ID"
rename Action action
rename Originator originator
rename Role role
rename Date date
rename Time time 
save  $mergedir\InterviewActions_merged, replace

* 2.8: Interview comments: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v13dir\interview_comments", clear
gen qversion = 13 
tempfile ic
save `ic'
use "$v14dir\interview_comments", clear
gen qversion = 14 
append using `ic' 
*list, sepby(Inter)

rename InterviewId interview 
label var interview "interview ID"
rename Id1 rosterid
label var rosterid "Id code within the roster"
save  $mergedir\InterviewComments_merged, replace



* 3. Make useful files: 
*===================================================================
*===================================================================

* File with current status of an interview: 
use $mergedir\InterviewActions_merged, clear

* make a counter to find the last status
sort interview date time 
by interview, sort: gen counter = _n 
egen maxct = max(counter), by(interview)
gen last = (counter==maxct)
list in 1/100, sepby(inter)

* now keep only the last status 
gen curstat = action if last==1 
list in 1/100, sepby(inter)

* make a file to merge with main: 
keep if last==1 
drop counter qversion maxct last action 
order interview curstat originator role date time 
label var curstat "current status of interview on server"
rename originator statorig 
rename role statrole 
rename date statdate
rename time stattime 
label var statorig "originator for current status"
label var statrole "role of originator for current status"
label var statdate "date of current status input"
label var stattime "time of current status input"
list in 1/10, sepby(inter)
save $mergedir\CurrentStatus, replace 

