use "C:\Users\Packabell\Documents\Cours\Explorations in Economic History\Final\decomposition.dta", clear
keep if year==1870|year==1913

sort ctyi ctyj year

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

bysort ctyi ctyj (year) : gen dlnyij=lnyij[2]-lnyij[1]
bysort ctyi ctyj (year) : gen dlnaij=lnaij[2]-lnaij[1]
bysort ctyi ctyj (year) : gen dlnbij=lnbij[2]-lnbij[1]

// for pooled
preserve
drop if ctyi=="France" & ctyj=="UK" |ctyi=="UK" & ctyj=="USA" |ctyi=="USA" & ctyj=="France" 
egen moyennedlna=mean(dlnaij)
egen moyennedlnb=mean(dlnbij)
egen moyennedlny=mean(dlnyij)
gen mdlnamdlny= moyennedlna/moyennedlny
gen mdlnbmdlny= moyennedlnb/moyennedlny
table moyennedlny
table moyennedlna
table moyennedlnb
table mdlnamdlny
table mdlnbmdlny
restore

// Theirs no log
// Careful : average of growth rates, nto the opposite

gen dyij=0
gen daij=0
gen dbij=0

bysort ctyi ctyj (year) : replace dyij=yij[2]/yij[1]-1
bysort ctyi ctyj (year) : replace daij=aij[2]/aij[1]-1
bysort ctyi ctyj (year) : replace dbij=bij[2]/bij[1]-1

bysort ctyi year : egen dyi = mean(dyij)
bysort ctyi year : egen dai = mean(daij)
bysort ctyi year : egen dbi = mean(dbij)

// Pour moyenne "mondiale" (drop doublons first)
preserve 
drop if ctyi=="France" & ctyj=="UK" |ctyi=="UK" & ctyj=="USA" |ctyi=="USA" & ctyj=="France" 
bysort year : egen moyennedy = mean(dyij)
bysort year : egen moyenneda = mean(daij)
bysort year : egen moyennedb = mean(dbij)
table moyennedy
table moyenneda
table moyennedb
restore

// 2. Theirs log, weighted mean of growth rates (what is consistent with the method)

gen productij=dlnyij*gdpj
bysort ctyi year : egen totalweight=sum(gdpj)
bysort ctyi year : egen auxi=sum(productij)
gen dlnyiw= auxi/totalweight
drop productij totalweight auxi
gen productij=dlnaij*gdpj
bysort ctyi year : egen totalweight=sum(gdpj)
bysort ctyi year : egen auxi=sum(productij)
gen dlnaiw= auxi/totalweight
drop productij totalweight auxi
gen productij=dlnbij*gdpj
bysort ctyi year : egen totalweight=sum(gdpj)
bysort ctyi year : egen auxi=sum(productij)
gen dlnbiw= auxi/totalweight
drop productij totalweight auxi

gen lnawlnyw= dlnaiw/dlnyiw
gen lnbwlnyw= dlnbiw/dlnyiw

// reading the table : in 1870 = weigthed with 1870 GDP; in 1913 = weighted with 1913's

// for pooled
preserve
drop if ctyi=="France" & ctyj=="UK" |ctyi=="UK" & ctyj=="USA" |ctyi=="USA" & ctyj=="France" 
gen productij=dlnyij*gdpi*gdpj
bysort year : egen totalweight=sum(gdpi*gdpj)
bysort year : egen auxi=sum(productij)
gen moyennedlnyw= auxi/totalweight
drop productij totalweight auxi
gen productij=dlnaij*gdpi*gdpj
bysort year : egen totalweight=sum(gdpi*gdpj)
bysort year : egen auxi=sum(productij)
gen moyennedlnaw= auxi/totalweight
drop productij totalweight auxi
gen productij=dlnbij*gdpi*gdpj
bysort year : egen totalweight=sum(gdpi*gdpj)
bysort year : egen auxi=sum(productij)
gen moyennedlnbw= auxi/totalweight
drop productij totalweight auxi
gen mdlnawmdlnyw= moyennedlnaw/moyennedlnyw
gen mdlnbwmdlnyw= moyennedlnbw/moyennedlnyw
table year moyennedlnyw
table year moyennedlnaw
table year moyennedlnbw
table year mdlnawmdlnyw
table year mdlnbwmdlnyw
restore

// Theirs weigthed no log
// reminder = average of growth rate, not...

gen productij=dyij*gdpj
bysort ctyi year : egen totalweight=sum(gdpj)
bysort ctyi year : egen auxi=sum(productij)
gen dyiw= auxi/totalweight
drop productij totalweight auxi
gen productij=daij*gdpj
bysort ctyi year : egen totalweight=sum(gdpj)
bysort ctyi year : egen auxi=sum(productij)
gen daiw= auxi/totalweight
drop productij totalweight auxi
gen productij=dbij*gdpj
bysort ctyi year : egen totalweight=sum(gdpj)
bysort ctyi year : egen auxi=sum(productij)
gen dbiw= auxi/totalweight
drop productij totalweight auxi

// all, drop doublons first
preserve 
drop if ctyi=="France" & ctyj=="UK" |ctyi=="UK" & ctyj=="USA" |ctyi=="USA" & ctyj=="France" 
gen productij=dyij*gdpi*gdpj
bysort year : egen totalweight=sum(gdpi*gdpj)
bysort year : egen auxi=sum(productij)
gen moyennedyw= auxi/totalweight
drop productij totalweight auxi
gen productij=daij*gdpi*gdpj
bysort year : egen totalweight=sum(gdpi*gdpj)
bysort year : egen auxi=sum(productij)
gen moyennedaw= auxi/totalweight
drop productij totalweight auxi
gen productij=dbij*gdpi*gdpj
bysort year : egen totalweight=sum(gdpi*gdpj)
bysort year : egen auxi=sum(productij)
gen moyennedbw= auxi/totalweight
drop productij totalweight auxi
table year moyennedyw
table year moyennedaw
table year moyennedbw
restore

// Here again, date of GDP for weighting changes quite a lot stuffs

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

/////////////////
// Some tests to show that can be lower decrease for index but higher for 1+index

bysort ctyi ctyj (year) : gen dtaui=taui[2]/taui[1]-1
bysort ctyi ctyj (year) : gen dtauiw=tauiw[2]/tauiw[1]-1
bysort ctyi ctyj (year) : gen dupsiloni=upsiloni[2]/upsiloni[1]-1


bysort ctyi ctyj (year) : gen dunplustauij=(1+tauij[2])/(1+tauij[1])-1

bysort ctyi year : egen dunplustaui = mean(dunplustauij)

gen productij=dunplustauij*gdpj
bysort ctyi year : egen totalweight=sum(gdpj)
bysort ctyi year : egen auxi=sum(productij)
gen dunplustauiw= auxi/totalweight
drop productij totalweight auxi

bysort ctyi ctyj (year) : gen dunplusupsiloni=(1+upsiloni[2])/(1+upsiloni[1])-1

keep 

