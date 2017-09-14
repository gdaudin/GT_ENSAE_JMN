use "C:\Users\Packabell\Documents\Cours\Explorations in Economic History\Final\table_final.dta", clear
keep year ctyi ctyj xji xij gdpj exportsj gdpi exportsi idpaysi idpaysj idyear ctypair
keep if year<=1913
drop if ctyj=="India"
gen xii=(gdpi-exportsi)
gen xjj=(gdpj-exportsj)
scalar sigma=11
gen tauij=(0.64*(xii*xjj)/(xij*xji))^(1/(2*(sigma-1)))-1

sort ctyi year ctyj

plot xij year if ctyi=="USA" & ctyj=="Sweden"

keep if year==1870|year==1913

gen gexp=0
bysort ctyi ctyj (year) : replace gexp=(xij[2]/xij[1])
gen gimp=0
bysort ctyi ctyj (year) : replace gimp=(xji[2]/xji[1])
gen impexp=sqrt(xij*xji)
gen gimpexp=0
bysort ctyi ctyj (year) : replace gimpexp=(impexp[2]/impexp[1])

gen gexportsi=0
bysort ctyi ctyj (year) : replace gexportsi=(exportsi[2]/exportsi[1])

gen share=impexp/exportsi*100
gen shareexp=xij/exportsi*100
gen gshareexp=0
bysort ctyi ctyj (year) : replace gshareexp=(shareexp[2]/shareexp[1])


keep ctyi ctyj year gimp gexp gimpexp share shareexp gexportsi gshareexp

sort ctyi gimp year

//Careful change = no -1 in growth so = times multplied and not percentage growth

// share= only divided by exp for commodity (but = mean geo no pb)
// Well no if graph selected = exports then...

twoway (scatter gimpexp share if year==1870, by(ctyi))

twoway (scatter gimp share if year==1870 & ctyj !="Australia" & ctyj !="NZ", by(ctyi))

twoway (scatter gexp share if year==1870, by(ctyi))

// below the one in the paper
scatter gexp shareexp if year==1870, by(ctyi) yscale(log)

// in log instead
gen lngexp=ln(gexp)
twoway (scatter lngexp shareexp if year==1870, by(ctyi))



// Below no use (graph and reg)

// Using growth of share is confusing, remain in "levels"

twoway (scatter gimp xji if year==1870 & ctyi=="France") (lfit gimp xji if year==1870 & ctyi=="France") 

twoway (scatter gimp xji if year==1870 & ctyi=="UK") (lfit gimp xji if year==1870 & ctyi=="UK")

twoway (scatter gimp xji if year==1870 & ctyi=="USA") (lfit gimp xji if year==1870 & ctyi=="USA")


twoway (scatter gexp xij if year==1870 & ctyi=="France") (lfit gexp xij if year==1870 & ctyi=="France") 

twoway (scatter gexp xij if year==1870 & ctyi=="UK") (lfit gexp xij if year==1870 & ctyi=="UK")

twoway (scatter gexp xij if year==1870 & ctyi=="USA") (lfit gexp xij if year==1870 & ctyi=="USA")


twoway (scatter gimpexp share if year==1870 & ctyi=="France") (lfit gimpexp share if year==1870 & ctyi=="France")

twoway (scatter gimpexp share if year==1870 & ctyi=="UK")(lfit gimpexp share if year==1870 & ctyi=="UK")

twoway (scatter gimpexp share if year==1870 & ctyi=="USA")(lfit gimpexp share if year==1870 & ctyi=="USA")






reg gimp xji if year==1870 & ctyi=="France"
scalar S = _b[xji]/_se[xji]
di "P_value =  " ttail(15,S)
reg gimp xji if year==1870 & ctyi=="UK"
scalar S = _b[xji]/_se[xji]
di "P_value =  " ttail(15,S)
reg gimp xji if year==1870 & ctyi=="USA"
scalar S = _b[xji]/_se[xji]
di "P_value =  " ttail(15,S)

reg gexp xij if year==1870 & ctyi=="France"
scalar S = _b[xij]/_se[xij]
di "P_value =  " ttail(15,S)
reg gexp xij if year==1870 & ctyi=="UK"
scalar S = _b[xij]/_se[xij]
di "P_value =  " ttail(15,S)
reg gexp xij if year==1870 & ctyi=="USA"
scalar S = _b[xij]/_se[xij]
di "P_value =  " ttail(15,S)

reg gimpexp impexp if year==1870 & ctyi=="France"
scalar S = _b[impexp]/_se[impexp]
di "P_value =  " ttail(15,S)
reg gimpexp impexp if year==1870 & ctyi=="UK"
scalar S = _b[impexp]/_se[impexp]
di "P_value =  " ttail(15,S)
reg gimpexp impexp if year==1870 & ctyi=="USA"
scalar S = _b[impexp]/_se[impexp]
di "P_value =  " ttail(15,S)

gen dummy=(ctyi=="USA")
gen dummyimpexp=dummy*impexp

reg gimpexp impexp dummy dummyimpexp if year==1870 & ctyj !="NZ" & ctyj != "Australia"
scalar S = _b[dummyimpexp]/_se[dummyimpexp]
di "P_value =  " ttail(15,S)

gen share=xij/exportsi
gen gshare=0
bysort ctyi ctyj (year) : replace gshare=(share[2]/share[1]-1)

gen dummyshare=dummy*share
reg gshare share dummy dummyshare if year==1870
scalar S = _b[dummyshare]/_se[dummyshare]
di "P_value =  " ttail(15,S)



