set more off 
pause off
set logtype text
set mem 500M

*import excel "C:\Users\ETURCO\Desktop\PhD\Data\COMPUSTAT\compustat.xlsx", sheet("WRDS") firstrow

/// DATA CLEANING ///

* Change variables name

rename GlobalCompanyKey gvkey
rename ActiveInactiveStatusMarker active
rename AssetsTotal at
rename CapitalExpenditures capx
rename CashandShortTermInvestments che
rename CommonSharesOutstanding csho
rename CompanyName nameaco
rename CurrentAssetsOtherTotal aco
rename CurrentAssetsTotal act
rename DataYearFiscal year
rename DebtinCurrentLiabilitiesTo dlc
rename DepreciationandAmortization dpam
rename DepreciationofTangibleFixedA dptk
rename DividendsTotal dt
rename EarningsBeforeInterestandTax ebitda
rename EarningsBeforeInterest ebit
rename IncomeTaxesTotal txt
rename InterestandRelatedExpenseT xint
rename LiabilitiesTotal lt
rename LongTermDebtTotal dltt
rename NonoperatingIncomeExpense nopi
rename OperatingIncomeAfterDepreciat oiadp
rename OperatingIncomeBeforeDeprecia oibdp
rename PurchaseofCommonandPreferred rep
rename PreferredStockRedemptionVal prsk
rename PriceCloseAnnualFiscal prcc_f
rename PropertyPlantandEquipment ppent
rename ResearchandDevelopmentExpense xrd
rename SalesTurnoverNet sa
rename StandardIndustryClassification sic
rename CommonSharesReservedforConve cmrc
rename StockCompensationExpense stce
rename EarningsPerShareBasicExc epsb
rename EarningsPerShareDilutedE epsd
rename ShortTermInvestmentsTotal stinv

rename DataDate datadate
rename IndustryFormat ind_for
rename LevelofConsolidationCompany lcc
rename DataFormat dataformat
rename PopulationSource popso
	
drop CurrentISOCountryCodeHeadq // all US firms
drop ISOCurrencyCode // all var expressed in US dollars
drop datadate ind_for lcc popso dataformat active



/// CREATION PANEL DATA ///

sort gvkey year 
xtset gvkey year


* Firm-level control
* Compute age
bys gvkey : g age = _n
g logage = log(age)

* Compute size
gen size = log(at)

******************************
*** Compute main variables ***
******************************

// Main variables //

* Market valuation
g me = prcc_f * csho
g be = at - lt
g mtb = me/l.be
g mtb2 = (mtb)^2 
g mv = me + at - be
g mv2 = me + dltt + dlc - act
g q = mv/at
g q2 = mv2/at
g q3 = mv/l.at

* Profitability
g nos = oiadp - txt - xint //net income (bottom line)
g roa = nos/l.at // ROA  
g roa2 = ebit/l.at // ROA2 (operating profitability)

g os = oibdp
g os_a = os/at
g os_la = os/l.at
g os_lk = os/l.ppent

* Payout: Stock buybacks, dividend, payout ratio
g repp = rep-prsk
g pay = rep+dt

g rep_a = rep/at
g repp_a = repp/at
g rep_la = rep/l.at
g repp_la = repp/l.at
g rep_os = rep/os
g rep_los = rep/l.os
g rep_sa = rep/sa
g rep_lsa = rep/l.sa

g dt_a = dt/at
g dt_la = dt/l.at
g dt_os = dt/os
g dt_los = dt/l.os

g pay_a = pay/at
g pay_la = pay/l.at
g pay_os = pay/os
g pay_los = pay/l.os
g pay_sa = pay/sa
g pay_lsa = pay/l.sa


* Leverage ratio and Interest expenses
g lev_a = (dltt + dlc)/at
g lev_la = (dltt + dlc)/l.at
g int_a = xint/at
g int_la = xint/l.at
g int_d = xint/(dltt+dlc)

* Cash holdings 
g ca_a = che/at
g ca_la = che/l.at
g nopi_k = nopi/ppent
g nopi_at = nopi/at
g nopi_lat = nopi/l.at


* Investment (capital, R&D)
sort year gvkey
xtset gvkey year

g i_k = capx/ppent
g i_lk = capx/l.ppent
g ni_k = d.ppent/ppent // use the perpetual inventory method to compute the net investment
g i_a = capx/at
g i_la = capx/l.at
 
*g im_k = capx/ppent if ysic_4==1
*g nim_k = d.ppent/ppent if ysic_4==1 // manufactoring firms

g i_los = capx/l.os
g i_lebitda = capx/l.ebitda
g i_sa = capx/sa
g i_lsa = capx/l.sa

* Sales:
g sa_k = sa/ppent
g sa_lk = sa/l.ppent
g sa_a = sa/at
g sa_la = sa/l.at

* Rename label variable
label variable me "Market Value of Equity"
label variable be "Book Value of Equity"
label variable mv "Market Value"
label variable mv2 "Market Value 2"
label variable mtb "Market-to-Book (lagged)"
label variable mtb2 "Market-to-Book (square)"
label variable q "Tobin's q (total assets)"
label variable q2 "Tobin's q2 (total assets)"
label variable q3 "Tobin's q3 (lagged total assets)"

label variable dt_a "Dividend / assets"
label variable dt_os "Dividend/operating surplus"
label variable dt_los "Dividend/(lagged) operating surplus"
label variable dt_la "Dividend / (lagged)assets"

label variable repp "Repurchases - Preferred Stocks"
label variable pay "Repurchases + Total dividend"
label variable rep_a "Repurchases/assets"
label variable rep_sa "Repurchases/ Sales"
label variable rep_lsa "Repurchases/ (lagged)Sales"
label variable rep_os "Repurchases/operating surplus"
label variable rep_los "Repurchases/ (lagged) net income"
label variable repp_a "Repurchases (- Preferred stocks) / Total assets"
label variable rep_la "Repurchases / (lagged)Total assets"
label variable repp_la "Repurchases (- Preferred stocks) / (lagged)Total assets"

label variable pay_a "Payout / assets"
label variable pay_la "Payout / (lagged) assets"
label variable pay_os "Payout/operating surplus"
label variable pay_los "Payout/(lagged) operating surplus"
label variable pay_sa "Payout/Sales"
label variable pay_lsa "Payout/(lagged)Sales"

label variable os "Opeating Surplus (oibdp)" 
label variable nos "Net Income" 
label variable roa "Net Income / (lagged)asset"
label variable roa2 "Ebit / (lagged)asset"
label variable os_a "Opeating Surplus/ total assets" 
label variable os_la "Opeating Surplus/ (lagged)total assets" 
label variable os_lk "Opeating Surplus/ (lagged)capital stock" 

label variable lev_a "Leverage / Total assets"
label variable lev_la "Leverage / (lagged) Total assets"
label variable int_a "Interest Expenses / Total assets"
label variable int_la "Interest Expenses / (lagged)Total assets"
label variable int_d "Interest Expenses / Total debt"

label variable ca_a "Cash holdings / assets"
label variable ca_la "Cash holdings + short-term investment / (lagged) assets"
label variable nopi_k "Non-operating surplus/ Capital stock"
label variable nopi_a "Non-operating surplus/ total assets"
label variable nopi_la "Non-operating surplus/ (lagged) total assets"


label variable i_a "CAPX / total assets"
label variable i_la "CAPX / (lagged)total assets"
label variable i_k "CAPX / PP&E"
label variable i_lk "CAPX / (lagged)PP&E"
label variable ni_k "(Net)CAPX / PP&E"
label variable i_los "CAPX / Net income"
label variable i_lebitda "CAPX / Operation surplus"

label variable i_sa "CAPX / SALES"
label variable i_lsa "CAPX / (lagged)SALES"
label variable sa_k "Sales / capital stock"
label variable sa_lk "Sales / (lagged)capital stock"
label variable sa_a "Sales / total assets"
label variable sa_la "Sales / (lagged) total assets"

label variable age "Age"
label variable logage "(log) Age"
label variable size "Size"

// SIC classification //
gen ysic=0
replace ysic=1 if sic>=100 & sic<=999
replace ysic=2 if sic>=1000 & sic<=1499
replace ysic=3 if sic>=1500 & sic<=1799
replace ysic=4 if sic>=1800 & sic<=1999
replace ysic=5 if sic>=2000 & sic<=3999
replace ysic=6 if sic>=4000 & sic<=4999
replace ysic=7 if sic>=5000 & sic<=5199
replace ysic=8 if sic>=5200 & sic<=5999
replace ysic=9 if sic>=6000 & sic<=6799
replace ysic=10 if sic>=7000 & sic<=8999
replace ysic=11 if sic>=9100 & sic<=9729
replace ysic=12 if sic>=9990 & sic<=9999
replace ysic=. if sic==.
ta ysic

label define lsic 1 "Agriculture, Forestry and Fishing" 2 "Mining" 3 "Construction" ///
4 "not used" 5 "Manufacturing" 6 "Transportation, Communications, Electric, Gas and Sanitary service" ///
7 "Wholesale Trade" 8 "Retail Trade" 9 "Finance, Insurance and Real Estate" ///
10 "Services" 11 "Public Administration" 12 "Nonclassifiable" 
label values ysic lsic
ta ysic, gen(ysic_)
/* NB: labels 4 and 11 are excluded because there are no observations. Accordingly, the order of the generated dummies is remoduled.
For example: the dummy for FIRE is ysic_8, instead of 9.
*/

