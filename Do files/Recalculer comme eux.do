
*cd "C:\Users\Packabell\Documents\Courses\JIE\Stata"

if "`c(username)'"=="guillaumedaudin" cd "~/Documents/Recherche/Coûts du commerce - ancien ENSAE/Stata"

use tbtbtc, replace

gen tau_1_2 = ((gdp1-exp1)*(gdp2-exp2)*1000000^2/(trade12*trade21))^(1/(2*(8-1)))-1







