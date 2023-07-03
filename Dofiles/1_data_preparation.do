* Stata programs for replication of "Why don't firms hire young workers during recessions? by Eliza Forsythe (2021)
* Replicators: J. Créchet, J. Cui, B. Sabada, A. Sawyer
* May 2023

**

* Program: 1_data_preparation, last edited June 21, 2023
* Produces final_dataset.dta, working dataset for the regression analysis.

**

* log
capture log close
log using Logfiles/1_data_preparation, text replace
 
* load data
use Data/cps_00038, clear

**

* 1. PANEL PREPARATION

* keep age 16-79 (as in the initial code, see YH_data_init, line 134)
keep if age >= 16 & age <= 79

* date
gen year_str = string(year)
gen month_str = string(month)
gen date_str = year_str + "m" + month_str
gen date = monthly( date_str, "YM" )
drop *_str

* declare panel
xtset cpsidp date, monthly
order cpsidp date
sort cpsidp date

* longitudinal sample
gen n = 0
replace n = 1 if L.empstat != .

* Check age, sex, race matching
* dummies for race
decode race, gen(race_string)
gen white = ( strpos(race_,"white")>0 )
gen black = ( strpos(race_,"black")>0 )
gen asian = ( strpos(race_,"asian")>0 )
gen pacific = ( strpos(race_,"pacific")>0 )
gen native  = ( strpos(race_,"hawaiian") + strpos(race_,"american") + strpos(race_,"aleut") + strpos(race_,"eskimo") > 0 )
gen tmp = white + black + asian + native + pacific
gen no_race = tmp == 0

* check
tab race if white
tab race if black
tab race if asian
tab race if native
tab race if pacific
tab race if no_race

* identify mismatched based on sex, race , age
gen mismatch = .
replace mismatch = 0 if n == 1 
replace mismatch = 1 if n == 1 & ( sex != L.sex | race != L.race | age < L.age | age > L.age+1 )

* sample longitudinally matched
replace n = 0 if mismatch == 1

* count number of mismatched per id
by cpsidp, sort: egen sum_mismatch = sum(mismatch)
tab sum_mismatch

* longitudinal weights
gen weights = 1/2*(L.wtfinl + wtfinl)

* normalize by date
by date, sort: egen w_sum = sum( weights )
replace weights = weights / w_sum


****
****


* 2. ADDITIONAL VARIABLES

** Potential experience

* years of education
gen year_educ = 0

* primary/secondary school
gen yeareduc = 0 if educ == 2 // none, preschool
replace yeareduc = 4 if educ >= 10 & educ <= 14 // grade 4 and less
replace yeareduc = 6 if educ >= 20 & educ <= 22 // grade 5 and 6
replace yeareduc = 8 if educ >= 30 & educ <= 32 // grade 7 and 8
replace yeareduc = 9 if educ == 40 // grade 9
replace yeareduc = 10 if educ == 50 // grade 10
replace yeareduc = 11 if educ == 60 // grade 11
replace yeareduc = 12 if educ >= 71 & educ <= 73 // grade 12/high school diploma

* higher education
replace yeareduc = 13 if educ == 81 				// some college
replace yeareduc = 14 if educ >= 91 & educ <= 92 	// AD
replace yeareduc = 16 if educ == 111 				// Bachelor
replace yeareduc = 18 if educ == 123				// Master's
replace yeareduc = 20 if educ == 124				// PD
replace yeareduc = 22 if educ == 125 				// PhD
by yeareduc, sort: tab educ, miss

* check
by educ, sort: tab yeareduc, miss

* compute potential experience
gen exp = max( age - yeareduc - 6, 0) // experience with imputed zero
gen exp_neg_val = age - yeareduc - 6  // experience with negative values

* check
tab exp, missing
tab exp_neg_val, missing

* flag exp variable for negative values
gen exp_flag = (exp_neg_val <= 0 & exp_neg_val != .)

* experience groups
gen exp_group = 0 if exp !=.
replace exp_group = 1 if exp <= 10 & exp != .
label def exp_lab 1 "PE $\leq$ 10" 0 "PE $>$ 10" 
label values exp_group exp_lab


**

** education groups
gen educgroup = 0 if educ >= 0 & educ <= 71  //no hs degree
replace educgroup = 1 if educ == 73 // hs 
replace educgroup = 2 if educ == 81 // some college
replace educg =  3 if educ >= 91 & educ <= 111 // college deg.
replace educg = 4 if educ == 123 //masters
replace educg = 5 if educ == 124 //prof deg
replace educg = 6 if educ == 125 //phd
by educg, sort: tab educ

* labels
label define educ_lab 0 "no hs degree" 1 "hs" 2 "some college" 3 "college degree" 4 "masters" 5 "prof. degree" 6 "PhD"
label values educgroup educ_lab


**


** demographic dummy set (gender/race (white, nonwhite)/hispanic origin/education group)
egen demographic = group(sex white hispan educg)

* checks
by educgroup, sort: tab educ, miss
by exp_group, sort: tab exp, miss
sort cpsidp date


**

** LAUS unemployment rate by state
merge m:1 statefip year month using Data/laus_state_wide, keepusing(unemp_rate)

* check the non merged
tab year if _merge == 2
tab statefip if year >= 1995 & year <= 2019 & _mer == 2
drop if _merge == 2  // dropping data before 1995 and 2019 & minesotta-iowa
drop _merge

* rename and label unemployment rate variable
rename unemp_rate urate
label var urate "U.\ rate"


**


** Unemployment rate by MSA (estimated using the CPS)

* individual unemployment and lab force dummies
gen unemployed = ( empstat >= 21 & empstat <= 22 ) // unem. dummy
gen participant = ( empstat >= 10 & empstat <= 22 ) 

* collapse to compute unemployment
preserve
keep if metarea >= 60 & metarea <= 9360  // keep data for hh in metro area, with available msa info
collapse (sum) u = unemployed (sum) p = participant (sum) n_msa = n [w = wtfinl], by(metarea date)
gen urate_msa = u / p * 100
drop u p
save tmp, replace
restore
merge m:1 metarea date using tmp
drop _merge 
erase tmp.dta


**


** Dependent variable for hiring
sort cpsidp date
gen d_hired = 0
replace d_hired = 100 if (empstat >= 10 & empstat <= 12) & (L.empstat >= 21 & L.empstat <= 36) 				  // hired from nonemployement
replace d_hired = 100 if (empstat >= 10 & empstat <= 12) & (L.empstat >= 10 & L.empstat <= 12) & empsame == 1 // hired from another job
replace d_hired = 0 if d_hired == 100 & (classwkr >= 13 & classwkr <= 14)  									  // exclude transitions to self-employment

** Sample 1994-2014
gen sample = (year >= 1994 & year <= 2014)
replace sample = 0 if ( year == 1995 & ( month >= 5 & month <= 8 ) ) 
replace sample = 0 if ( year == 2014 & month > 6 )
replace sample = 0 if n == 0

** Sample 1994-2019
gen sample_2019 = (year >= 1994 & year <= 2019)
replace sample_2019 = 0 if ( year == 1995 & ( month >= 5 & month <= 8 ) ) 
replace sample_2019 = 0 if n == 0


**

* save intermediate dataset
save Data/intermediate_data, replace


**

* 3. SAVE FINAL DATASETS

use Data/intermediate_data, clear

#delimit ;
global variables = "cpsidp date year month statefip metfips metarea age sex race hispan educgroup empstat classwkr empsame
				    sample sample_2019 weights d_hired urate exp exp_neg exp_flag exp_group urate_msa n_msa demographic whyunemp
					eligorg earnweek_cpiu_2010 occ1990 ind1990 qearn";
#delimit cr

di "$variables"

* save dataset				  
keep $variables
compress
saveold Data/final_dataset, replace
macro drop variables

**

log close 
