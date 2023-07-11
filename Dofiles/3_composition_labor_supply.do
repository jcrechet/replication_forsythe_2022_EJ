* Stata programs for replication of "Why don't firms hire young workers during recessions? by Eliza Forsythe (2021)
* Replicators: J. Créchet, J. Cui, B. Sabada, A. Sawyer
* May 2023, updated June 2023

**

* program: 3_composition_labor_supply
* replicate tables 5 and 6 (section3)


**

* log
capture log close
log using Logfiles/3_composition_labor_supply, text replace

* options for regressions with fixed effects
set matsize 2000
set emptycells drop

**

* tables 5 and 6
use Data/final_dataset, clear

** 

* latex path for tables
global table_path = "$latex_path\Tables"

**

* Table 5
eststo  clear
eststo: qui reg exp urate i.state i.date i.demographic if sample & d_hired==100 [w=weights], vce(cl state) cformat(%9.4f)
eststo: qui reg exp urate i.state i.date i.demographic i.occ1990 i.ind1990 if sample & d_hired==100 [w=weights], vce(cl state) cformat(%9.4f)

* stata table
esttab, keep(urate) p stats(r2 N) label varwidth(35) nonumbers nomtitles ///
indicate("Occupation fixed effects = *.occ1990" "Industry fixed effects = *.ind1990")
	
* latex table
esttab using "$table_path\table5.tex", keep(urate) p stats(r2 N, label("$ R^2 $")) label varwidth(35) nonumbers nomtitles ///
indicate("Occupation fixed effects = *.occ1990" "Industry fixed effects = *.ind1990") replace /// 
booktabs title("Average Potential Experience of Hires \label{table5}") 

**

* Table 6 

* Panel A: all individuals
eststo  clear
eststo: qui reg exp urate i.state i.date i.demographic [w=weights] if sample, vce(cluster state) cformat(%9.4f)
eststo: qui reg exp urate i.state i.date i.demographic [w=weights] if sample & (L.empstat>=10 & L.empstat<=12), vce(cluster state) cformat(%9.4f)
eststo: qui reg exp urate i.state i.date i.demographic [w=weights] if sample & (L.empstat>=21 & L.empstat<=22), vce(cluster state) cformat(%9.4f)
eststo: qui reg exp urate i.state i.date i.demographic [w=weights] if sample & (L.empstat>=32 & L.empstat<=36), vce(cluster state) cformat(%9.4f)

* stata table 
di "table 6 panel A"
esttab, keep(urate) p r2 label nonumbers nomtitles

* latex table
esttab  using "$table_path\table6a.tex", keep(urate) p stats(r2 N, label("$ R^2 $")) label varwidth(35) nonumbers nomtitles replace /// 
booktabs title("Potential Experience within Cells (all) \label{table6a}") 

* Panel B: new hires
eststo  clear
eststo: qui reg exp urate i.state i.date i.demographic [w=weights] if sample & d_hired==100, vce(cluster state) cformat(%9.4f)
eststo: qui reg exp urate i.state i.date i.demographic [w=weights] if sample & d_hired==100 & (L.empstat>=10 & L.empstat<=12), vce(cluster state) cformat(%9.4f)
eststo: qui reg exp urate i.state i.date i.demographic [w=weights] if sample & d_hired==100 & (L.empstat>=21 & L.empstat<=22), vce(cluster state) cformat(%9.4f)
eststo: qui reg exp urate i.state i.date i.demographic [w=weights] if sample & d_hired==100 & (L.empstat>=32 & L.empstat<=36), vce(cluster state) cformat(%9.4f)

* Stata table
di "table 6 panel B"
esttab, keep(urate) p r2 label nonumbers nomtitles

* latex table
esttab  using "$table_path\table6b.tex", keep(urate) p stats(r2 N, label("$ R^2 $")) label varwidth(35) nonumbers nomtitles replace /// 
booktabs title("Potential Experience within Cells (new hires) \label{table6b}")

**

* Panel C: Ratio
* two differences with original paper: (1) experience variables (zero imputed to negative values) 
* (2) no sample restrictions based on number of hires in all three categories.

* dummies for exp conditional on hiring
gen exp_hired_all 	= exp if d_hired == 100 // all
gen exp_hired_emp 	= exp if d_hired == 100 & (L.empstat>=10 & L.empstat<=12) // employed
gen exp_hired_unemp = exp if d_hired == 100 & (L.empstat>=21 & L.empstat<=22) // unemployed
gen exp_hired_nilf  = exp if d_hired == 100 & (L.empstat>=32 & L.empstat<=36) // nilf

* collapse to get average experience by cells
collapse exp* urate [w=weights] if sample, by(date state)
gen ratio_all 	= exp_hired_all / exp
gen ratio_emp 	= exp_hired_emp / exp
gen ratio_unemp = exp_hired_unemp / exp
gen ratio_nilf  = exp_hired_nilf / exp

* labels
label var ratio_all
label var urate "U.\ rate"

* regressions
eststo  clear
eststo: qui reg ratio_all urate i.state i.date, vce(cluster state) cformat(%9.4f)
eststo: qui reg ratio_emp urate i.state i.date, vce(cluster state) cformat(%9.4f)
eststo: qui reg ratio_unemp urate i.state i.date, vce(cluster state) cformat(%9.4f)
eststo: qui reg ratio_nilf  urate i.state i.date, vce(cluster state) cformat(%9.4f)

* stata table 
di "table 6 panel C"
esttab, keep(urate) p r2 label nonumbers nomtitles

* latex table
esttab  using "$table_path\table6c.tex", keep(urate) p stats(r2 N, label("$ R^2 $")) label varwidth(35) nonumbers nomtitles replace /// 
booktabs title("Potential Experience within Cells (ratio) \label{table6c}")

**

log close
