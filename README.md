# TITANIC
Turbine Inflow Turbulence ANalysIs Code

#Introduction
This code analyses data obtained from a meteorological tower and extracts a range of statistics and meteorological information. Data are also converted into a standard format and summarized graphically. For examples of the outputs, see https://nwtc.nrel.gov/M4 and https://nwtc.nrel.gov/M5.

#Requirements
1. MATLAB.

#Download
Click on the "Download ZIP" button on the lower right of this page. 

#Installing and using the scripts
1. Unpack the .zip file. You will find scripts, sample data, and a dummy directory structure representing local data and a web server.
2. Open `AdminCodeTester.m`. 
3. Change `C:\blah\` to the path to the directory you just created. 
4. Add a directory at the root, called `webserver`. This will be your pseudo web output, corresponding to the archives at http://wind.nrel.gov/MetData/135mData/M5Twr/
4. Run the first few cells to set your paths.
5. Try each cells in order. Each calls different scripts:
  1. `TowerRunAnalysis.m`: read in a raw data file and analyse the data. Push results to file in the directory.
  2. `TowerPlotSummaryData.m`: create summaries of data for arbitrary periods.
  3. `TowerDeleteCorruptData.m`: check the web archive for damaged files
  4. `TowerExportMonthlyData.m`: export summaries of data as .txt and matlab files to a web server
  5. `TowerCopy20HzData.m`: copy the highest resolution data to the web server

Scripts can be compiled and run from a Windows command line using the MATLAB MCR. 

#Documentation
You're reading it. See also comments in the code

#Reporting issues and errors
Please use the issue-tracker at https://github.com/NREL/TITANIC/issues to report issues.

#Wiki
Please use the wiki at https://github.com/NREL/TITANIC/wiki as you feel fit.

#Code Maintainers
* [Andy Clifton](mailto:andrew.clifton@nrel.gov) (National Renewable Energy Laboratory)

#Project Contributors
* Jenni Rinker (Duke University)
