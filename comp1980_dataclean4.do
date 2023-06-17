***********************
*** Data cleaning 2 *** 
***********************
* More precise data cleaning: drop missing only for dep vars

sort year gvkey

*xtdescribe

* To explore data 
*bysort year: sum rep capx os 

// Keep one duplicate if observations have the same value for total assets (these are most duplicates). For remaining duplicates, keep the one that is more recent
sort year gvkey
drop if gvkey[_n-1] == gvkey[_n] & year[_n-1] == year[_n] & at[_n-1] == at[_n]
duplicates drop year gvkey, force
* No duiplicates found


// Firms constraints //
*Drop financial companies and utilites //
drop if ysic_8==1 // sic>=6000 & sic<=6999
drop if ysic_5==1 // sic>=4000 & sic<=4999
ta ysic 


// MISSING VALUES // 

* Drop missing values of selected variables
* Dependend variable
drop if missing(rep_la)
drop if missing(repp_la)
drop if missing(i_la)
drop if missing(i_lk)

* MISSING RANDOMLY. Check in data. E.g. small and large companies.

* Drop firms with persistent negative profits
bys gvkey: egen av_profit = mean(os)
drop if av_profit<0

* Further restrictions: delete negative values  
drop if at<5
drop if rep<0
drop if repp<0
drop if dt<0
drop if capx<0
drop if mtb<0
drop if be<0 
drop if che<0
drop if  sa<0

* CHECK THE PERCENTAGE
* IMPUTATION. If u have missing values, linear model and put missing. 


*** Check ***
/*count if missing(rep_la)
count if missing(i_la) 

count if rep_la==0 /*w/o f&u, 35,409*/
count if rep_la<0
count if rep<0 /* 23 cases of repurches<0*/
count if rep>0 /*30,616 obs*/
*/

// TIME CONSTRAINTS //

*** Keep firms with at least 4 years of life - THIS HAS TO BE DONE AT THE END AFTER ALL THE THE CORRECTIONS ***
sort gvkey year
by gvkey: egen num_years = count(year)
drop if num_years <= 3 // 526

* Possible selection bias. Check how often it happens

// OUTLIERS //
* First look at the variables' distribution
/*
hist capx, normal
hist i_k, normal
hist i_lk, normal
hist i_a, normal
hist i_la, normal

hist rep, normal
hist rep_a, normal
hist repp_a, normal
hist rep_la, normal
hist repp_la, normal
hist rep_la if rep_la>0.01, normal

hist dt_a, normal
hist dt_la, normal

hist pay_a, normal
hist pay_la, normal

hist q, normal 
hist q3, normal 
hist mtb, normal
hist mtb_l, normal

hist os_a, normal
hist os_la, normal
hist os_k, normal
hist os_lk, normal
hist roa, normal
hist roa2, normal
hist roa_l, normal

hist lev_a, normal
hist lev_la, normal

hist ca_a, normal
hist ca_la, normal
hist nopi_a, normal
hist nopi_la, normal

hist sa_a, normal
hist sa_la, normal
hist sa_k, normal
hist sa_lk, normal

hist inat_a, normal
hist inat_la, normal
hist xrd_a, normal
hist xrd_la, normal
hist xrd_k, normal
hist xrd_lk, normal

hist os, normal
hist os_a, normal
hist os_la, normal
hist os_k, normal
hist os_lk, normal
hist roa, normal
hist roa_l, normal
hist roa2, normal

hist ca_a, normal
hist ca_la, normal
hist xrd_a, normal
hist inta_a, normal
hist inta_la, normal
hist acq_a, normal
hist acq_la, normal
hist mabt_a, normal
hist mabt_la, normal
hist maat_a, normal
hist maat_la, normal

*/

* e.g. everything large than 3 is 3.

* Winsorize
winsor2 i_k, cut(0 98) replace
winsor2 i_lk, cut(0 98) replace
winsor2 i_a, cut(0 98) replace
winsor2 i_la, cut(0 98) replace

winsor2 rep_a, cuts(0 98) replace
winsor2 repp_a, cuts(0 98) replace
winsor2 rep_la, cuts(0 98) replace
winsor2 repp_la, cuts(0 98) replace

winsor2 i_os, cuts(1 99) replace
winsor2 i_los, cuts(1 99) replace
winsor2 rep_os, cuts(1 99) replace
winsor2 rep_los, cuts(1 99) replace

winsor2 dt_a, cuts(0 98) replace
winsor2 dt_la, cuts(0 98) replace
winsor2 dt_os, cuts(1 99) replace
winsor2 dt_los, cuts(1 99) replace

winsor2 pay_a, cuts(0 98) replace
winsor2 pay_la, cuts(0 98) replace
winsor2 pay_os, cuts(1 99) replace
winsor2 pay_los, cuts(1 99) replace

winsor2 mtb, cuts(0 97) replace
winsor2 mtb_l, cuts(1 99) replace
winsor2 mtb2, cuts(0 95) replace
winsor2 q, cuts(0 97) replace
winsor2 q3, cuts(0 97) replace

winsor2 os_a, cuts(1 99) replace
winsor2 os_la, cuts(1 99) replace
winsor2 os_k, cuts(1 98) replace
winsor2 os_lk, cuts(1 98) replace
winsor2 roa, cuts(1 99) replace
winsor2 roa_l, cuts(1 99) replace
winsor2 roa2, cuts(1 99) replace

winsor2 lev_a, cuts(2 98) replace
winsor2 lev_la, cuts(2 98) replace
winsor2 int_a, cuts(1 99) replace
winsor2 int_la, cuts(1 99) replace
winsor2 int_d, cuts(1 99) replace

winsor2 ca_a, cuts (1 99) replace
winsor2 ca_la, cuts (1 99) replace
winsor2 nopi_k, cuts (1 99) replace
winsor2 nopi_a, cuts (1 99) replace
winsor2 nopi_la, cuts (1 99) replace

winsor2 sa_a, cuts (1 99) replace
winsor2 sa_la, cuts (1 99) replace
winsor2 sa_k, cuts (1 98) replace
winsor2 sa_lk, cuts (1 98) replace

winsor2 inta_a, cut(0 98) replace
winsor2 inta_la, cut(0 98) replace
winsor2 acq_a, cut(0 98) replace
winsor2 acq_la, cut(0 98) replace
winsor2 mabt_a, cut(0 99) replace
winsor2 mabt_la, cut(0 99) replace
winsor2 maat_a, cut(0 99) replace
winsor2 maat_la, cut(0 99) replace

winsor2 xrd_a, cuts (0 98) replace
winsor2 xrd_la, cuts (0 98) replace
winsor2 xrd_k, cuts (2 98) replace
winsor2 xrd_lk, cuts (2 98) replace

winsor2 rep_lk, cut(0 99) replace

winsor2 rep_ts, cut(0 99) replace

winsor2 lev_lk, cut(0 99) replace

winsor2 lev_be, cut(0 99) replace

winsor2 nopi_lk, cut(1 99) replace

* RUN ESTIMATION WITH ROW DATA, NOT CLEANING APART FROM MISSING 
