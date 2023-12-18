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
gen secD   = D35Electricitygassteamand
gen secE   = D36T39Watersupplysewerage
gen secF   = D41T43Construction
egen secG_I = rowtotal(D45T47Wholesaleandretailtra - D55T56Accommodationandfoods)
egen secJ   = rowtotal(D58T60Publishingaudiovisual - D62T63ITandotherinformation)
gen secK   = D64T66Financialandinsurance
gen secL   = D68Realestateactivities
egen secM_N = rowtotal(D69T75Professionalscientific - D77T82Administrativeandsuppo)
egen secO_Q = rowtotal(D84Publicadministrationandd  - D86T88Humanhealthandsocial)
egen secR_T = rowtotal(D90T93Artsentertainmentand   - D97T98Activitiesofhouseholds)

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


replace sec_id = "A" 				if inlist(from_name, "Agriculture, hunting, forestry", "Fishing and aquaculture")
replace sec_id = "B" 				if inlist(from_name, "Mining and quarrying, energy producing products", "Mining and quarrying, non-energy producing products", "Mining support service activities")

replace sec_id = "C" 				if inlist(from_name, "Food products, beverages and tobacco", "Textiles, textile products, leather and footwear", "Wood and products of wood and cork", ///
										"Paper products and printing", "Coke and refined petroleum products", "Chemical and chemical products", "Pharmaceuticals, medicinal chemical and botanical products", ///
										"Rubber and plastics products", "Other non-metallic mineral products")
					
replace sec_id = "C" 				if inlist(from_name,  "Basic metals", "Fabricated metal products", "Computer, electronic and optical equipment", "Electrical equipment", "Machinery and equipment, nec", "Motor vehicles, trailers and semi-trailers", "Other transport equipment", "Manufacturing nec; repair and installation of machinery and equipment")
replace sec_id = "D" 				if inlist(from_name, "Electricity, gas, steam and air conditioning supply")
replace sec_id = "E" 				if inlist(from_name, "Water supply; sewerage, waste management and remediation activities")
replace sec_id = "F" 				if inlist(from_name, "Construction")
replace sec_id = "G_I" 				if inlist(from_name, "Wholesale and retail trade; repair of motor vehicles", "Land transport and transport via pipelines", "Water transport")
replace sec_id = "G_I" 				if inlist(from_name, "Air transport", "Warehousing and support activities for transportation", "Postal and courier activities", "Accommodation and food service activities")
replace sec_id = "J" 				if inlist(from_name, "Publishing, audiovisual and broadcasting activities", "Telecommunications", "IT and other information services")
replace sec_id = "K" 				if inlist(from_name, "Financial and insurance activities")
replace sec_id = "L" 				if inlist(from_name, "Real estate activities")
replace sec_id = "M_N" 				if inlist(from_name, "Professional, scientific and technical activities", "Administrative and support services")
replace sec_id = "O_Q" 				if inlist(from_name, "Public administration and defence; compulsory social security", "Education", "Human health and social work activities")
replace sec_id = "R_T" 				if inlist(from_name, "Arts, entertainment and recreation", "Other service activities", "Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use")
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
save "./data/IO_Portugal_2021_full.dta", replace


// layer 1

use "./data/IO_Portugal_2021_full.dta", clear
keep fd_imports from
ren from to
gen from = "Imports"
ren fd_imports value
replace value = value * -1
drop in 14/18
gen layer = 1
order layer from to value
save "./data/IO_Portugal_2021_1_full.dta", replace


**** layer 2
use "./data/IO_Portugal_2021_full.dta", clear
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
save "./data/IO_Portugal_2021_2_full.dta", replace


**** layer 3
use "./data/IO_Portugal_2021_full.dta", clear
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
save "./data/IO_Portugal_2021_3_full.dta", replace




use 		 "./data/IO_Portugal_2021_1_full.dta", clear
append using "./data/IO_Portugal_2021_2_full.dta"
append using "./data/IO_Portugal_2021_3_full.dta"



replace to 		= subinstr(to	, "_", "-", .)
replace from 	= subinstr(from	, "_", "-", .)



ssc install sankey, replace


graph set window fontface "Abel"
sankey value, from(from) to(to) by(layer) noval showtotal format(%10.0fc) alpha(40) ///
laba(0) labpos(3) labs(3) labc(white) palette(CET C6) offset(15) labgap(2) lw(none) labprop ///
title("{fontface Playfair Display SemiBold:Portugal's Input-Output flows}", size(6)) ///
subtitle("(2021 USD million)", size(4)) ///
note("Source: OECD ICIO", size(3)) ///
xsize(2) ysize(1)

graph export  "./figures/IO_Portugal_2021_full.png", replace wid(2000)







