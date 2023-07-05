clear all

cd "C:\Users\feder\OneDrive\Documenti Fede\Scuola\Università\MSc in Economics\Research Assistantship\R Codes\RA-Codes"

use compustat.dta

keep gvkey datadate fyear sale naicsh naics sic at conm emp
destring gvkey, replace


* Creat the panel

sort gvkey fyear


// Keep one duplicate if observations have the same value for total assets (these are most duplicates). For remaining duplicates, keep the one that is more recent
sort fyear gvkey
drop if gvkey[_n-1] == gvkey[_n] & fyear[_n-1] == fyear[_n] & at[_n-1] == at[_n]
duplicates drop fyear gvkey, force
* some duplicates found

xtset gvkey fyear

gen sector = ""
replace sector = "Agriculture, Forestry, Fishing and Hunting" if substr(naics, 1, 2) == "11"
replace sector = "Mining, Quarrying, and Oil and Gas Extraction" if substr(naics, 1, 2) == "21"
replace sector = "Utilities" if substr(naics, 1, 2) == "22"
replace sector = "Construction" if substr(naics, 1, 2) == "23"
replace sector = "Manufacturing" if substr(naics, 1, 2) == "31" | substr(naics, 1, 2) == "32" | substr(naics, 1, 2) == "33"
replace sector = "Wholesale Trade" if substr(naics, 1, 2) == "42"
replace sector = "Retail Trade" if substr(naics, 1, 2) == "44" | substr(naics, 1, 2) == "45"
replace sector = "Transportation and Warehousing" if substr(naics, 1, 2) == "48" | substr(naics, 1, 2) == "49"
replace sector = "Information" if substr(naics, 1, 2) == "51"
replace sector = "Finance and Insurance" if substr(naics, 1, 2) == "52"
replace sector = "Real Estate and Rental and Leasing" if substr(naics, 1, 2) == "53"
replace sector = "Professional, Scientific, and Technical Services" if substr(naics, 1, 2) == "54"
replace sector = "Management of Companies and Enterprises" if substr(naics, 1, 2) == "55"
replace sector = "Administrative and Support and Waste Management and Remediation Services" if substr(naics, 1, 2) == "56"
replace sector = "Educational Services" if substr(naics, 1, 2) == "61"
replace sector = "Health Care and Social Assistance" if substr(naics, 1, 2) == "62"
replace sector = "Arts, Entertainment, and Recreation" if substr(naics, 1, 2) == "71"
replace sector = "Accommodation and Food Services" if substr(naics, 1, 2) == "72"
replace sector = "Other Services (except Public Administration)" if substr(naics, 1, 2) == "81"
replace sector = "Public Administration" if substr(naics, 1, 2) == "92"

table sector

* drop public administration since it has only 1 observation

drop if sector == "Public Administration"

* CHECK IF MISSING VALUES ARE FROM SAME FIRMS OR ONLY IN SOME YEARS

// Check if observations with missing naics are from the same firms based on gvkey
duplicates report gvkey if missing(naics)


* distribution of missing naics across different gvkeys
by gvkey: egen naics_missing_count = total(missing(naics))
tabulate naics_missing_count, gen(freq)
histogram naics_missing_count  if naics_missing_count > 0, discrete 
graph export "histmissingnaics.png", as(png) replace


* distribution of missing naics/duration across different gvkeys
by gvkey: egen duration = count(gvkey)
histogram duration
graph export "histduration.png", as(png) replace
histogram duration if naics_missing_count > 0, color(red)
graph export "histdurationofmissingnaics.png", as(png) replace
twoway (histogram duration if naics_missing_count > 0,  color(red) ) ///
       (histogram duration if naics_missing_count == 0, color(blue) )
graph export "hist_duration_comparison.png", as(png) replace

twoway (histogram sale if naics_missing_count > 0 & sale!=0,  color(red) width(1000)) ///
       (histogram sale if naics_missing_count == 0 & sale!=0, color(blue) width(1000) )
graph export "hist_sales_comparison.png", as(png) replace




gen naicsprop = naics_missing_count/duration
tabulate naicsprop
histogram naicsprop  if naicsprop > 0 
graph export "histpropmissingnaics.png", as(png) replace







drop if missing(naics) & missing(naicsh)




// drop if missing(sale)
// drop if missing(emp)



*egen naics3 = group(substr(naics, 1, 3))

gen naics1 = substr(naics, 1, 1)
drop if length(naics1) < 1


gen naics2 = substr(naics, 1, 2)
drop if length(naics2) < 2

gen naics3 = substr(naics, 1, 3)
drop if length(naics3) < 3

gen naics4 = substr(naics, 1, 4)

// Since emp has lots of missing values and since employment is usually stable year
// over year, we try to give missing values the same value they had in the previous period

// Generate a new variable "emp_new" and initialize it with the same values as "emp"
gen emp_new = emp

// Loop over the dataset by gvkey
by gvkey: replace emp_new = emp_new[_n-1] if missing(emp_new) & !missing(emp_new[_n-1])

by gvkey: replace emp_new = emp_new[_n+1] if missing(emp_new) & !missing(emp_new[_n+1])

replace emp_new = 0 if emp_new==.

// Drop the original "emp" variable
drop emp

// Rename "emp_new" as "emp"
rename emp_new emp

// The same but for sales

// Generate a new variable "sale_new" and initialize it with the same values as "sale"
gen sale_new = sale

// Loop over the dataset by gvkey
by gvkey: replace sale_new = sale_new[_n-1] if missing(sale_new) & !missing(sale_new[_n-1])

by gvkey: replace sale_new = sale_new[_n+1] if missing(sale_new) & !missing(sale_new[_n+1])

replace sale_new = 0 if sale_new==.

// Drop the original "emp" variable
drop sale

// Rename "emp_new" as "emp"
rename sale_new sale




keep gvkey datadate fyear conm sale naics sector duration sic emp naics1 naics2 naics3 naics4





save "leancompustat.dta", replace