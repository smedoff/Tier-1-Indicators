# Tier-1-Indicators

This R project is used to summarize fishing data for the National Oceanic Atmospheric Administration (NOAA) headquarters.   Data produced helps support web-based platforms like https://wpcouncildata.org/archipelagicsafereport 

The purpose of this project was to remove the reliance of contracting the data compilation to 3rd party divisions. With this program, the Ecosystem Science Division (ESD) at NOAA now produces this data set internally. To accomplish this goal, all SQL codes used to produce the data set by our 3rd party division was translated to R scripts. The original SQL code used can be found in the *Supporting Documents* folder. Each R code is created with a linear naming convention where the numeric order indicates the order of execution. In addition, each R script preserves the naming convention of the original SQL codes

*Project Structure*

	- Open the *Tier1_D7.Rproj*
	- Open up the *00 – Prologue.R* script and run 
	- The program will prompt the end user to input their oracle user name and password in order to query the appropriate data sets
	- All intermediate tables and final deliverables will be saved in the *data/current_yr* folder where current_yr is as specified by the end user and reflects the year in which the data set is being produced. 

*Check Output* 

Consistency with data maintained from year to year can be of particular concern. To check for outliers and ensure consistency between years, navigate to the folder, *data/current_yr/Check Output*. Open each markdown file to compare all intermediate and final tables with the previous year.  

*Data Confidentiality*

Due to the confidentiality agreements pertaining to the NOAA data sets, this program cannot be ran without government access. For government officials, researchers, and staff, an active oracle username and password is required to run this R project. 


