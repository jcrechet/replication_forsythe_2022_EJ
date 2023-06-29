* Stata programs for replication of "Why don't firms hire young workers during recessions? by Eliza Forsythe (2021)
* Replicators: J. Créchet, J. Cui, B. Sabada, A. Sawyer
* May 2023, last updated June 2023


**

* directory paths
* [insert your device name and working directory paths here]
if "`c(hostname)'" == " "  {
global stata_path = " "  //Stata directory
global latex_path = " "  //Path to Latex tables 
}

cd "$stata_path"

**

* run do files
do Dofiles/0b_laus_data
do Dofiles/1_data_preparation
do Dofiles/2_hiring
do Dofiles/3_composition_labor_supply
do Dofiles/4_wages 
