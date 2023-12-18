clear


set scheme neon
cap cd "D:\Dropbox\STATA - MEDIUM\PRESENTATION - PORTO 2023"
cap cd "C:\Users\asjad\Dropbox\STATA - MEDIUM\PRESENTATION - PORTO 2023"



import excel using  "./data/portugal_ICIO_clean.xlsx", clear first





split from, p(":")

drop from
order from1 from2

ren from1 from_id
ren from2 from_name




**** fix columns ****

egen secA   = rowtotal(D01T02Agriculturehuntingfo  - D03Fishingandaquaculture)
egen secB   = rowtotal(D05T06Miningandquarryingen  - D09Miningsupportserviceacti)
egen secC   = rowtotal(D10T12Foodproductsbeverages - D31T33Manufacturingnecrepai)
egen secD_E   = rowtotal(D35Electricitygassteamand D36T39Watersupplysewerage)
gen secF   = D41T43Construction
egen secG_T = rowtotal( D45T47Wholesaleandretailtra- D97T98Activitiesofhouseholds)


ren HFCEFinalconsumptionexpendit 	fd_HH	 
ren NPISHFinalconsumptionexpendi	fd_NPISH
ren GGFCFinalconsumptionexpendit	fd_GOV    
ren GFCFGrossFixedCapitalFormat     fd_GFCF
ren INVNTChangesininventories		fd_DeltaInv
ren CONS_ABRDirectpurchasesabroa    fd_HH_imports
ren CONS_NONRESDirectpurchasesby    fd_HH_exports

ren EXPOExportscrossborder    fd_exports
ren IMPOImportscrossborder    fd_imports

*replace fd_imports = abs(fd_imports)

drop D01T02Agriculturehuntingfo- D97T98Activitiesofhouseholds
order from_id from_name sec* fd*


**** fix rows ****

replace from_name = trim(from_name)

gen sec_id = ""
order sec_id


replace sec_id = "A: Agriculture" 				if inlist(from_name, "Agriculture, hunting, forestry", "Fishing and aquaculture")
replace sec_id = "B: Mining" 					if inlist(from_name, "Mining and quarrying, energy producing products", "Mining and quarrying, non-energy producing products", "Mining support service activities")

replace sec_id = "C: Production" 				if inlist(from_name, "Food products, beverages and tobacco", "Textiles, textile products, leather and footwear", "Wood and products of wood and cork", ///
										"Paper products and printing", "Coke and refined petroleum products", "Chemical and chemical products", "Pharmaceuticals, medicinal chemical and botanical products", ///
										"Rubber and plastics products", "Other non-metallic mineral products")
					
replace sec_id = "C: Production" 				if inlist(from_name,  "Basic metals", "Fabricated metal products", "Computer, electronic and optical equipment", "Electrical equipment", "Machinery and equipment, nec", "Motor vehicles, trailers and semi-trailers", "Other transport equipment", "Manufacturing nec; repair and installation of machinery and equipment")
replace sec_id = "D-E: Electricity & Water" 				if inlist(from_name, "Electricity, gas, steam and air conditioning supply")
replace sec_id = "D-E: Electricity & Water" 				if inlist(from_name, "Water supply; sewerage, waste management and remediation activities")
replace sec_id = "F: Construction" 				if inlist(from_name, "Construction")
replace sec_id = "G-T: Services" 				if inlist(from_name, "Wholesale and retail trade; repair of motor vehicles", "Land transport and transport via pipelines", "Water transport")
replace sec_id = "G-T: Services" 				if inlist(from_name, "Air transport", "Warehousing and support activities for transportation", "Postal and courier activities", "Accommodation and food service activities")
replace sec_id = "G-T: Services" 				if inlist(from_name, "Publishing, audiovisual and broadcasting activities", "Telecommunications", "IT and other information services")
replace sec_id = "G-T: Services" 				if inlist(from_name, "Financial and insurance activities")
replace sec_id = "G-T: Services" 				if inlist(from_name, "Real estate activities")
replace sec_id = "G-T: Services" 				if inlist(from_name, "Professional, scientific and technical activities", "Administrative and support services")
replace sec_id = "G-T: Services" 				if inlist(from_name, "Public administration and defence; compulsory social security", "Education", "Human health and social work activities")
replace sec_id = "G-T: Services" 				if inlist(from_name, "Arts, entertainment and recreation", "Other service activities", "Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use")
replace sec_id = "add_tax_sub_for" 	if  inlist(from_name, "Taxes less subsidies on intermediate and final products (paid in foreign countries)")
replace sec_id = "add_tax_sub_dom" 	if  inlist(from_name, "Taxes less subsidies on intermediate and final products (paid in domestic agencies, includes duty on imported products)")
replace sec_id = "add_int_cons" 	if  inlist(from_name, "Total intermediate consumption at purchasers’ prices")
replace sec_id = "add_valueadded" 	if  inlist(from_name, "Value added at basic prices")
replace sec_id = "add_output" 		if  inlist(from_name, "Output at basic prices")

drop from_id from_name
ren sec_id from

cap drop id
egen id = tag(from)
order id

replace id = sum(id)



collapse (sum) sec* fd*, by( id from)


compress
save "./data/IO_Portugal_2021_reduced.dta", replace


gen fd_C = fd_HH + fd_NPISH + fd_HH_imports
gen fd_I = fd_GFCF + fd_DeltaInv
gen fd_G = fd_GOV
gen fd_X = fd_exports + fd_HH_exports
gen fd_IM = fd_imports 


*drop fd_HH- fd_imports
*egen output = rowtotal(secA-fd_IM)
*export excel using IO_Portugal_2021_reduced.xlsx, replace first(var)


// layer 1

use "./data/IO_Portugal_2021_reduced", clear
keep fd_imports from
ren from to
gen from = "Imports"
ren fd_imports value
replace value = value * -1
drop if substr(to, 1, 3)=="add"
gen layer = 1
order layer from to value
save "./data/IO_Portugal_2021_1.dta", replace


**** layer 2
use "./data/IO_Portugal_2021_reduced", clear
drop fd_*
drop if substr(from,1,3)== "add"
reshape long sec , i(from) j(to) string
ren sec value
gen temp = 1 if !missing(value)
sort from temp to 
drop temp
drop id
gen layer=2
order layer from to value

replace to = "A: Agriculture" 	if to=="A"
replace to = "B: Mining" 		if to=="B"
replace to = "C: Production" 	if to=="C"
replace to = "D-E: Electricity & Water" 	if to=="D_E"
replace to = "F: Construction" 	if to=="F"
replace to = "G-T: Services" 	if to=="G_T"

save "./data/IO_Portugal_2021_2.dta", replace


**** layer 3
use "./data/IO_Portugal_2021_reduced", clear
drop sec*
drop if substr(from,1,3)== "add"
gen fd_C = fd_HH + fd_NPISH + fd_HH_imports
gen fd_I = fd_GFCF + fd_DeltaInv
gen fd_G = fd_GOV
gen fd_X = fd_exports + fd_HH_exports
drop fd_HH- fd_imports
reshape long fd , i(from) j(to) string
ren fd value
drop id
*replace to = subinstr(to, "_", "Final_", .)
replace to = "Consumption" if to == "_C"
replace to = "Investment" if to == "_I"
replace to = "Government" if to == "_G"
replace to = "Exports" if to == "_X"

gen layer=3
order layer from to value
save "./data/IO_Portugal_2021_3.dta", replace




use "./data/IO_Portugal_2021_1.dta", clear
append using "./data/IO_Portugal_2021_2.dta"
append using "./data/IO_Portugal_2021_3.dta"



replace to 		= subinstr(to	, "_", "-", .)
replace from 	= subinstr(from	, "_", "-", .)





sankey value if layer==2, from(from) to(to) by(layer) noval showtotal format(%10.0fc) ///
laba(0) labpos(3) labs(2.2) palette(tableau) offset(15) labgap(-1) lw(none) labc(white) alpha(50)  ///
title("{fontface Playfair Display SemiBold:Portugal's I-O Intermediate flows}", size(6)) ///
subtitle("(2021 USD million)", size(4)) ///
note("Source: OECD ICIO", size(3)) ///
xsize(2) ysize(1)
graph export  "./figures/IO_Portugal1.png", replace wid(2000)


* ssc install arcplot, replace

arcplot value if layer==2, from(from) to(to) palette(CET C6) gap(0.13) alpha(40) vallabc(white) valcond(5000) labsize(2) laba(0)  ///
xsize(5) ysize(3) 
graph export  "./figures/IO_Portugal2.png", replace wid(2000)


graph set window fontface "Abel"
sankey value, from(from) to(to) by(layer) noval showtotal format(%10.0fc) alpha(40) ///
	laba(0) labpos(3) labs(3) labc(white) palette(CET C6) offset(15) labgap(2) lw(none) labprop ///
	title("{fontface Playfair Display SemiBold:Portugal's Input-Output flows}", size(6)) ///
	subtitle("(2021 USD million)", size(4)) ///
	note("Source: OECD ICIO", size(3)) ///
	xsize(2) ysize(1)

graph export  "./figures/IO_Portugal_2021_USD.png", replace wid(2000)









