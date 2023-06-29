# replication_forsythe_2022_EJ
Data and Stata codes for replication report for "Why firms don't hire young workers in recession" by Eliza Forsythe, Economic Journal (2022) doi: https://doi.org/10.1093/ej/ueab096.

Report written by Jonathan Créchet, Jing Cui, Barbara Sabada, and Antoine Sawyer as part of the Ottawa replication games organized by the Institute for Replication.

Raw data obtained from IPUMS CPS (IPUMS-CPS, University of Minnesota, www.ipums.org).

# Instructions:
1. Go to https://doi.org/10.5281/zenodo.8095825 and download the compressed data folder data_replication_forsythe_2022.7z.
2. Download the content of the repository https://github.com/jcrechet/replication_forsythe_2022_EJ.
3. Create a local folder named "Data" in the Stata working directory. Uncompress the content of the .7z data file in this folder.
4. Open the Stata do file "0_main.do" and specify the macro for the local Stata directory path and Latex table path.
5. Run the dofile "0_main.do".

# Data file content
1. IPUMS_CPS/fipcode_cps and IPUMS_CPS/msa_code_cps: State and MSA fips
2. LAUS folder: BLS local area unemployment statistics data retrieved from https://download.bls.gov/pub/time.series/la
3. cps_00038: CPS micro data IPUMS extract

# Do-file description
0. 0b_laus_data.do: prepare LAUS data for merging with CPS micro data
1. 1_data_preparation.do: prepare dataset for regression analysis
2. 2_hiring.do: replicate results in section 2 (direct replication and robustness analysis)
3. 3_composition_labor_supply.do: replicate Tables 5 and 6 in section 3
4. 4_wages.do: replicate Table 10.
