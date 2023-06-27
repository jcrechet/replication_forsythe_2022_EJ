* Stata programs for replication of "Why don't firms hire young workers during recessions? by Eliza Forsythe (2021)
* Replicators: J. Créchet, J. Cui, B. Sabada, A. Sawyer
* May 2023


**

* directory paths
if "`c(hostname)'" == "DESKTOP-LBOSF73"  {
global stata_path = "D:\Dropbox\Research\Data\Replication\Forsythe 2021\Replication_games"
global latex_path = "D:\Dropbox\Applications\Overleaf\Forsythe (2021) - Replication"
}

if "`c(hostname)'" == "DESKTOP-OV023AQ"  {
global stata_path = "C:\Users\\`c(username)'\Dropbox\Research\Data\Replication\Forsythe 2021\Replication_games"
global latex_path = "C:\Users\\`c(username)'\Dropbox\Applications\Overleaf\Forsythe (2021) - Replication"
}

if "`c(hostname)'" == "DESKTOP-CJJ"  {
global stata_path = "C:\Users\18814\Dropbox\Forsythe 2021\Replication_games"
global latex_path = "C:\Users\18814\OneDrive\桌面\fun learnings\replication game\Forsythe_2021"
}

* [insert your device name and working directory path here]
cd "$stata_path"

**

* run do files
do Dofiles/0b_laus_data
do Dofiles/1_data_preparation
do Dofiles/2_hiring
do Dofiles/3_composition_labor_supply

* do Dofiles/4_wages 
