gen yij2=xij*xji
gen aij2=xii*xjj
gen bij2=(xij*xji)/(xii*xjj)

bysort ctyi year : egen yi2 = mean(yij2)
bysort ctyi year : egen ai2 = mean(aij2)
bysort ctyi year : egen bi2 = mean(bij2)

gen dyi2=0
gen dai2=0
gen dbi2=0

bysort ctyi ctyj (year) : replace dyi2=yi2[2]/yi2[1]-1
bysort ctyi ctyj (year) : replace dai2=ai2[2]/ai2[1]-1
bysort ctyi ctyj (year) : replace dbi2=bi2[2]/bi2[1]-1

keep dyi dyi2 dai dai2 dbi dbi2
