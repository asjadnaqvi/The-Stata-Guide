In this folder are various new Stata schemes. The schemes have been programmed in three flavors: **white**, **black**, and **ggplot**. As the names suggest, these are the background colors, where the last one is inspired by the ggplot scheme in R.

These schemes are procedurally generated where the colors and other information is introduced in the scheme via scripts. The core white scheme is based on the [Cleanplots theme](https://www.trentonmize.com/software/cleanplots) (Trenton Mize 2018) that is itself derived from the [plainplots theme](https://www.stata.com/meeting/switzerland16/slides/bischof-switzerland16.pdf) (Bischof 2017). Most of the elements have been overwritten but the simple structure of the dotted grid lines and the axis colors is maintained. I really like these features.

This folder will be filled up with dozens of schemes.

* The dofile contains the script to test the code.
* The graph folder contains the sample figures.


### How to use the themes:

Install the scheme:
> net install schemes, from("https://github.com/asjadnaqvi/The-Stata-Guide/raw/master/schemes")

You can try various graphs either using this test data set:
> use "https://github.com/asjadnaqvi/The-Stata-Guide/blob/master/schemes/scheme_test.dta?raw=true", clear

or use your own dataset!

Please report errors or bugs or suggestions if you find any.
