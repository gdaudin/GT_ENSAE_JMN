// On their data

use "C:\Documents and Settings\Packard Bell\Bureau\Explorations in Economic History\Final\tcifwg.dta", clear

preserve
bysort ctyi year : egen tci=mean(tc)
drop if (ctyi=="FRA" & ctyj=="UK")|(ctyi=="UK" & ctyj=="US")|(ctyi=="UK" & ctyj=="US")
cap drop France UK USA
gen France=tci if ctyi=="FRA"
gen UK=tci if ctyi=="UK"
gen USA=tci if ctyi=="US"
keep if ctyj=="Australia"
line France UK USA year
restore


/////////////////////////////////////////////////


use "C:\Documents and Settings\Packard Bell\Bureau\Explorations in Economic History\Final\table_final.dta", clear
keep year ctyi ctyj xji xij gdpj exportsj gdpi exportsi idpaysi idpaysj idyear ctypair
keep if year<=1913
drop if ctyj=="India"
gen xii=(gdpi-exportsi)
gen xjj=(gdpj-exportsj)

// 17*44*3

scalar sigma=11
gen tauij=(0.64*(xii*xjj)/(xij*xji))^(1/(2*(sigma-1)))-1
bysort ctyi year : egen taui=mean(tauij)

gen tauijbis=1-((xij*xji)/(0.64*(xii*xjj)))^(1/(2*(sigma-1)))
bysort ctyi year : egen tauibis=mean(tauijbis)

preserve
gen France=tauibis if ctyi=="France"
gen UK=tauibis if ctyi=="UK"
gen USA=tauibis if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year
restore
//?
preserve
gen France=taui if ctyi=="France"
gen UK=taui if ctyi=="UK"
gen USA=taui if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year
restore
// 2 countries

gen upsiloni=(0.8*xii/exportsi)^(1/(sigma-1))-1

preserve
gen France=upsiloni if ctyi=="France"
gen UK=upsiloni if ctyi=="UK"
gen USA=upsiloni if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year
restore

// comparison normalised
gen tauin =0
gen tauibisn =0
gen upsilonin =0

bysort ctyi ctyj (year) : replace tauin=taui/taui[1]
bysort ctyi ctyj (year) : replace tauibisn=tauibis/tauibis[1]
bysort ctyi ctyj (year) : replace upsilonin=upsiloni/upsiloni[1]

// Only normalized since n factor
preserve
gen France=tauin if ctyi=="France"
gen UK=tauin if ctyi=="UK"
gen USA=tauin if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year
restore

preserve
gen France=tauibisn if ctyi=="France"
gen UK=tauibisn if ctyi=="UK"
gen USA=tauibisn if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year
restore

preserve
gen France=upsilonin if ctyi=="France"
gen UK=upsilonin if ctyi=="UK"
gen USA=upsilonin if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year
restore

line tauin upsilonin year, by(ctyi)
// Do graphs by country, two measures tau and upsilon, but first pb with taubis to solve
// Doesn't appear dramatic but AER...


//Openness ratio

preserve
gen or=exportsi/gdpi
gen France=or if ctyi=="France"
gen UK=or if ctyi=="UK"
gen USA=or if ctyi=="USA"
keep if ctyj=="Australia"
line France UK USA year
restore


// Decomposition
// 0.8 shares: We can get rid of it since = multiplicative cst
keep if year==1870|year==1913

// Theirs

// log

gen yij=sqrt(xij*xji)
gen aij=sqrt(xii*xjj)
gen bij=sqrt((xij*xji)/(xii*xjj))

gen lnyij=ln(yij)
gen lnaij=ln(aij)
gen lnbij=ln(bij)
// sqrt so no 0.5

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


//nolog

bysort ctyi year : egen yi = mean(yij)
bysort ctyi year : egen ai = mean(aij)
bysort ctyi year : egen bi = mean(bij)

gen dyi=0
gen dai=0
gen dbi=0

bysort ctyi ctyj (year) : replace dyi=yi[2]/yi[1]-1
bysort ctyi ctyj (year) : replace dai=ai[2]/ai[1]-1
bysort ctyi ctyj (year) : replace dbi=bi[2]/bi[1]-1

keep if ctyj=="Australia"
// Ours does not need j

// Ours

//log
// no 0.5 since...
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

// nolog
gen dyiours=0
gen daiours=0
gen dbiours=0

bysort ctyi ctyj (year) : replace dyiours=exportsi[2]/exportsi[1]-1
bysort ctyi ctyj (year) : replace daiours=xii[2]/xii[1]-1
bysort ctyi ctyj (year) : replace dbiours=-(upsiloni[2]/upsiloni[1]-1)

egen dyiourstot=mean(dyiours)
egen daiourstot=mean(daiours)
egen dbiourstot=mean(dbiours)


// decompo total

keep if year==1870|year==1913
drop if (ctyi=="France" & ctyj=="UK")|(ctyi=="UK" & ctyj=="USA")|(ctyi=="UK" & ctyj=="USA")
// Theirs

// log

gen yij=sqrt(xij*xji)
gen aij=sqrt(xii*xjj)
gen bij=sqrt((xij*xji)/(xii*xjj))
gen lnyij=ln(yij)
gen lnaij=ln(aij)
gen lnbij=ln(bij)
bysort year : egen lnyi = mean(lnyij)
bysort year : egen lnai = mean(lnaij)
bysort year : egen lnbi = mean(lnbij)
gen dlnyi=0
gen dlnai=0
gen dlnbi=0
bysort ctyi ctyj (year) : replace dlnyi=lnyi[2]-lnyi[1]
bysort ctyi ctyj (year) : replace dlnai=lnai[2]-lnai[1]
bysort ctyi ctyj (year) : replace dlnbi=lnbi[2]-lnbi[1]
gen lnalny= dlnai/dlnyi
gen lnblny= dlnbi/dlnyi


//nolog

bysort year : egen yi = mean(yij)
bysort year : egen ai = mean(aij)
bysort year : egen bi = mean(bij)
gen dyi=0
gen dai=0
gen dbi=0
bysort ctyi ctyj (year) : replace dyi=yi[2]/yi[1]-1
bysort ctyi ctyj (year) : replace dai=ai[2]/ai[1]-1
bysort ctyi ctyj (year) : replace dbi=bi[2]/bi[1]-1

keep if ctyj=="Australia"
// Ours does not need j

// Ours; arithmetic mean : not great; Rk: we use twice some dyades but no bug deal
// We just take the mean, see above (no need to get rid of the paris here)

save "C:\Documents and Settings\Packard Bell\Bureau\Explorations in Economic History\Final\table.dta", clear
