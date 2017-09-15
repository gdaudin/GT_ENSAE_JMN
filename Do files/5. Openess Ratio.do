*cd "C:\Users\Packabell\Documents\Courses\JIE\Stata"

if "`c(username)'"=="guillaumedaudin" cd "~/Documents/Recherche/Coûts du commerce - ancien ENSAE/Stata"

use doubletable, replace

gen or=exp1/gdp1

gen lnexp=log(exp1)
gen lngdp=log(gdp1)
gen lnor=log(or)

keep if year==1870|year==1913|year==1921|year==1939|year==1950|year==2000
sort ctry1 ctry2 year
gen dlnexp=lnexp[_n]-lnexp[_n-1]
gen dlngdp=lngdp[_n]-lngdp[_n-1]
gen dlnor=lnor[_n]-lnor[_n-1]
keep if year==1913|year==1939|year==2000

gen id=_n

table ctry1 ctry2

//keep if id==1|id==13|id==28|id==46|id==103|id==127|id==160|id==184|id==256|id==298|id==310|id==352|id==373|id==409|id==424|id==433|id==466|id==481|id==517|id==520|id==547|id==583|id==589|id==616|id==625|id==700|id==712
keep if ctry1=="ARG" & ctry2=="BEL"|ctry1=="AUH" & ctry2=="BEL"|ctry1=="AUS" & ctry2=="FRA"|ctry1=="BEL" & ctry2=="ARG"|ctry1=="BRA"	& ctry2=="BEL"|ctry1=="CAN"	& ctry2=="BEL"|ctry1=="DEN"	& ctry2=="BEL"|ctry1=="FRA"	& ctry2=="ARG"|ctry1=="GER"	& ctry2=="BEL"|ctry1=="GRE"	& ctry2=="FRA"|ctry1=="IND"	& ctry2=="AUS"|ctry1=="INN"	& ctry2=="AUS"|ctry1=="ITA"	& ctry2=="AUH"|ctry1=="JAP"	& ctry2=="FRA"|ctry1=="MEX"	& ctry2=="FRA"|ctry1=="NET"	& ctry2=="BEL"|ctry1=="NEW"	& ctry2=="AUS"|ctry1=="NOR"	& ctry2=="BEL"|ctry1=="PHI"	& ctry2=="UK"|ctry1=="POR"	& ctry2=="BEL"|ctry1=="SPA"	& ctry2=="BEL"|ctry1=="SRI"	& ctry2=="IND"|ctry1=="SWE"	& ctry2=="BEL"|ctry1=="SWI"	& ctry2=="BEL"|ctry1=="UK"& ctry2=="ARG"|ctry1=="URU"	& ctry2=="BEL"|ctry1=="USA"	& ctry2=="ARG"

bysort year: egen meanexp=mean(dlnexp)
bysort year: egen meangdp=mean(dlngdp)
bysort year: egen meanor=mean(dlnor)

sort year ctry1 ctry2 

replace dlnexp=dlnexp*100
replace dlngdp=dlngdp*100
replace dlnor=dlnor*100


drop if year==1939

keep ctry1 year dlnexp dlngdp dlnor

replace dlnexp=. if ctry1=="NOR" & year==1913
replace dlngdp=. if ctry1=="NOR" & year==1913
replace dlnor=. if ctry1=="NOR" & year==1913

reshape wide dlnexp dlngdp dlnor, i(ctry1) j(year)


format dlnexp1913-dlnor2000 %9.0f
label var dlnexp1913 "Exports"
label var dlnexp2000 "Exports"
label var dlngdp1913 "GDP"
label var dlngdp2000 "GDP"
label var dlnor1913 "Openness Ratio"
label var dlnor2000 "Openness Ratio"

preserve
collapse (mean) dlnexp1913-dlnor2000
gen ctry1="Average"
save blink, replace
restore
append using blink
erase blink.dta


replace dlnexp1913=round(dlnexp1913,1)
replace dlnexp2000=round(dlnexp2000,1)
replace dlngdp1913=round(dlngdp1913,1)
replace dlngdp2000=round(dlngdp2000,1)
replace dlnor1913=round(dlnor1913,1)
replace dlnor2000=round(dlnor2000,1)

texsave using table1.tex, frag varlabels replace bold("Average")




