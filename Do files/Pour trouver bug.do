
*cd "C:\Users\Packabell\Documents\Courses\JIE\Stata"

if "`c(username)'"=="guillaumedaudin" cd "~/Documents/Recherche/Coûts du commerce - ancien ENSAE/Stata"

use tbtbtc, replace

egen test = min(exp2), by(ctry2 year)

tab year if test !=exp2
tab ctry1 if test !=exp2
tab ctry2  if test !=exp2

*assert blif==exp2

preserve
collapse (sum) trade21, by(ctry2 year)
rename ctry2 ctry
save blif, replace

restore
collapse (sum) trade12, by(ctry1 year)
rename ctry1 ctry

merge 1:1 year ctry using blif.dta
erase blif.dta
drop _merge

sort year ctry


replace trade21=0 if trade21==.
replace trade12=0 if trade12==.

generate exp=trade21 + trade12 



preserve
rename ctry ctry1
merge 1:m year ctry1 using tbtbtc.dta, keep(3)
rename exp exp1b
drop _merge

save tbtbtc_corr_essai.dta, replace

restore
rename ctry ctry2
merge 1:m year ctry2 using tbtbtc_corr_essai.dta, keep(3)
rename exp exp2b
drop _merge

save tbtbtc_corr_essai.dta, replace

*order ctry1 exp1 exp1b ctry2 exp2 exp2b 

sort  year ctry1 ctry2

br year ctry1 exp1 exp1b ctry2 exp2 exp2b 

***Cela montre que leurs chiffres d'exportation ne sont pas la somme des exportations bilatérales ??
***Correction plus simple...


use tbtbtc, replace

gen tau_1_2_ori = ((gdp1-exp1)*(gdp2-exp2)*1000000^2/(trade12*trade21))^(1/(2*(8-1)))-1
twoway (scatter tc8 tau_1_2)



egen test = max(exp2), by(ctry2 year)
replace exp2=test

drop test

egen test = max(exp1), by(ctry1 year)
replace exp1=test

drop test

save tbtbtc_corr.dta, replace

gen tau_1_2 = ((gdp1-exp1)*(gdp2-exp2)*1000000^2/(trade12*trade21))^(1/(2*(8-1)))-1
twoway (scatter tc8 tau_1_2)
replace tc8=tau_1_2

save tbtbtc_corr.dta, replace








