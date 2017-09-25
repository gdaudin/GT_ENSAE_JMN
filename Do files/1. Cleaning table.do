
*cd "C:\Users\Packabell\Documents\Courses\JIE\Stata"

if "`c(username)'"=="guillaumedaudin" cd "~/Documents/Recherche/Coûts du commerce - ancien ENSAE/Stata"

use tbtbtc_corr, replace

//keep if year==1870|year==1913|year==1921|year==1939|year==1950|year==2000
//list ctry1 ctry2 year if trade12==.|trade12==0|trade21==.|trade21==0
// pairs missing :
drop if ctry1=="BEL"& ctry2=="AUS"
drop if ctry1=="BEL"& ctry2=="JAP"
drop if ctry1=="CAN"& ctry2=="AUS"
drop if ctry1=="CAN"& ctry2=="DEN"
drop if ctry1=="CAN"& ctry2=="INN"
drop if ctry1=="CAN"& ctry2=="JAP"
drop if ctry1=="CAN"& ctry2=="NEW"
drop if ctry1=="CAN"& ctry2=="NOR"
drop if ctry1=="CAN"& ctry2=="SWE"
drop if ctry1=="JAP"& ctry2=="AUS"
drop if ctry1=="JAP"& ctry2=="BRA"
drop if ctry1=="JAP"& ctry2=="INN"
drop if ctry1=="JAP"& ctry2=="ITA"
drop if ctry1=="JAP"& ctry2=="NET"
drop if ctry1=="JAP"& ctry2=="POR"
drop if ctry1=="JAP"& ctry2=="SPA"
drop if ctry1=="NOR"& ctry2=="AUS"
drop if ctry1=="NOR"& ctry2=="JAP"
drop if ctry1=="NOR"& ctry2=="NEW"
//table ctry1 ctry2

keep year ctry1 ctry2 trade12 trade21 gdp1 exp1 gdp2 exp2 tc8 amer asia euro amerasia ameuro eurasia complete
replace exp1=exp1*10^6
replace exp2=exp2*10^6
replace gdp1=gdp1*10^6
replace gdp2=gdp2*10^6
gen trade11=gdp1-exp1
gen trade22=gdp2-exp2

scalar sigma=8
gen tauij=((trade11*trade22)/(trade12*trade21))^(1/(2*(sigma-1)))-1
// No more 0.8

bysort year ctry1: egen aux12=total(trade12)
label var aux12 "sum of ctry1 exports in the sample for a given year"
gen expcorr1=exp1-aux12+trade12
label var expcorr1 "Total X of ctry1 - sum of ctry1 X in the sample + X from ctry1 to ctry2"
bysort year ctry2: egen aux21=total(trade21)
label var aux21 "sum of ctry2 exports in the sample for a given year"
gen expcorr2=exp2-aux21+trade21
label var expcorr2 "Total X of ctry2 - sum of ctry2 X in the sample + X from ctry2 to ctry1"
drop aux12 aux21


gen sqr_sample=0
local sqrlist "UK FRA USA IND BEL CAN GER ITA SPA"
replace sqr_sample=1 if strpos("`sqrlist'", ctry1)!=0 & strpos("`sqrlist'", ctry2)!=0
save table, replace
