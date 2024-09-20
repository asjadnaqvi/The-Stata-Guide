
****************************************************
****************************************************
***                                              ***
*** Keynote: Maps in Stata - New Developments    ***
*** Stata Oslo 2024 Conference                   ***         _,--',   _._.--._____
***                                              *** .--.--';_'-.', ";_      _.,-'
*** Asjad Naqvi, PhD                             *** .'--'.  _.'    {`'-;_ .-.>.'
***                                              ***       '-:_      )  / `' '=.
*** E: asjadnaqvi@gmail.com                      ***         ) >     {_/,     /~)
*** W: https://github.com/asjadnaqvi             ***         |/               `^ .'
*** W: https://medium.com/the-stata-guide        ***
***                                              ***
****************************************************
****************************************************


clear 


// Step 0: set your path
cap cd "D:/Dropbox/STATA - GIS/Europe/test"  


// Step 1: install the packages (mark out after installation. Rerun only if there is an update)

/*
net install geoplot, replace from("https://raw.githubusercontent.com/benjann/geoplot/main/")
*help geoplot
ssc install moremata, replace
ssc install palettes, replace
ssc install colrspace, replace
ssc install bimap, replace
*/


// Step 2: get the shape and data files (mark out after installation. Rerun only if there is an update)

/*
foreach x in nuts0 nuts0_shp nuts1 nuts1_shp nuts2 nuts2_shp nuts3 nuts3_shp cities cities_shp hospitals hospitals_shp   {
	copy "https://github.com/asjadnaqvi/The-Stata-Guide/raw/master/GIS/`x'.dta" "`x'.dta", replace
}


foreach x in cities_data NUTS3_pop cities_data demo_r_pjanind3_2022 {
	copy "https://github.com/asjadnaqvi/The-Stata-Guide/raw/master/GIS/`x'.dta" "`x'.dta", replace
}
*/


// Step 3: try out the maps

geoframe create nuts0 nuts0.dta, replace shp(nuts0_shp)

geoframe create nuts0, replace // shorter version with well-behaved names
geoframe create nuts1, replace 
geoframe create nuts2, replace 
geoframe create nuts3, replace


geoframe create cities  cities_data.dta , replace shp(cities_shp)
geoframe create hospitals, replace


geoplot (area nuts3) (area nuts2) (area nuts0)


//////////////
// basics  //
/////////////

	

geoplot ///
	(area nuts3, lc(red) 	lw(0.02))  	///
	(area nuts2, lc(blue) 	lw(0.05)) 	///
	(area nuts1, lc(gs6) 	lw(0.1)) 	///
	(area nuts0, lc(black) 	lw(0.2))	
	


frame change nuts3
	merge 1:1 NUTS_ID using demo_r_pjanind3_2022
	drop if _m==2
	drop _m

	merge 1:1 NUTS_ID using NUTS3_pop
	drop if _m==2
	drop _m

format 	y_MEDAGEPOP %6.1f


/////////////////
//   legends   //
/////////////////



geoplot ///
	(area nuts3 y_MEDAGEPOP )  ///
	(line nuts1, lc(white) lw(0.04) ) ///
	(line nuts0, lc(black) lw(0.2))  ///
	, legend(size(2.3))  
	
	
	

geoplot ///
	(area nuts3 y_MEDAGEPOP, level(10, q) color(viridis, reverse) label("@lb - @ub (N=@n)")  )  ///
	(line nuts1, lc(white) lw(0.04) ) ///
	(line nuts0, lc(black) lw(0.2))  ///
	, legend(size(2.3))  			

	
format 	y64prop %6.1f	
	
geoplot ///
	(area nuts3 y64prop, level(10, kmean) color(viridis, reverse) label("@lb - @ub (N=@n)")  )  ///
	(line nuts1, lc(white) lw(0.04) ) ///
	(line nuts0, lc(black) lw(0.2))  ///
	, legend(size(2.3))	
	

	
geoplot ///
	(area nuts3 y_DEPRATIO1, level(10, kmean) color(viridis, reverse) label("@lb - @ub (N=@n)")  )  ///
	(line nuts1, lc(white) lw(0.04) ) ///
	(line nuts0, lc(black) lw(0.2))  ///
	, legend(size(2.3))	
		
	
	
*** note: instead of levels, cuts can also be specified.	
	
geoplot ///
	(area nuts3 y_MEDAGEPOP, level(40) color(CET L20, reverse) )  ///
	(line nuts1, lc(white) lw(0.03) ) ///
	(line nuts0, lc(black) lw(0.2)) ///
	, ///
	clegend(height(40) pos(2))	zlabel(#10) 	


	
*** zooms and insets

geoplot ///
		(area nuts3 y_MEDAGEPOP, color(viridis, reverse) level(10, kmean) label("@lb - @ub") )  ///
		(line nuts0 , lc(white) lw(0.1) label("NUTS 0")) ///
			(area nuts3 y_MEDAGEPOP if NUTS_ID=="DE300", color(viridis, reverse) cuts(20(5)60) )  ///
		, ///
		glegend(layout( - "{bf:Median age}" 1  ))	///	
		zoom(3: 18 600 0, circle connect(lp(dash)) lcolor(black) title("Berlin", size(1.5))  ) 

	
frame change nuts3		


geoframe query bbox if NUTS_ID=="DE300", pad(60) n(50) circle
mat zoom1 = r(bbox)		

foreach frame in nuts3 nuts0 {
	frame `frame': geoframe clip zoom1, into(`frame'_zoom) replace
}	
	
geoplot ///
		(area nuts3 y_MEDAGEPOP, color(viridis, reverse) cuts(20(5)60) label("@lb - @ub") )  ///
		(line nuts0 , lc(black) lw(0.1) label("NUTS 0")) ///
			(area nuts3_zoom y_MEDAGEPOP, color(viridis, reverse) cuts(20(5)60) )  ///
			(line nuts0_zoom, lc(white) lw(0.1)) ///
		, ///
		glegend(layout( - "{bf:Median age}" 1 - "{bf:Boundaries}" 2  ))	///	
		zoom(3/4: 12 380 0, circle connect(lp(dash)) lcolor(black) title("Berlin", size(1.5)) ) 
	
	
	

****************************
***** LINES AND POINTS ***** 
****************************

**** cities


frame change cities


geoplot ///
		(area nuts1 , lc(gs8) lw(0.05)) ///
		(area nuts0 , lc(black) lw(0.1)) ///
		(point cities ,  mc(orange%50) msize(0.8)) 


geoplot ///
		(area nuts1 , lc(gs8) lw(0.05)) ///
		(area nuts0 , lc(black) lw(0.1)) ///
		(point cities [w = pop],  mc(orange%50) msize(0.8)) 

		
geoplot ///
		(area nuts1 , lc(gs8) lw(0.05)) ///
		(area nuts0 , lc(black) lw(0.1)) ///
		(point cities i.popcat if CITY_CPTL!="Y"  [w = pop], color(Reds%70) mlwidth(none) msize(*0.4)) ///
		(symbol cities if CITY_CPTL=="Y", shape(pin2) color(red) size(*0.5) label("Capital cities")) ///
		, ///
		glegend(layout( - "{bf:Boundaries}" 1 2  | - "{bf:City size}" 3 4))				
		
		

*** rasters		
		
frame change hospitals

geoplot ///
	(area nuts1 , lc(gs8) lw(0.05)) ///
	(area nuts0 , lc(black) lw(0.1)) ///
	(point hospitals ,  mc(orange%40) msize(0.8)) 


		
	frame nuts0: geoframe raster R, hex	n(60) replace
		
		
	geoplot ///
		(area R i.ID, color(%80) lw(0.05) lc(white)) ///
		(line nuts0, lc(black))	///
		, nolegend			

		
		
	geoplot ///
		(area R i.ID, color(%80) lw(0.05) lc(white)) ///
		(line nuts0, lc(black))	///
		(point hospitals,  mc(black%50) msize(0.3)) ///
		, nolegend	
	
	
	
	// contract hospital locations with hex grids
	frame R: geoframe contract hospitals

	geoplot ///
		(area R _freq, level(15, q) color(viridis, reverse) lab(@lab, format(%9.0f)) ) ///
		(line nuts0, lc(black))	
		
	

	// test if it works with other categories
	frame R: geoframe collapse nuts3 (mean) y_MEDAGEPOP		
		
	
	
	geoplot ///
		(area nuts3 y_MEDAGEPOP, level(10, q) color(viridis, reverse) lab(@lab, format(%9.2f)) ) ///
		(line nuts0, lc(black))	
			
	
	geoplot ///
		(area R y_MEDAGEPOP, level(10, q) color(viridis, reverse) lab(@lab, format(%9.2f)) ) ///
		(line nuts0, lc(black))	
		
			
frame nuts3_shp: geoframe copy nuts3 y_MEDAGEPOP   // copy hrate to shape frame
frame nuts3_shp: geoframe spsmooth y_MEDAGEPOP, generate(medage2) at(R) kernel(gaussian)


	geoplot ///
		(area R medage2, level(10, q) color(viridis, reverse) lab(@lab, format(%9.2f)) ) ///
		(line nuts0, lc(black))

	geoplot ///
		(area nuts3 y_MEDAGEPOP, level(10, q) color(viridis, reverse) lab(@lab, format(%9.2f)) ) ///
		(line nuts0, lc(black))
		

			
**************************			
***** bi-variate maps ****
**************************

ssc install bimap, replace

frames change nuts3
			
			
			
bimap y_MEDAGEPOP y64prop , frame(nuts3) 		
			
bimap y64prop y_MEDAGEPOP  , frame(nuts3) cut(pctile) palette(orangeblue) bins(5) count values			
			
bimap y64prop y_MEDAGEPOP  , frame(nuts3) cut(pctile) palette(orangeblue) bins(5) count values	///
			geo( (line nuts0, lc(white) lw(0.2)) )
		
bimap y64prop y_MEDAGEPOP  , frame(nuts3) cut(pctile) palette(orangeblue) binx(2) biny(3) count values	///
			geo( (line nuts0, lc(white) lw(0.2)) )		
			
						
bimap y_DEPRATIO1 y_MEDAGEPOP  , frame(nuts3) cut(pctile) palette(orangeblue) bins(8)  values	///
			geo( (line nuts0, lc(white) lw(0.2)) ) 	

bimap y_DEPRATIO1 y_MEDAGEPOP  , frame(nuts3) cut(pctile) palette(orangeblue) bins(3) binsproper  values	///
			geo( (line nuts0, lc(white) lw(0.2)) ) 	

			
**** END OF FILE ****
			
			
			
			
		