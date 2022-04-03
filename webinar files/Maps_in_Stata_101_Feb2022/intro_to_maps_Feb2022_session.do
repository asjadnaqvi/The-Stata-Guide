
***********************************               ,_   .  ._. _.  .
***********************************           , _-\','|~\~      ~/      ;-'_   _-'     ,;_;_,    ~~-
***						   	  	***  /~~-\_/-'~'--' \~~| ',    ,'      /  / ~|-_\_/~/~      ~~--~~~~'--_
***	    Maps in Stata 101	   	***  /              ,/'-/~ '\ ,' _  , '|,'|~                   ._/-, /~
***	   					   		***  ~/-'~\_,       '-,| '|. '   ~  ,\ /'~                /    /_  /~
***  	 Stata UK Webinar	   	***.-~      '|        '',\~|\       _\~     ,_  ,               /|
***						   		***          '\        /'~          |_/~\\,-,~  \ "         ,_,/ |
***       02 Feb 2022		   	***           |       /            ._-~'\_ _~|              \ ) /
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
ssc install colrspace, replace

*ssc install schemepack, replace  // optional
set scheme white_tableau

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

cd "D:\Programs\Dropbox\Dropbox\STATA - MEDIUM\Webinar - Stata UK Maps 1\GIS"

dir

spshape2dta WB_countries_Admin0_10m, saving(world) replace


use world
scatter _CY _CX


use world_shp, clear
scatter _Y _X, msize(vsmall)

use world, clear

spmap using world_shp, id(_ID)
spmap POP_EST using world_shp, id(_ID)


use world_shp, clear

	scatter _Y _X, msize(tiny)

	geo2xy _Y _X, proj(web_mercator) replace
	
	replace _X = 180 if _X > 180 & _X!=.
	
	geo2xy _Y _X, proj(web_mercator) replace	
	
	scatter _Y _X, msize(tiny)
	
	compress
save world_shp2.dta, replace	


use world, clear

spmap using world_shp, id(_ID)
spmap using world_shp2, id(_ID)

*******************************
// Step 4: Let's make maps!  //
*******************************

gen gdp_pc = (GDP_MD_EST / POP_EST) * 1000000

kdensity gdp_pc


spmap gdp_pc using world_shp2, id(_ID)

spmap gdp_pc using world_shp2, id(_ID) fcolor(Blues)

spmap gdp_pc using world_shp2, id(_ID) cln(10) fcolor(Heat)

spmap gdp_pc using world_shp2, id(_ID) cln(10)  fcolor(Heat)

spmap gdp_pc using world_shp2, id(_ID) cln(10) clmethod(eqint)  fcolor(Heat)

spmap gdp_pc using world_shp2, id(_ID) cln(10) fcolor(Heat)

spmap gdp_pc using world_shp2, id(_ID) clm(custom) clb(0 10000 20000 50000 100000 500000) fcolor(Heat)


// formatting legends

format gdp_pc %12.0fc

spmap gdp_pc using world_shp2, id(_ID) cln(10) fcolor(Heat)
	
spmap gdp_pc using world_shp2, id(_ID) ///
	cln(10) fcolor(Heat) legstyle(2)	

spmap gdp_pc using world_shp2, id(_ID) ///
	cln(10) fcolor(Heat) legstyle(2) ///
	ocolor(black ..) osize(0.05 ..)
		
spmap gdp_pc using world_shp2, id(_ID) ///
	cln(10) fcolor(Heat) ///
	legstyle(2) legend(pos(7) size(2.5) region(fcolor(gs14)))  ///
	ocolor(black ..) osize(0.05 ..)	

spmap gdp_pc using world_shp2, id(_ID) ///
	cln(10) fcolor(Heat) ///
	legstyle(2) legend(pos(7) size(2.5) region(fcolor(gs14)))  ///
	ocolor(black ..) osize(0.05 ..)	///
	title("My first custom map in Stata") ///
	note("Source: World Bank files.")
	

spmap gdp_pc using world_shp2, id(_ID) ///
	cln(10) fcolor(Heat) ///
	legstyle(2) legend(pos(7) size(2.5) region(fcolor(gs14)))  ///
	ocolor(black ..) osize(0.05 ..)	///
	title("My first custom map in Stata", size(6)) ///
	note("Source: World Bank files.", size(2.5))	
	
	
// customizing colors	
	
help colorpalette
	
colorpalette viridis, n(10)	
return list



colorpalette viridis, n(10)	nograph
local colors `r(p)'

spmap gdp_pc using world_shp2, id(_ID) ///
	cln(10) fcolor("`colors'") ///
	legstyle(2) legend(pos(7) size(2.5) region(fcolor(gs14)))  ///
	ocolor(black ..) osize(0.05 ..)	///
	title("My first custom map in Stata", size(6)) ///
	note("Source: World Bank files.", size(2.5))	
	
	
colorpalette viridis, n(12)	nograph reverse
local colors `r(p)'

spmap gdp_pc using world_shp2, id(_ID) ///
	cln(10) fcolor("`colors'") ///
	legstyle(2) legend(pos(7) size(2.5) region(fcolor(gs14)))  ///
	ocolor(black ..) osize(0.05 ..)	///
	title("My first custom map in Stata", size(6)) ///
	note("Source: World Bank files.", size(2.5))		

	
colorpalette viridis, n(12)	nograph reverse
local colors `r(p)'

spmap gdp_pc using world_shp2 if REGION_WB=="Sub-Saharan Africa", id(_ID) ///
	cln(10) fcolor("`colors'") ///
	legstyle(2) legend(pos(7) size(2.5) region(fcolor(gs14)))  ///
	ocolor(black ..) osize(0.05 ..)	///
	title("My first custom map in Stata", size(6)) ///
	note("Source: World Bank files.", size(2.5))		
		
	
**** END OF FILE ****




