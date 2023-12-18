clear 

set scheme neon
graph set window fontface "Abel"

cap cd "D:\Dropbox\STATA - MEDIUM\PRESENTATION - PORTO 2023"
cap cd "C:\Users\asjad\Dropbox\STATA - MEDIUM\PRESENTATION - PORTO 2023"


use ./data/nama_10r_3gdp


keep if substr(NUTS_ID,1,2)=="PT"

keep if unit=="MIO_PPS_EU27_2020"
drop unit

keep if length(NUTS_ID)==5

ren NUTS_ID nuts_id

merge m:1 nuts_id using ./data/NUTS_NAME
keep if _m==3
drop _m

foreach x of varlist nuts_name {
replace `x' = subinstr(`x', "Área Metropolitana de ", "", .)
replace `x' = subinstr(`x', "Área Metropolitana do ", "", .)
replace `x' = subinstr(`x', "Região Autónoma da ", "", .)
replace `x' = subinstr(`x', "Região Autónoma dos ", "", .)
}

gen name2 = nuts_id + ": " + nuts_name


levelsof nuts_id, local(lvls)

local z = 1

colorpalette tableau, nograph


foreach x of local lvls {
	local lines `lines' (line y year if nuts_id=="`x'", lw(0.4) lc("`r(p`z')'"%80)) ///

	local points `points' (scatter y year if year==2021 & nuts_id=="`x'", msym(none) mlab(name2) mlabc("`r(p`z')'") mlabsize(2.5))
	
	local z = `z' + 1
}


twoway ///
	`lines' ///
	`points' ///
	, ///
	legend(off) ///
	xscale(range(2000 2025)) ///
	xtitle("") ytitle("EUR") ///
	title("{fontface Playfair Display SemiBold:Portugal's NUTS3 real GDP per capita}") ///
	note("Source: Eurostat table nama_10r_3gdp", size(2))  ///
	xsize(2) ysize(1)
graph export  "./figures/gdppc1.png", replace wid(2000)


*ssc install bumpline, replace

bumpline y year, by(name2) top(15) palette(tableau) ///
	xsize(2) ysize(1) labs(2.5) offset(20) msize(1.2) lw(1) ///
	title("{fontface Playfair Display SemiBold:Portugal's NUTS3 real GDP per capita (Top 15)}") ///
	note("Source: Eurostat table nama_10r_3gdp", size(2)) 
graph export  "./figures/bumpline1.png", replace wid(2000)
	

*ssc install bumparea, replace	
	
bumparea y year, by(name2) top(15) palette(tableau) ///
	xsize(2) ysize(1) labs(2.5) smooth(8) offset(23) lc(black) ///
	title("{fontface Playfair Display SemiBold:Portugal's NUTS3 real GDP per capita (EUR)}") ///
	note("Source: Eurostat table nama_10r_3gdp", size(2)) 
graph export  "./figures/bumpline2.png", replace wid(2000)





	
	