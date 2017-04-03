clear
capture log close
set more off

* define paths
include D:\Docs\Myanmar\DryZone\Analysis\Stata\do\dz000_paths.do


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

* dot plot for numbers of households: 
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
*twoway pcarrow  nhh5 nhh nhh10 nhh , pstyle(p1)
*twoway connected nhh nhx || connected nhh5 nhx || connected nhh10 nhx
*twoway pcscatter nhh nhx  nhh5 nhx  
* Full range 
*twoway  (pcarrow nhh10 nhx  nhh5 nhx , pstyle(p2)) || (pcarrow   nhh5 nhx  nhh nhx, pstyle(p1)) , title("full range")
*twoway  (pcarrow nhh10 nhx  nhh5 nhx , pstyle(p2)) || (pcarrow   nhh5 nhx  nhh nhx, pstyle(p1)) if nhx<=600, title("only villages under 600") 

* Adding lanless and migrants: 
*twoway  (pcarrow nhh10 nhx  nhh5 nhx , pstyle(p2)) || (pcarrow   nhh5 nhx  nhh nhx, pstyle(p1)) || (scatter nhmigin nhx) , title("full range")
*twoway  (pcarrow nhh10 nhx  nhh5 nhx , pstyle(p2)) || (pcarrow   nhh5 nhx  nhh nhx, pstyle(p1)) || (dropline nhmigin nhx) /// 
	|| (dropline nhmigneg nhx) || (scatter nhlanded nhx) , title("full range")

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
