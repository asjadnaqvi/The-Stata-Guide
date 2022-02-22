
***********************************               ,_   .  ._. _.  .
***********************************           , _-\','|~\~      ~/      ;-'_   _-'     ,;_;_,    ~~-
***						   	  	***  /~~-\_/-'~'--' \~~| ',    ,'      /  / ~|-_\_/~/~      ~~--~~~~'--_
***	    Maps in Stata 101	   	***  /              ,/'-/~ '\ ,' _  , '|,'|~                   ._/-, /~
***	   					   		***  ~/-'~\_,       '-,| '|. '   ~  ,\ /'~                /    /_  /~
***  	 Stata UK Webinar	   	***.-~      '|        '',\~|\       _\~     ,_  ,               /|
***						   		***          '\        /'~          |_/~\\,-,~  \ "         ,_,/ |
***       19 Jan 2022		   	***           |       /            ._-~'\_ _~|              \ ) /
***						   		***            \   __-\           '/      ~ |\  \_          /  ~
***	      Asjad Naqvi		   	***  .,         '\ |,  ~-_      - |          \\_' ~|  /\  \~ ,
***						   		***               ~-_'  _;       '\           '-,   \,' /\/  |
***	  T: @AsjadNaqvi		   	***                 '\_,~'\_       \_ _,       /'    '  |, /|'
***	  E: asjadnaqvi@gmail.com	***                   /     \_       ~ |      /         \  ~'; -,_.
***						   		***                   |       ~\        |    |  ,        '-_, ,; ~ ~\
***********************************                    \,      /        \    / /|            ,-, ,   -,
***********************************                     |    ,/          |  |' |/          ,-   ~ \   '.
* 								                       ,|   ,/           \ ,/              \       | 	
*      					     						   /    |             ~                 -~~-, /   _
*                   						    	   |  ,-'                                    ~    /
*                   							       / ,'                                      ~
*                    								   ',|  ~
*                      									 ~'
*		
*

clear

********************************
// Step 1: get the packages   //
********************************

ssc install spmap, replace   	// the core package
ssc install geo2xy, replace		// for projections
ssc install palettes, replace	// for colors (optional)

*ssc install schemepack, replace  // optional
*set scheme white_tableau

graph set window fontface "Arial Narrow"
help spmap

****************************
// Step 2: get the data   //
****************************

* Download the official World Bank boundaries shapefile here:
* https://datacatalog.worldbank.org/search/dataset/0038272

* I also have it on my GitHub:
* https://github.com/asjadnaqvi/The-Stata-Guide/tree/master/GIS

* Create a folder and extract the files
* Make sure you know its path


******************************
// Step 3: set up the data  //
******************************

cd "D:\Programs\Dropbox\Dropbox\STATA - MEDIUM\Seminars\GIS"

dir

spshape2dta WB_countries_Admin0_10m, replace saving(world)


dir

use world, clear

scatter _CY _CX

use world_shp, clear

scatter _Y _X, msize(vsmall)


use world, clear
spmap using world_shp, id(_ID)


use world_shp,clear

	geo2xy _Y _X, proj(web_mercator) replace
	
	replace _X = 180 if _X > 180 & _X!=.

	geo2xy _Y _X, proj(web_mercator) replace

save world_shp2.dta, replace


use world, clear
	
	spmap using world_shp, id(_ID)
	spmap using world_shp2, id(_ID)	


*******************************
// Step 4: Let's make maps!  //
*******************************


use world, clear


duplicates list _ID

gen gdp_pc = (GDP_MD_EST / POP_EST) * 1000000

kdensity gdp_pc


spmap gdp_pc using world_shp2, id(_ID)

spmap gdp_pc using world_shp2, id(_ID) fcolor(Topological)

spmap gdp_pc using world_shp2, id(_ID) clnum(10) fcolor(Topological)

spmap gdp_pc using world_shp2, id(_ID) clnum(10) fcolor(RdYlGn)

spmap gdp_pc using world_shp2, id(_ID) ///
	clnum(10) ///
	fcolor(Heat)	
graph export "map1.png", replace wid(2000)	

spmap gdp_pc using world_shp2, id(_ID) ///
	clnum(10) ///
	clmethod(kmean) ///
	fcolor(Heat)

spmap gdp_pc using world_shp2, id(_ID) ///
	clnum(10) ///
	clmethod(kmean) ///
	fcolor(Heat) 
	
spmap gdp_pc using world_shp2, id(_ID) ///
	clmethod(custom) ///
	clbreaks(0 10000 20000 50000 100000 300000) ///
	fcolor(Heat) 
	

format gdp_pc %12.0fc	
	
spmap gdp_pc using world_shp2, id(_ID) ///
	clnum(10) ///
	clmethod(kmean) ///
	fcolor(Heat) 	///
	legstyle(2)
	

spmap gdp_pc using world_shp2, id(_ID) ///
	clnum(10) ///
	clmethod(kmean) ///
	fcolor(Heat) 	///
	legstyle(2)		///
	ocolor(black ..) osize(vthin ..)

spmap gdp_pc using world_shp2, id(_ID) ///
	clnum(10) ///
	clmethod(kmean) ///
	fcolor(Heat) 	///
	legstyle(2)		///
	ocolor(black ..) osize(0.05 ..)	

spmap gdp_pc using world_shp2, id(_ID) ///
	clnum(10) ///
	clmethod(kmean) ///
	fcolor(Heat) 	///
	legstyle(2)	legend(pos(7) size(2.8) region(fcolor(gs15)))	///
	ocolor(black ..) osize(0.05 ..)	

spmap gdp_pc using world_shp2, id(_ID) ///
	clnum(10) ///
	clmethod(kmean) ///
	fcolor(Heat) 	///
	legstyle(2)	legend(pos(7) size(2.8) region(fcolor(gs15)))	///
	ocolor(black ..) osize(0.05 ..)	///
	title("My first map in Stata") ///
	note("Source: World Bank data files")

	
spmap gdp_pc using world_shp2, id(_ID) ///
	clnum(10) ///
	clmethod(kmean) ///
	fcolor(Heat) 	///
	legstyle(2)	legend(pos(7) size(2.8) region(fcolor(gs15)))	///
	ocolor(black ..) osize(0.05 ..)	///
	title("My first map in Stata", size(5)) ///
	note("Source: World Bank data files", size(2.5))	

	
help colorpalette

colorpalette viridis, n(10)
return list	



colorpalette viridis, n(10) nograph reverse
local colors `r(p)'

	
spmap gdp_pc using world_shp2, id(_ID) ///
	clnum(10) ///
	fcolor("`colors'") 	///
	legstyle(2)	legend(pos(7) size(2.8) region(fcolor(gs15)))	///
	ocolor(black ..) osize(0.05 ..)	///
	title("My first map in Stata: GDP per capita", size(5)) ///
	note("Source: World Bank data files", size(2.5))	

	
colorpalette viridis, n(12) nograph reverse
local colors `r(p)'

	
spmap gdp_pc using world_shp2, id(_ID) ///
	clnum(10) ///
	fcolor("`colors'") 	///
	legstyle(2)	legend(pos(7) size(2.8) region(fcolor(gs15)))	///
	ocolor(white ..) osize(0.05 ..)	///
	title("My first customized map in Stata: GDP per capita", size(5)) ///
	note("Source: World Bank data files", size(2.5))	
	
graph export "map2.png", replace wid(2000)	

	
**** END OF FILE ****






