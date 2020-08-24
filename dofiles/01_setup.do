clear

cd "D:/Programs/Dropbox/Dropbox/PROJECT COVID - MEDIUM"


***********************************
**** our worldindata ECDC dataset
***********************************


insheet using "https://covid.ourworldindata.org/data/ecdc/full_data.csv", clear
save ./raw/full_data_raw.dta, replace


gen year  = substr(date,1,4)
gen month = substr(date,6,2)
gen day   = substr(date,9,2)

destring year month day, replace

drop date
gen date = mdy(month,day,year)
format date %tdDD-Mon-yyyy
drop year month day
gen date2 = date
order date date2
drop if date2 < 21915


gen group = .

replace group = 1 if ///
	location == "Austria" 			|	///	
	location == "Belgium" 			|	///
	location == "Czech Republic" 	|	///
	location == "Denmark"    		| 	///
	location == "Finland"   		|	///
	location == "France" 			|	///
	location == "Germany" 			|	///
	location == "Greece" 			|	///
	location == "Hungary" 			|	///
	location == "Italy" 			|	///
	location == "Ireland"			| 	///
	location == "Netherlands" 		|	///
	location == "Norway" 			| 	///
	location == "Poland" 			|	///
	location == "Portugal" 			| 	///
	location == "Slovenia" 			|	///
	location == "Slovak Republic" 	| 	///
	location == "Spain"				| 	///
	location == "Sweden"			|	///
	location == "Switzerland"		|	///
	location == "United Kingdom" 	 	
	 		

keep if group==1


ren location country
tab country
compress
save "./temp/OWID_data.dta", replace



**** adding the population data

insheet using "https://covid.ourworldindata.org/data/ecdc/locations.csv", clear
drop countriesandterritories population_year
ren location country
compress
save "./temp/OWID_pop.dta", replace



**** merging the two datasets

use ./temp/OWID_data, clear
merge m:1 country using ./temp/OWID_pop

drop if _m!=3
drop _m



***** fixing the data: PART 2



***** generating population normalized variables

gen total_cases_pop  = (total_cases  / population) * 1000000
gen total_deaths_pop = (total_deaths / population) * 1000000



*** declare the data panel
encode country, gen(id)
order id
xtset id date



*** generate 3-day smoothing averages of new cases/deaths
tssmooth ma new_cases_ma3  = new_cases , w(2 1 0) 
tssmooth ma new_deaths_ma3 = new_deaths, w(2 1 0)

*** generate 7-day smoothing averages of new cases/deaths
tssmooth ma new_cases_ma7  = new_cases , w(6 1 0) 
tssmooth ma new_deaths_ma7 = new_deaths, w(6 1 0)


*** just for comparison. 

sort country date
bysort country: gen new_cases_ma3_2 = (new_cases + new_cases[_n-1] + new_cases[_n-2]) / 3
br new_cases_ma3 new_cases_ma3_2
compare new_cases_ma3 new_cases_ma3_2
drop new_cases_ma3_2




*** generating logs of variables
gen total_cases_log  	 = log(total_cases)
gen total_deaths_log	 = log(total_deaths)
gen total_cases_pop_log  = log(total_cases_pop)
gen total_deaths_pop_log = log(total_deaths_pop)


**** label the variables for completeness

lab var id				 "Country"
lab var date			 "Date"

lab var total_cases  	 "Total cases"
lab var total_deaths 	 "Total deaths"
lab var total_cases_pop  "Total cases per one million population"
lab var total_deaths_pop "Total deaths per one million population"
lab var new_cases		 "New cases"
lab var new_deaths		 "New deaths"

lab var new_cases_ma3  	 "New cases (3-day moving average)"
lab var new_deaths_ma3 	 "New deaths (3-day moving average)"
lab var new_cases_ma7  	 "New cases (7-day moving average)"
lab var new_deaths_ma7 	 "New deaths (7-day moving average)"

lab var total_cases_log  	  "Total cases (Log)"
lab var total_deaths_log  	  "Total deaths (Log)"
lab var total_cases_pop_log   "Total cases per one million population (Log)"
lab var total_deaths_pop_log  "Total deaths per one million population (Log)"




***** save the file
compress
save ./master/COVID_data.dta, replace


**** END OF FILE ****

