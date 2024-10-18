
# GIS files


*Last updated: 18 Oct 2024*


This folder contains a backup of GIS shapefiles used in different guides. They have been modified or removed from official sources online. Until the guides are updated, you can use these files with the guides.

The following are available here:

## Global files

The world files `countries.dta` and `countries_shp.dta` are from the official [World Bank boundaries](https://datacatalog.worldbank.org/search/dataset/0038272/World-Bank-Official-Boundaries) version 3 page.
Please see the website for more information.

The remaining files, such as cities, lakes, etc. are from the [Natural Earth](https://www.naturalearthdata.com/) database.

## EU NUTS files

- Raw `NUTS_RG_03M_2021_3035_mainland.xxx` shapefile from Eurostat GISCO with islands cleaned up.
- The Stata versions of the above shapefiles for NUTS0, NUTS1, NUTS2, NUTS3.
- The `demo_r_pjanind3.dta` contains demographic data from Eurostat that can be merged with the NUTS files.


## Cartograms

- Stata files for a global cartogram: `world_cartogram.dta` and `world_cartogram_shp.dta`. Can be merged using `ISO3` country codes.
- Stata files for USA cartogram: `usa_cartogram.dta` and `usa_cartogram_shp.dta`. Can be merged using `FIPS` or 2-letter state codes.




