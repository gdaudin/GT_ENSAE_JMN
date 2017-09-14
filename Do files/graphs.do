use "C:\Users\Packabell\Documents\Cours\Explorations in Economic History\Final\table_final.dta", clear
keep year ctyi ctyj xji xij gdpj exportsj gdpi exportsi idpaysi idpaysj idyear ctypair
keep if year<=1913
drop if ctyj=="India"
gen xii=(gdpi-exportsi)
gen xjj=(gdpj-exportsj)
scalar sigma=11
gen tauij=(0.64*(xii*xjj)/(xij*xji))^(1/(2*(sigma-1)))-1
// 17*44*3

/////////////////////////////////////////////////////////////////////////
// About their mistake tau ij
gen mistakeij=1-(0.64*(xii*xjj)/(xij*xji))^(-1/(2*(sigma-1)))
bysort ctyi year : egen mistakei=mean(mistakeij)
// normalized
gen mistakein =0
bysort ctyi ctyj (year) : replace mistakein=mistakei/mistakei[1]
// mistake weighted (did they weight?)
gen costtimesgdpij=mistakeij*gdpj
bysort ctyi year : egen totalweight=sum(gdpj)
bysort ctyi year : egen auxi=sum(costtimesgdpij)
gen mistakeiw= auxi/totalweight
gen mistakeiwn =0
bysort ctyi ctyj (year) : replace mistakeiwn=mistakeiw/mistakeiw[1]
drop costtimesgdpij totalweight aux
//graphs mistake
preserve
gen France=mistakei if ctyi=="France"
gen UK=mistakei if ctyi=="UK"
gen USA=mistakei if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year, lpattern(dash dash_dot solid) title("Unweighted average method for France, the UK and the USA, 1870-1913")
restore
preserve
gen France=mistakeiw if ctyi=="France"
gen UK=mistakeiw if ctyi=="UK"
gen USA=mistakeiw if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year, lpattern(dash dash_dot solid) title("Unweighted average method for France, the UK and the USA, 1870-1913")
restore
//////////////////////////////////////////////////////////////////////////

// 1. Theirs (corrected) = tauij
bysort ctyi year : egen taui=mean(tauij)
// normalized
gen tauin =0
bysort ctyi ctyj (year) : replace tauin=taui/taui[1]

// 2. Theirs weighted
gen costtimesgdpij=tauij*gdpj
bysort ctyi year : egen totalweight=sum(gdpj)
bysort ctyi year : egen auxi=sum(costtimesgdpij)
gen tauiw= auxi/totalweight
gen tauiwn =0
bysort ctyi ctyj (year) : replace tauiwn=tauiw/tauiw[1]
drop costtimesgdpij totalweight aux

// 3. Ours
gen upsiloni=(0.8*xii/exportsi)^(1/(sigma-1))-1
//normalised
gen upsilonin =0
bysort ctyi ctyj (year) : replace upsilonin=upsiloni/upsiloni[1]


// 4. Openness ratio
gen OR= exportsi/gdpi
gen ORn =0
bysort ctyi ctyj (year) : replace ORn=OR/OR[1]

///////////////////////////////////////////////////////////
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
//graph
preserve
gen France=ORcor if ctyi=="France"
gen UK=ORcor if ctyi=="UK"
gen USA=ORcor if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year
restore
/////////////////////////////////////////////////////////////

// Correlations
corr OR upsiloni if ctyi=="France"
corr OR upsiloni if ctyi=="UK"
corr OR upsiloni if ctyi=="USA"
// idem if normalized of course

// Other correlations
corr upsiloni tauiw if ctyi=="France"
corr upsiloni taui if ctyi=="France"

// Now the graphs
//Graph trade costs 1870-1913 normalized, both methods
//one graph/ country

preserve
replace taui=tauin
replace tauiw=tauiwn
replace upsiloni=upsilonin
keep if ctyj=="Australia"
line taui tauiw upsiloni year, by(ctyi) lpattern(dash solid) legend(label(1 "Unweigthed average") label(2 "GDP-weigthed average") label(3 "Two-countries model") colfirst)
restore


//Graph trade costs 1870-1913 normalized, both methods
//one graph/ method
// Don't use it actually

//JMN's
preserve
gen France=tauin if ctyi=="France"
gen UK=tauin if ctyi=="UK"
gen USA=tauin if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year, lpattern(dash dash_dot solid) title("Unweighted average method for France, the UK and the USA, 1870-1913")
restore

// JMN's weighted
preserve
gen France=tauiwn if ctyi=="France"
gen UK=tauiwn if ctyi=="UK"
gen USA=tauiwn if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year, lpattern(dash dash_dot solid) title("GDP-weighted average method for France, the UK and the USA, 1870-1913")
restore

//Ours
preserve
gen France=upsilonin if ctyi=="France"
gen UK=upsilonin if ctyi=="UK"
gen USA=upsilonin if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year, lpattern(dash dash_dot solid) title("Two-countries method for France, the UK and the USA, 1870-1913")
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

save "C:\Users\Packabell\Documents\Cours\Explorations in Economic History\Final\decomposition.dta", replace

use "C:\Users\Packabell\Documents\Cours\Explorations in Economic History\Final\decomposition.dta", replace

// checking power mean below arithmetic mean

bysort ctyi year : egen arithmeticmean= mean(xij)
gen powerij=xij^(-1/10)
bysort ctyi year : egen auxiliary= mean(powerij)
gen powermean=auxiliary^(-10)
drop auxiliary powerij
gen arithmeticmeann =0
bysort ctyi ctyj (year) : replace arithmeticmeann=arithmeticmean/arithmeticmean[1]
gen powermeann =0
bysort ctyi ctyj (year) : replace powermeann=powermean/powermean[1]
scatter powermeann arithmeticmeann year if ctyj=="Australia", by(ctyi)

// idem with xji
bysort ctyi year : egen arithmeticmeanexp= mean(xji)
gen powerji=xji^(-1/10)
bysort ctyi year : egen auxiliary= mean(powerji)
gen powermeanexp=auxiliary^(-10)
drop auxiliary powerji
gen arithmeticmeanexpn =0
bysort ctyi ctyj (year) : replace arithmeticmeanexpn=arithmeticmeanexp/arithmeticmeanexp[1]
gen powermeanexpn =0
bysort ctyi ctyj (year) : replace powermeanexpn=powermeanexp/powermeanexp[1]
scatter powermeanexpn arithmeticmeanexpn year if ctyj=="Australia", by(ctyi)

gen exportsn =0
bysort ctyi ctyj (year) : replace exportsn=exportsi/exportsi[1]
scatter exportsn arithmeticmeann arithmeticmeanexpn powermeann powermeanexpn year if ctyj=="Australia", by(ctyi)
//so far actually ok, just that not much with France and UK
// only Q = why BIGGER with upsilon for Uk and France

// idem with geometric average
gen geoij=sqrt(xij*xji)
bysort ctyi year : egen arithmeticmeangeo= mean(geoij)
gen powerijji=geoij^(-1/10)
bysort ctyi year : egen auxiliary= mean(powerijji)
gen powermeangeo=auxiliary^(-10)
drop auxiliary powerijji
gen arithmeticmeangeon =0
bysort ctyi ctyj (year) : replace arithmeticmeangeon=arithmeticmeangeo/arithmeticmeangeo[1]
gen powermeangeon =0
bysort ctyi ctyj (year) : replace powermeangeon=powermeangeo/powermeangeo[1]
scatter powermeangeon arithmeticmeangeon year if ctyj=="Australia", by(ctyi)
// Still good

// tauij without xjj
gen tauijwxjj=(0.64*(xii)/(sqrt(xij*xji)))^(1/((sigma-1)))-1
bysort ctyi ctyj year : egen tauiwxjj = mean(tauijwxjj)
gen tauiwxjjn=0
bysort ctyi ctyj (year) : replace tauiwxjjn=tauiwxjj/tauiwxjj[1]
scatter tauiwxjjn upsilonin year if ctyj=="Australia", by(ctyi)
// So we have our answer : it is because of the averaging of xjj

// checking if tau_k as in the comparison in the comment

gen taualtij=(xii/xij)^(1/10)
bysort ctyi year : egen taualti=mean(taualtij)
gen taualtin =0
bysort ctyi ctyj (year) : replace taualtin=taualti/taualti[1]

// see 0.8, see total exports or sum of 
