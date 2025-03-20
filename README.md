# replication_forsythe_2022_EJ
Data and Stata codes for replication study of "Why Don’t Firms Hire Young Workers During Recessions?" by Eliza Forsythe, The Economic Journal (2022) doi: https://doi.org/10.1093/ej/ueab096.

Report written by Jonathan Créchet (University of Ottawa), Jing Cui (University of Ottawa), Barbara Sabada (Bank of Canada), and Antoine Sawyer (Queen's University) as part of the 2022 Ottawa Replication Games organized by the Institute for Replication.

Raw data obtained from IPUMS CPS (University of Minnesota, www.ipums.org;  Flood et al (2020)).

# Instructions
1. Go to https://doi.org/10.5281/zenodo.8095825 and download the compressed data folder data_replication_forsythe_2022.7z.
3. Download the content of the repository https://github.com/jcrechet/replication_forsythe_2022_EJ.
4. Create a local folder named "Data" in the desired Stata working directory. Uncompress the content of the .7z data file in this folder.
5. Create a folder named "Logfiles" in the same Stata directory.
6. Create a folder named "Latex"
7. In the Latex directory, create a folder named "Tables" with three subfolders named "2019", "MSA", and "original".
8. Open the Stata do file "0_main.do" and specify the global macro for the user's local Stata directory path and Latex table path.
9. Run the dofile "0_main.do".


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

# System specs and time requirements 



Original study (see Read me file available at https://zenodo.org/records/5710784)

Main file: yh_data.csv (2.1 GB, 1 GB after conversion to .dta)

Total data files: 2.02 GB

Software: Stata 14.2

Packages: parmest (SJ10-4 st0043_2) esttab (SJ14-2: st0085_2))

Estimated Processing Time: (on shared 16 core UNIX server with 396 GB RAM)

YH_fileconversion.do [4 minutes]

YH_data_init [16.6 minutes]

YH_regs.do [91 minutes]

YH_appendix_tables [52 minutes]

YH_appendix_figure.do [1 second]


