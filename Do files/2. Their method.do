*cd "C:\Users\Packabell\Documents\Courses\JIE\Stata"

if "`c(username)'"=="guillaumedaudin" cd "~/Documents/Recherche/Coûts du commerce - ancien ENSAE/Stata"

use table, replace


local sqrlist "UK FRA USA IND BEL CAN GER ITA SPA"
replace sqr_sample=1 if strpos("`sqrlist'", ctry1)!=0 & strpos("`sqrlist'", ctry2)!=0
keep if sqr_sample==1


gen weight= gdp1+gdp2

gen s1=gdp1/(gdp1+gdp2)
gen s2=gdp2/(gdp1+gdp2)

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

//Dropping 3 pairs (cf. structure)
//drop if ctry1=="IND"&ctry2=="SPA"
//drop if ctry1=="USA"&ctry2=="GRE"
//drop if ctry1=="BEL"&ctry2=="INN"
//drop if ctry1=="IND"&ctry2=="INN"	
//drop if ctry1=="BEL"&ctry2=="IND"

// They use end-of-period weights
keep if year==1913|year==1939|year==2000

gen aux0= dlnleftterm*weight
gen aux1= dlnterm1*weight
gen aux2= dlnterm2*weight
gen aux3= dlnterm3*weight
gen aux4= dlnterm4*weight

bysort year: egen weightamer=total(weight) if amer==1
bysort year: egen weightasia=total(weight) if asia==1
bysort year: egen weighteuro=total(weight) if euro==1
bysort year: egen weightamerasia=total(weight) if amerasia==1
bysort year: egen weightameuro=total(weight) if ameuro==1
bysort year: egen weighteurasia=total(weight) if eurasia==1
bysort year: egen weightcomplete=total(weight) if complete==1

bysort year: egen mdlnlefttermamer=total(aux0/weightamer) if amer==1
bysort year: egen mdlnlefttermasia=total(aux0/weightasia) if asia==1
bysort year: egen mdlnlefttermeuro=total(aux0/weighteuro) if euro==1
bysort year: egen mdlnlefttermamerasia=total(aux0/weightamerasia) if amerasia==1
bysort year: egen mdlnlefttermameuro=total(aux0/weightameuro) if ameuro==1
bysort year: egen mdlnlefttermeurasia=total(aux0/weighteurasia) if eurasia==1
bysort year: egen mdlnlefttermcomplete=total(aux0/weightcomplete) if complete==1

bysort year: egen mdlnterm1amer=total(aux1/weightamer) if amer==1
bysort year: egen mdlnterm1asia=total(aux1/weightasia) if asia==1
bysort year: egen mdlnterm1euro=total(aux1/weighteuro) if euro==1
bysort year: egen mdlnterm1amerasia=total(aux1/weightamerasia) if amerasia==1
bysort year: egen mdlnterm1ameuro=total(aux1/weightameuro) if ameuro==1
bysort year: egen mdlnterm1eurasia=total(aux1/weighteurasia) if eurasia==1
bysort year: egen mdlnterm1complete=total(aux1/weightcomplete) if complete==1

bysort year: egen mdlnterm2amer=total(aux2/weightamer) if amer==1
bysort year: egen mdlnterm2asia=total(aux2/weightasia) if asia==1
bysort year: egen mdlnterm2euro=total(aux2/weighteuro) if euro==1
bysort year: egen mdlnterm2amerasia=total(aux2/weightamerasia) if amerasia==1
bysort year: egen mdlnterm2ameuro=total(aux2/weightameuro) if ameuro==1
bysort year: egen mdlnterm2eurasia=total(aux2/weighteurasia) if eurasia==1
bysort year: egen mdlnterm2complete=total(aux2/weightcomplete) if complete==1

bysort year: egen mdlnterm3amer=total(aux3/weightamer) if amer==1
bysort year: egen mdlnterm3asia=total(aux3/weightasia) if asia==1
bysort year: egen mdlnterm3euro=total(aux3/weighteuro) if euro==1
bysort year: egen mdlnterm3amerasia=total(aux3/weightamerasia) if amerasia==1
bysort year: egen mdlnterm3ameuro=total(aux3/weightameuro) if ameuro==1
bysort year: egen mdlnterm3eurasia=total(aux3/weighteurasia) if eurasia==1
bysort year: egen mdlnterm3complete=total(aux3/weightcomplete) if complete==1

bysort year: egen mdlnterm4amer=total(aux4/weightamer) if amer==1
bysort year: egen mdlnterm4asia=total(aux4/weightasia) if asia==1
bysort year: egen mdlnterm4euro=total(aux4/weighteuro) if euro==1
bysort year: egen mdlnterm4amerasia=total(aux4/weightamerasia) if amerasia==1
bysort year: egen mdlnterm4ameuro=total(aux4/weightameuro) if ameuro==1
bysort year: egen mdlnterm4eurasia=total(aux4/weighteurasia) if eurasia==1
bysort year: egen mdlnterm4complete=total(aux4/weightcomplete) if complete==1

// Without weights, for complete only

bysort year: egen munwdlnleftterm=mean(dlnleftterm)
bysort year: egen munwdlnterm1=mean(dlnterm1)
bysort year: egen munwdlnterm2=mean(dlnterm2)
bysort year: egen munwdlnterm3=mean(dlnterm3)
bysort year: egen munwdlnterm4=mean(dlnterm4)


***


save blouf.dta, replace

foreach year of num 1913 2000 {
	use blouf.dta, clear
	keep if year==`year'
	
	
	preserve
	
	keep if _n==1
	keep ctry1 md*complete
	replace ctry1="JMN 2011, GDP-weighted"
	rename m*complete *
	save blink.dta, replace
	
	
	restore
	keep if _n==1
	keep ctry1 munwd*
	replace ctry1="JMN 2011, unweighted"
	rename munw* *
	
	
	
	append using blink.dta
	
	erase blink.dta
	
	
	
	
	replace dlnterm1=round(dlnterm1*100,1)
	replace dlnterm2=round(dlnterm2*100,1)
	replace dlnterm3=round(dlnterm3*100,1)
	replace dlnterm4=round(dlnterm4*100,1)
	replace dlnleftterm=round(dlnleftterm*100,1)
	
	order ctry1 dlnterm1 dlnterm2 dlnterm3 dlnterm4 dlnleftterm
	
	texsave using "JMN-`year'.tex", frag varlabels replace bold("JMN 2011, GDP-weighted")
}

erase blouf.dta
