
*cd "C:\Users\Packabell\Documents\Courses\JIE\Stata"

if "`c(username)'"=="guillaumedaudin" cd "~/Documents/Recherche/Coûts du commerce - ancien ENSAE/Stata"









capture program drop for_square
program  for_square
args sqrlist

use table, clear
keep if year==2000

keep if strpos("`sqrlist'", ctry1)!=0 & strpos("`sqrlist'", ctry2)!=0



preserve
encode ctry2, gen(ctry2_num)
collapse (count) ctry2_num, by(ctry1)

rename ctry1 ctry

save blink.dta, replace



restore
encode ctry1, gen(ctry1_num)
collapse (count) ctry1_num, by(ctry2)

rename ctry2 ctry

merge 1:1 ctry using blink
erase blink.dta
replace ctry1_num=0 if ctry1==.
replace ctry2_num=0 if ctry2==.
gen nbr_part=ctry1_num+ctry2_num

drop ctry1_num-_merge 

codebook nbr_part

end

 for_square "UK FRA USA IND BEL CAN GER ITA SPA"
 
 **C'est le plus grand que j'ai trouvé**




