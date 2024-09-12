# replication_forsythe_2022_EJ
Data and Stata codes for replication study of "Why Don’t Firms Hire Young Workers During Recessions?" by Eliza Forsythe, The Economic Journal (2022) doi: https://doi.org/10.1093/ej/ueab096.
Report written by Jonathan Créchet, Jing Cui, Barbara Sabada, and Antoine Sawyer as part of the Ottawa Replication Games organized by the Institute for Replication.
Raw data obtained from IPUMS CPS (IPUMS-CPS, University of Minnesota, www.ipums.org).

# Instructions
1. Go to https://doi.org/10.5281/zenodo.8095825 and download the compressed data folder data_replication_forsythe_2022.7z.
2. Download the content of the repository https://github.com/jcrechet/replication_forsythe_2022_EJ.
3. Create a local folder named "Data" in the desired Stata working directory. Uncompress the content of the .7z data file in this folder.
4. Create a folder named "Logfiles" in the same Stata directory.
5. In the Latex directory, create a folder named "Tables" with two subfolders named "2019" and "MSA".
6. Open the Stata do file "0_main.do" and specify the global macro for the user's local Stata directory path and Latex table path.
7. Run the dofile "0_main.do".


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

# References
Forsythe, E.: 2022, Why Don’t Firms Hire Young Workers During Recessions?, The Economic Journal 132(645), 1765–1789.
Flood, S., King, M., Rodgers, R., Ruggles, S., Warren, J. R. and Michael, W.: 2020, Integrated Public Use Microdata Series, Current Population Survey: Version 8.0 [dataset]. Minneapolis, MN: IPUMS. DOI: https://doi.org/10.18128/D030.V8.0.
