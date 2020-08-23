clear
cd "D:/Programs/Dropbox/Dropbox/PROJECT COVID - MEDIUM"


use ./master/COVID_data.dta


**** export a basic graph
xtline total_cases_pop, overlay
graph export ./graphs/total_cases_pop_1.png, replace wid(1000)


**** drop dates before 15 February
drop if date < 21960
format date %tdDD-Mon
summ date



*** graph 2
xtline total_cases_pop, overlay ttitle(" ") tlabel(21960(15)22180, labsize(small) angle(vertical)) legend(off)
graph export ./graphs/total_cases_pop_2.png, replace wid(1000)


*** graph 3
xtline total_cases_pop ///
	, overlay ///
		ttitle("") ///
		tlabel(21960(15)22180, labsize(small) angle(vertical) grid) ///
		title(COVID19 trends for European countries) ///
		note(Source: ECDC via Our World in Data) legend(off)
graph export ./graphs/total_cases_pop_3.png, replace wid(1000)		


*** graph 4
xtline total_cases_pop ///
	, overlay ///
		ttitle("") ///
		tlabel(21960(15)22180, labsize(small) angle(vertical) grid) ///
		title(COVID19 trends for European countries) ///
		note(Source: ECDC via Our World in Data) ///
		legend(off) ///
		graphregion(fcolor(white))
graph export ./graphs/total_cases_pop_4.png, replace wid(1000)		


**** graph 5
summ date
return list

summ date, d
return list



summ date
local start = `r(min)'
local end   = `r(max)' + 30

display `start'
display `end'


xtline total_cases_pop ///
	, overlay ///
		ttitle("") ///
		tlabel(`start'(15)`end', labsize(small) angle(vertical) grid) ///
		title(COVID19 trends for European countries) ///
		note(Source: ECDC via Our World in Data) ///
		legend(off) ///
		graphregion(fcolor(white))
graph export ./graphs/total_cases_pop_5.png, replace wid(1000)		


**** graph 6
summ date
gen tick = 1 if date == `r(max)'


summ date
local start = `r(min)'
local end   = `r(max)' + 30

display `start'
display `end'

xtline total_cases_pop ///
	, overlay ///
		addplot((scatter total_cases_pop date if tick==1, mcolor(black) msymbol(point) mlabel(country) mlabsize(vsmall) mlabcolor(black))) ///
		ttitle("") ///
		tlabel(`start'(15)`end', labsize(small) angle(vertical) grid) ///
		title(COVID19 trends for European countries) ///
		note(Source: ECDC via Our World in Data) ///
		legend(off) ///
		graphregion(fcolor(white))
graph export ./graphs/total_cases_pop_6.png, replace wid(1000)	






