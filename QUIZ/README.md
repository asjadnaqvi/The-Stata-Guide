


# Maps in Stata 101

The first course *Maps in Stata 101* will be repeated again if you missed it or want a refresher (and its free!)

Date: 22 Feb 2022 (Tuesday)

Time: 1300-1430 GMT

Location: Online

More info and registration: https://www2.stata-uk.com/maps-in-stata-101-asjad-naqvi…


# Maps in Stata 2

*Maps in Stata 2* is a three hour course on 25th Feb 2022, will dive deeper in making maps. Here we will learn how to deal with multiple layers, labels, and other modifications.

Date: 25 Feb 2022 (Friday)

Time: 0930-1230 GMT

Location: Online

More info and registration: https://www.stata-uk.com/courses/maps-in-stata-2.html

The course has a small fee of GBP 80. If you are from the global South, and/or cannot pay, you can get in by doing the following quiz:


# Quiz

Once you have answered the questions, fill out the information, including the code on the [**Stata Quiz 2022 form**](https://forms.gle/uCj8cET9BNF9qQaA9). You can modify entries even after you have submitted the form but it will change the timestamp.


## Problem set 1

The file **problemset1.dta** contains data with the following variables: ID = country id, X = x-coordinate, Y = y-coordinate, shape_order = the order of the points

In order to read it as a shapefile, we need to add a blank row before each group. Do the following:
1.	Add an empty row before each group
2.	Assign it the correct _ID
3.	Regenerate the shape_order variable such that the blank row has shape_order = 1 for each _ID, and the remaining rows have their current shape_order incremented by one.

If your code is working correctly, then the following code should yield the correct map:

```
twoway (area _Y _X, nodropbase cmissing(no))
```

## Problem set 2

The file **problemset2.dta** contains the outline of Denmark, which is made up of multiple "islands":

```
twoway (area _Y _X, nodropbase cmissing(no))
```

In the Stata shapefiles file, each island is separated out by a blank row, which you can view by scrolling down the data browser window.

1.	Identify all the islands in the data by assigning each a unique identifier
2.	How many islands are there in this file?

## Problem set 3

In the **problemset3.dta** file

1.	Sort the columns pairs (x1,y1), (x2, y2),…(x5,y5) so that each column pair is in ascending order. Or x1, y1 are sorted from smaller numbers to higher numbers, and then x2, y2, etc.
2.	Make sure the "id" column remains unchanged.

## Problem set 4

In the **problemset4.dta** file

1.	Move up the entries of each column such that all the entries are stacked on top of each other and all the blanks at the bottom.
2.	Make sure the "id" column remains unchanged

## Problem set 5

The **problemset5.dta** contains entry from the Our World in Data COVID-19 database. It includes the date, continent, country, and total deaths in that country till the specified date.

1.	Generate a new variable that is a percentage share of the total deaths for each continent for each country.
2.	Check that the shares add up to 1 for each continent.
3.	Sort the shares in descending order (going from highest to lowest) for each continent.
4.	Generate a cumulative sum of the shares for each continent for the sort generated above.
5.	Preserve the data order by generating a sort “order” variable. In case we mess up the order of the countries or shares from other data operations, this variable allows us to recover the continent-wise descending ordering.



*END OF QUIZ! GOOD LUCK!!*

