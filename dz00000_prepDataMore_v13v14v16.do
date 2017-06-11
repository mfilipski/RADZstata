clear
capture log close
set more off

* 2. make the double merge of versoin 13/14 and version 16:
*===================================================================
*===================================================================
* paths 
global workdir "D:\Docs\Myanmar\DryZone\Analysis\Stata\do"
global v16dir "D:\Docs\Myanmar\DryZone\DATA\tempdata\TempSurveyData\RADZ_v16_170529"
global merge1dir "D:\Docs\Myanmar\DryZone\DATA\tempdata\TempSurveyData\Merged_current"
global merge1file "$merge1dir\RADZ_MAIN_merged"

global merge2dir "D:\Docs\Myanmar\DryZone\DATA\tempdata\TempSurveyData\DoubleMerged_current"
global merge2file "$merge2dir\RADZ_MAIN_DoubleMerged"


global temp "D:\Docs\Myanmar\DryZone\DATA\tempdata\TempSurveyData\Merged_current\temp"


cd "$workdir"

* 2.1 MAIN FILE :
* @@@@@@@@@@@@@@@@@@@ 
use "$v16dir\RADZ survey - Dry Zone Community Questionnaire", clear

* convert village tract code from string to integer: 
rename Id interview 
clonevar vtcode = a103
clonevar eacode = a102 
clonevar tcode = a101 
gen qversion = 16 
label var qversion "version of questionnaire 13 / 14 / 16"
#delimit ;  
label define tcode 1 "Budalin" 2 "Magway" 3 "Pwintbyut" 4 "Myittha"
11 "Yenangyaung" 
12 "Natmauk"       
13 "Sintgaing"      
14 "Meiktila"         
15 "Wundwin"      
16 "Tabayin"          
17 "Khin-U"          
18 "Wetlet"          
19 "Chaung-U"      
20 "Shwebo"         
;
#delimit cr 
label values tcode tcode


append using $merge1file, force
label var interview "interview ID"
list inter a101 a102 a103* vt* a104 a105__L*  a110 
list inter tcode eacode vtcode a103* a104 a105__L*
save $merge2file, replace





* 2.2 : Section B, respondents: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v16dir\B_Respondents", clear
list 
label var b101 "b101. Respondent name"
gen qversion = 16 
rename ParentId interview 
label var interview "interview ID"
tempfile B 
save `B'


use "$merge1dir\B_Respondents_merged", clear
append using `B'
label var qversion "version of questionnaire 13 or 14 or 16"
save $merge2dir\B_Respondents_DoubleMerged, replace




* 2.2 : Section E1, Business 1: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v16dir\E_AgBus1", clear
gen qversion = 16 
rename Id bustype
rename ParentId interview 
tempfile E1
save `E1'

use "$merge1dir\E_AgBus1_merged", clear
list 
append using `E1'
label var qversion "version of questionnaire 13 or 14 or 16"

save $merge2dir\E_AgBus1_DoubleMerged, replace




* 2.2 : Section E2, Business 2: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v16dir\E_AgBus2", clear
list
gen qversion = 16 
rename Id bustype
rename ParentId interview 
tempfile E2
save `E2'
use "$merge1dir\E_AgBus2_merged", clear
append using `E2'
label var qversion "version of questionnaire 13 or 14 or 16"
save $merge2dir\E_AgBus2_DoubleMerged, replace





* 2.3 : Section G1, Credit 1: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v16dir\G_Credit1", clear
gen qversion = 16 
rename Id fintype
rename ParentId interview 
tempfile G1
save `G1'


use "$merge1dir\G_Credit1_merged", clear
append using `G1'
label var qversion "version of questionnaire 13 or 14 or 16"
save $merge2dir\G_Credit1_DoubleMerged, replace



* 2.3 : Section G2, Credit 2: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v16dir\G_Credit2", clear
rename ParentId interview 
gen qversion = 16 
tempfile G2
save `G2'

use "$merge1dir\G_Credit2_merged", clear
append using `E2'
save $mergedir\G_Credit2_DoubleMerged, replace



* 2.4 : Section H, Nonfarm: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v16dir\H_Nonfarm", clear
gen qversion = 16
rename Id bustype
rename ParentId interview 
tempfile H
save `H'
list
use "$merge1dir\H_Nonfarm_merged", clear
append using `H'
label var qversion "version of questionnaire 13 or 14 or 16"
save $merge2dir\H_Nonfarm_DoubleMerged, replace


* 2.4 : Section I, FarmAssoc: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v16dir\I_FarmAssoc", clear
rename ParentId interview 
gen qversion = 16 
tempfile I
save `I'
list

use "$merge1dir\I_FarmAssoc_merged", clear
append using `I'
label var qversion "version of questionnaire 13 or 14 or 16"
save  $merge2dir\I_FarmAssoc_DoubleMerged, replace



* 2.5 : Section J, Prices: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v16dir\J_PricesUnits", clear
rename ParentId interview 
 gen qversion = 16 
tempfile J
save `J'
 
use "$merge1dir\J_PricesUnits_merged", clear
append using `J', force
label var qversion "version of questionnaire 13 or 14 or 16"
save  $merge2dir\J_PricesUnits_DoubleMerged, replace


* 2.6 : Section K1 Climate: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v16dir\K1_Climate", clear
rename ParentId interview 
gen qversion = 16 
tempfile K1
save `K1'

use "$merge1dir\K1_Climate_merged", clear
append using `K1', force
label var qversion "version of questionnaire 13 or 14 or 16"
save  $merge2dir\K1_Climate_DoubleMerged, replace


* 2.7 : Section K2 Climate Crops: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v16dir\K2_ClimateCrops", clear
rename Id crop
rename ParentId interview 
gen qversion = 16 
tempfile K2
save `K2'
list
 
use "$merge1dir\K2_ClimateCrops_merged", clear
append using `K2', force
label var qversion "version of questionnaire 13 or 14 or 16"
save  $merge2dir\K2_ClimateCrops_DoubleMerged, replace





* 2.8: Interview actions : 
* @@@@@@@@@@@@@@@@@@@ 
use "$v16dir\interview_actions", clear
rename InterviewId interview 
rename Action action
rename Originator originator
rename Role role
rename Date date
rename Time time 
gen qversion = 16 
tempfile ia
save `ia'

use "$merge1dir\InterviewActions_merged", clear
append using `ia' 
save  $merge2dir\InterviewActions_DoubleMerged, replace

* 2.8: Interview comments: 
* @@@@@@@@@@@@@@@@@@@ 
use "$v16dir\interview_comments", clear
rename InterviewId interview 
rename Id1 rosterid
gen qversion = 16 
tempfile ic
save `ic'

use "$merge1dir\InterviewComments_merged", clear
append using `ic' 

save  $merge2dir\InterviewComments_DoubleMerged, replace


