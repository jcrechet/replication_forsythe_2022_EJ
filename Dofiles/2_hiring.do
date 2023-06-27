* Stata programs for replication of "Why don't firms hire young workers during recessions? by Eliza Forsythe (2021)
* Replicators: J. Créchet, J. Cui, B. Sabada, A. Sawyer
* May 2023

**

* Program: 2_hiring, last edited June 21, 2023
* modified on Jun 12th (line 31-33, 45, 48) to replace the urate with local area urate, (line 231-232, 350, 388) to re-generate variables in the loop. 
* Description: replication of section 2 (direct replicationd and robsutness)

**

* log
capture log close
log using Logfiles/2_hiring, text replace

* data
use Data/final_dataset, clear

* options for regressions with fixed effects
set matsize 2000
set emptycells drop

* command to update/install estout package if needed
ssc install estout, replace

**

* Initialize macro and variables

* variable for clustering
gen clust_var = statefip

* variable for geo fixed effect
gen geo_fe = statefip
	
* macro label for geographic fe unit
global geo "State"
	
* latex path for tables
global table_path = "$latex_path\Tables"


forvalues step = 1(1)3 {

di " "
di "****************"
di " "
di "Step `step'" 
di " "
di "****************"
di " "

* step 1: regression with initial sample in paper (1994-2014)

* step 2: run regression with our sample (1994-2019) 
if `step' == 2 {
		
	* update sample
	replace sample = sample_2019
	drop sample_2019

	* latex path
	global table_path = "$latex_path\Tables\2019"

}

**

* step 3: use MSA variation instead of State
if `step' == 3 {

	* update sample
	replace sample = (sample & urate_msa != .)
	
	* update unemp. variable
	replace urate = urate_msa
	drop urate_msa
	
	* update variable for geo fixed effect
	replace geo_fe = metarea
	
	* update variable for clustering (msa instead of state)
	replace clust_var = metarea
	
	* geographic unit label
	global geo "MSA"
	
	* latex path
	global table_path = "$latex_path\Tables\MSA"

}

di " "
di "latex path for tables:"
di "$table_path"
di " "


**

* Table 1

* Panel A
eststo  clear

* col (1)
eststo: quietly reg d_hired urate [w=weights] if sample, vce(cluster clust_var) cformat(%9.4f) // no fixed effect

* col (2)
eststo: quietly reg d_hired urate i.geo_fe [w=weights] if sample, vce(cluster clust_var) cformat(%9.4f) // state fe

* col (3)
eststo: quietly reg d_hired urate i.geo_fe i.demographic [w=weights] if sample, vce(cluster clust_var) cformat(%9.4f) // state demographic fe
	
* col (4)
eststo: quietly reg d_hired urate i.geo_fe i.demographic i.date [w=weights] if sample, vce(cluster clust_var) cformat(%9.4f) // state/demographic/date

* Stata table
esttab, keep(urate) se r2 nomtitles label varwidth(35) ///
		indicate("`geo' fixed effect = *.geo_fe" "Demographic fixed effect = *.demographic" "Month-year fixed effect = *.date")
										
* latex table
esttab using "$table_path\table1a.tex", replace keep(urate) se r2 nomtitles label varwidth(35) ///
	   indicate("State fixed effect = *.geo_fe" "Demographic fixed effect = *.demographic" "Month-year fixed effect = *.date") ///
	   title("Hiring over the Business Cycle: With and Without Controls - Aggregate effect \label{table1a}") nomtitles
	   								

* Panel B
eststo  clear
local variables = "i1.exp_group c.urate#i1.exp_group c.urate#i0.exp_group"

* col (1)
eststo: quietly reg d_hired `variables' [w=weight] if sample, vce(cluster clust_var) cformat(%9.4f)

* col (2)
eststo: quietly reg d_hired `variables' i.geo_fe [w=weight] if sample, vce(cluster clust_var) cformat(%9.4f)

* col (3)
eststo: quietly reg d_hired `variables' i.geo_fe i.demographic [w=weight] if sample, vce(cluster clust_var) cformat(%9.4f)

* col (4)
eststo: quietly reg d_hired `variables' i.geo_fe i.demographic i.date [w=weight] if sample, vce(cluster clust_var) cformat(%9.4f)

* Stata table
esttab, keep(*.exp_group*) se r2 nomtitles label varwidth(35) order(1.exp_group 1.exp_group#c.urate 0.exp_group#c.urate) ///
		indicate("`geo' fixed effect = *.geo_fe" "Demographic fixed effect = *.demographic" "Month-year fixed effect = *.date")
										
* latex table
esttab using "$table_path\table1b.tex", replace keep(*.exp_group*) se r2 nomtitles label ///
	   varwidth(35) order(1.exp_group 1.exp_group#c.urate 0.exp_group#c.urate) interaction(" $\times$ ") ///		
	   indicate("State fixed effect = *.geo_fe" "Demographic fixed effect = *.demographic" "Month-year fixed effect = *.date") ///
	   title("Hiring over the Business Cycle: With and Without Controls - Disaggregated by potential experience \label{table1b}") booktabs ///
										
**
			 
			 		 
* Table B2

* detailed experience cat.
gen exp_cat = exp_neg_val + 1 if exp_neg_val >= 0 & exp_neg_val < 10

replace exp_cat = 0 if exp_neg_val < 0

replace exp_cat = 1014 if exp_neg_val >= 10 & exp_neg_val < 15
replace exp_cat = 1519 if exp_neg_val >= 15 & exp_neg_val < 20
replace exp_cat = 2024 if exp_neg_val >= 20 & exp_neg_val < 25
replace exp_cat = 2529 if exp_neg_val >= 25 & exp_neg_val < 30
replace exp_cat = 3034 if exp_neg_val >= 30 & exp_neg_val < 35
replace exp_cat = 3539 if exp_neg_val >= 35 & exp_neg_val < 40
replace exp_cat = 4044 if exp_neg_val >= 40 & exp_neg_val < 45
replace exp_cat = 9999 if exp_neg_val >= 45 & exp_neg_val != .

* label values
#delimit ;
	label define exp_cat_lab  0 "PE < 0" 1 "PE = 0" 2 "PE = 1" 3 "PE = 2" 4 "PE = 3" 5 "PE = 4"  	
							  6 "PE = 5" 7 "PE = 6" 8 "PE = 7" 9 "PE = 8" 10 "PE = 9"
							  1014 "10 $\leq$ PE < 15" 1519 "15 $\leq$ PE < 19"
							  2024 "20 $\leq$ PE < 24" 2529 "25 $\leq$ PE < 29"
							  3034 "30 $\leq$ PE < 34" 3539 "35 $\leq$ PE < 39"
							  4044 "40 $\leq$ PE < 44" 9999 "PE $\geq$ 45";	  
#delimit cr
label val exp_cat exp_cat_lab 
tab exp_cat

* check
by exp_cat, sort: tab exp_neg_val, miss
count if exp_cat == . & exp_neg_val != .
sort cpsidp date

* regression
eststo  clear
local variables = "ibn.exp_cat c.urate#ibn.exp_cat i.geo_fe i.demographic i.date"

eststo: quietly reg d_hired `variables' [w=weight] if sample, noconstant vce(cluster clust_var) cformat(%9.4f)
estadd local samp "All"

eststo: quietly reg d_hired `variables' [w=weight] if sample & (L.empstat>=10 & L.empstat<=12), noconstant vce(cluster clust_var) cformat(%9.4f)
estadd local samp "Employed"

eststo: quietly reg d_hired `variables' [w=weight] if sample & (L.empstat>=21 & L.empstat<=22), noconstant vce(cluster clust_var) cformat(%9.4f)
estadd local samp "Unemployed"

eststo: quietly reg d_hired `variables' [w=weight] if sample & (L.empstat>=32 & L.empstat<=36), noconstant vce(cluster clust_var) cformat(%9.4f)
estadd local samp "NILF"

* stata table
esttab, keep(*.exp_cat#*) se stat(samp r2 N, label("Sample")) nomtitles label varwidth(40) interaction(" X ") 

* latex table
esttab using "$table_path\tableb2.tex", replace keep(*.exp_cat#*) se stat(samp r2 N, label("Sample" "$ R^2 $")) label nomtitles  ///
	   interaction(" $\times$ ") varwidth(40) title("Hiring Over the Business Cycle: Detailed Potential Experience Categories \label{tableB2}") booktabs
	   
drop exp_cat
label drop exp_cat_lab
									
**


* Table 2
eststo  clear
local variables = "i1.exp_group c.urate#i1.exp_group c.urate#i0.exp_group i.geo_fe i.demographic i.date"

eststo: quietly reg d_hired `variables' [w=weight] if sample, vce(cluster clust_var) cformat(%9.4f)
quiet test c.urate#i1.exp_group = c.urate#i0.exp_group
estadd local samp "All"
estadd scalar w = r(F)

eststo: quietly reg d_hired `variables' [w=weight] if sample & (L.empstat>=10 & L.empstat<=12), vce(cluster clust_var) cformat(%9.4f)
quiet test c.urate#i1.exp_group = c.urate#i0.exp_group
estadd local samp "Employed"
estadd scalar w = r(F)

eststo: quietly reg d_hired `variables' [w=weight] if sample & (L.empstat>=21 & L.empstat<=22), vce(cluster clust_var) cformat(%9.4f)
quiet test c.urate#i1.exp_group = c.urate#i0.exp_group
estadd local samp "Unemployed"
estadd scalar w = r(F)

eststo: quietly reg d_hired `variables' [w=weight] if sample & (L.empstat>=32 & L.empstat<=36), vce(cluster clust_var) cformat(%9.4f)
quiet test c.urate#i1.exp_group = c.urate#i0.exp_group
estadd local samp "NILF"
estadd scalar w = r(F)

* Stata table
esttab, keep(*.exp_group*) se stats(samp w r2 N, label("Sample" "Wald test")) ///
		nomtitles label varwidth(35) order(1.exp_group 1.exp_group#c.urate 0.exp_group#c.urate) interaction(" X ")

* latex table
esttab using "$table_path\table2.tex", replace keep(*.exp_group*) se stats(samp w r2 N, label("Sample" "Wald test" "$ R^2 $")) ///
	   nomtitles label varwidth(35) order(1.exp_group 1.exp_group#c.urate 0.exp_group#c.urate) interaction(" $\times$ ") ///
	   title("Hiring over the Business Cycle: Young and Experienced \label{table2}") booktabs
			 		
					
**


* Table 3

* gen dep variables

* employment exit (to all)
gen d_exit = 0 if (L.empstat >= 10 & L.empstat <= 12)
replace d_exit = 100 if (empstat >= 10 & empstat <= 12) & (L.empstat >= 10 & L.empstat <= 12) & empsame == 1
replace d_exit = 100 if (empstat >= 21 & empstat <= 36) & (L.empstat >= 10 & L.empstat <= 12)

* employment transition to unem
gen d_eu = 0 if (L.empstat >= 10 & L.empstat <= 12)
replace d_eu = 100 if (empstat >= 21 & empstat <= 22) & (L.empstat >= 10 & L.empstat <= 12)

* emp to emp
gen d_ee = 0 if (L.empstat >= 10 & L.empstat <= 12)
replace d_ee = 100 if (empstat >= 10 & empstat <= 12) & (L.empstat >= 10 & L.empstat <= 12) & empsame == 1

* emp to nilf
gen d_en = 0 if (L.empstat >= 10 & L.empstat <= 12)
replace d_en = 100 if (empstat >= 32 & empstat <= 36) & (L.empstat >= 10 & L.empstat <= 12)

* nilf to unem
gen d_nu = 0 if (L.empstat >= 32 & L.empstat <= 36)
replace d_nu = 100 if (empstat >= 21 & empstat <= 22) & (L.empstat >= 32 & L.empstat <= 36)

* unem to nilf
gen d_un = 0 if (L.empstat >= 21 & L.empstat <= 22)
replace d_un = 100 if (empstat >= 32 & empstat <= 36) & (L.empstat >= 21 & L.empstat <= 22)

* regressions
eststo  clear

eststo: quiet reg d_exit i1.exp_group c.urate#i1.exp_group c.urate#i0.exp_group i.geo_fe i.demographic i.date if sample, vce(cluster clust_var) cformat(%9.4f)
quiet test c.urate#i1.exp_group = c.urate#i0.exp_group
estadd local samp "Employed"
estadd local dest "All"
estadd scalar w = r(F)

eststo: quiet reg d_eu i1.exp_group c.urate#i1.exp_group c.urate#i0.exp_group i.geo_fe i.demographic i.date if sample, vce(cluster clust_var) cformat(%9.4f)
quiet test c.urate#i1.exp_group = c.urate#i0.exp_group
estadd local samp "Employed"
estadd local dest "Unemp."
estadd scalar w = r(F)

eststo: quiet reg d_ee i1.exp_group c.urate#i1.exp_group c.urate#i0.exp_group i.geo_fe i.demographic i.date if sample, vce(cluster clust_var) cformat(%9.4f)
quiet test c.urate#i1.exp_group = c.urate#i0.exp_group
estadd local samp "Employed"
estadd local dest "Emp."
estadd scalar w = r(F)

eststo: quiet reg d_en i1.exp_group c.urate#i1.exp_group c.urate#i0.exp_group i.geo_fe i.demographic i.date if sample, vce(cluster clust_var) cformat(%9.4f)
quiet test c.urate#i1.exp_group = c.urate#i0.exp_group
estadd local samp "Employed"
estadd local dest "NILF"
estadd scalar w = r(F)

eststo: quiet reg d_nu i1.exp_group c.urate#i1.exp_group c.urate#i0.exp_group i.geo_fe i.demographic i.date if sample, vce(cluster clust_var) cformat(%9.4f)
quiet test c.urate#i1.exp_group = c.urate#i0.exp_group
estadd local samp "NILF"
estadd local dest "Unemp."
estadd scalar w = r(F)

eststo: quiet reg d_un i1.exp_group c.urate#i1.exp_group c.urate#i0.exp_group i.geo_fe i.demographic i.date if sample, vce(cluster clust_var) cformat(%9.4f)
quiet test c.urate#i1.exp_group = c.urate#i0.exp_group
estadd local samp "Unemp."
estadd local dest "NILF"
estadd scalar w = r(F)

* Stata table
esttab, keep(*.exp_group*) se stats(samp dest w r2 N, label("Sample" "Destination" "Wald test")) ///
		nomtitles label varwidth(35) order(1.exp_group 1.exp_group#c.urate 0.exp_group#c.urate) interaction(" X ")

* latex table
esttab using "$table_path\table3.tex", replace keep(*.exp_group*) se stats(samp dest w r2 N, label("Sample" "Destination" "Wald test" "$ R^2 $"))   ///
	   nomtitles label varwidth(35) order(1.exp_group 1.exp_group#c.urate 0.exp_group#c.urate) interaction(" $\times$ ") ///
	   title("Exits and Other Flows \label{table3}") booktabs
	
drop d_exit d_eu d_ee d_en d_nu d_un
	
**

			 
* Table 4

* dep variables
* ivoluntary separation to unemployment
gen d_eu_involuntary = 0 if (L.empstat>=10 & L.empstat<=12)
replace d_eu_involuntary = 100 if (L.empstat>=10 & L.empstat<=12) & (whyunemp >= 1 & whyunemp <= 3)

* voluntary sep. to unemployment
gen d_eu_voluntary = 0 if (L.empstat>=10 & L.empstat<=12)
replace d_eu_voluntary = 100 if (L.empstat>=10 & L.empstat<=12) & (whyunemp == 4)

* regressions
eststo clear
local variables = "i1.exp_group c.urate#i1.exp_group c.urate#i0.exp_group i.geo_fe i.demographic i.date"

eststo: quietly reg d_eu_involuntary `variables' [w=weight] if sample, vce(cluster clust_var) cformat(%9.4f)
quiet test c.urate#i1.exp_group = c.urate#i0.exp_group
estadd scalar w = r(F)

eststo: quietly reg d_eu_voluntary `variables' [w=weight] if sample, vce(cluster clust_var) cformat(%9.4f)
quiet test c.urate#i1.exp_group = c.urate#i0.exp_group
estadd scalar w = r(F)

* Stata table
esttab, keep(*.exp_group*) se stats(w r2 N, label("Wald test")) nomtitles label varwidth(35) ///
		order(1.exp_group 1.exp_group#c.urate 0.exp_group#c.urate) interaction(" X ")
		
* latex table
esttab using "$table_path\table4.tex", replace keep(*.exp_group*) se stats(w r2 N, label("Wald test" "$ R^2 $")) label  ///
		order(1.exp_group 1.exp_group#c.urate 0.exp_group#c.urate) ///
		mtitles("$\Pr(\text{Involuntary}) \times 100$" "$\Pr(\text{Voluntary}) \times 100$" "(3)") interaction(" $\times$ ") ///
		title("Involuntary and Voluntary Separations to Unemployment \label{table4}") booktabs

drop d_eu_involuntary d_eu_voluntary
		
** 

}

**

log close
