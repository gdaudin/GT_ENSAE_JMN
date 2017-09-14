cd "C:\Users\Packabell\Documents\Courses\JIE\Stata"
use table, replace

keep if year==1870|year==1913|year==1921|year==1939|year==1950|year==2000
sort ctry1 ctry2 year
gen dlnxijxji=0.5*(ln(trade12[_n])+ln(trade21[_n])-ln(trade12[_n-1])-ln(trade21[_n-1]))
gen abscisse=1/2*log(trade12*trade21)
replace abscisse=abscisse[_n-1] if year==1913|year==2000

keep if year==1913 | year==2000

scatter dlnxijxji abscisse, by(year)

reg dlnxijxji abscisse if year==1913 
reg dlnxijxji abscisse if year==2000

gen firstglob=(year==2000)

gen abscissefirstglob=abscisse*firstglob

reg dlnxijxji abscisse firstglob abscissefirstglob 

//`"{&Delta}ln({&sqrt}x{subscript:ij}x{subscript:ji})"'
//`"ln({&sqrt}x{subscript:ij}x{subscript:ji}) (beginning of period)"'

sort abscisse
