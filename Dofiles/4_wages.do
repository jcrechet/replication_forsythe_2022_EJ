* Stata programs for replication of "Why don't firms hire young workers during recessions? by Eliza Forsythe (2021)
* Replicators: J. Créchet, J. Cui, B. Sabada, A. Sawyer
* May 2023

**

* Program: 4_wages, last edited Jun 25th, 2023
* Description: replication of table 10.


**

* log
capture log close
log using Logfiles/4_wages, text replace 

* data
use Data/final_dataset, clear

* latex path for tables
global table_path = "$latex_path\Tables"

* options for regressions
set matsize 10000
set emptycells drop

* command to update/install estout package if needed
* ssc install estout, replace

**

* log wage for eligible/non allocated/in universe
* sample 
gen n = ( empstat >= 10 & empstat <= 12  ///
		  & earnweek_cpiu_2010 > 0 & earnweek_cpiu_2010 < 9999 & eligorg==1 & qearnwee==0 )	  
gen ln_w = ln( earnweek_cpiu_2010 ) if n


**

* Regressions

**

* Table 10, panel A
local fe = "i.demographic i.date i.state i.occ1990 i.ind1990"

eststo clear 

* col (1) - all
eststo: qui reg ln_w urate `fe' if sample & d_hired==100 [w=weights], vce(cl state) cformat(%9.4f) //all 
estadd local samp "All"
	
* col (2) - employed
eststo: qui reg ln_w urate `fe' if sample & d_hired==100 & (L.empstat>=10 & L.empstat<=12) [w=weights], vce(cl state) cformat(%9.4f) //from employed 
estadd local samp "Employed"

* col (3) - unemployed
eststo: qui reg ln_w urate `fe' if sample & d_hired==100 & (L.empstat>=21 & L.empstat<=22) [w=weights], vce(cl state) cformat(%9.4f) //from unemployed 
estadd local samp "Unemployed"

* col (4) - nilf
eststo: qui reg ln_w urate `fe' if sample & d_hired==100 & (L.empstat>=32 & L.empstat<=36) [w=weights], vce(cl state) cformat(%9.4f) //from NILF 
estadd local samp "NILF"

* Stata table
esttab, keep(urate) se r2 label nomtitles varwidth(35) 

* latex table
esttab using "$table_path\table10a.tex", keep(urate) se stats(samp r2 N, label("Sample" "$ R^2 $")) label nomtitles varwidth(35) replace ///
booktabs title("Log Wages During Recessions for New Hires - Aggregated hires \label{table10a}") 


**

* Table 10, panel B
eststo  clear
local variables = "i1.exp_group c.urate#i1.exp_group c.urate#i0.exp_group"
local fe = "i.demographic i.date i.state i.occ1990 i.ind1990"

* col (1)
eststo: qui reg ln_w `variables' `fe' if sample & d_hired==100 [w=weight], vce(cl state) cformat(%9.4f)
quiet test c.urate#i1.exp_group = c.urate#i0.exp_group
estadd local samp "All"
estadd scalar w = r(F)

* col (2)
eststo: qui reg ln_w `variables' `fe' if sample & d_hired==100 & (L.empstat>=10 & L.empstat<=12) [w=weights], vce(cl state) cformat(%9.4f)
quiet test c.urate#i1.exp_group = c.urate#i0.exp_group
estadd local samp "Employed"
estadd scalar w = r(F)

* col (3)
eststo: qui reg ln_w `variables' `fe' if sample & d_hired==100 & (L.empstat>=21 & L.empstat<=22) [w=weights], vce(cl state) cformat(%9.4f)
quiet test c.urate#i1.exp_group = c.urate#i0.exp_group
estadd local samp "Unemployed"
estadd scalar w = r(F)

* col (4)
eststo: qui reg ln_w `variables' `fe' if sample & d_hired==100 & (L.empstat>=32 & L.empstat<=36) [w=weights], vce(cl state) cformat(%9.4f)
quiet test c.urate#i1.exp_group = c.urate#i0.exp_group
estadd local samp "NILF"
estadd scalar w = r(F)

* Stata table
esttab, keep(*.exp_group*) se stats(samp w r2 N, label("Sample" "Wald test")) ///
		nomtitles label varwidth(35) order(1.exp_group 1.exp_group#c.urate 0.exp_group#c.urate) interaction(" X ")

* latex table
esttab using "$table_path\table10b.tex", replace keep(*.exp_group*) se stats(samp w r2 N, label("Sample" "Wald test" "$ R^2 $")) ///
	   nomtitles label varwidth(35) order(1.exp_group 1.exp_group#c.urate 0.exp_group#c.urate) interaction(" $\times$ ") ///
	   title("Hiring over the Business Cycle: Young and Experienced \label{table10b}") booktabs
										
**

log close
