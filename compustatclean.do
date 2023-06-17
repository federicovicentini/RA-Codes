clear all

cd "C:\Users\feder\OneDrive\Documenti Fede\Scuola\Università\MSc in Economics\Research Assistantship\R Codes\RA-Codes"

use compustat.dta

keep gvkey datadate fyear sale naicsh naics at conm
destring gvkey, replace


* Creat the panel

sort gvkey fyear


// Keep one duplicate if observations have the same value for total assets (these are most duplicates). For remaining duplicates, keep the one that is more recent
sort fyear gvkey
drop if gvkey[_n-1] == gvkey[_n] & fyear[_n-1] == fyear[_n] & at[_n-1] == at[_n]
duplicates drop fyear gvkey, force
* No duiplicates found

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

* drop if there is no naics  and no naicsh value, or no sales

* CHECK IF MISSING VALUES ARE FROM SAME FIRMS OR ONLY IN SOME YEARS

drop if missing(naics) & missing(naicsh)
drop if missing(sale)

*egen naics3 = group(substr(naics, 1, 3))

gen naics3 = substr(naics, 1, 3)
drop if length(naics3) < 3








save "leancompustat.dta", replace