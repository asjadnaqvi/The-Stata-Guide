clear 

set scheme neon
graph set window fontface "Abel"

cap cd "D:\Dropbox\STATA - MEDIUM\PRESENTATION - PORTO 2023"


** newer version is not currently on SSC
net install streamplot, from("https://raw.githubusercontent.com/asjadnaqvi/stata-streamplot/main/installation/") replace


import excel using "./data/GDP_expenditure.xlsx", clear first

lab var GDP "GDP (chain-linked EUR million)"

foreach x of varlist _all {
	format `x' %12.0fc
}

format date %tdMon-YY


* gen temp = GDP - (C + I + G + X - M)  // minor statistical discrepencies



*** graphs

colorpalette tableau, nograph


twoway ///
	(line GDP date, lw(0.8) lc("`r(p1)'") ) ///
	, ///
	xlabel(, labsize(3.5)) ///
	ylabel(, labsize(3.5)) ///
	xtitle("") ///
	ytitle("EUR million") ///
	title("{fontface Playfair Display SemiBold:Portugal's GDP}") ///
	subtitle("EUR million chain-linked quarterly data") ///
	note("Source: Banco de Portugal", size(2)) xsize(2) ysize(1)
graph export  "./figures/gdp_line1.png", replace wid(2000)	
	
	
colorpalette tableau, nograph	
	
twoway ///
	(line C date, lw(0.8) lc("`r(p1)'")) ///
	(line I date, lw(0.8) lc("`r(p2)'")) ///
	(line G date, lw(0.8) lc("`r(p3)'")) ///
	(line X date, lw(0.8) lc("`r(p4)'")) ///
	(line M date, lw(0.8) lc("`r(p5)'")) ///
	, ///
		xlabel(, labsize(3.5)) ///
	ylabel(, labsize(3.5)) ///
	xtitle("") ///
	ytitle("EUR million") ///
	legend( pos(3) col(1) size(4)) ///
	title("{fontface Playfair Display SemiBold:Portugal's GDP}") ///
	subtitle("EUR million chain-linked quarterly data") ///
	note("Source: Banco de Portugal", size(2)) xsize(2) ysize(1)
graph export  "./figures/gdp_line2.png", replace wid(2000)		
	
	
cap drop GDP	




foreach x of varlist C I G X M {
	ren `x' y`x'
}

reshape long y, i(date) j(exp) string

ren y val	
sort exp date

gen exp2 = .
replace exp2 = 1 if exp=="M"
replace exp2 = 2 if exp=="X"
replace exp2 = 3 if exp=="G"
replace exp2 = 4 if exp=="I"
replace exp2 = 5 if exp=="C"

*labmask exp2, val(exp)

lab de exp2 1 "Imports" 2 "Exports" 3 "Goverment" 4 "Investment" 5 "Consumption"
lab val exp2 exp2


streamplot val date, by(exp2) ylabsize(2.2) recen(bot) smooth(1) lc(black) ///
	palette(tableau) xsize(2) ysize(1) xtitle("") ///
	title("{fontface Playfair Display SemiBold:Portugal's GDP by expenditure}") ///
	subtitle("EUR million chain-linked quarterly data") ///
	note("Source: Banco de Portugal", size(2))  
graph export  "./figures/streamplot1.png", replace wid(2000)	
	
streamplot val date, by(exp2) ylabsize(2.2)	smooth(1) lc(black) ///
	palette(tableau) xsize(2) ysize(1) xtitle("") ///
	title("{fontface Playfair Display SemiBold:Portugal's GDP by expenditure}") ///
	subtitle("EUR million chain-linked quarterly data") ///
	note("Source: Banco de Portugal", size(2)) 
graph export  "./figures/streamplot2.png", replace wid(2000)


	
cap drop ns
gen ns = 2
replace ns = 1 if exp2==1
		
streamplot val date, by(exp2) cat(ns) ylabsize(2.2)	smooth(1) lc(black) ///
	palette(tableau) xsize(2) ysize(1) xtitle("") ///
	title("{fontface Playfair Display SemiBold:Portugal's GDP by expenditure}") ///
	subtitle("EUR million chain-linked quarterly data") ///
	note("Source: Banco de Portugal", size(2)) 
graph export  "./figures/streamplot3.png", replace wid(2000)	
	
streamplot val date, by(exp2) cat(ns) ylabsize(2.2)	smooth(1) percent format(%5.2f) lc(black) ///
	palette(tableau) xsize(2) ysize(1) xtitle("") ///
	title("{fontface Playfair Display SemiBold:Portugal's GDP by expenditure}") ///
	subtitle("EUR million chain-linked quarterly data") ///
	note("Source: Banco de Portugal", size(2)) 
graph export  "./figures/streamplot4.png", replace wid(2000)	
	

	
	
	