* Stata programs for replication of "Why don't firms hire young workers during recessions? by Eliza Forsythe (2021)
* Replicators: J. Créchet, J. Cui, B. Sabada, A. Sawyer
* May 2023

**

* Program: 0b_laus_data
* Prepare LAUS unemployment statistics for merging with CPS IPUMS micro data.

**

capture log close
log using Logfiles/0b_laus_data, text replace


****
****

** Crosswalk

* LAUS codes 
import delimited Data\LAUS\la.area.txt, clear 
keep if area_type_code == "A"
gen state = lower( area_text )
rename area_code laus_code
keep laus_code state
save Data\temp.dta, replace 

* FIPS codes
import delimited Data\IPUMS_CPS\fipcode_cps.txt, delimiter(tab) clear 
rename v1 statefip 
rename v2 state 

* merge 
merge 1:1 state using Data\temp.dta
drop _merge 
sort statefip
order statefip state laus_code
replace statefip = 72 if state == "puerto rico" 
save Data\state_crosswalk.dta, replace 


****
****


** Convert in Stata format

* Import LAUS data
import delimited "Data\LAUS\la.data.2.AllStatesU.txt", delimiter(whitespace, collapse) clear 

* LAUS area codes
gen laus_code = substr(series_id,4,15)

* measure code
gen measure = substr(series_id,-2,2)

* States and FIPS codes  
merge m:1 laus_code using Data/state_crosswalk
drop _merge

* destring and rename month variable
drop if period == "M13" // drop yearly average
rename period month
replace month = subinstr(month,"M","",1)
destring month, replace

* destring values
replace value = "" if footnote == "N" // recode missings
destring value, replace

* destring measure and label values
destring measure, replace
label define lab 3 "unemployment rate" 4 "unemployment" 5 "employment" 6 "labor force" ///
				 7 "employment-population ratio" 8 "labor force participation rate" 9 "civilian noninstitutional population"
label values measure lab
label drop lab
						
* sort, order
sort statefip measure year month
order statefip state year month measure value measure footnote laus_code series_id

* save data
save Data/laus_state, replace

* data in wide format
drop laus_code series_id footnote
reshape wide value, i(statefip year month) j(measure)
rename value3 unemp_rate
rename value4 unemp
rename value5 emp
rename value6 lab_force
rename value7 emp_pop
rename value8 part_rate
rename value9 pop

* variable labels
label var unemp_rate 	"unemployment rate" 
label var unemp 		"unemployment" 
label var emp 			"employment" 
label var lab_force 	"labor force" 
label var emp_pop 		"employment-population ratio" 
label var part_rate 	"labor force participation rate" 
label var pop 			"civilian noninstitutional population"

* save
order statefip state year month
sort statefip year month
save Data/laus_state_wide, replace

* cleanup
erase Data\temp.dta

**

log close


