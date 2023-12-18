clear all


cap cd "D:\Dropbox\STATA - MEDIUM\PRESENTATION - PORTO 2023"
cap cd "C:\Users\asjad\Dropbox\STATA - MEDIUM\PRESENTATION - PORTO 2023"


graph set window fontface "Abel"  // needs to be downloaded and installed

*ssc install schemepack, replace
*ssc install palettes, replace
*ssc install colrspace, replace


set scheme neon


use "./data/demo_r_pjangrp3_clean.dta"


drop year
keep NUTS_ID y_TOT

drop if y_TOT==0

keep if length(NUTS_ID)==5



gen NUTS2 = substr(NUTS_ID, 1, 4)
gen NUTS1 = substr(NUTS_ID, 1, 3)
gen NUTS0 = substr(NUTS_ID, 1, 2)
ren NUTS_ID NUTS3
order NUTS0 NUTS1 NUTS2 NUTS3

keep if NUTS0=="PT"

foreach x of varlist NUTS2 NUTS3 {
ren `x' nuts_id
merge m:1 nuts_id using ./data/NUTS_NAME
keep if _m==3
drop _m
ren nuts_id `x'
ren nuts_name `x'_name

replace `x'_name = subinstr(`x'_name, "Área Metropolitana de ", "", .)
replace `x'_name = subinstr(`x'_name, "Área Metropolitana do ", "", .)
replace `x'_name = subinstr(`x'_name, "Região Autónoma da ", "", .)
replace `x'_name = subinstr(`x'_name, "Região Autónoma dos ", "", .)
}


compress


gen name1 = ""
replace name1 = "Continente" if NUTS1 == "PT1"
replace name1 = "Açores" if NUTS1 == "PT2"
replace name1 = "Madeira" if NUTS1 == "PT3"

gen name2 = NUTS2 + ": " + NUTS2_name
gen name3 = NUTS3 + ": " + NUTS3_name


graph hbar (sum) y_TOT, over(name2) ytitle("Persons") ylabel(, format(%12.0fc)) ///
	title("{fontface Playfair Display SemiBold:Population of NUTS2 regions}") ///
	note("Source: Eurostat") xsize(1) ysize(1) scheme(black_tableau)
graph export  "./figures/pop_bar1.png", replace wid(2000)


graph pie y_TOT, over(name2) plabel(_all percent, color(black) format(%9.2f)) ///
title("{fontface Playfair Display SemiBold:Population of NUTS2 regions}") ///
	legend( pos(6) rows(2)) ///
	note("Source: Eurostat")  xsize(1) ysize(1)  scheme(black_tableau)
graph export  "./figures/pop_pie1.png", replace wid(2000)

*circlebar y_TOT, by(name2) cfill(black) labc(white)
*circlebar y_TOT, by(name2) stack(name3) cfill(black) labc(white)


*ssc install treemap, replace


treemap y_TOT, by(name2) ///
	title("{fontface Playfair Display SemiBold:Population of NUTS2 regions}") ///
	note("Source: Eurostat table demo_r_pjangrp3.", size(2)) ///
	addtitles labsize(2) format(%15.0fc) palette(tableau) share labprop colorprop
graph export  "./figures/pop_treemap1.png", replace wid(2000)

treemap y_TOT, by(name1 name2) ///
	title("{fontface Playfair Display SemiBold:Population of NUTS2 regions}") ///
	note("Source: Eurostat table demo_r_pjangrp3.", size(2)) ///
	addtitles labsize(2) format(%15.0fc) palette(tableau) share labprop colorprop
graph export  "./figures/pop_treemap2.png", replace wid(2000)

treemap y_TOT, by(name2 name3) ///
	title("{fontface Playfair Display SemiBold:Population of NUTS3 regions}") ///
	note("Source: Eurostat table demo_r_pjangrp3.", size(2)) ///
	addtitles labsize(2) format(%15.0fc) palette(tableau) share labprop colorprop
graph export  "./figures/pop_treemap3.png", replace wid(2000)


*ssc install circlepack, replace

circlepack y_TOT, by(name1 name2 name3) ///
	title("{fontface Playfair Display SemiBold:Population of NUTS3 regions}") ///
	note("Source: Eurostat table demo_r_pjangrp3.", size(2)) ///
	labsize(3) format(%15.0fc) palette(tableau) labprop  labc(black)
graph export  "./figures/pop_circlepack3.png", replace wid(2000)	
	
circlepack y_TOT, by(name2 name3) ///
	title("{fontface Playfair Display SemiBold:Population of NUTS3 regions}") ///
	note("Source: Eurostat table demo_r_pjangrp3.", size(2)) ///
	labsize(3) format(%15.0fc) palette(tableau) labprop labc(black)
graph export  "./figures/pop_circlepack1.png", replace wid(2000)

circlepack y_TOT, by(name3) ///
	title("{fontface Playfair Display SemiBold:Population of NUTS3 regions}") ///
	note("Source: Eurostat table demo_r_pjangrp3.", size(2)) ///
	labsize(3) format(%8.1f) palette(tableau) labprop share labc(black)
graph export  "./figures/pop_circlepack2.png", replace wid(2000)



*ssc install sunburst, replace
	
sunburst y_TOT, by(name2 name3) ///
	title("{fontface Playfair Display SemiBold:Population of NUTS3 regions}") ///
	note("Source: Eurostat table demo_r_pjangrp3.", size(2)) ///
	 format(%15.0fc) palette(tableau) labprop labsize(2 2) colorprop cfill(black)
	 graph export  "./figures/pop_sunburst1.png", replace wid(2000)
	 
	 
	 
*ssc install treecluster, replace	 
	 
treecluster y_TOT, by(name2 name3) ///
	title("{fontface Playfair Display SemiBold:Population of NUTS2 and NUTS3 regions}") ///
	note("Source: Eurostat table demo_r_pjangrp3.", size(2)) ///
	 format(%15.0fc) xsize(2) ysize(1) offset(0.2) lc(eltblue) labs(2)
	 graph export  "./figures/pop_treecluster1.png", replace wid(2000)
	 
treecluster y_TOT, by(NUTS2 NUTS3) ///
	 format(%15.0fc) xsize(1) ysize(1) aspect(1) laboffset(0.4) offset(0.1) lc(eltblue) labs(1.6) polar radius(0.5 2)
	 graph export  "./figures/pop_treecluster2.png", replace wid(2000)	 
	 
	 
	 
	 