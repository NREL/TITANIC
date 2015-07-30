# TITANIC
Turbine Inflow Turbulence ANalysIs Code

This code analyses data obtained from a meteorological tower and extracts a range of statistics and meteorological information. Data are also converted into a standard format and summarized graphically.

#Introduction

#Requirements
1. MATLAB.

#Download
Click on the "Download ZIP" button on the lower right of this page. 

The following files are the important ones:
* TowerRunAnalysis: read in a raw data file and analyse the data.
* TowerPlotSummaryData: create summaries of data for arbitrary periods.
* TowerDeleteCorruptData: check the web archive for damaged files
* TowerExportMonthlyData: export summaries of data as .txt and matlab files to a web server
* TowerCopy20HzData: copy the highest resolution data to the web server

#Installing and using the scripts
unpack the .zip file. Open `AdminCodeTester.m`. Change `C:\blah\` to be the path to the directory you just created. Then try the various cells. Each calls different scripts.

#Documentation
You're reading it. See also comments in the code

#Reporting issues and errors
Please use the issue-tracker at https://github.com/NREL/TITANIC/issues to report issues.

#Wiki
Please use the wiki at https://github.com/NREL/TITANIC/wiki as you feel fit. Useful examples may be rolled in to the template file over time.

#Code Maintainers
* [Andy Clifton](mailto:andrew.clifton@nrel.gov) (National Renewable Energy Laboratory)

#Project Contributors
* Jenni Rinker (Duke University)
