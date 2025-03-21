# replication_forsythe_2022_EJ
Data and Stata codes for replication study of "Why Don’t Firms Hire Young Workers During Recessions?" by Eliza Forsythe, The Economic Journal (2022) doi: https://doi.org/10.1093/ej/ueab096.

Report written by Jonathan Créchet (University of Ottawa), Jing Cui (University of Ottawa), Barbara Sabada (Bank of Canada), and Antoine Sawyer (Queen's University) as part of the 2022 Ottawa Replication Games organized by the Institute for Replication.

Raw data obtained from IPUMS CPS (University of Minnesota, www.ipums.org;  Flood et al (2020)) and from original author's Zenodo repository at https://zenodo.org/records/5710784.

# Instructions
1. Go to https://doi.org/10.5281/zenodo.8095825 and download the compressed data folder 'data_replication_forsythe_2022.7z'.  
2. Download the content of the repository https://github.com/jcrechet/replication_forsythe_2022_EJ.
3. Create a local folder named "Data" in the desired Stata working directory. Uncompress the content of 'data_replication_forsythe_2022.7z' in this folder.
4. Create folders named "Logfiles", "Graphs", and "Tables" in the Stata directory. Create three subfolders: "Tables/2019", "Tables/MSA", and "Tables/original".
5. Open the Stata do file "0_main.do" and specify the global macro for the user's local Stata directory path.
6. Run the dofile "0_main.do".

# Data file content
1. IPUMS_CPS/fipcode_cps and IPUMS_CPS/msa_code_cps: State and MSA fips
2. LAUS folder: BLS local area unemployment statistics data retrieved from https://download.bls.gov/pub/time.series/la
3. cps_00038: CPS micro data IPUMS extract
4. original/v2unemp_smy and original/yh_data: original author's data (state unemployment rates and CPS micro-data). 

# Do-file description
0. 0b_laus_data.do: prepare LAUS data for merging with CPS micro data
1. 1_data_preparation.do: prepare dataset for regression analysis
2. 1b_original_data_prep: prepare dataset for regression analysis using data provided by the original author
3. 2_hiring.do: replicate results in section 2 (direct replication and robustness analysis)
4. 2b_hiring_figure: replicate Figure 2 
5. 3_composition_labor_supply.do: replicate Tables 5 and 6 in section 3
6. 4_wages.do: replicate Table 10.

# References
Forsythe, E.: 2022, Why Don’t Firms Hire Young Workers During Recessions?, The Economic Journal 132(645), 1765–1789.
Flood, S., King, M., Rodgers, R., Ruggles, S., Warren, J. R. and Michael, W.: 2020, Integrated Public Use Microdata Series, Current Population Survey: Version 8.0 [dataset]. Minneapolis, MN: IPUMS. DOI: https://doi.org/10.18128/D030.V8.0.

# System specs and time requirements 

## Replication study

Specs:  Windows 11 Pro, 8-core Intel Core i7-11800H CPU, and 32 GB RAM

Software: StataMP18 (64-bit)

Packages: esttab (SJ14-2: st0085_2))

Estimated Processing Time: 

0b_laus_data.do [3 sec]

1_data_preparation.do [6 min]

1b_original_data_prep [7 min]

2_hiring.do [step 1: 50 min; step 2: 73 min; step 3: 98 min; 85 min]

2b_hiring_figure [26 min]

3_composition_labor_supply [14 min]

4_wages.do [4 min]

Full workflow [364 minutes]

## Original study
From Read me file available at https://zenodo.org/records/5710784).

Specs: shared 16 core UNIX server with 396 GB RAM

Software: Stata 14.2

Packages: parmest (SJ10-4 st0043_2) esttab (SJ14-2: st0085_2))

Estimated Processing Time: 

YH_fileconversion.do [4 minutes]

YH_data_init [16.6 minutes]

YH_regs.do [91 minutes]

YH_appendix_tables [52 minutes]

YH_appendix_figure.do [1 second]


