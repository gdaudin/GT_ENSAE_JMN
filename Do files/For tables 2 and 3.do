if "`c(username)'"=="guillaumedaudin" cd "~/Documents/Recherche/Coûts du commerce - ancien ENSAE/Stata"


foreach year of num 1913 2000 {

use "JMN-`year'.dta", replace
append using "table-their-method-by-country-`year'.dta"
append using "table-our-method-`year'.dta"

label var dlnterm1 "Contribution of growth in output"
label var dlnterm2 "Contribution of growth in income similarity"
label var dlnterm3 "Contribution of change in trade cost measure"
label var dlnterm4 "Contribution of change in multilateral factors"
label var dlnleftterm "Average growth of bilateral trade flows"

local nbr_obs = _N+4
set obs `nbr_obs'
gen line_nbr=_n

replace method="JMN 2011" if line_nbr== _N-3
replace method="JMN by country, unweighted" if line_nbr== _N-2
replace method="JMN by country, GDP-weighted" if line_nbr== _N-1
replace method="Our method" if line_nbr== _N

gen forsort=ctry1
replace forsort ="zAverage" if ctry1=="Average"
replace forsort = "zzGDP-weighted average" if ctry1=="GDP-weighted average"
replace forsort ="zUnweighted" if ctry1 == "Unweighted"

gen forsort2=method
replace forsort2="JMN by country, zGDP-weighted" if method=="JMN by country, GDP-weighted"

sort forsort2 forsort
replace ctry1=method if ctry1==""
drop forsort forsort2 method line_nbr



texsave using "table-`year'.tex", frag varlabels replace hlines(3 8 13)

}
