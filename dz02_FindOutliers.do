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

* add interview status
merge 1:1 interview using $rawdir\CurrentStatus

* make useful variables: 
clonevar enumerator = a110 
clonevar vname = a104
clonevar dt = a107 


* Check for outliers with graphs: 

* 1) dot plot for numbers of households:  
*===================================================================
clonevar nhh = c102a 
clonevar nhh5 = c102b
clonevar nhh10 = c102c
clonevar nhmigin = c103
clonevar nhmigout = c104
gen nhmigneg = -nhmigout 
clonevar nhlanded = c105

lab var nhh "nb hh now"
lab var nhh5 "nb hh 5y ago"
lab var nhh10 "nb hh 10y ago"
lab var nhmigin "nb hh migrated in"
lab var nhmigout "nb hh migrated out"
lab var nhmigneg "nb hh migrated out (negative)"
lab var nhlanded "nb landed households"


* make the x axis: 
gen nhx = nhh10 
sort nhx 
*twoway scatter (nhh nhh5) || scatter (nhh nhh10)
*twoway pcarrow  nhh5 nhh nhh10 nhh , pstyle(p1)
*twoway connected nhh nhx || connected nhh5 nhx || connected nhh10 nhx

twoway  (pcarrow nhh10 nhx  nhh5 nhx , pstyle(p2)) || (pcarrow   nhh5 nhx  nhh nhx, pstyle(p1)) || (scatter nhlanded nhx) , title("full range")
*twoway  (pcarrow nhh10 nhx  nhh5 nhx , pstyle(p2)) || (pcarrow   nhh5 nhx  nhh nhx, pstyle(p1)) || (scatter nhlanded nhx, mlabel(eacode)) if nhx<=600, title("only villages under 600")	
*twoway  (pcarrow nhh10 nhx  nhh5 nhx , pstyle(p2)) || (pcarrow   nhh5 nhx  nhh nhx, pstyle(p1)) || (scatter nhlanded nhx, mlabel(eacode)) if nhx<=200, title("only villages under 200")	
* several seem to have very low numbers of hh: 
list inter eacode vtcode enum curstat stat* qver nhh nhlanded if nhlanded < 20

* EA 48 , vt 726  is not a farm village
gen str mfcomments = ""
lab var mfcomments "comments by MF made while cleaning the data"
replace mfcomments = "This is not a farm village" if eacode==48
list inter eacode vtcode enum curstat stat* mfcomments qver nhh nhlanded if nhlanded < 20

* 2) mini-max for years:  
*===================================================================
clonevar yearprim = c202 
clonevar yearjunior = c204
clonevar yearsenior = c206
sum year*
* twoway hist yearprim || hist yearjunior || hist yearsenior 
* graph matrix year*

* 3) distance to town/city
*============================================
*hist c401a 
*hist c401b 


* 3) modes of transport 
*==================================================
clonevar ttown = c402a 
clonevar ttown5 = c404a
tab ttown5 ttown 

clonevar tcity = c402b 
clonevar tcity5 = c404b
tab tcity5 tcity 

* look at "other specify"
tab c402as
tab c402bs
tab c404as
tab c404bs


* 4) histograms for wage variables: 
*=================================================== 
local wvars = "d401ma d401mb d401mc d401fa d401fb d401fc"
cd $graphs 
foreach v of varlist   `wvars' { 
	recode `v' (9997=.)
	hist `v' 
	graph save  `v'g, replace
}
cd $workdir

graph combine "$graphs\d401mag" "$graphs\d401mbg" "$graphs\d401mcg" "$graphs\d401fag" "$graphs\d401fbg" "$graphs\d401fcg" 
graph export  $graphs\wage_hists.png, replace

foreach v of varlist `wvars' { 
	list ea vtcode vname enum `v' if `v' >= 6000  & `v' !=. 
}


