*cd "C:\Users\Packabell\Documents\Courses\JIE\Stata"

if "`c(username)'"=="guillaumedaudin" cd "~/Documents/Recherche/Coûts du commerce - ancien ENSAE/Stata"

use table, replace

// Create 130 doublons first
expand 2
gen id = _n
gen auxctry = ctry1
gen auxgdp= gdp1
gen auxtrade12=trade12
gen auxexp=exp1
gen auxexpcorr=expcorr1
gen auxtrade11=trade11
replace ctry1=ctry2 if id>17030
replace ctry2=auxctry if id>17030
replace gdp1=gdp2 if id>17030
replace gdp2=auxgdp if id>17030
replace trade12=trade21 if id>17030
replace trade21=auxtrade12 if id>17030
replace exp1=exp2 if id>17030
replace exp2=auxexp if id>17030
replace expcorr1=expcorr2 if id>17030
replace expcorr2=auxexpcorr if id>17030
replace trade11=trade22 if id>17030
replace trade22=auxtrade11 if id>17030
drop auxctry auxgdp auxtrade12 auxexp auxtrade11 id
sort ctry1 ctry2 year
//130*2*131 observation

drop amer asia euro amerasia ameuro eurasia complete

save doubletable, replace



local sqrlist "UK FRA USA IND BEL CAN GER ITA SPA"
replace sqr_sample=1 if strpos("`sqrlist'", ctry1)!=0 & strpos("`sqrlist'", ctry2)!=0
keep if sqr_sample==1


// Building upsilon
bysort ctry1 year: egen x12=total(trade12)
bysort ctry1 year: egen x21=total(trade21)
bysort ctry1 year: egen totalgdp2=total(gdp2)
bysort ctry1 year: egen totalexp2=total(expcorr2)
gen x22=totalgdp2-totalexp2
gen x11=trade11

scalar sigma=8
gen upsilon=((x11*x22)/(x12*x21))^(1/(2*(sigma-1)))-1	

// Below graphs, do not consider

bysort year: egen mupsilon=mean(upsilon)

preserve
keep if year<1914
gen nmupsilon=mupsilon/mupsilon[1]
//line nmupsilon year if ctry1=="UK" & ctry2=="USA"
restore

preserve
keep if year>1920 & year<1940
gen nmupsilon=mupsilon/mupsilon[1]
//line nmupsilon year if ctry1=="UK" & ctry2=="USA"
restore

preserve
keep if year>1949
gen nmupsilon=mupsilon/mupsilon[1]
//line nmupsilon year if ctry1=="UK" & ctry2=="USA"
restore

// decomposition
gen s1=gdp1/(gdp1+totalgdp2)
gen s2=totalgdp2/(gdp1+totalgdp2)

gen leftterm=log(x12*x21)
gen term1=2*log(gdp1+totalgdp2)
gen term2=log(s1*s2)
gen term3=2*(1-sigma)*log(1+upsilon)
gen term4=log(x11*x22/(gdp1*totalgdp2))

keep if year==1870|year==1913|year==1921|year==1939|year==1950|year==2000
sort ctry1 ctry2 year
gen dlnleftterm=leftterm[_n]-leftterm[_n-1]
gen dlnterm1=term1[_n]-term1[_n-1]
gen dlnterm2=term2[_n]-term2[_n-1]
gen dlnterm3=term3[_n]-term3[_n-1]
gen dlnterm4=term4[_n]-term4[_n-1]
keep if year==1913|year==1939|year==2000


// Careful limit to one pair of each

keep if ctry1>ctry2


//checking
gen checking=leftterm-term1-term2-term3-term4
drop checking
//ok



bysort year: egen mdlnterm1=mean(dlnterm1)
bysort year: egen mdlnterm2=mean(dlnterm2)
bysort year: egen mdlnterm3=mean(dlnterm3)
bysort year: egen mdlnterm4=mean(dlnterm4)
bysort year: egen mdlnleftterm=mean(dlnleftterm)

// And weighted

gen weight=gdp1

gen aux0= dlnleftterm*weight
gen aux1= dlnterm1*weight
gen aux2= dlnterm2*weight
gen aux3= dlnterm3*weight
gen aux4= dlnterm4*weight

bysort year: egen totalweight=total(weight)

bysort year: egen mwdlnterm1=total(aux1/totalweight)
bysort year: egen mwdlnterm2=total(aux2/totalweight)
bysort year: egen mwdlnterm3=total(aux3/totalweight)
bysort year: egen mwdlnterm4=total(aux4/totalweight)
bysort year: egen mwdlnleftterm=total(aux0/totalweight)

bys ctry1 year : keep if _n==1

save blouf.dta, replace

foreach year of num 1913 2000 {
	use blouf.dta, clear

	keep if (ctry1=="FRA"|ctry1=="UK"|ctry1=="USA") & year==`year'
	
	
	preserve
	keep ctry1 mwdlnterm1 mwdlnterm2 mwdlnterm3 mwdlnterm4 mwdlnleftterm
	keep if _n==1
	replace ctry1 ="GDP-weighted average"
	rename mw* *
	
	save blink.dta, replace
	
	restore
	preserve
	keep ctry1 mdlnterm1 mdlnterm2 mdlnterm3 mdlnterm4 mdlnleftterm
	keep if _n==1
	replace ctry1 ="Unweighted average"
	rename m* *
	append using blink.dta
	save blink.dta, replace
	
	
	restore
	keep ctry1 dlnterm1 dlnterm2 dlnterm3 dlnterm4 dlnleftterm
	sort ctry1
	append using blink.dta
	erase blink.dta
	
	
	replace dlnterm1=round(dlnterm1*100,1)
	replace dlnterm2=round(dlnterm2*100,1)
	replace dlnterm3=round(dlnterm3*100,1)
	replace dlnterm4=round(dlnterm4*100,1)
	replace dlnleftter=round(dlnleftterm*100,1)
	
	keep ctry1 dlnterm1 dlnterm2 dlnterm3 dlnterm4 dlnleftterm
	order ctry1 dlnterm1 dlnterm2 dlnterm3 dlnterm4 dlnleftterm
	
	
	
	texsave using "table-our-method-`year'.tex", frag varlabels replace bold("GDP-weighted average")

}
erase blouf.dta
