use "C:\Users\Packabell\Documents\Cours\Explorations in Economic History\Final\table_final.dta", clear
keep year ctyi ctyj xji xij gdpj exportsj gdpi exportsi idpaysi idpaysj idyear ctypair
keep if year<=1913
drop if ctyj=="India"|ctyj=="NZ"
gen xii=(gdpi-exportsi)
gen xjj=(gdpj-exportsj)
scalar sigma=11
gen tauij=(0.64*(xii*xjj)/(xij*xji))^(1/(2*(sigma-1)))-1
// 17*44*3

// Theirs (corrected)

bysort ctyi year : egen taui=mean(tauij)
// normalized
gen tauin =0
bysort ctyi ctyj (year) : replace tauin=taui/taui[1]

// Ours

gen upsiloni=(0.8*xii/exportsi)^(1/(sigma-1))-1
//normalised
gen upsilonin =0
bysort ctyi ctyj (year) : replace upsilonin=upsiloni/upsiloni[1]
// Openness ratio

gen OR= exportsi/gdpi
gen ORn =0
bysort ctyi ctyj (year) : replace ORn=OR/OR[1]

gen oneoverOR=1/OR
gen oneoverORn =0
bysort ctyi ctyj (year) : replace oneoverORn=oneoverOR/oneoverOR[1]

gen ORcor=exportsi/(gdpi-exportsi)
gen ORcorn =0
bysort ctyi ctyj (year) : replace ORcorn=ORcor/ORcor[1]

gen oneoverORcor=1/ORcor
gen oneoverORcorn =0
bysort ctyi ctyj (year) : replace oneoverORcorn=oneoverORcor/oneoverORcor[1]

gen oneoverORpuiss=OR^(-1/10)-1
gen oneoverORpuissn =0
bysort ctyi ctyj (year) : replace oneoverORpuissn=oneoverORpuiss/oneoverORpuiss[1]

gen oneoverORcorpuiss=ORcor^(-1/10)-1
gen oneoverORcorpuissn =0
bysort ctyi ctyj (year) : replace oneoverORcorpuissn=oneoverORcorpuiss/oneoverORcorpuiss[1]


preserve
gen France=ORcor if ctyi=="France"
gen UK=ORcor if ctyi=="UK"
gen USA=ORcor if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year
restore


//1. Graph trade costs 1870-1913 normalized, both methods
//one graph/ country

preserve
replace taui=tauin
replace upsiloni=upsilonin
keep if ctyj=="Australia"
line taui upsiloni year, by(ctyi) lpattern(dash solid) legend(label(1 "Tau i (JMN)") label(2 "Upsilon i   ") colfirst)
restore


//(1'.)Graph trade costs 1870-1913 normalized, both methods
//one graph/ method
// Don't use it actually

//JMN's
preserve
gen France=tauin if ctyi=="France"
gen UK=tauin if ctyi=="UK"
gen USA=tauin if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year, lpattern(dash dash_dot solid) title("{&tau}k (JMN) for France, the UK and the USA, 1870-1913")
restore

//Ours
preserve
gen France=upsilonin if ctyi=="France"
gen UK=upsilonin if ctyi=="UK"
gen USA=upsilonin if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year, lpattern(dash dash_dot solid) title("{&upsilon}k for France, the UK and the USA, 1870-1913")
restore

//OR
preserve
gen France=ORn if ctyi=="France"
gen UK=ORn if ctyi=="UK"
gen USA=ORn if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year, lpattern(dash dash_dot solid) title("Openness ratio for France, the UK and the USA, 1870-1913")
restore

scatter xji year if ctyi=="USA" & ctyj=="NL"

// So does not seem dramatic in normalized 

// 2. Who's singled out : openness ratio, theirs and ours, in levels (not normalized)
//(forget about it)
// Three graphs

preserve
gen France=taui if ctyi=="France"
gen UK=taui if ctyi=="UK"
gen USA=taui if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year, lpattern(dash dash_dot solid) title("Tau i (JMN) for France, the UK and the USA, 1870-1913")
restore

preserve
gen France=upsiloni if ctyi=="France"
gen UK=upsiloni if ctyi=="UK"
gen USA=upsiloni if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year, lpattern(dash dash_dot solid) title("Upsilon i for France, the UK and the USA, 1870-1913")
restore

// US singled out with our method, which only reflect OR:

preserve
gen France=OR if ctyi=="France"
gen UK=OR if ctyi=="UK"
gen USA=OR if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year, lpattern(dash dash_dot solid) title("Openness ratio for France, the UK and the USA, 1870-1913")
restore

// Decomposition
keep if year==1870|year==1913

// 1. Theirs log

gen yij=sqrt(xij*xji)
gen aij=sqrt(xii*xjj)
gen bij=sqrt((xij*xji)/(xii*xjj))

gen lnyij=ln(yij)
gen lnaij=ln(aij)
gen lnbij=ln(bij)

bysort ctyi year : egen lnyi = mean(lnyij)
bysort ctyi year : egen lnai = mean(lnaij)
bysort ctyi year : egen lnbi = mean(lnbij)

gen dlnyi=0
gen dlnai=0
gen dlnbi=0

bysort ctyi ctyj (year) : replace dlnyi=lnyi[2]-lnyi[1]
bysort ctyi ctyj (year) : replace dlnai=lnai[2]-lnai[1]
bysort ctyi ctyj (year) : replace dlnbi=lnbi[2]-lnbi[1]

gen lnalny= dlnai/dlnyi
gen lnblny= dlnbi/dlnyi

preserve
drop if ctyi=="France" & ctyj=="UK" |ctyi=="UK" & ctyj=="USA" |ctyi=="USA" & ctyj=="France" 
bysort year : egen lny = mean(lnyij)
bysort year : egen lna = mean(lnaij)
bysort year : egen lnb = mean(lnbij)
gen dlny=0
gen dlna=0
gen dlnb=0
bysort ctyi ctyj (year) : replace dlny=lny[2]-lny[1]
bysort ctyi ctyj (year) : replace dlna=lna[2]-lna[1]
bysort ctyi ctyj (year) : replace dlnb=lnb[2]-lnb[1]
gen lnay= dlna/dlny
gen lnby= dlnb/dlny
table dlny
table dlna
table dlnb
table lnay
table lnby
restore


//2. Theirs no log

bysort ctyi year : egen yi = mean(yij)
bysort ctyi year : egen ai = mean(aij)
bysort ctyi year : egen bi = mean(bij)

// RK: Ours does not need j

// Needs to do first diff then mean to find guillaume in Stat App (and phrasal in 2008 paper)

gen dyij=0
gen daij=0
gen dbij=0

bysort ctyi ctyj (year) : replace dyij=yij[2]/yij[1]-1
bysort ctyi ctyj (year) : replace daij=aij[2]/aij[1]-1
bysort ctyi ctyj (year) : replace dbij=bij[2]/bij[1]-1

bysort ctyi year : egen dyi = mean(dyij)
bysort ctyi year : egen dai = mean(daij)
bysort ctyi year : egen dbi = mean(dbij)

// Pour moyenne "mondiale" (drop doublond first)
preserve 
drop if ctyi=="France" & ctyj=="UK" |ctyi=="UK" & ctyj=="USA" |ctyi=="USA" & ctyj=="France" 
bysort year : egen moyennedy = mean(dyij)
bysort year : egen moyenneda = mean(daij)
bysort year : egen moyennedb = mean(dbij)
table moyennedy
table moyenneda
table moyennedb
restore

// 3. Ours log

gen lnyiours=ln(exportsi)
gen lnaiours=ln(xii)
gen lnbiours=ln(exportsi/xii)

gen dlnyiours=0
gen dlnaiours=0
gen dlnbiours=0

bysort ctyi ctyj (year) : replace dlnyiours=lnyiours[2]-lnyiours[1]
bysort ctyi ctyj (year) : replace dlnaiours=lnaiours[2]-lnaiours[1]
bysort ctyi ctyj (year) : replace dlnbiours=lnbiours[2]-lnbiours[1]

gen lnalnyours= dlnaiours/dlnyiours
gen lnblnyours= dlnbiours/dlnyiours

egen dlnyiourstot=mean(dlnyiours)
egen dlnaiourstot=mean(dlnaiours)
egen dlnbiourstot=mean(dlnbiours)

gen lnalnyourstot= dlnaiourstot/dlnyiourstot
gen lnblnyourstot= dlnbiourstot/dlnyiourstot

// 4. Ours no log
gen dyiours=0
gen daiours=0
gen dbiours=0

bysort ctyi ctyj (year) : replace dyiours=exportsi[2]/exportsi[1]-1
bysort ctyi ctyj (year) : replace daiours=xii[2]/xii[1]-1
bysort ctyi ctyj (year) : replace dbiours=(exportsi[2]*xii[1])/(exportsi[1]*xii[2])-1



//5. Openness ratio log
gen lngdp=ln(gdpi)
gen lnor=ln(exportsi/gdpi)

gen dlngdp=0
gen dlnor=0

bysort ctyi ctyj (year) : replace dlngdp=lngdp[2]-lngdp[1]
bysort ctyi ctyj (year) : replace dlnor=lnor[2]-lnor[1]

gen lngdplnyiours= dlngdp/dlnyiours
gen lnorlnyours= dlnor/dlnyiours

egen dlngdptot=mean(dlngdp)
egen dlnortot=mean(dlnor)

gen lngdplny=dlngdptot/dlnyiourstot
gen lnorlny= dlnortot/dlnyiourstot

//6. Openness ratio no log
gen or= exportsi/gdpi

gen dgdp=0
gen dor=0

bysort ctyi ctyj (year) : replace dgdp=gdpi[2]/gdpi[1]-1
bysort ctyi ctyj (year) : replace dor=or[2]/or[1]-1


// figures of variation
gen aux=1-tauin
gen auxours=1-upsilonin
gen auxor=1-ORn


save "C:\Documents and Settings\Packard Bell\Bureau\Explorations in Economic History\Final\table.dta", replace
