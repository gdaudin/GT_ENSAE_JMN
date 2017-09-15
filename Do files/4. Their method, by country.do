*cd "C:\Users\Packabell\Documents\Courses\JIE\Stata"

if "`c(username)'"=="guillaumedaudin" cd "~/Documents/Recherche/Coûts du commerce - ancien ENSAE/Stata"

use doubletable, replace
// use doubletable generated in 3.

gen weight= gdp2

gen s1=gdp1/(gdp1+gdp2)
gen s2=gdp2/(gdp1+gdp2)

scalar sigma=8

gen leftterm=log(trade12*trade21)
gen term1=2*log(gdp1+gdp2)
gen term2=log(s1*s2)
gen term3=2*(1-sigma)*log(1+tauij)
gen term4=log(trade11*trade22/(gdp1*gdp2))

//Checking
gen checking=leftterm-term1-term2-term3-term4
drop checking
//ok

keep if year==1870|year==1913|year==1921|year==1939|year==1950|year==2000
sort ctry1 ctry2 year
gen dlnleftterm=leftterm[_n]-leftterm[_n-1]
gen dlnterm1=term1[_n]-term1[_n-1]
gen dlnterm2=term2[_n]-term2[_n-1]
gen dlnterm3=term3[_n]-term3[_n-1]
gen dlnterm4=term4[_n]-term4[_n-1]

sort ctry1 ctry2 year

// To compare to 2008 article
// keep if ctry2=="AUS"|ctry2=="BEL"|ctry2=="BRA"|ctry2=="CAN"|ctry2=="DEN"|ctry2=="FRA"|ctry2=="GER"|ctry2=="IND"|ctry2=="INN"|ctry2=="ITA"|ctry2=="JAP"|ctry2=="NET"|ctry2=="NEW"|ctry2=="NOR"|ctry2=="POR"|ctry2=="SPA"|ctry2=="SWE"|ctry2=="USA"|ctry2=="UK"
// table ctry1 ctry2
//ok

// Weighted
// They use end-of-period weights
keep if year==1913|year==1939|year==2000

gen aux0= dlnleftterm*weight
gen aux1= dlnterm1*weight
gen aux2= dlnterm2*weight
gen aux3= dlnterm3*weight
gen aux4= dlnterm4*weight

bysort ctry1 year: egen totalweight=total(weight)

bysort ctry1 year: egen mdlnleftterm=total(aux0/totalweight)
bysort ctry1 year: egen mdlnterm1=total(aux1/totalweight)
bysort ctry1 year: egen mdlnterm2=total(aux2/totalweight)
bysort ctry1 year: egen mdlnterm3=total(aux3/totalweight)
bysort ctry1 year: egen mdlnterm4=total(aux4/totalweight)

// And unweighted
bysort ctry1 year: egen munwdlnleftterm=mean(dlnleftterm)
bysort ctry1 year: egen munwdlnterm1=mean(dlnterm1)
bysort ctry1 year: egen munwdlnterm2=mean(dlnterm2)
bysort ctry1 year: egen munwdlnterm3=mean(dlnterm3)
bysort ctry1 year: egen munwdlnterm4=mean(dlnterm4)

//Averaging over ctry1
keep if ctry1=="ARG" & ctry2=="USA"|ctry1=="USA" & ctry2=="USA"|ctry1=="AUS" & ctry2=="USA"|ctry1=="BEL" & ctry2=="USA"|ctry1=="BRA" & ctry2=="USA"|ctry1=="CAN"	& ctry2=="USA"|ctry1=="DEN"	& ctry2=="USA"|ctry1=="FRA"	& ctry2=="USA"|ctry1=="GER"	& ctry2=="USA"|ctry1=="GRE"	& ctry2=="FRA"|ctry1=="IND"	& ctry2=="USA"|ctry1=="INN"	& ctry2=="USA"|ctry1=="ITA"	& ctry2=="USA"|ctry1=="JAP"	& ctry2=="USA"|ctry1=="MEX"	& ctry2=="USA"|ctry1=="NET"	& ctry2=="USA"|ctry1=="NEW"	& ctry2=="USA"|ctry1=="NOR"	& ctry2=="USA"|ctry1=="PHI"	& ctry2=="USA"|ctry1=="POR"	& ctry2=="USA"|ctry1=="SPA"	& ctry2=="USA"|ctry1=="SRI"	& ctry2=="USA"|ctry1=="SWE"	& ctry2=="USA"|ctry1=="SWI"	& ctry2=="USA"|ctry1=="UK"& ctry2=="USA"|ctry1=="URU"	& ctry2=="USA"|ctry1=="USA"	& ctry2=="FRA"

//Unweighted
bysort year: egen gunwmdlnleftterm=mean(mdlnleftterm)
bysort year: egen gunwmdlnterm1=mean(mdlnterm1)
bysort year: egen gunwmdlnterm2=mean(mdlnterm2)
bysort year: egen gunwmdlnterm3=mean(mdlnterm3)
bysort year: egen gunwmdlnterm4=mean(mdlnterm4)

//Weighted
drop aux0 aux1 aux2 aux3 aux4 weight totalweight
gen weight= gdp1
gen aux0= mdlnleftterm*weight
gen aux1= mdlnterm1*weight
gen aux2= mdlnterm2*weight
gen aux3= mdlnterm3*weight
gen aux4= mdlnterm4*weight

bysort year: egen totalweight=total(weight)

bysort year: egen gmdlnleftterm=total(aux0/totalweight)
bysort year: egen gmdlnterm1=total(aux1/totalweight)
bysort year: egen gmdlnterm2=total(aux2/totalweight)
bysort year: egen gmdlnterm3=total(aux3/totalweight)
bysort year: egen gmdlnterm4=total(aux4/totalweight)

drop aux0 aux1 aux2 aux3 aux4

// NB: when weigthed always weighted, when not never (country 1 and country 2)

keep if ctry1=="FRA"|ctry1=="UK"|ctry1=="USA"


bys ctry1 year : keep if _n==1

save blouf.dta, replace

foreach year of num 1913 2000 {
	use blouf.dta, clear

	keep if (ctry1=="FRA"|ctry1=="UK"|ctry1=="USA") & year==`year'
	
	
	preserve
	
	
		keep ctry1 gmdlnterm1 gmdlnterm2 gmdlnterm3 gmdlnterm4 gmdlnleftterm
	keep if _n==1
	replace ctry1 ="Average"
	gen method="JMN 2011, GDP-weighted"
	rename gm* *
	
	save blink.dta, replace

	
	restore
	preserve
	
	
	keep ctry1 mdlnterm1 mdlnterm2 mdlnterm3 mdlnterm4 mdlnleftterm
	gen method = "JMN 2011, GDP-weighted"
	sort ctry1
	rename m* *
	rename ethod method
	

	
	append using blink.dta
	save blink.dta, replace
	
	
	restore
	preserve
	
	
		keep ctry1 gunwmdlnterm1 gunwmdlnterm2 gunwmdlnterm3 gunwmdlnterm4 gunwmdlnleftterm
	keep if _n==1
	replace ctry1 ="Average"
	gen method ="JMN 2011, unweighted"
	rename gunwm* *
	append using blink.dta
	
	save blink.dta, replace
	
	
	
	
	
	restore
	keep ctry1 munwdlnterm1 munwdlnterm2 munwdlnterm3 munwdlnterm4 munwdlnleftterm
	gen method = "JMN 2011, unweighted"
	sort ctry1
	rename munw* *
	append using blink.dta
	save blink.dta, replace
	
	
	
	erase blink.dta
	
	
	replace dlnterm1=round(dlnterm1*100,1)
	replace dlnterm2=round(dlnterm2*100,1)
	replace dlnterm3=round(dlnterm3*100,1)
	replace dlnterm4=round(dlnterm4*100,1)
	replace dlnleftter=round(dlnleftterm*100,1)
	
	keep ctry1 method dlnterm1 dlnterm2 dlnterm3 dlnterm4 dlnleftterm
	order ctry1 method dlnterm1 dlnterm2 dlnterm3 dlnterm4 dlnleftterm
	
	
	
	texsave using "table-their-method-by-country-`year'.tex", frag varlabels replace bold("GDP-weighted average")

}
erase blouf.dta
