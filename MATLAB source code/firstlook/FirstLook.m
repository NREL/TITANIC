% FirstLook
% Function to process raw, high-frequnecy meteorological data into
% 10-minute average values.
%
% Written and maintained by Andy Clifton.
%
% CHANGE HISTORY
% version -- date -- comments
% 1.41 07/08/2015 1. Added ability to recalibrate instruments
% 1.40  12/22/2014  1. Added backward-compatible support for TDMS files with
%                       varying sampling frequency
%                   2. Fixed a small bug in the spike detection routine,
%                       increased detection threshold to changes with lower
%                       than 0.1% / 99.9% chance (was 1/99%)
%                   3. Removing duplicate timestamps, rather than just
%                       crashing
%                   4. Fixed situation where lack of a wind vane at the
%                       height of a cup would cause a crash.
%                   5. Note that this release requires an updated
%                       configuration file
% 1.33  7/15/2014   1. Added cup-equivalent wind speed and direction to
%                       sonic raw data
% 1.32  12/6/2013   1. Set veer to be rate of change of wind direction with
%                       height between two heights. Was maximum difference
%                       across the rotor disk.
%                   2. Added covariance of uw and wT to sonic output data
%                   3. Change Richardson number to use gradient calculated
%                       by regression rather than differences
% 1.31  3/9/2013	1. Can detect configuration file where DAQ frequency changes
% 1.30  5/8/2013	1. Fixed to version of ustar that is always positive
% 1.29  5/8/2013	1. Fixed bug in definition of Monin Obukhov Length.
%					2. Switched to claissc defintion of ustar
% 1.28  24/7/2013	1. Fixed bug in definition of Richardson Number.
% 1.27  16/5/2013	1. Fixed bug that was causing the lower of tower.sonicrotaterate and
%   					tower. sonicrotaterate to be used as the lowest acceptable rate
%   					for rotating the sonic data.
% 1.26  30/4/2013	1. Exporting rotated and cleaned time stamps for every sonic
% 1.25  29/4/2013	1. Including precip in processed data (bugfix versus 1.25)
% 1.24  25/4/2013	1. Including precip in processed data
% 1.23  29/1/2013	1. Fixed bug in interpolating to new time series.
% 1.22  28/1/2013	1. Raw sonic data are linearly interpolated to regular
%                       time series before rotation. Extrapolated data uses
%                       mean value.
% 1.21  19/1/2013   1. When cleaning rotated sonic data, missing data
%                   points are replaced with the mean values.
%                   2. Fixed a bug where the sonic raw z data may have been
%                   overwritten by the y data.
% 1.2	11/09/12	1. Defined a cup-equivalent Wind speed and Ti from sonic data
%					2. Added in length scale calculations using Bonni
%					Jonkman's code
%					3. Updated output data files to use the new data
%					4. limiting certain sonics (ATI, campbell sci) to 2dp
%					in data to reflect the resolution of the serial data
%					acquisition.
%					5. Changed from using covariances to mean u_p w_p to
%						get friction velocity from sonics
% 1.11  9/24/12		1. known outages propogate into sonic anemoemter
%						processing.
%					2. Timing requires less than 2% outage ans no more than
%					1 second gap in data to pass QC
% 1.10	8/13/12		1. Added output relating to the data files that we
%						received
%					2. Coded velocity trends for cups and sonics d(U)/d(t)
% 1.08              1. Some changes to data processing to accomoodate M5
%						tower.
% 1.07				1. Writing sonic data to raw data file to reduce
%					overhead
%					2. Renamed friction velocity and friction temperature
%					to ustar and Tstar.
%					3. General code tidy-up. Added checks for
%					output image files from previous runs. Some 'warnings'
%					changed to 'error'.
% 1.06              1. Writing out minimal sonic data to reduce disk usage
% 1.05				1. Fixed graphics to not spew all over the screen
%					2. Updated friction velocity to match eddyflux definition
%					3. Exporting cV2 and cT2
% 1.04              1. Added boom vertical acceleration as a diagnostic.
%					2. Confirmed that Richardson matches the M2 tower
% 1.03				1. Fixed load_twer_data to return aspirator status.
% 1.02              1. Fixed a bug in the thermodynamics that may have led
%                   to the wrong temperature being used to calculate pressure.
%                   2. Added quality coding to the thermodyanmics, so
%                   temperatures are now given quality flags.
% 1.01              1. Loading config data from file each time
%                   2. If the config file is updated, the analysis will be
%                   re-run.
%                   3. If the outage file was updated more recently than
%                   the last processing date, the file will be analysed
%                   again.
% BETA RELEASE
% 1.0              1. Fixed some graphics routines
%                  2. Recoded to allow known outages to be queried.
%                  3. *** NOTE THAT INPUTS HAVE CHANGED ***
%                  4. Calculating inflow angle from horizontal and total
%                  velocity magnitudes (+ve inflow angle implies mean(w) is
%                  positive.)
%                  5. Defining mean TKE and CTKE as RMS values
%                  6. Sonic turbulence intensity is just w.r.t. horizontal
% 0.978 1/31/12    1. Fixed paths
% 0.977 12/19/11   1. Allowing veocity and direction pairs where we just have
%                       a velocity measure but no direction data,
%                       e.g. the hub-height cup
%                   2. Channel data written to file are now prefixed 'Raw'
%                   3. QC code 1006 is now applied if absolute standard
%                   deviation / mean is less than 0.01%
% 0.976 12/5/11 1. Plotting structure functions
%                  2. Fixed definition of TKE (was 0.5 * u_p^2 +... without
%                  brackets around turbulent components, i.e. wrong!)
%                  3. Exporting peak TKE
%                  4. Looking to find data intervals that are at least 95%
%                   of target
% 0.975 11/28/11 - 1. Tower base height updated to 1845 m asl; was 1625 (wrong!)
% 0.974 11/18/11 - 1. Cup and sonic now use exactly the same definition of
%                       mean wind speed
% 0.973 11/15/11 - 1. Changed definition of mean CTKE to be mean(CTKE), not
%                   some random (wrong) value
% 0.970 11/9/11 -- 1. Fixed up HTML export to better show sonic data
% 0.969 11/9/11 -- 1. Altered sonic processing to simplify quality codes
%                      (was inheriting all codes from sonic channels)
% 0.968 11/8/11 -- 1. Coded fog detection at each temperature measurement
%                       height
%                   2. Added dewpoint and fog layers to output plots
%                   3. Debug plots included instrument height
% 0.967 10/28/11 -- 1. Exporting sonic anemometer u,v,w,T time series.
%                   2. Updated plotting fuctions, pretty_xyplot.m and
%                       readyforprint.m
% 0.966 10/18/11 -- 1. Found the bug in MO length, fixed. (Was using
%                       heat flux [rho.Cp.mean(w'T')] rather than mean(w'T'))
% 0.965 10/12/11 -- 1. Calculating 'ground' heat flux as heat flux from
%                       sonic closest to the ground
%                   2. Calculating Monin-Obukhov Length using ground heat
%                       flux
% 0.964 10/11/11 -- 1. Added sonic velocity fluctuations to output data
%                   2. Corrected Richardson definition to include
%                       mean du\dz in each layer
% 0.963 10/10/11 -- 1. Found bug in sonic friction velocity definition; corrected.
%                       May influence many things!
% 0.962 10/03/11 -- 1. Changed spike detection routine to look for unusual
%                       up/down changes
% 0.961 09/29/11 -- 1. Fixed definition of standard deviation of wind speed
%                   2. Added different Richardson numbers
%                   3. Corrected density, saturation vapor pressure
%                   calculation to use temperature in kelvin
%                   4. Corrected thermodynamics and output results to file
% 0.960 09/13/11 -- 1. Fixed definition of Richardson number
% 0.959 09/07/11 -- 1. Cleaned sonic processing code a bit further
% 0.958 09/07/11 -- 1. Cleaned sonic processing code
%                   2. Writing out raw data to matlab format
% 0.957 09/02/11 -- 1. correct definition of sonic horizontal turbulence intensity
%                   2. Allowed more than 2 heights for shear calculation
% 0.956 08/25/11 -- 1. Calculating shear as the fit to mutiple velocities
%                   2. Fixed met profile display
% 0.955 08/22/11 -- 1. Included accelerometer calculations. Now writing out
%                       peak and RMS velocity
%                   2. Calculate Brunt-vaisala frequency
% 0.954 08/19/2011 -- 1. Changed horizontal turbulence to include
% streamwise and lateral velocity components
%                     2. Modified status plot to include n. valid points
%                     3. Checking for rain
% 0.953 08/18/2011 -- 1. Changed graphics colours to accomodate RGB
%                           colorblindness
%                     2. Updated graphics to include file names, code
%                        versions
% *** ALPHA RELEASE ***
% 0.952 08/17/2011 -- 1. Added interpolation of sonic data to regular
%                           sampling rate if there is sufficient raw data
%                    2. Added friction temperature, T_*
%                    3. Added Monin-Obukhov length, L
%                    4. Added ratio of z/L
%                    5. Data files overwrite existing data
% 0.94 08/16/2011 -- 1. Added the number of points to the exported data
%                    2. Slight change to graphics
%                    3. All try / catch loops now include an error message
%                    4. Function return a '1' if it found pre-existing data
% 0.93 08/15/2011 -- 1. Distinguish between amout of data required to
%                       calculate mean values and carry out rotation of
%                       sonic anemometers
% 0.92 8/8/2011 -- 1. Defined dissipation rate using direct and
%                       structure function methods
%                       2. Added length scale to spectra
% 0.91 -- 8/8/2011 -- 1. Defined intergral length scale using the MRS of
%                       streamwise fluctuations (was defined using mean
%                       horiz wind speed)
%                       2. Added TKE and Coherent TKE calculations
% 0.9 -- 8/3/2011 --

function uptodate = FirstLook(data_path,data_file,...
    output_path,output_file,...
    LogFID,...
    varargin)

%% START THE CLOCK
tic

%% CLEAN UP PREVIOUS ATTEMPTS
close all
lasterror('reset')
lastwarn('')

%% DEFINE THE CODE VERSION
code.date = [2015 07 22 15 50 0];
code.version = 1.41;

%% DEFINE  CONSTANTS
KAPPA = 0.41 ;
GRAV = 9.81;

%% DEAL WITH INPUTS
DEBUG = 0;
outage_path = '';
outage_file = '';
config_path = '';
config_file = '';
calibration_path ='';
calibration_file = '';

%% check the input data
for k = 1:2:size(varargin,2)
    if isnumeric(varargin{k+1})
        eval([char(varargin{k}) '= varargin{' num2str(k+1) '};']);
    elseif ischar(varargin{k+1})
        eval([char(varargin{k}) '=''' char(varargin{k+1}) ''';']);
    end 
end

%% CREATE OUTPUT FOLDERS
try
    % make a directory to put raw data in to
    opp = fullfile(data_path,'raw_data');
    if exist(opp,'dir')
    else
        mkdir(opp);
    end
    
    % make a directory to put summary data in to
    opp = fullfile(data_path,'summary_data');
    if exist(opp,'dir')
    else
        mkdir(opp);
    end
    
    if DEBUG
        % make a directory to put plots of signals in to
        opp = fullfile(data_path,'signals');
        if exist(opp,'dir')
        else
            mkdir(opp);
        end
    end
catch
    warning('tower_doQC:CreateDataFolders', ...
        'Error creating folders for output data');
end

%% OPEN LOG FILE

if isempty(LogFID)
    LogFID = 1;
end
fprintf(LogFID,'\n******\nFirstlook.m\n******\n');
fprintf(1,'\n******\nFirstlook.m\n******\n');

fprintf(LogFID,'*  started at %s local time.\n', datestr(now));
fprintf(1,'*  started at %s local time.\n', datestr(now));

%% LOAD THE CONFIGURATION FILE
try
    load(fullfile(config_path,config_file));
    fprintf(LogFID,'*  loaded configuration file %s\n', config_file);
    fprintf(1,'*  loaded configuration file %s\n', config_file);
catch
    fprintf(LogFID,'ERROR: Problem with reading configuration file %s.\n', config_file);
    fprintf(1,'ERROR: Problem with reading configuration file %s.\n', config_file);
    error('tower_doQC:LoadConfigFile', ...
        ['Problem loading the configuration file ' config_file]);
end

%%  LOAD INFO ON KNOWN OUTAGES
try
    if or(isempty(outage_path),isempty(outage_file))
        tower.outage = {};
        % not enough path information given
        fprintf(LogFID,'ERROR: Insufficient path to find outage file.');
        fprintf(1,'ERROR: Insufficient path to find outage file.');
        error('tower_doQC:LoadOutageFile', ...
            'Insufficient path to find outage file.');
    else
        % the we have a path at least
        if exist(fullfile(outage_path,outage_file),'file') == 2
            A = load(fullfile(outage_path,outage_file),'outage');
            tower.outage = A.outage;
            clear A;
        end
    end
catch
    tower.outage = {};
    fprintf(LogFID,'ERROR: Problem reading outage file %s.\n', outage_file);
    fprintf(1,'ERROR: Problem reading outage file %s.\n', outage_file);
    error('tower_doQC:LoadOutageFile', ...
        ['Problem loading the outage file ' outage_file]);
end

%%  LOAD INFO ON CALIBRATIONS
try
    if or(isempty(calibration_path),isempty(calibration_file))
        tower.calibrations = {};
        % not enough path information given
        fprintf(LogFID,'ERROR: Insufficient path to find calibration file.');
        fprintf(1,'ERROR: Insufficient path to find calibration file.');
        error('tower_doQC:LoadCalibrationFile', ...
            'Insufficient path to find calibration file.');
    else
        % the we have a path at least
        if exist(fullfile(calibration_path,calibration_file),'file') == 2
            A = load(fullfile(calibration_path,calibration_file),'calibrations');
            tower.calibrations = A.calibrations;
            clear A;
        end
    end
catch
    tower.calibrations = {};
    fprintf(LogFID,'ERROR: Problem reading calibration file %s.\n', calibration_file);
    fprintf(1,'ERROR: Problem reading calibration file %s.\n', calibration_file);
    error('tower_doQC:LoadCalibrationFile', ...
        ['Problem loading the calibration file ' calibration_file]);
end

fprintf(LogFID,'Checking data file %s\n', data_file);
fprintf(1,'Checking data file %s\n', data_file);

%% CHECK FOR EXISTING DATA

% names of the output files
HTMLPage = [output_file '_QC_overview'];
StrctFncImage = [output_file '_structure_function'];
ProfileImage = [output_file '_profiles'];
TimingImage = [output_file '_timing'];
StatusImage = [output_file '_status'];
SpectraImage = [output_file '_sonic_anemometer_spectra'];
try
    uptodate = 0;
    fileexists = 0;
    
    %%%%%%%%%%%%%%%%%
    % CURRENT CODE? %
    %%%%%%%%%%%%%%%%%
    
    % check to see if the code version used to process the stored data is
    % the same as the version of this file.
    currentcode = 0;
    if exist(fullfile(output_path,[output_file '.mat']),'file')
        % then it's a matlab file
        waituntilunlock(fullfile(output_path,[output_file '.mat']))
        lock(fullfile(output_path,[output_file '.mat']),'Firstlook.m')
        extant = load(fullfile(output_path,[output_file '.mat']));
        unlock(fullfile(output_path,[output_file '.mat']))
        fileexists = 1;
        if isfield(extant,'processing')
            if isfield(extant.processing,'code')
                if isfield(extant.processing.code,'version') && ...
                        (extant.processing.code.version == code.version)
                    currentcode = 1;
                elseif extant.processing.code.version == 999
                    currentcode = 0;
                    fprintf(LogFID,'*  Processed data file used test code version %3.2f.\n', extant.processing.code.version);
                    fprintf(1,'*  Processed data file used test code version %3.2f.\n', extant.processing.code.version);
                elseif  code.version == 999
                    currentcode = 0;
                    fprintf(LogFID,'*  Processing data file using test code (version %3.2f).\n', extant.processing.code.version);
                    fprintf(1,'*  Processing data file using test code (version %3.2f).\n', extant.processing.code.version);
                end
            end
        end
        
    end
    if currentcode
        fprintf(LogFID,'*  Processed data file using code version %3.2f already exists.\n', code.version);
        fprintf(1,'*  Processed data file using code version %3.2f already exists.\n', code.version);
    end
    
    %%%%%%%%%%%%%%%%%%%
    % CURRENT CONFIG? %
    %%%%%%%%%%%%%%%%%%%
    
    % check if the configuration is the current version or not
    currentconfig = 0;
    if fileexists
        if isfield(extant.processing,'configfile')
            if isfield(extant.processing.configfile,'date')
                
                if isfield(tower,'config')
                    if isfield(tower.config,'date')
                        if datenum(extant.processing.configfile.date) >= ...
                                datenum(tower.config.date)
                            currentconfig = 1;
                        end
                    end
                end
            end
        end
        if currentconfig
            fprintf(LogFID,'*  Processed data file using configuration from %s already exists.\n', datestr(tower.config.date));
            fprintf(1,'*  Processed data file using configuration from %s already exists.\n', datestr(tower.config.date));
        else
            fprintf(LogFID,'*  Processed data file uses old configuration file.\n');
            fprintf(1,'*  Processed data file uses old configuration file.\n');
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%
    % CURRENT OUTAGES? %
    %%%%%%%%%%%%%%%%%%%%
    
    % check we didn't change the outage file since the last time this file
    % was processed
    currentoutage = 0;
    if fileexists
        if isfield(tower,'outage')
            if ~isempty(tower.outage)
                % then there is outage information
                if datenum(extant.processing.datevec) < ...
                        datenum(tower.outage{end}.dateadded)
                    % then the outage file was updated more recently
                    fprintf(LogFID,'*  Outage file has been updated since this file was processed.\n');
                    fprintf(1,'* Outage file has been updated since this file was processed.\n');
                    
                    % check the dates that the data file covers
                    filestartdatenum = TowerConvertDatafilenameDatenum(data_file,...
                        tower.processing.datafile.dateFormatStr);
                    filestopdatenum = filestartdatenum +...
                        (tower.windowsize/tower.daqfreq)/(24*60*60);
                    % assume that the changed outages don't affect the
                    % period of the data file, but check anyway
                    currentoutage = 1;
                    for i = 1:numel(tower.outage)
                        % check to see if we have any relevant outages
                        if (tower.outage{i}.startdatenum <= filestopdatenum) &&...
                                (tower.outage{i}.stopdatenum >= filestartdatenum)
                            currentoutage = 0;
                            fprintf(LogFID,'* Found new outages that occur during this data file.\n');
                            fprintf(1,'* Found new outages that occur during this file.\n');
                        end
                    end
                    if currentoutage
                        fprintf(LogFID,'* No new outages occur during this data file.\n');
                        fprintf(1,'* No new outages occur during this file.\n');
                    end
                else
                    % then the data file was processed more recently than
                    % the configuration file was updated.
                    currentoutage = 1;
                end
            else
                % then no outage information
                currentoutage = 1;
            end
        else
            % then no outage information
            currentoutage = 1;
        end
        if currentoutage
            fprintf(LogFID,'* Outages from %s are OK.\n', outage_file);
            fprintf(1,'* Outages from %s are OK.\n', outage_file);
        else
            fprintf(LogFID,'* Processed data file uses old outage file.\n');
            fprintf(1,'* Processed data file uses old outage file.\n');
        end
    else
        currentoutage = 0;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % CURRENT CALIBRATIONS? %
    %%%%%%%%%%%%%%%%%%%%%%%%%
    
    % check we didn't change the outage file since the last time this file
    % was processed
    currentcalibrations = 0;
    if fileexists
        if isfield(tower,'calibrations')
            if ~isempty(tower.calibrations)
                % then there is calibrations information
                if datenum(extant.processing.datevec) < ...
                        datenum(tower.calibrations{end}.dateadded)
                    % then the calibration file was updated more recently
                    fprintf(LogFID,'* Calibration file has been updated since this file was processed.\n');
                    fprintf(1,'* Calibration file has been updated since this file was processed.\n');
                    
                    % check the dates that the data file covers
                    filestartdatenum = TowerConvertDatafilenameDatenum(data_file,...
                        tower.processing.datafile.dateFormatStr);
                    filestopdatenum = filestartdatenum +...
                        (tower.windowsize/tower.daqfreq)/(24*60*60);
                    % assume that the changed calibrations don't affect the
                    % period of the data file, but check anyway
                    currentcalibrations = 1;
                    for i = 1:numel(tower.calibrations)
                        % check to see if we have any relevant calibrations
                        if (tower.calibrations{i}.startdatenum <= filestopdatenum) &&...
                                (tower.calibrations{i}.stopdatenum >= filestartdatenum)
                            currentcalibrations = 0;
                            fprintf(LogFID,'* Found new calibrations that occur during this data file.\n');
                            fprintf(1,'* Found new calibrations that occur during this file.\n');
                        end
                    end
                    if currentcalibrations
                        fprintf(LogFID,'* No new calibrations occur during this data file.\n');
                        fprintf(1,'* No new calibrations occur during this file.\n');
                    end
                else
                    % then the data file was processed more recently than
                    % the configuration file was updated.
                    currentcalibrations = 1;
                end
            else
                % then no calibration information
                currentcalibrations = 1;
            end
        else
            % then no calibration information
            currentcalibrations = 1;
        end
        if currentcalibrations
            fprintf(LogFID,'* Calibrations from %s are OK.\n', calibration_file);
            fprintf(1,'* Calibrations from %s are OK.\n', calibration_file);
        else
            fprintf(LogFID,'* Processed data file uses old calibrations file.\n');
            fprintf(1,'* Processed data file uses old calibrations file.\n');
        end
    else
        currentcalibrations = 0;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % CHECK FOR IMAGE FILES %
    %%%%%%%%%%%%%%%%%%%%%%%%%
    currentimages = ...
        exist(fullfile(data_path,'summary_data',[StrctFncImage '.png']),'file') ...
        && exist(fullfile(data_path,'summary_data',[ProfileImage '.png']),'file') ...
        && exist(fullfile(data_path,'summary_data',[TimingImage '.png']),'file') ...
        && exist(fullfile(data_path,'summary_data',[StatusImage '.png']),'file') ...
        && exist(fullfile(data_path,'summary_data',[SpectraImage '.png']),'file') ...
        && exist(fullfile(data_path,'summary_data',[HTMLPage '.html']),'file');
    if currentimages
        fprintf(LogFID,'* Image files already exist.\n');
        fprintf(1,'* Image files already exist.\n');
    else
        fprintf(LogFID,'* Did not find required output image files\n');
        fprintf(1,'* Did not find required output image files\n');
    end
    
    %%%%%%%%%%%%%%%%%%%%%%
    % CHECK FOR RAW DATA %
    %%%%%%%%%%%%%%%%%%%%%%
    currentRawData = 0;
    if exist(fullfile(data_path,'raw_data',[output_file '.mat']),'file')
        try
            waituntilunlock(fullfile(data_path,'raw_data',[output_file '.mat']))
            lock(fullfile(data_path,'raw_data',[output_file '.mat']),'Firstlook.m')
            A = load(fullfile(data_path,'raw_data',[output_file '.mat']));
            unlock(fullfile(data_path,'raw_data',[output_file '.mat']))
            clear A;
            currentRawData = 1;
            fprintf(LogFID,'* Raw data files already exist.\n');
            fprintf(1,'* Raw data already exist.\n');
        catch
            currentRawData = 0;
            fprintf(LogFID,'* Raw data files cannot be read.\n');
            fprintf(1,'* Raw data files cannot be read.\n');
        end
    else
        fprintf(LogFID,'* Did not find required output raw data files\n');
        fprintf(1,'* Did not find required output raw data files\n');
    end
    
    %%%%%%%%%%%%%%
    % CONTINUE ? %
    %%%%%%%%%%%%%%
    
    if (currentcode && currentconfig && currentoutage && currentcalibrations ...
            && currentimages && currentRawData)
        uptodate = 1;
        return
    else
        fprintf(LogFID,'-> Processing data file %s using code version %3.2f \n', data_file, code.version);
        fprintf(1,'-> Processing data file %s using code version %3.2f \n', data_file, code.version);
    end
    clear extant
catch
    clear extant
    warning('tower_doQC:DataVersionChecking', ...
        'Could not check version of existing data');
end

%% PROCESS THE DATA FILE

% get the date the file was started
filedatenum = TowerConvertDatafilenameDatenum(data_file,...
    tower.processing.datafile.dateFormatStr);

% Load data
try
switch tower.processing.datafile.type
    case'NWTC_binary';
        % EXTRACT MULTIPLIERS AND SCALES
        mult = [];
        scale = [];
        for i = 1:numel(datastream)
            if isempty(datastream{i}) || any(isnan(datenum(datastream{i}.unpack.fromdate)))
            else
                ii = find(filedatenum>datenum(datastream{i}.unpack.fromdate),1,'last');
                mult(end+1) = datastream{i}.unpack.mult(ii);
                scale(end+1) = datastream{i}.unpack.scale(ii);
            end
        end
        
        % LOAD DATA
        raw_data = SubReadNWTCBinaryTowerData(fullfile(data_path,data_file),...
            mult,scale,tower.processing.datafile);
        
        %% ---------------------
        % TIMING / RECORD LENGTH
        % ----------------------
        
        % find out when data was recorded, relative to the start of the file
        datestring = num2str(raw_data(:,1));
        % ignore maatlab request to use str2double as we need vector capabilities
        % of str2num.
        if numel(datestring(1,:)) == 4
            % m dd y
            yrs = str2num(datestring(:,4))+2010;
            mnth = str2num(datestring(:,1));
            dd = str2num(datestring(:,2:3));
        elseif numel(datestring(1,:)) == 5
            % mm dd y
            yrs = str2num(datestring(:,5))+2010;
            mnth = str2num(datestring(:,1:2));
            dd = str2num(datestring(:,3:4));
        end
        hh = raw_data(:,2);
        ss = raw_data(:,4) +raw_data(:,5)/1000;
        mm = raw_data(:,3);
        
        % get the miniumum vector lenth
        ntin = max([length(yrs) length(mnth) length(dd) length(hh) length(mm) length(ss)]);
        nt1 = min([length(yrs) length(mnth) length(dd) length(hh) length(mm) length(ss)]);
        nt2 = find(abs(diff(yrs))>0,1,'first');
        nt = min([nt1 nt2]);
        fprintf(LogFID,'* Found %d valid records out of %d.\n', nt, ntin);
        fprintf(1,'* Found %d valid records out of %d.\n', nt, ntin);
        
        if nt<=1
            delete(fullfile(data_path,'summary_data',[strrep(data_file,'.dat','') '*']))
            fprintf(LogFID,'ERROR: corrupt data file %s\n.', data_file);
            fprintf(1,'ERROR: corrupt data file %s\n.', data_file);
            error('tower_doQC:LoadDataFile', ...
                ['Corrupt data file ' data_file]);
        end
        
        % trim the data to this length
        raw_data = raw_data(1:nt,:);
        % create the timestamp
        timestamp = datenum([yrs(1:nt,1) mnth(1:nt,1) dd(1:nt,1) hh(1:nt,1) mm(1:nt,1) ss(1:nt,1)]);
    case 'Processed_NWTC_MATLAB'
        waituntilunlock(fullfile(data_path,data_file))
        lock(fullfile(data_path,data_file),'Firstlook.m')
        load(fullfile(data_path,data_file));
        unlock(fullfile(data_path,data_file))
        ntin = size(raw_data,1);
        nt = ntin;
    case 'NWTC_TDMS'
        % This case written by AJC, December 23, 2014.
        waituntilunlock(fullfile(data_path,data_file))
        lock(fullfile(data_path,data_file),'Firstlook.m')
        % get the data
        finalOutput = TDMS_readTDMSFile(fullfile(data_path,data_file));
        unlock(fullfile(data_path,data_file))
        % map TDMS data to the raw data matrix
        for channel_idx = 1:numel(finalOutput.chanIndices{1})
            channel = finalOutput.chanIndices{1}(channel_idx);
            match = 0;
            for di = 1:length(datastream)
                if ~isempty(datastream{di})
                    if isfield(datastream{di}.instrument,'TDMSchanName')
                        if(strmatch(cell2mat(finalOutput.chanNames{1}(channel_idx)),...
                                datastream{di}.instrument.TDMSchanName, 'exact') & ...
                                match == 0 ) 
                            raw_data(:,di) = finalOutput.data{1,channel};
                            data_name(di,:) = finalOutput.chanNames{1}(channel_idx);
                            match = 1;
                        end
                    end
                end
            end
            if match == 0
                fprintf(1,'Warning:  No match for %s in the configuration file\n',...
                    cell2mat(finalOutput.chanNames{1}(channel_idx)))
            end
        end
        % get the time. Note that LabVIEW uses seconds
        LabVIEW_timestamp = finalOutput.data{1,find(strncmp('LabVIEW Timestamp',...
            finalOutput.chanNames{1},10))+2};
        timestamp = datenum(1904, 1, 1) + LabVIEW_timestamp/(24*3600);
        ntin = length(timestamp);
        nt = ntin;
        clear LabVIEW_timestamp;
    otherwise
        fprintf(LogFID,'ERROR: could not read data file %s\n.', data_file);
        fprintf(1,'ERROR: could not read data file %s\n.', data_file);
        error('tower_doQC:LoadDataFile', ...
            ['Problem loading the data file ' data_file]);
end
catch
    % write a message
    fprintf(LogFID,'WARNING: problem reading %s\n.', data_file);
    fprintf(1,'WARNING: problem reading %s\n.', data_file);
    warning('tower_doQC:LoadDataFile', ...
        ['Problem reading ' data_file]);
end

%% DAQ CONFIGURATION
% figure out the frequency of the DAQ
ii = find(filedatenum>datenum(tower.daq.freq.fromdate),1,'last');
tower.daqfreq = tower.daq.freq.value(ii);
% figure out the number of samples
ii = find(filedatenum>datenum(tower.daq.duration.fromdate),1,'last');
tower.windowsize = tower.daqfreq*60*tower.daq.duration.value(ii);

fprintf(LogFID,'* Using %d-Hz DAQ and %d-minute files.\n', ...
    tower.daqfreq, tower.daq.duration.value(ii));
fprintf(1,'* Using %d-Hz DAQ and %d-minute files.\n', ...
    tower.daqfreq, tower.daq.duration.value(ii));

%% SAVE MORE CONFIGURATION INFO
tower.processing.datafile.name = data_file;
tower.processing.datafile.path = data_path;
tower.processing.configfile.name = config_file;
tower.processing.configfile.date = tower.config.date;
% code version
tower.processing.code = code;
% processing info
tower.processing.hostname = SubGetHostname;
tower.processing.datevec = datevec(now);

%% TIME INFORMATION
% Find out what the nominal sampling frequency should have been
% (units are days)
dt_nominal = 1/(24*60*60*tower.daqfreq);
% look for the frequency of measurements where the time interval was more
% than +/-5% from this frequency
dt_actual = diff(timestamp);

if sum(dt_actual == 0)>0
    % remove some data from the file
    iduplicate = find(dt_actual == 0);
    raw_data(iduplicate,:) = [];
    dt_actual(iduplicate) = [];
    timestamp(iduplicate+1) = [];
    nt = nt - sum(dt_actual == 0);
    % write a message
    fprintf(LogFID,'WARNING: duplicate timestamps %s\n.', data_file);
    fprintf(1,'WARNING: duplicate timestamp %s\n.', data_file);
    warning('tower_doQC:LoadDataFile', ...
        ['Duplicate timestamp in ' data_file]);
end


% FLAG if we have more than 2% of time steps outside of plus/minus 5% from the nominal
n_dt_outside = sum(dt_actual>(dt_nominal*1.05)) + ...
    sum(dt_actual<(dt_nominal*0.95));
if ((n_dt_outside / numel(dt_actual)) >0.02) | (max(dt_actual) > (1/60*60*24))
    timing_flag = 1001;
else
    timing_flag = [];
end

% get the elapsed time in seconds
dt_sec = (timestamp-timestamp(1))*60*60*24;
if sum(diff(dt_sec) < 0)>0
    fprintf(LogFID,'ERROR: corrupt timestamp %s\n.', data_file);
    fprintf(1,'ERROR: corrupt timestamp %s\n.', data_file);
    error('tower_doQC:LoadDataFile', ...
        ['Corrupt timestamp in ' data_file]);
end

% save the start time in the tower structure
qcd.file.starttime_UTC = timestamp(1);
qcd.file.starttime = timestamp(1) + tower.UTCoffset/24;

% find out how many data points, in how many streams
qcd.file.nstreams = numel(raw_data(1,:));
qcd.file.npoints = nt;
qcd.file.ninputrecords = ntin;

% allocate empty cell arrays for qcd data and data from each datastream
qcd.datastream = cell(numel(datastream),1);

%% APPLY (RE)CALIBRATIONS
try
    if isfield(tower,'calibrations')
        for i = 1:numel(tower.calibrations)
            % check to see if the start time for this outage overlaps with the data
            if tower.calibrations{i}.startdatenum <= timestamp(end) ...
                    && (tower.calibrations{i}.stopdatenum >= timestamp(1))
                % then we have found an error
                fprintf('Data are impacted by a known recalibration (no. %i) in %s:\n',i,calibration_file)
                fprintf('- reason: %s \n',tower.calibrations{i}.reason)
                fprintf('- instrument channel %i \n',tower.calibrations{i}.channel)
                fprintf('- from %s',datestr(tower.calibrations{i}.startdatenum,'HH:MM mmmm dd, yyyy'))
                fprintf(' to %s.',datestr(tower.calibrations{i}.stopdatenum,'HH:MM mmmm dd, yyyy'))
                fprintf('\n')
                % apply this calibration to the data
                DAS_in = (raw_data(:,tower.calibrations{i}.channel) - tower.calibrations{i}.from.offset)./tower.calibrations{i}.from.gradient;
                DAS_out = DAS_in .* tower.calibrations{i}.to.gradient + tower.calibrations{i}.to.offset;
                % overwrite the raw data
                raw_data(:,tower.calibrations{i}.channel) = DAS_out;
                clear DAS_in DAS out
            end
        end
    end
catch exception
    fprintf(LogFID,'WARNING: could not read calibration file.\n');
    fprintf(1,'WARNING: could not read calibration file.\n');
    warning('tower_doQC:calibration', ...
        'Error importing calibration information');
end
%% WRAP WIND DATA TO 0-360 RANGE
if ~isempty(tower.veldirpairs)
    for ji = 1:numel(tower.veldirpairs(:,2))
        if ~isnan(tower.veldirpairs(ji,2))
            raw_data(:,tower.veldirpairs(ji,2)) = ...
                SubWindWrapDir(raw_data(:,tower.veldirpairs(ji,2)));
        end
    end
end

%% GET BASIC STATISTICS
for di = 1:qcd.file.nstreams
    % check to see if we want this data
    try
        if (di<=numel(datastream)) && ~isempty(datastream{di}) && datastream{di}.qc.doqc
            % check for downsampling
            if (~isfield(datastream{di}.instrument,'skipnsamples'))
                skipnsamples(di) = 1;
            else
                skipnsamples(di) = datastream{di}.instrument.skipnsamples;
            end
            
            %------------------
            % DATA DOWNSAMPLING
            %------------------
            qcd.datastream{di}.data.raw.value = raw_data(:,di);
            qcd.datastream{di}.data.raw.timestamp = timestamp;
            qcd.datastream{di}.data.downsampled.value = raw_data(1:skipnsamples(di):end,di);
            qcd.datastream{di}.data.downsampled.timestamp = timestamp(1:skipnsamples(di):end);
            
            %-----------
            % STATISTICS
            %-----------
            stats = SubQCBasicStats(qcd.datastream{di}.data.downsampled.value,...
                datastream{di}.qc.range.min,...
                datastream{di}.qc.range.max);
            qcd.datastream{di}.data.downsampled.statistics = stats;
            clear stats
        end
    catch
        fprintf(LogFID,'WARNING: corrupt datastream %s\n.', di);
        fprintf(1,'WARNING: corrupt datastream %s\n.', di);
        warning('tower_doQC:GetStats', ...
            ['Corrupt data in datastream' di]);
    end
end

%% CHECK KNOWN OUTAGES

outage_channels = [];
try
    if isfield(tower,'outage')
        for i = 1:numel(tower.outage)
            % check to see if the start time for this outage overlaps with the data
            if tower.outage{i}.startdatenum <= timestamp(end) ...
                    && (tower.outage{i}.stopdatenum >= timestamp(1))
                % then we have found an error
                fprintf('Data are impacted by a known outage (no. %i) in %s:\n',i,outage_file)
                fprintf('- reason: %s \n',tower.outage{i}.reason)
                fprintf('- instrument channels ')
                for c = 1:numel(tower.outage{i}.channels)-1
                    fprintf(' %i,',tower.outage{i}.channels(c))
                end
                fprintf(' %i.',tower.outage{i}.channels(end))
                fprintf('\n- from %s',datestr(tower.outage{i}.startdatenum,'HH:MM mmmm dd, yyyy'))
                fprintf(' to %s.',datestr(tower.outage{i}.stopdatenum,'HH:MM mmmm dd, yyyy'))
                fprintf('\n')
                % add this to the list of channels to flag
                new_outages = reshape(tower.outage{i}.channels,[],1);
                outage_channels = unique(...
                    vertcat(outage_channels,new_outages));
            end
        end
    end
catch exception
    fprintf(LogFID,'WARNING: could not read outage file.\n');
    fprintf(1,'WARNING: could not read outage file.\n');
    warning('tower_doQC:Outages', ...
        'Error importing outage information');
end
%% GENERATE QC FLAGS

%count the number of errors
npost = 0;
% work through each data stream generating QA QC flags
try
    for di = 1:qcd.file.nstreams
        % check to see if we want this data
        if (di<=numel(datastream)) && ~isempty(datastream{di}) && datastream{di}.qc.doqc
            % create 'qcd.datastream', an array of structures for quality
            % control of each individual datastream.
            
            %--------------------------------
            % CHECK DATA ARE WITHIN QC LIMITS
            %--------------------------------
            % start by checking for data that are within limits
            [qc_limits_out,data_inlimits] = SubQCLimits(qcd.datastream{di}.data.downsampled.value,...
                datastream{di});
            qcd.datastream{di}.limits = qc_limits_out;
            qcd.datastream{di}.limits.ntarget = tower.windowsize/skipnsamples(di);
            % get data that pass QC limits
            qcd.datastream{di}.data.clean.value = data_inlimits.val;
            qcd.datastream{di}.data.clean.timestamp = qcd.datastream{di}.data.downsampled.timestamp(data_inlimits.logicali);
            % find the index of the cleaned data, in the raw data set
            dinr = 1:skipnsamples(di):length(qcd.datastream{di}.data.raw.timestamp);
            qcd.datastream{di}.data.clean.rawi = dinr(data_inlimits.logicali);
            % find the index of the cleaned data, in the downsampled data set
            qcd.datastream{di}.data.clean.downsampledi = data_inlimits.logicali;
            
            %------------
            % QC FLAGGING
            %------------
            % check for reasons to flag the data
            qc_flags_out = SubQCFlags(qcd.datastream{di}.data.downsampled.value,...
                qcd.datastream{di},...
                datastream{di},tower);
            % now check for all the reasons why it failed, which could include
            % the timing
            qcd.datastream{di}.flags = [timing_flag qc_flags_out];
            
            %------------
            % QC FAILURES
            %------------
            % check for reasons to fail data
            qc_fails_out = SubQCFails(qcd.datastream{di}.data.downsampled.value,...
                qcd.datastream{di}.data.downsampled,...
                datastream{di});
            % now check for all the reasons why it failed
            qcd.datastream{di}.flags(end+1) = qc_fails_out;
            
            % remove flags wth value 'NaN'.
            qcd.datastream{di}.flags(isnan(qcd.datastream{di}.flags)) = [];
            
            % get the number of flags / fails
            npost = npost + numel(qcd.datastream{di}.flags);
            
            % --------
            % WARNINGS
            % --------
            if isfield(datastream{di}.qc,'warnrate')
                warnn = sum((qcd.datastream{di}.data.clean.value > datastream{di}.qc.warnifover) ...
                    | ...
                    (qcd.datastream{di}.data.clean.value < datastream{di}.qc.warnifunder));
                if (warnn / qcd.datastream{di}.limits.ntarget) >= datastream{di}.qc.warnrate
                    qcd.datastream{di}.flags(end+1) = 5006;
                end
                clear warnn
            end
            
            %--------
            % OUTAGES
            %--------
            if exist('outage_channels','var')
                if ismember(di,outage_channels)
                    qcd.datastream{di}.flags(end+1) = 5005;
                end
            end
        end
    end
catch
    fprintf(LogFID,'* WARNING: problem with inital processing of channel %u.\n',di);
    fprintf(1,'* WARNING: problem with inital processing of channel %u.\n',di);
    warning('tower_doQC:DoQC', ...
        ['Problem with inital processing of channel ' num2str(i)]);
end

%% PLOT SIGNALS

if DEBUG
    fprintf(LogFID,'* generating signal plots.\n');
    fprintf(1,'* generating signal plots.\n');
    % get the start and finish of the data stream to the nearest minute
    tleft = floor(timestamp(1)*(24*60))/(24*60);
    tright = ceil(timestamp(end)*(24*60))/(24*60);
    
    for di = 1:qcd.file.nstreams
        if ~isempty(datastream{di})
            try
                
                % FIGURE
                if isdeployed
                    fdebug = figure('Name', [ num2str(di) ': ' datastream{di}.instrument.name ],...
                        'Visible','off');
                else
                    fdebug = figure('Name', [ num2str(di) ': ' datastream{di}.instrument.name ],...
                        'Visible','on');
                end
                clear h lstring
                
                % %%%%%%%%%%
                % RAW SIGNAL
                % %%%%%%%%%%
                ahr = subplot(2,3,[1 2],'Parent',fdebug);
                h(1) = plot(ahr,...
                    qcd.datastream{di}.data.raw.timestamp,...
                    qcd.datastream{di}.data.raw.value,'k.');
                hold(ahr,'on')
                
                rsn = min(abs(diff(unique(qcd.datastream{di}.data.raw.timestamp))));
                lstring{1} = sprintf('n = %u, resolution = %3.3f\nData starts %s',...
                    numel(dt_sec),rsn,datestr(timestamp(1),'HH:MM:SS dd-mmm-yyyy'));
                
                % add on the extreme limits
                plot(ahr,[tleft tright],...
                    [datastream{di}.qc.range.max datastream{di}.qc.range.max],...
                    'r--')
                plot(ahr,[tleft tright],...
                    [datastream{di}.qc.range.min datastream{di}.qc.range.min],...
                    'r--')
                % add on the acceptable range
                plot(ahr,[tleft tright],...
                    [datastream{di}.qc.accept.max datastream{di}.qc.accept.max],...
                    'r--')
                plot(ahr,[tleft tright],...
                    [datastream{di}.qc.accept.min datastream{di}.qc.accept.min],...
                    'r--')
                
                % add labels
                legend(ahr,h,lstring,'Location','Best')
                xlim(ahr,[tleft tright])
                set(ahr,'Xtick',tleft:2/(24*60):tright);
                xlabel(ahr,'Time (HHMM UTC)')
                ylabel(ahr,[ strrep(datastream{di}.instrument.name,'_',' ') ...
                    ' [' datastream{di}.instrument.units ']' ])
                title(ahr,['Raw data: Channel ' num2str(di) ': ' ...
                    strrep(datastream{di}.instrument.name,'_',' ') ...
                    ' ' num2str(datastream{di}.config.height) 'm'])
                grid(ahr,'on')
                
                %%%%%%%%%%%%%%
                % CLEAN SIGNAL
                %%%%%%%%%%%%%%
                ahc = subplot(2,3,[4 5],'Parent',fdebug);
                h(1) = plot(ahc,NaN,NaN,'k.');
                lstring{1} = 'n = 0';
                if isfield(qcd.datastream{di}.data,'clean')
                    if ~isempty(qcd.datastream{di}.data.clean.value)
                        h(1) = plot(ahc,...
                            qcd.datastream{di}.data.clean.timestamp,...
                            qcd.datastream{di}.data.clean.value,...
                            'k.');
                        lstring{1} = sprintf('n = %u',...
                            numel(find(qcd.datastream{di}.data.clean.timestamp)));
                    end
                end
                hold(ahc,'on')
                
                % add labels
                legend(ahc,h,lstring,'Location','Best')
                xlim(ahc,[tleft tright])
                set(ahc,'Xtick',tleft:2/(24*60):tright);
                xlabel(ahc,'Time (HHMM UTC)')
                ylabel(ahc,[ strrep(datastream{di}.instrument.name,'_',' ') ...
                    ' [' datastream{di}.instrument.units ']' ])
                title(ahc,['Cleaned data: Channel ' num2str(di) ': ' ...
                    strrep(datastream{di}.instrument.name,'_',' ')])
                grid(ahc,'on')
                
                % link axes
                datetick(ahr,'x','HHMM','keepticks','keeplimits')
                datetick(ahc,'x','HHMM','keepticks','keeplimits')
                
                %%%%%%%%%%%
                % HISTOGRAM
                %%%%%%%%%%%
                ahh = subplot(2,3,6,'Parent',fdebug);
                if isfield(qcd.datastream{di}.data,'clean')
                    [n,xout] = hist(ahh,qcd.datastream{di}.data.clean.value,50);
                else
                    [n,xout] = hist(ahh,[],50);
                end
                hold(ahh,'on')
                plot(ahh,xout,n,'k-');
                title(ahh,'Cleaned data')
                xlabel(ahh,'Value')
                ylabel(ahh,'Count')
                
                %%%%%%%%%%%%%
                % PRINT PLOTS
                %%%%%%%%%%%%%
                pretty_xyplot([ahr ahc ahh])
                opf = [num2str(di,'%02i') '_' strtok(datastream{di}.instrument.variable,' ')];
                fo = fullfile(data_path,'signals',opf);
                hgsave(fdebug,fo)
                readyforprint([6 4],8,'k','w',0.5,fdebug)
                print(fdebug,'-dpng',fo)
                
                %%%%%%%%%%
                % ALL DONE
                %%%%%%%%%%
                clear y y_bar y_prime welch_f welch_k  rsn h
                close(fdebug)
            catch
                close(fdebug)
                fprintf(LogFID,'WARNING: Problem with plotting datastream %i.\n', di);
                fprintf(1,'WARNING: Problem with plotting datastream %i.\n', di);
                warning('tower_doQC:DebugDatastream', ...
                    ['Problem creating the debug plots for datastream ' num2str(di) ' in ' data_file]);
            end
        end
    end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FLAGGING & FAILIING LINKED DATASTREAMS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% flagging or failing of one datastream can mean the other channels on the
% same device or at the same height should also be flagged. This can be set
% in the configuration file using the 'alsofail' array for each datastream.

% This is an iterative process; a failure of one channel may cause another
% to fail, which then may cascade through several instruments

% get the count of new flags or failures
fprintf(1,'Checking quality.\n');
nnew = npost;

while nnew >0
    nnew = 0;
    for di = 1:qcd.file.nstreams
        % check to see if we want this data
        if (di<=numel(datastream)) && ~isempty(datastream{di}) && datastream{di}.qc.doqc
            
            % did this datastream generate a flag or not?
            flagged = sum(qcd.datastream{di}.flags < 5000) >= 1;
            failed = sum(qcd.datastream{di}.flags > 5000) >= 1;
            if flagged
                %-----------------------
                % FLAG OTHER INSTRUMENTS
                %-----------------------
                newflag = 2000+di;
                % check to see if this instrument's flagging also requires
                % other data to be flagged
                for doopsi = 1:numel(datastream{di}.qc.alsoflag)
                    % add the number of this datastream, indicating that it is the
                    % reason for a flagging
                    if datastream{di}.qc.alsoflag(doopsi) > numel(datastream)
                        % then we had an undefined datastream
                        % DO NOTHING
                    elseif isempty(qcd.datastream{datastream{di}.qc.alsoflag(doopsi)})
                        % then the datastream was there, but
                        % nothing was flagged
                        qcd.datastream{datastream{di}.qc.alsoflag(doopsi)}.flags = newflag;
                    elseif ~ismember(newflag,qcd.datastream{datastream{di}.qc.alsoflag(doopsi)}.flags)
                        qcd.datastream{datastream{di}.qc.alsoflag(doopsi)}.flags(end+1) = newflag;
                        nnew = nnew + 1;
                    end
                    
                end
            end
            
            if failed
                %-----------------------
                % FAIL OTHER INSTRUMENTS
                %-----------------------
                newflag = 6000+di;
                % check to see if this instrument's failure also requires
                % other data to be failed
                for doopsi = 1:numel(datastream{di}.qc.alsofail)
                    % add the number of this datastream, indicating that it is the
                    % reason for a flagging
                    if datastream{di}.qc.alsoflag(doopsi) > numel(datastream)
                        % then we had an undefined datastream
                        % DO NOTHING
                    elseif isempty(qcd.datastream{datastream{di}.qc.alsoflag(doopsi)})
                        qcd.datastream{datastream{di}.qc.alsoflag(doopsi)}.flags = newflag;
                    elseif ~ismember(newflag,qcd.datastream{datastream{di}.qc.alsoflag(doopsi)}.flags)
                        qcd.datastream{datastream{di}.qc.alsoflag(doopsi)}.flags(end+1) = newflag;
                        nnew = nnew + 1;
                    end
                end
            end
            % END FLAGS
        end
    end
end

%% -------------
% IS IT RAINING?
% --------------
fprintf(1,'Checking for rain.\n');
if ~isempty(tower.precipsensor)
    % get the mean value
    qcd.precipsensormean.value = qcd.datastream{tower.precipsensor}.data.downsampled.statistics.mean;
    % get the flags
    qcd.precipsensormean.flags = qcd.datastream{tower.precipsensor}.flags;
    % get the height
    qcd.precipsensormean.z = datastream{tower.precipsensor}.config.height;
    % see if this corresponds to rain or not
    if (sum(qcd.datastream{tower.precipsensor}.data.clean.value<2.7)) >...
            (0.2*qcd.datastream{tower.precipsensor}.data.downsampled.statistics.nvalid)
        % more than 20% of observations show less than 2.7 (i.e. some
        % precip) then there's a good chance of rain.
        Rainrisk = 1;
        fprintf(LogFID,'* Rain Detected!\n');
        fprintf(1,'* Rain Detected!\n');
    else
        Rainrisk = 0;
    end
else
    Rainrisk = 0;
end
%% -------------
% THERMODYNAMICS
% --------------
fprintf(1,'Calculating thermodynamics.\n');
if isempty(tower.thermodynamics.zground)
    Zground = NaN;
else
    Zground = datastream{tower.thermodynamics.zground}.config.height;
    z_o = Zground;
end
if isempty(tower.thermodynamics.ATground)
    ATground.val = NaN;
    ATground.flags{1} = 5002;
else
    ATground.val = qcd.datastream{tower.thermodynamics.ATground}.data.downsampled.statistics.mean;
    ATground.flags{1} = qcd.datastream{tower.thermodynamics.ATground}.flags;
end
if isempty(tower.thermodynamics.DPTground)
    DPTground.val = NaN;
    DPTground.flags{1} = 5002;
else
    DPTground.val = qcd.datastream{tower.thermodynamics.DPTground}.data.downsampled.statistics.mean;
    DPTground.flags{1} = qcd.datastream{tower.thermodynamics.DPTground}.flags;
end
if isempty(tower.thermodynamics.Pground)
    Pground.val = NaN;
    Pground.flags{1} = 5002;
else
    Pground.val = qcd.datastream{tower.thermodynamics.Pground}.data.downsampled.statistics.mean;
    Pground.flags{1} = qcd.datastream{tower.thermodynamics.Pground}.flags;
end
% Temperature profiles
if ~isempty(tower.thermodynamics.AT)
    % air temperatures
    for i = 1:numel(tower.thermodynamics.AT)
        % look for air temperature
        if isnan(tower.thermodynamics.AT(i))
            AT_o.val(i) = NaN;
            % flags
            AT_o.flags{i} = 5002;
        else
            AT_o.val(i) = qcd.datastream{tower.thermodynamics.AT(i)}.data.downsampled.statistics.mean;
            z_o(i) = datastream{tower.thermodynamics.AT(i)}.config.height;
            % flags
            AT_o.flags{i} = qcd.datastream{tower.thermodynamics.AT(i)}.flags;
        end
        % look for dewpoints
        if isnan(tower.thermodynamics.DPT(i))
            DPT_o.val(i) = NaN;
            DPT_o.flags{i} = 5002;
        else
            DPT_o.val(i) = qcd.datastream{tower.thermodynamics.DPT(i)}.data.downsampled.statistics.mean;
            z_o(i) = datastream{tower.thermodynamics.DPT(i)}.config.height;
            DPT_o.flags{i} = qcd.datastream{tower.thermodynamics.DPT(i)}.flags;
        end
        % look for Delta temperature
        if isnan(tower.thermodynamics.DT(i))
            DT_o.val(i) = NaN;
            DT_o.flags{i} = 5002;
        else
            DT_o.val(i) = qcd.datastream{tower.thermodynamics.DT(i)}.data.downsampled.statistics.mean;
            DT_o.flags{i} = qcd.datastream{tower.thermodynamics.DT(i)}.flags;
        end
    end
else % no temperature profile defined.
    z_o = NaN;
    AT_o.val = NaN;
    AT_o.flags{1} = 5002;
    DT_o.val = NaN;
    DT_o.flags{1} = 5002;
    DPT_o.val = NaN;
    DPT_o.flags{1} = 5002;
end

% go find data
[z, P, T, RH, DPT, PT, VT, VPT, Fogrisk] = thermodynamics(Zground,ATground,DPTground,Pground,...
    z_o,AT_o,DT_o,DPT_o);

% air density
rho_air.value = get_rho_air(P.value*100,T.value,RH.value);
for i = 1:numel(rho_air.value)
    rho_air.flags{i} = union(P.flags{i},union(T.flags{i},RH.flags{i}));
end

% save in the qcd structure
tower.thermodynamics.ouputlevels = numel(z);
for i = 1:tower.thermodynamics.ouputlevels
    qcd.thermodynamics{i}.height = z(i);
    qcd.thermodynamics{i}.airdensity.value = rho_air.value(i);
    qcd.thermodynamics{i}.airdensity.flags = rho_air.flags{i};
    qcd.thermodynamics{i}.P_mBar.value = P.value(i);
    qcd.thermodynamics{i}.P_mBar.flags = P.flags{i};
    qcd.thermodynamics{i}.T.value = T.value(i);
    qcd.thermodynamics{i}.T.flags = T.flags{i};
    qcd.thermodynamics{i}.RH.value = RH.value(i);
    qcd.thermodynamics{i}.RH.flags = RH.flags{i};
    qcd.thermodynamics{i}.DPT.value = DPT.value(i);
    qcd.thermodynamics{i}.DPT.flags = DPT.flags{i};
    qcd.thermodynamics{i}.PT.value = PT.value(i);
    qcd.thermodynamics{i}.PT.flags = PT.flags{i};
    qcd.thermodynamics{i}.VT.value = VT.value(i);
    qcd.thermodynamics{i}.VT.flags = VT.flags{i};
    qcd.thermodynamics{i}.VPT.value = VPT.value(i);
    qcd.thermodynamics{i}.VPT.flags = VPT.flags{i};
    qcd.thermodynamics{i}.Fogrisk.value = Fogrisk(i);
    qcd.thermodynamics{i}.Rainrisk.value = Rainrisk;
end

% save in a vector for later use
[tower.thermodynamics.z,zi] = sort(z,'ascend');
tower.thermodynamics.airdensity = rho_air.value(zi);
tower.thermodynamics.P_mBar = P.value(zi);
tower.thermodynamics.T = T.value(zi);
tower.thermodynamics.RH = RH.value(zi);
tower.thermodynamics.DPT = DPT.value(zi);
tower.thermodynamics.PT.value = PT.value(zi);
tower.thermodynamics.VT.value = VT.value(zi);
tower.thermodynamics.VPT.value = VPT.value(zi);
for i=1:numel(zi)
    tower.thermodynamics.PT.flags{i} = PT.flags{zi(i)};
    tower.thermodynamics.VT.flags{i} = VT.flags{zi(i)};
    tower.thermodynamics.VPT.flags{i} = VPT.flags{zi(i)};
end
tower.thermodynamics.Fogrisk = Fogrisk(zi);
tower.thermodynamics.Rainrisk = Rainrisk;
tower.thermodynamics.cp = 1005;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WIND SPEED AND DIRECTION PAIRS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(1,'-> Calculating wind speed and direction profiles.\n');
if ~isempty(tower.veldirpairs)
    for i = 1:numel(tower.veldirpairs(:,1))
        % record the datastreams we are using
        % height
        qcd.veldirpairs{i}.height = ...
            datastream{tower.veldirpairs(i,1)}.config.height;
        % velocity
        qcd.veldirpairs{i}.speed.id = tower.veldirpairs(i,1);
        % direction
        qcd.veldirpairs{i}.direction.id = tower.veldirpairs(i,2);
        try
            % get flags associated with the two channels
            if ~isnan(qcd.veldirpairs{i}.direction.id)
                qcd.veldirpairs{i}.flags =  unique(...
                    [qcd.datastream{qcd.veldirpairs{i}.speed.id}.flags...
                    qcd.datastream{qcd.veldirpairs{i}.direction.id}.flags]);
            else
                qcd.veldirpairs{i}.flags =  unique(...
                    [qcd.datastream{qcd.veldirpairs{i}.speed.id}.flags]);
            end
            
            % check we aren't dealing with the case where we have no direction
            % data
            if ~isnan(qcd.veldirpairs{i}.direction.id)
                % get the overlapping samples
                vdi = qcd.datastream{qcd.veldirpairs{i}.speed.id}.data.clean.downsampledi & ...
                    qcd.datastream{qcd.veldirpairs{i}.direction.id}.data.clean.downsampledi;
                % get the number of data points
                qcd.veldirpairs{i}.npoints = sum(vdi);
                % get velocity
                vel = qcd.datastream{qcd.veldirpairs{i}.speed.id}.data.downsampled.value(vdi);
                % get direction
                dir = qcd.datastream{qcd.veldirpairs{i}.direction.id}.data.downsampled.value(vdi);
                % get the time
                vel_dir_time = qcd.datastream{qcd.veldirpairs{i}.direction.id}.data.downsampled.timestamp(vdi);
                
                % now get those data where we actually have changes - saw that we have
                % an issue with the data not always changing
                if isempty(vel)
                    u = [];
                    v = [];
                else
                    [u,v] = SubWindComponents(vel,dir);
                end
                
                % find valid data
                ii = find(~isnan(u) & ~isnan(v));
                
                % get the mean wind speed
                UCupMean = nanmean(vel);
                
                % get the resultant mean wind direction
                TH = (180./pi).*atan2(-mean(u(ii)),-mean(v(ii)));
                % wrap data into the 0-360 range
                TH(TH<0) = 360 + TH(TH<0);
                TH(TH>360) = TH(TH>360)-360;
                
                % standard deviation of wind direction using yamartino algorithm
                sigma_TH = SubWindSDev(u(ii),v(ii),vel(ii));
            else
                % get velocity
                vel = qcd.datastream{qcd.veldirpairs{i}.speed.id}.data.clean.value;
                % get the time
                vel_dir_time = qcd.datastream{qcd.veldirpairs{i}.speed.id}.data.clean.timestamp;
                % get the number of data points
                qcd.veldirpairs{i}.npoints = numel(vel);
                % get the components
                u = nan.*vel;
                v = u;
                % find valid data
                ii = find(~isnan(vel));
                
                % get resultant mean wind speed
                UCupMean = nanmean(vel(ii));
                
                % set the wind direction to invald
                TH = NaN;
                sigma_TH = NaN;
                % set the components to nan;
            end
            
            % get the velocity trend at this height
            if (isempty(vel)) || (numel(vel) == 1)
                U_trend = NaN;
            else
                U_trend = regress(vel(ii),...
                    [reshape((vel_dir_time(ii)-vel_dir_time(1))*60*60*24,[],1)...
                    reshape(vel_dir_time(ii).^0,[],1)]);
                U_trend = U_trend(1);
            end
            
            % get the fluctuation
            CupTi = 100*nanstd(vel(ii)) / nanmean(vel(ii));
            
            % save results
            met_u = mean(u(ii));
            met_v = mean(v(ii));
            met_Ubar = (mean(v(ii))^2+mean(u(ii))^2)^(1/2);
            CupSpeed = UCupMean;
            direction = TH;
            stdev_direction = sigma_TH;
        catch
            % save results
            met_u = NaN;
            met_v = NaN;
            met_Ubar = NaN;
            CupSpeed = NaN;
            U_trend = NaN;
            direction = NaN;
            stdev_direction = NaN;
            CupTi = NaN;
            
            fprintf(LogFID,'WARNING: Unable to calculate velocity and Direction data for pair %i.\n', i);
            fprintf(1,'WARNING: Unable to calculate velocity and Direction data for pair %i.\n', i);
            warning('tower_doQC:VelocityandDirection', ...
                ['Unable to calculate velocity and Direction data for pair ' num2str(i)]);
        end
        
        % save data
        qcd.veldirpairs{i}.met_u.value = met_u;
        qcd.veldirpairs{i}.met_v.value = met_v;
        qcd.veldirpairs{i}.met_Ubar.value = met_Ubar;
        qcd.veldirpairs{i}.CupSpeed.value = CupSpeed;
        qcd.veldirpairs{i}.U_trend.value = U_trend;
        qcd.veldirpairs{i}.direction.value = direction;
        qcd.veldirpairs{i}.stdev_direction.value = stdev_direction;
        qcd.veldirpairs{i}.CupTi.value = CupTi;
        
        % tidy up
        clear z* vel* dir* u u_Ti v* cup* met*
        clear cp U* TH*
        clear ii
        clear epsilon* sigma* p cup_trend cup_p u_Ti
    end
    clear i
else % no speed-direction pairs defined.
    
end
%% %%%%%%%%%%%%%%%%%
% RICHARDSON NUMBERS
%%%%%%%%%%%%%%%%%%%%
fprintf(1,'-> Calculating Richardson Numbers.\n');
if ~isempty(tower.richardsonpairs)
    for i = 1:numel(tower.richardsonpairs(:,1))
        try
            % get the height
            zlimits = [datastream{tower.richardsonpairs(i,1)}.config.height ...
                datastream{tower.richardsonpairs(i,2)}.config.height];
            
            % work out all of the wind speeds and temperatures in this range
            zmin = min(zlimits);
            zmax = max(zlimits);
            
            % generate empty vectors to throw velocities into
            zRi = [];
            u_m = [];
            v_m = [];
            U = [];
            flags = [];
            
            % find wind speeds in this range
            
            for zi = 1:numel(qcd.veldirpairs)
                ztemp = qcd.veldirpairs{zi}.height;
                if (ztemp >= zmin) && (ztemp <= zmax) ...
                        && ~isnan(qcd.veldirpairs{zi}.direction.id)
                    
                    zRi = [zRi ztemp];
                    u_m =[u_m qcd.veldirpairs{zi}.met_u.value];
                    v_m =[v_m qcd.veldirpairs{zi}.met_v.value];
                    U = [U qcd.veldirpairs{zi}.met_Ubar.value];
                    flags = unique([flags ...
                        qcd.veldirpairs{zi}.flags]);
                end
            end
            clear ztemp
            
            % sort this data
            [zRi,zRii] = sort(zRi,'ascend');
            U = U(zRii);
            u_m = u_m(zRii);
            v_m = v_m(zRii);
            
            % get the virtual temperatures
            VT = interp1(tower.thermodynamics.z,...
                tower.thermodynamics.VT.value,...
                zRi);
            % mean value is simple mean
            VTbar = mean(VT);
            
            % get the potential temperatures
            PT = interp1(tower.thermodynamics.z,...
                tower.thermodynamics.PT.value,...
                zRi);
            % mean value is simple mean
            PTbar = mean(PT);
            
            % get the virtual potential temperature
            VPT = interp1(tower.thermodynamics.z,...
                tower.thermodynamics.VPT.value,...
                zRi);
            % mean value is simple mean
            VPTbar = mean(VPT);
            
            % get the mean gradients of velocity, etc.
            NotUsed = regress(reshape(U,[],1),...
                [ones(numel(zRi),1) reshape(zRi,[],1)]);
            dUdz = NotUsed(2);
            NotUsed = regress(reshape(u_m,[],1),...
                [ones(numel(zRi),1) reshape(zRi,[],1)]);
            du_mdz = NotUsed(2);
            NotUsed = regress(reshape(v_m,[],1),...
                [ones(numel(zRi),1) reshape(zRi,[],1)]);
            dv_mdz = NotUsed(2);
            NotUsed = regress(reshape(VPT,[],1),...
                [ones(numel(zRi),1) reshape(zRi,[],1)]);
            dVPTdz = NotUsed(2);
            
            % figure out which instruments we used
            VPTi = [...
                max([find(tower.thermodynamics.z<=min(zRi)) 1]) ...
                min([find(tower.thermodynamics.z>=max(zRi)) numel(tower.thermodynamics.z)])...
                ];
            %get the flags
            for j = min(VPTi):max(VPTi)
                flags = unique([flags ...
                    tower.thermodynamics.VPT.flags{j}]);
            end
            
            % Gradient Richardson as used at NREL M2 tower
            Ri_WS = (GRAV/VTbar)*dVPTdz/(dUdz*dUdz);
            
            % Brunt-vaisala frequency
            N2 = ((GRAV/VTbar)*abs(dVPTdz));
            N = abs(N2).^(1/2);
            
            % Gradient Richardson as defined in the AMS Glossary or Stull; see
            % http://amsglossary.allenpress.com/glossary/search?id=gradient-richardson-number1
            Ri_grad = (GRAV/VTbar)*dVPTdz/((du_mdz*du_mdz)+(dv_mdz*dv_mdz));
            
            % ERROR CATCHING
            Ri_flags = [];
            if abs(Ri_WS) >= 10
                Ri_WS = (Ri_WS/abs(Ri_WS)) * 10;
                Ri_flags = 1007;
            end
            
            %results
            flags = [Ri_flags flags];
            
        catch
            % set results to NaN
            Ri_WS = NaN;
            Ri_grad = NaN;
            N= NaN;
            flags = [];
            
            fprintf(LogFID,'* WARNING: unable to calculate Richardson data for pair %u.\n',i);
            fprintf(1,'* WARNING: unable to calculate Richardson data for pair %u.\n',i);
            warning('tower_doQC:Richardson', ...
                ['Unable to calculate Richardson data for pair ' num2str(i)]);
        end
        % save the results
        qcd.richardsonpairs{i}.height = zRi;
        qcd.richardsonpairs{i}.Ri_WS.value = Ri_WS;
        qcd.richardsonpairs{i}.Ri_grad.value = Ri_grad;
        qcd.richardsonpairs{i}.BruntVaisala.value = N;
        % and the flags
        qcd.richardsonpairs{i}.flags = flags;
        
        clear U u_m v_m z* flags
        clear dUdz du_mdz dv_mdz dVTPdz dPTdz
        clear PT* VPT* Ri_* N N2
    end
    clear i
    %else % no richardson pairs defined)
end
%% %%%%%%%%%%%%%%%%%%
% WIND SHEAR AND VEER
%%%%%%%%%%%%%%%%%%%%%
fprintf(1,'-> Calcuating wind shear and veer.\n');
if ~isempty(cell2mat(tower.shearpairs))
    for i = 1:numel(tower.shearpairs)
        % positive shear should indicate increasing wind speed with height
        % get the heights
        z = [];
        uz = [];
        shearpairsflags = [];
        Dirz = [];
        for j = 1:length(tower.shearpairs{i})
            % get the height
            z(j) = datastream{tower.shearpairs{i}(j)}.config.height;
            % get the velocity data at this height
            if sum(tower.veldirpairs(:,1) == tower.shearpairs{i}(j)) == 0
                warning('tower_doQC:ShearPairs', ...
                    ['Need valid speed and direction measurements at ' num2str(z)]);
            else
                iU = find(tower.veldirpairs(:,1) == tower.shearpairs{i}(j),1,'first');
                if isempty(iU)
                    Uz(j) = NaN;
                    warning('tower_doQC:ShearPairs', ...
                        ['Need a valid speed measurement at ' num2str(z)]);
                else
                    Uz(j) = qcd.veldirpairs{iU}.CupSpeed.value;
                end
                % get the wind direction at this height
                iDir = find(tower.veldirpairs(:,1) == tower.shearpairs{i}(j),1,'first');
                if isempty(iDir)
                    Dirz(j) = NaN;
                    warning('tower_doQC:ShearPairs', ...
                        ['Need a valid direction measurement at ' num2str(z)]);
                else
                    Dirz(j) = qcd.veldirpairs{iU}.direction.value;
                end
            end
            % get the flags
            shearpairsflags = unique([shearpairsflags qcd.veldirpairs{iU}.flags]);
        end
        
        % check we found some
        if sum(~isnan(Uz))<2
            shear = NaN;
            frictionvel = NaN;
            z0 = NaN;
            veer = NaN;
            flags = [];
        else
            try
                % POWER LAW FIT
                % Uz = beta.z^alpha; convert this into
                % ln(Uz) = alpha.ln(z)+ln(b)
                xdata = log(z);
                ydata = log(Uz);
                try
                    p = polyfit(xdata,ydata,1);
                    shear = p(1);
                catch
                    warning('tower_doQC:Shear', ...
                        ['Unable to calculate power-law fit for shear pair ' num2str(i)]);
                    shear = NaN;
                end
                
                % LOG LAW FIT
                xdata = log(z);
                ydata = Uz;
                try
                    p = polyfit(xdata,ydata,1);
                    frictionvel = p(1)*KAPPA;
                    z0 = exp((p(2)*KAPPA)/-frictionvel);
                catch
                    warning('tower_doQC:Shear', ...
                        ['Unable to calculate power-law fit for shear pair ' num2str(i)]);
                    frictionvel = NaN;
                    z0 = NaN;
                end
                % catch negative roughness
                if z0 < 0
                    frictionvel = NaN;
                    z0 = NaN;
                end
                
            catch
                fprintf(LogFID,'* WARNING: unable to calculate shear profile for shear pair %u.\n',i);
                fprintf(1,'* WARNING: unable to calculate shear profile for shear pair %u.\n',i);
                warning('tower_doQC:Shear', ...
                    ['Unable to calculate shear profile for shear pair ' num2str(i)]);
                shear = NaN;
                frictionvel = NaN;
                z0 = NaN;
                veer = NaN;
            end
            
            % Veer is the rate of change of wind direction with height
            try
                if any(Dirz)
                    b = regress(reshape((unwrap((Dirz/360)*2*pi)/(2*pi))*360,[],1),...
                        [ones(numel(z),1) reshape(z,[],1)]);
                    veer = b(2);
                else
                    veer = NaN;
                end
            catch
                veer = NaN;
                fprintf(LogFID,'* WARNING: unable to calculate veer for shear pair %u.\n',i);
                fprintf(1,'* WARNING: unable to calculate veer for shear pair %u.\n',i);
                warning('tower_doQC:Veer', ...
                    ['Unable to calculate veer for shear pair ' num2str(i)]);
            end
        end
        
        % save data
        qcd.shearpairs{i}.height = z;
        qcd.shearpairs{i}.shear.value = shear;
        qcd.shearpairs{i}.frictionvelocity.value = frictionvel;
        qcd.shearpairs{i}.roughnesslength.value = z0;
        qcd.shearpairs{i}.veer.value = veer;
        % and the flags
        qcd.shearpairs{i}.flags = shearpairsflags;
    end
    % else  % no shear pairs defined
end
%% ----------------
% SONIC ANEMOMETERS
% -----------------
% figures
% spectra
if isdeployed
    FSonicSpectra = figure('Name','Sonic Anemometer Spectra','Visible','off');
else
    FSonicSpectra = figure('Name','Sonic Anemometer Spectra','Visible','on');
end
% structure function
if isdeployed
    FSonicSF = figure('Name','Sonic Anemometer Structure Function','Visible','off');
else
    FSonicSF = figure('Name','Sonic Anemometer Structure Function','Visible','on');
end

% define a colormap so that each instrument has a different colour
soniccmap = colormap(lines(numel(tower.sonicpairs(:,1))));
hsonicu = [];
lstringsonicu = {};
hsonicsf = [];
lstringsonicsf = {};
zmax = 130;
zmin = 130;

% quickly run through and figure out heights of devices; need this for a few
% things
for i = 1:numel(tower.sonicpairs(:,1))
    %Sonic_zmax = max(zmax,datastream{tower.sonicpairs(i,1)}.config.height);
    Sonic_zmin = min(zmin,datastream{tower.sonicpairs(i,1)}.config.height);
end

% work through each sonic, level by level
fprintf(LogFID,'-> Checking sonic data.\n');
fprintf(1,'-> Checking sonic data.\n');

for i = 1:numel(tower.sonicpairs(:,1))
    
    % height
    qcd.sonicpairs{i}.height = ...
        datastream{tower.sonicpairs(i,1)}.config.height;
    
    % set a flag to state whether or not the sonic data have been rotated.
    DID_ROTATION = 0;
    
    % display information
    fprintf(LogFID,'* Checking sonic at %i m;\n', qcd.sonicpairs{i}.height);
    fprintf(1,'* Checking sonic at %i m;\n', qcd.sonicpairs{i}.height);
    
    % get the air density
    if sum(isnan(tower.thermodynamics.airdensity)) == numel(tower.thermodynamics.airdensity)
        rho_air = NaN;
    elseif sum(~isnan(tower.thermodynamics.airdensity)) ==1
        rho_air = tower.thermodynamics.airdensity(~isnan(tower.thermodynamics.airdensity));
    else
        rho_air = interp1(tower.thermodynamics.z(~isnan(tower.thermodynamics.airdensity)),...
            tower.thermodynamics.airdensity(~isnan(tower.thermodynamics.airdensity)),...
            qcd.sonicpairs{i}.height);
    end
    
    % --------------
    % RAW SONIC DATA
    % --------------
    % Channels for each measurement are given by
    x_chan = tower.sonicpairs(i,1);
    y_chan = tower.sonicpairs(i,2);
    z_chan = tower.sonicpairs(i,3);
    T_chan = tower.sonicpairs(i,4);
    
    % generate empty vectors
    x_raw = NaN.*zeros(numel(qcd.datastream{x_chan}.data.downsampled.value),1);
    y_raw = x_raw;
    z_raw = x_raw;
    T_raw = x_raw;
    
    % --------------
    % INCOMING FLAGS
    % --------------
    % pick up flags that are important but ignore insufficient data flags
    % check for codes
    % 1006 - Standard deviation of this channel is below 1E-5
    % 5001 - No data points at all in the data stream
    % 5002 - All data points are bad (e.g. equal to -999)
    % 5003 - All data points are NaN after filtering for limits
    % 5005 - Known outage impacts a channel
    sonicdata_flag = unique([qcd.datastream{x_chan}.flags...
        qcd.datastream{y_chan}.flags...
        qcd.datastream{z_chan}.flags...
        qcd.datastream{T_chan}.flags...
        ]);
    sonicdata_flag = intersect(sonicdata_flag,[1006 5001 5002 5003 5005]);
    
    % --------
    % CLEANING
    % --------
    % 1. Pick up data that passed channel cleaning
    % indices of good data are given by qcd.datastream{tower.sonicpairs(i,1)}.data.i
    % pick up the raw data
    x_raw(qcd.datastream{x_chan}.data.clean.rawi) = ...
        qcd.datastream{x_chan}.data.clean.value;
    y_raw(qcd.datastream{y_chan}.data.clean.rawi) = ...
        qcd.datastream{y_chan}.data.clean.value;
    z_raw(qcd.datastream{z_chan}.data.clean.rawi) = ...
        qcd.datastream{z_chan}.data.clean.value;
    T_raw(qcd.datastream{T_chan}.data.clean.rawi) = ...
        qcd.datastream{T_chan}.data.clean.value;
    
    % perform sonic-specific operations
    switch tower.sonictype{i}
        case 'ATIK'
            % need to round data to 2dp, e.g. 5.14 rather than 5.142
            x_raw = round((x_raw*100))/100;
            y_raw = round((y_raw*100))/100;
            z_raw = round((z_raw*100))/100;
            T_raw = round((T_raw*100))/100;
    end
    
    % get very simple flow properties
    % wind speed, inflow angle, direction
    [~,STsF] = SubFlowFromUxUyUz(x_raw,y_raw,z_raw,...
        tower.sonictype{i},...
        datastream{tower.sonicpairs(i,1)}.config.inflow);
    
    % ---------
    % GOOD DATA
    % ---------
    % find indices of data where we have 4 valid data points
    QC_pass = find((~isnan(x_raw) + ~isnan(y_raw) + ~isnan(z_raw) + ~isnan(T_raw)) >3);
    % record the minimum number of points in a data stream
    qcd.sonicpairs{i}.npoints = min([sum(~isnan(x_raw)) ...
        sum(~isnan(y_raw)) ...
        sum(~isnan(z_raw)) ...
        sum(~isnan(T_raw))]);
    
    % HORIZONTAL DATA
    % get data in the horizontal plane
    if (qcd.sonicpairs{i}.npoints/tower.windowsize) >= tower.sonicpassrate
        
        % 1. REMOVE SPIKES FROM DATA
        if tower.sonicdespike(i)==1
            % x
            x_ok = find(~isnan(x_raw));
            % get the indices of the clean data without the spikes
            [x_pass,~,nspikes] = SubSonicDespike(x_raw(x_ok),[0.1 99.9]);
            qci_x(1:length(x_raw),1) = false;
            qci_x(x_ok(x_pass),1) = true;
            fprintf(LogFID,'** %d spikes in x time series\n',nspikes);
            fprintf(1,'** %d spikes in x time series\n',nspikes);
            
            % y
            y_ok = find(~isnan(y_raw));
            % get the indices of the clean data without the spikes
            [y_pass,~,nspikes] = SubSonicDespike(y_raw(y_ok),[0.1 99.9]);
            qci_y(1:length(y_raw),1) = false;
            qci_y(y_ok(y_pass),1) = true;
            fprintf(LogFID,'** %d spikes in y time series\n',nspikes);
            fprintf(1,'** %d spikes in y time series\n',nspikes);
            
            % z
            z_ok = find(~isnan(z_raw));
            % get the indices of the clean data without the spikes
            [z_pass,~,nspikes] = SubSonicDespike(z_raw(z_ok),[0.1 99.9]);
            qci_z(1:length(z_raw),1) = false;
            qci_z(z_ok(z_pass),1) = true;
            fprintf(LogFID,'** %d spikes in z time series\n',nspikes);
            fprintf(1,'** %d spikes in z time series\n',nspikes);
            
            % T
            T_ok = find(~isnan(T_raw));
            % get the indices of the clean data without the spikes
            [T_pass,~,nspikes] = SubSonicDespike(T_raw(T_ok),[0.1 99.9]);
            qci_T(1:length(T_raw),1) = false;
            qci_T(T_ok(T_pass),1) = true;
            fprintf(LogFID,'** %d spikes in T time series\n',nspikes);
            fprintf(1,'** %d spikes in T time series\n',nspikes);
            
            % get the data that pass the 'statistical' de-noising
            qci_pass_x = find(qci_x);
            qci_pass_y = find(qci_y);
            qci_pass_z = find(qci_z);
            qci_pass_T = find(qci_T);
            
            if 0
                figure
                plot(dt_sec,x_raw,'k-')
                hold on
                plot(dt_sec(~qci_x),x_raw(~qci_x),'ro')
                close
            end
            
        else % don't apply despiking routine
            qci_pass_T = QC_pass;
        end
        
        %2. RESAMPLE DATA ON TO REGULAR TIMESERIES
        % generate an ideal time series [seconds]
        dt_sec_clean = [0:1/tower.daqfreq:max(dt_sec)]';
        % interpolate x-data to the new time series, allowing a time
        % buffer that is less than half of the sampling period
        [~,ia,ib] = get_common_times(dt_sec_clean,dt_sec(qci_pass_x),...
            0.4*(1/tower.daqfreq));
        x_clean = NaN*ones(size(dt_sec_clean));
        x_clean(ia) = x_raw(qci_pass_x(ib));
        % replace NaN with linear interpolation
        x_clean(isnan(x_clean)) = interp1(dt_sec_clean(~isnan(x_clean)),...
            x_clean(~isnan(x_clean)),...
            dt_sec_clean(isnan(x_clean)),...
            'linear',...
            nanmean(x_clean));
        
        % interpolate y-data to the new time series, allowing a time
        % buffer that is less than half of the sampling period
        [~,ia,ib] = get_common_times(dt_sec_clean,dt_sec(qci_pass_y),...
            0.4*(1/tower.daqfreq));
        y_clean = NaN*ones(size(dt_sec_clean));
        y_clean(ia) = y_raw(qci_pass_y(ib));
        % replace NaN with linear interpolation
        y_clean(isnan(y_clean)) = interp1(dt_sec_clean(~isnan(y_clean)),y_clean(~isnan(y_clean)),...
            dt_sec_clean(isnan(y_clean)),'linear',nanmean(y_clean));
        
        % interpolate z-data to the new time series, allowing a time
        % buffer that is less than half of the sampling period
        [~,ia,ib] = get_common_times(dt_sec_clean,dt_sec(qci_pass_z),...
            0.4*(1/tower.daqfreq));
        z_clean = NaN*ones(size(dt_sec_clean));
        z_clean(ia) = z_raw(qci_pass_z(ib));
        % replace NaN with linear interpolation
        z_clean(isnan(z_clean)) = interp1(dt_sec_clean(~isnan(z_clean)),z_clean(~isnan(z_clean)),...
            dt_sec_clean(isnan(z_clean)),'linear',nanmean(z_clean));
        
        
        % interpolate temp-data to the new time series, allowing a time
        % buffer that is less than half of the sampling period
        [~,ia,ib] = get_common_times(dt_sec_clean,dt_sec(qci_pass_T),...
            0.4*(1/tower.daqfreq));
        temp_clean = NaN*ones(size(dt_sec_clean));
        temp_clean(ia) = T_raw(qci_pass_T(ib));
        % replace NaN with linear interpolation
        temp_clean(isnan(temp_clean)) = interp1(dt_sec_clean(~isnan(temp_clean)),temp_clean(~isnan(temp_clean)),...
            dt_sec_clean(isnan(temp_clean)),'linear',nanmean(temp_clean));
        
        
        % 2. GET BASIC FLOW PARAMETERS
        % wind speed, inflow angle, direction
        [SMF,~] = SubFlowFromUxUyUz(x_clean,y_clean,z_clean,...
            tower.sonictype{i},...
            datastream{tower.sonicpairs(i,1)}.config.inflow);
        
        % save some data
        qcd.sonicpairs{i}.Uxbar.value = nanmean(x_clean);
        qcd.sonicpairs{i}.Uybar.value = nanmean(y_clean);
        qcd.sonicpairs{i}.Uzbar.value = nanmean(z_clean);
        qcd.sonicpairs{i}.Tsbar.value = mean(temp_clean);
        qcd.sonicpairs{i}.met_u.value = SMF.met_u;
        qcd.sonicpairs{i}.met_v.value = SMF.met_v;
        qcd.sonicpairs{i}.horizspeed.value = SMF.HorizSpeed;
        qcd.sonicpairs{i}.totalspeed.value = SMF.TotalSpeed;
        qcd.sonicpairs{i}.CupEqHorizSpeed.value = SMF.CupEqHorizSpeed;
        qcd.sonicpairs{i}.CupEqHorizTi.value = SMF.CupEqHorizTi;
        qcd.sonicpairs{i}.inflowangle.value = SMF.InflowAngle;
        qcd.sonicpairs{i}.direction.value = SMF.theta_m;
    else
        % and set 'NaN' for the data
        qcd.sonicpairs{i}.Uxbar.value = NaN;
        qcd.sonicpairs{i}.Uybar.value = NaN;
        qcd.sonicpairs{i}.Uzbar.value = NaN;
        qcd.sonicpairs{i}.Tsbar.value = NaN;
        qcd.sonicpairs{i}.met_u.value = NaN;
        qcd.sonicpairs{i}.met_v.value = NaN;
        qcd.sonicpairs{i}.horizspeed.value = NaN;
        qcd.sonicpairs{i}.totalspeed.value = NaN;
        qcd.sonicpairs{i}.CupEqHorizSpeed.value = NaN;
        qcd.sonicpairs{i}.CupEqHorizTi.value = NaN;
        qcd.sonicpairs{i}.inflowangle.value = NaN;
        qcd.sonicpairs{i}.direction.value = NaN;
        
        % display a warning
        fprintf(LogFID,'* Insufficient sonic data at %i m to calculate horizontal flow.\n', qcd.sonicpairs{i}.height);
        fprintf(1,'* Insufficient sonic data at %i m to calculate horizontal flow.\n', qcd.sonicpairs{i}.height);
    end
    
    % --------
    % ROTATION
    % --------
    % generate an ideal time series [seconds]
    dt_sec_full = [0:1/tower.daqfreq:(tower.windowsize-1)/tower.daqfreq]';
    % only do the rotation if we have enough data points
    if (qcd.sonicpairs{i}.npoints/tower.windowsize) >= ...
            tower.sonicrotaterate
        DID_ROTATION =1;
        % EXTEND THE SONIC TIME SERIES
        % Previous interpolation did not lengthen the duration of the sonic
        % data
        x_full = interp1(dt_sec_clean,x_clean,dt_sec_full,'linear',nanmean(x_clean));
        y_full = interp1(dt_sec_clean,y_clean,dt_sec_full,'linear',nanmean(y_clean));
        z_full = interp1(dt_sec_clean,z_clean,dt_sec_full,'linear',nanmean(z_clean));
        temp_full = interp1(dt_sec_clean,temp_clean,dt_sec_full,'linear',nanmean(temp_clean));
        
        % RESHAPE ARRAYS
        x_full = reshape(x_full,[],1);
        y_full = reshape(y_full,[],1);
        z_full = reshape(z_full,[],1);
        temp_full = reshape(temp_full,[],1);
        
        % 2. ROTATE VELOCITIES TO STREAMWISE / LATERAL / VERTICAL
        [u_rot,v_rot,w_rot,temp_rot] = SubSonicRotateWindVector(...
            x_full,y_full,z_full,temp_full,...
            tower.sonicrotationmethod);
        
        % 3. STATIONARITY TEST
        U_trend = regress(u_rot,[dt_sec_full.^0 dt_sec_full]);
        U_trend = U_trend(2);
        
        % 4. DETREND SIGNALS TO GET TURBULENCE
        [u_p,v_p,w_p,T_p] = SubSonicTurbulenceTimeseries(u_rot,v_rot,...
            w_rot,temp_rot,dt_sec_full,...
            tower.sonicdetrendingorder);
        
        % 5. MEAN STREAMWISE VELOCITY
        SonicAdvectionSpeed = (nanmean(u_rot));
        
        % 6. TURBULENCE
        % get rms values of turbulence
        u_std = nanstd(u_p);
        v_std = nanstd(v_p);
        w_std = nanstd(w_p);
        T_std = nanstd(T_p);
        % covariance of turbulence
        covuw = cov(u_p,w_p);
        covwT = cov(w_p,T_p);
        
        % could also report skew and kurtosis
        
        % 7. INTEGRAL TIME SCALE
        [L_is,iac,L_zc,zct,L_sz,iacz,L_kaim,time_kaim,L_peakK,t_peakK] = ...
            IntegralLengthScales([u_p v_p w_p],SonicAdvectionSpeed,...
            1/tower.daqfreq);
        %  L_is       the integral length scale, integrated over [0, inf), one for each column of x
        %  iac      the correlation times (integrated autocorrelation time over [0, inf) ),
        %           one for each column of x (iac = L_is/mws)
        %  L_zc      the zero-crossing or characteristic distance, one for each
        %           column of x
        %  zct      the zero-crossing or characteristic time, one for each column
        %           of x (zct = L_zc/mws)
        %  L_sz      the integral length scale, integrated over [0, zct], one for each column of x
        %  iacz     the correlation times (integrated autocorrelation time over [0, zct]),
        %           one for each column of x (iacz = L_sz/mws)
        %  L_kaim   the integral length scale, assuming the data fits the Kaimal
        %           spectral shape
        %  time_kaim  the corresponding time scale for the Kaimal spectral shape.
        %  L_peakK  the length associated with the peak of the spectrum: f*S(f),
        %           divided by 4, assuming the same relationship between the Kaimal
        %           spectral peak and the length scale.
        %  t_peakK  the time associated with L_peakK
        
        % 8. SURFACE SCALES
        ustar = ((nanmean(u_p.*w_p))^2 + (nanmean(v_p.*w_p))^2)^(1/4);
        Tstar = - mean(w_p.*T_p) / ustar;
        
        % 9. FLUXES
        % momentum flux
        % requires density
        if ~isnan(tower.thermodynamics.T)
            dens_air = interp1(tower.thermodynamics.z,...
                tower.thermodynamics.airdensity,...
                qcd.sonicpairs{i}.height);
        else
            dens_air = NaN;
        end
        mom_flux = dens_air * ustar^2;
        % heat flux
        wt_mean = mean(w_p.*T_p);
        heat_flux = rho_air.*1005.*wt_mean;
        
        % 10. TURBULENT KINETIC ENERGY
        % classical TKE, defined according to Stull (1988, p46, eq. 2,.5c)
        tke_bar = 0.5 * (nanmean(u_p.*u_p)+nanmean(v_p.*v_p)+nanmean(w_p.*w_p));
        % coherent TKE
        Ctke_bar = 0.5 * (nanmean((u_p.*w_p).*(u_p.*w_p)) + ...
            nanmean((u_p.*v_p).*(u_p.*v_p)) + ...
            nanmean((v_p.*w_p).*(v_p.*w_p))).^(0.5);
        Ctke = 0.5 * ((u_p.*w_p).*(u_p.*w_p) + ...
            (u_p.*v_p).*(u_p.*v_p) + ...
            (v_p.*w_p).*(v_p.*w_p)).^(0.5);
        Ctke_max = max(Ctke);
        Ctke_up_max = max(w_p.*Ctke);
        Ctke_down_max = min(w_p.*Ctke);
        
        % 11.  DISSIPATION RATE
        % requires kinematic viscosity; requires air temperature
        % get the local air temperature
        if ~isnan(tower.thermodynamics.T)
            temp_air = interp1(tower.thermodynamics.z,...
                tower.thermodynamics.T,...
                qcd.sonicpairs{i}.height);
        else
            temp_air = qcd.sonicpairs{i}.Tsbar.value + 273.15;
        end
        nu = get_dvisc_air(temp_air) / rho_air;
        epsilon_direct = SubDissipationRateDirect(nu,...
            SonicAdvectionSpeed, u_p, v_p, w_p, dt_sec_full);
        [epsilon_SF,lags,cv2,cv2m,DVV,cT2,cT2m,DTT] = ...
            SubDissipationRateStructureFunction(SonicAdvectionSpeed,...
            tower.daqfreq,u_p,T_p);
        
        % 12. PLOT STRUCTURE FUNCTIONS
        aDVV = subplot(2,2,1,'Parent',FSonicSF);
        hsonicsf(end+1) = plot(aDVV,lags, DVV,'k.','Color',soniccmap(i,:));
        lstringsonicsf{end+1} = num2str(qcd.sonicpairs{i}.height);
        hold(aDVV,'on')
        
        acv2 = subplot(2,2,3,'Parent',FSonicSF);
        plot(acv2,lags, cv2,'k.','Color',soniccmap(i,:))
        hold(acv2,'on')
        plot(acv2,lags, cv2m*ones(size(lags)),'k-','Color',soniccmap(i,:))
        
        aDTT = subplot(2,2,2,'Parent',FSonicSF);
        plot(aDTT,lags, DTT,'k.','Color',soniccmap(i,:));
        hold(aDTT,'on')
        
        acT2 = subplot(2,2,4,'Parent',FSonicSF);
        plot(acT2,lags, cT2,'k.','Color',soniccmap(i,:))
        hold(acT2,'on')
        plot(acT2,lags, cT2m*ones(size(lags)),'k-','Color',soniccmap(i,:))
        
        % 13. CALCULATE POWER SPECTRA
        
        [Puu,fu] = SubSimpleFFTPSD(u_p,tower.daqfreq);
        [Pvv,fv] = SubSimpleFFTPSD(v_p,tower.daqfreq);
        [Pww,fw] = SubSimpleFFTPSD(w_p,tower.daqfreq);
        [PTT,fT] = SubSimpleFFTPSD(T_p,tower.daqfreq);
        [Puw,fuw] = SubSimpleFFTPSD(u_p.*w_p,tower.daqfreq);
        
        % 14. PLOT POWER SPECTRA AND LENGTH SCALES
        set(0,'CurrentFigure',FSonicSpectra)
        try
            % streamwise
            asonicu = subplot(3,3,4,'Parent',FSonicSpectra);
            hsonicu(end+1) = plot_smoothed_spectra(asonicu,fu,Puu,soniccmap(i,:));
            lstringsonicu{end+1} = num2str(qcd.sonicpairs{i}.height);
            % add the lengthscale
            dummy = plot(asonicu,[1/time_kaim(1) 1/time_kaim(1)],...
                [1E-6 0.1],'k--','Color',soniccmap(i,:));
            legend(asonicu,hsonicu,lstringsonicu,'FontSize',8)
            
            % lateral
            asonicv = subplot(3,3,5,'Parent',FSonicSpectra);
            plot_smoothed_spectra(asonicv,fv,Pvv,soniccmap(i,:));
            
            % vertical
            asonicw = subplot(3,3,6,'Parent',FSonicSpectra);
            plot_smoothed_spectra(asonicw,fw,Pww,soniccmap(i,:));
            % add the lengthscale
            dummy = plot(asonicw,[1/time_kaim(3) 1/time_kaim(3)],...
                [1E-6 0.1],'Color',soniccmap(i,:));
            
            % shear
            asonicuw = subplot(3,3,7,'Parent',FSonicSpectra);
            plot_smoothed_spectra(asonicuw,fuw,Puw,soniccmap(i,:));
            
            % temperature
            asonicT = subplot(3,3,8,'Parent',FSonicSpectra);
            plot_smoothed_spectra(asonicT,fT,PTT,soniccmap(i,:));
            
        catch % error producing spectra
            fprintf(LogFID,'* WARNING: unable to produce sonic spectra data at level %u.\n',i);
            fprintf(1,'* WARNING: unable to produce sonic spectra data at level %u.\n',i);
            warning('tower_doQC:SonicSpectra', ...
                ['Unable to produce turbulent spectra from sonic anemometer level ' num2str(i) ' in ' data_file]);
        end
        
        % 15. save results of the rotation
        qcd.sonicpairs{i}.Umean.value= SonicAdvectionSpeed;
        qcd.sonicpairs{i}.U_trend.value = U_trend;
        qcd.sonicpairs{i}.u_std.value = u_std;
        qcd.sonicpairs{i}.v_std.value = v_std;
        qcd.sonicpairs{i}.w_std.value = w_std;
        qcd.sonicpairs{i}.T_std.value = T_std;
        qcd.sonicpairs{i}.uw_cov.value = covuw(1,2);
        qcd.sonicpairs{i}.wT_cov.value = covwT(1,2);
        qcd.sonicpairs{i}.ustar.value = ustar;
        qcd.sonicpairs{i}.Tstar.value = Tstar;
        qcd.sonicpairs{i}.wT_mean.value = wt_mean;
        qcd.sonicpairs{i}.heatflux.value = heat_flux;
        qcd.sonicpairs{i}.momentumflux.value = mom_flux;
        qcd.sonicpairs{i}.L_integral_u.value = L_is(1);
        qcd.sonicpairs{i}.L_integral_v.value = L_is(2);
        qcd.sonicpairs{i}.L_integral_w.value = L_is(3);
        qcd.sonicpairs{i}.L_zc_u.value = L_zc(1);
        qcd.sonicpairs{i}.L_zc_v.value = L_zc(2);
        qcd.sonicpairs{i}.L_zc_w.value = L_zc(3);
        qcd.sonicpairs{i}.L_sz_u.value = L_sz(1);
        qcd.sonicpairs{i}.L_sz_v.value = L_sz(2);
        qcd.sonicpairs{i}.L_sz_w.value = L_sz(3);
        qcd.sonicpairs{i}.L_Kaim_u.value = L_kaim(1);
        qcd.sonicpairs{i}.L_Kaim_v.value = L_kaim(2);
        qcd.sonicpairs{i}.L_Kaim_w.value = L_kaim(3);
        qcd.sonicpairs{i}.L_peakK_u.value = L_peakK(1);
        qcd.sonicpairs{i}.L_peakK_v.value = L_peakK(2);
        qcd.sonicpairs{i}.L_peakK_w.value = L_peakK(3);
        qcd.sonicpairs{i}.TKE.value = tke_bar;
        qcd.sonicpairs{i}.CTKE.value = Ctke_bar;
        qcd.sonicpairs{i}.CTKE_peak.value = Ctke_max;
        qcd.sonicpairs{i}.CTKE_down_peak.value = Ctke_down_max;
        qcd.sonicpairs{i}.CTKE_up_peak.value = Ctke_up_max;
        qcd.sonicpairs{i}.directdissipationrate.value = epsilon_direct;
        qcd.sonicpairs{i}.SFdissipationrate.value = epsilon_SF;
        qcd.sonicpairs{i}.cv2.value = cv2m;
        qcd.sonicpairs{i}.cT2.value = cT2m;
        
        % clean up
        clear u v w temp SMF SonicAdvectionSpeed
        clear L_*
        clear Ctke*
    else
        % no good data from this sonic
        sonicdata_flag = [sonicdata_flag 1004];
        
        % then set NaN
        qcd.sonicpairs{i}.Umean.value= NaN;
        qcd.sonicpairs{i}.U_trend.value = NaN;
        qcd.sonicpairs{i}.Uxbar.value = NaN;
        qcd.sonicpairs{i}.Uybar.value = NaN;
        qcd.sonicpairs{i}.Uzbar.value = NaN;
        qcd.sonicpairs{i}.Tsbar.value = NaN;
        qcd.sonicpairs{i}.u_std.value = NaN;
        qcd.sonicpairs{i}.v_std.value = NaN;
        qcd.sonicpairs{i}.w_std.value = NaN;
        qcd.sonicpairs{i}.T_std.value = NaN;
        qcd.sonicpairs{i}.uw_cov.value = NaN;
        qcd.sonicpairs{i}.wT_cov.value = NaN;
        qcd.sonicpairs{i}.ustar.value = NaN;
        qcd.sonicpairs{i}.Tstar.value = NaN;
        qcd.sonicpairs{i}.wT_mean.value = NaN;
        qcd.sonicpairs{i}.heatflux.value = NaN;
        qcd.sonicpairs{i}.momentumflux.value = NaN;
        qcd.sonicpairs{i}.L_integral_u.value = NaN;
        qcd.sonicpairs{i}.L_integral_v.value = NaN;
        qcd.sonicpairs{i}.L_integral_w.value = NaN;
        qcd.sonicpairs{i}.L_zc_u.value = NaN;
        qcd.sonicpairs{i}.L_zc_v.value = NaN;
        qcd.sonicpairs{i}.L_zc_w.value = NaN;
        qcd.sonicpairs{i}.L_sz_u.value = NaN;
        qcd.sonicpairs{i}.L_sz_v.value = NaN;
        qcd.sonicpairs{i}.L_sz_w.value = NaN;
        qcd.sonicpairs{i}.L_Kaim_u.value = NaN;
        qcd.sonicpairs{i}.L_Kaim_v.value = NaN;
        qcd.sonicpairs{i}.L_Kaim_w.value = NaN;
        qcd.sonicpairs{i}.L_peakK_u.value = NaN;
        qcd.sonicpairs{i}.L_peakK_v.value = NaN;
        qcd.sonicpairs{i}.L_peakK_w.value = NaN;
        qcd.sonicpairs{i}.TKE.value = NaN;
        qcd.sonicpairs{i}.CTKE.value = NaN;
        qcd.sonicpairs{i}.CTKE_peak.value = NaN;
        qcd.sonicpairs{i}.CTKE_down_peak.value = NaN;
        qcd.sonicpairs{i}.CTKE_up_peak.value = NaN;
        qcd.sonicpairs{i}.directdissipationrate.value = NaN;
        qcd.sonicpairs{i}.SFdissipationrate.value = NaN;
        qcd.sonicpairs{i}.cv2.value = NaN;
        qcd.sonicpairs{i}.cT2.value = NaN;
        
        % display a warning
        fprintf(LogFID,'** Insufficient sonic data at %i m for rotation.\n', qcd.sonicpairs{i}.height);
        fprintf(1,'** Insufficient sonic data at %i m for rotation.\n', qcd.sonicpairs{i}.height);
    end
    
    % SANITY CHECK
    % maximum velocity that we measure is the vector defined by u, v and w
    maxuvel = max(abs([datastream{tower.sonicpairs(i,1)}.qc.range.min ...
        datastream{tower.sonicpairs(i,1)}.qc.range.max]));
    maxvvel = max(abs([datastream{tower.sonicpairs(i,2)}.qc.range.min ...
        datastream{tower.sonicpairs(i,2)}.qc.range.max]));
    maxwvel = max(abs([datastream{tower.sonicpairs(i,3)}.qc.range.min ...
        datastream{tower.sonicpairs(i,3)}.qc.range.max]));
    maxvel = (maxwvel^2+(maxuvel^2+maxvvel^2)^(1/2))^(1/2);
    
    % if we exceed this value, throw out the data
    if qcd.sonicpairs{i}.horizspeed.value > maxvel
        qcd.sonicpairs{i}.met_u.value = NaN;
        qcd.sonicpairs{i}.met_v.value = NaN;
        qcd.sonicpairs{i}.horizspeed.value = NaN;
        qcd.sonicpairs{i}.totalspeed.value = NaN;
        qcd.sonicpairs{i}.CupEqHorizSpeed.value = NaN;
        qcd.sonicpairs{i}.CupEqHorizTi.value = NaN;
        qcd.sonicpairs{i}.direction.value = NaN;
        qcd.sonicpairs{i}.U_trend.value = NaN;
        qcd.sonicpairs{i}.u_std.value = NaN;
        qcd.sonicpairs{i}.v_std.value = NaN;
        qcd.sonicpairs{i}.w_std.value = NaN;
        qcd.sonicpairs{i}.T_std.value = NaN;
        qcd.sonicpairs{i}.uw_cov.value = NaN;
        qcd.sonicpairs{i}.wT_cov.value = NaN;
        qcd.sonicpairs{i}.ustar.value = NaN;
        qcd.sonicpairs{i}.Tstar.value = NaN;
        qcd.sonicpairs{i}.wT_mean.value = NaN;
        qcd.sonicpairs{i}.heatflux.value = NaN;
        qcd.sonicpairs{i}.momentumflux.value = NaN;
        qcd.sonicpairs{i}.L_integral_u.value = NaN;
        qcd.sonicpairs{i}.L_integral_v.value = NaN;
        qcd.sonicpairs{i}.L_integral_w.value = NaN;
        qcd.sonicpairs{i}.L_zc_u.value = NaN;
        qcd.sonicpairs{i}.L_zc_v.value = NaN;
        qcd.sonicpairs{i}.L_zc_w.value = NaN;
        qcd.sonicpairs{i}.L_sz_u.value = NaN;
        qcd.sonicpairs{i}.L_sz_v.value = NaN;
        qcd.sonicpairs{i}.L_sz_w.value = NaN;
        qcd.sonicpairs{i}.L_Kaim_u.value = NaN;
        qcd.sonicpairs{i}.L_Kaim_v.value = NaN;
        qcd.sonicpairs{i}.L_Kaim_w.value = NaN;
        qcd.sonicpairs{i}.L_peakK_u.value = NaN;
        qcd.sonicpairs{i}.L_peakK_v.value = NaN;
        qcd.sonicpairs{i}.L_peakK_w.value = NaN;
        qcd.sonicpairs{i}.TKE.value = NaN;
        qcd.sonicpairs{i}.CTKE.value = NaN;
        qcd.sonicpairs{i}.CTKE_peak.value = NaN;
        qcd.sonicpairs{i}.CTKE_down_peak.value = NaN;
        qcd.sonicpairs{i}.CTKE_up_peak.value = NaN;
        qcd.sonicpairs{i}.directdissipationrate.value = NaN;
        qcd.sonicpairs{i}.SFdissipationrate.value = NaN;
        qcd.sonicpairs{i}.cv2.value = NaN;
        qcd.sonicpairs{i}.cT2.value = NaN;
    end
    
    % clean up
    clear ii welch_*
    clear zoverMOlength MOlength
    
    %% BOOM ACCELERATIONS
    try
        boom_flag = [];
        
        % work out which accelerometer axis we are working with
        nacc = numel(tower.sonicpairs(i,:)) - 4;
        
        for nacci = 1:nacc
            % then we have acceleration data
            % channel number is given y
            device = tower.sonicpairs(i,nacci + 4);
            if ~isnan(device)
                % get the default values
                switch nacci
                    case 1
                        qcd.sonicpairs{i}.boom_velocity_peak_x.value = NaN;
                        qcd.sonicpairs{i}.boom_velocity_RMS_x.value = NaN;
                    case 2
                        qcd.sonicpairs{i}.boom_velocity_peak_y.value = NaN;
                        qcd.sonicpairs{i}.boom_velocity_RMS_y.value = NaN;
                    case 3
                        qcd.sonicpairs{i}.boom_accn_mean_z.value = NaN;
                        qcd.sonicpairs{i}.boom_accn_RMS_z.value = NaN;
                        qcd.sonicpairs{i}.boom_velocity_peak_z.value = NaN;
                        qcd.sonicpairs{i}.boom_velocity_RMS_z.value = NaN;
                end
                
                
                % now get the data
                if ~isempty(qcd.datastream{device}.data.clean.rawi)
                    ib = qcd.datastream{device}.data.clean.rawi;
                    % get the acceleration
                    accn_raw = raw_data(ib,device)*GRAV;
                    % remove the mean
                    accn = reshape(accn_raw,[],1) - nanmean(accn_raw);
                    % get the timestamp for these
                    t = timestamp(ib) - timestamp(1);
                    t = reshape(t,[],1);
                    % get data for the trapezoidal rule
                    ta = vertcat(NaN,t);
                    tb = vertcat(t,NaN);
                    fa = vertcat(NaN,accn);
                    fb = vertcat(accn,NaN);
                    % apply trapezoidal rule
                    dvel = (tb - ta) .* (fa + fb)./2;
                    
                    % get the zero-mean velocity boom speed
                    boomvel = dvel- nanmean(dvel);
                    
                    % save data
                    maxboomvel = max(abs(boomvel));
                    switch nacci
                        case 1
                            qcd.sonicpairs{i}.boom_velocity_peak_x.value = maxboomvel;
                            qcd.sonicpairs{i}.boom_velocity_RMS_x.value = (nanmean(boomvel.^2)).^(1/2);
                        case 2
                            qcd.sonicpairs{i}.boom_velocity_peak_y.value = maxboomvel;
                            qcd.sonicpairs{i}.boom_velocity_RMS_y.value = (nanmean(boomvel.^2)).^(1/2);
                        case 3
                            qcd.sonicpairs{i}.boom_accn_mean_z.value = nanmean(accn_raw);
                            qcd.sonicpairs{i}.boom_accn_RMS_z.value = (nanmean(accn_raw.^2)).^(1/2);
                            qcd.sonicpairs{i}.boom_velocity_peak_z.value = maxboomvel;
                            qcd.sonicpairs{i}.boom_velocity_RMS_z.value = (nanmean(boomvel.^2)).^(1/2);
                    end
                    
                    % flag data if peak mount velocity exceeds 0.1 m/s
                    if maxboomvel > 0.1 & ~isempty(boomvel)
                        % display a warning
                        fprintf(LogFID,'** Boom velocity over 0.1 m/s detected on channel %i at %i m\n',device, qcd.sonicpairs{i}.height);
                        fprintf(1,'** Boom velocity over 0.1 m/s detected on channel %i at %i m\n',device, qcd.sonicpairs{i}.height);
                        % generate a flag
                        boom_flag = 5004;
                    end
                end
            end
        end
        clear ib
    catch
        fprintf(LogFID,'* WARNING: unable to process boom acceleration data at level %u.\n',i);
        fprintf(1,'*WARNING: unable to process boom acceleration data at level %u.\n',i);
        warning('tower_doQC:BoomAccn', ...
            ['Unable to process boom acceleration data at level ' num2str(i) ' in ' data_file]);
    end
    % PLOT THE ACCELERATION
    if ~isempty(FSonicSpectra)
        % figure out if we had an accelerometer at this height
        if isfield(qcd.sonicpairs{i},'boom_accn_mean_z')
            device = tower.sonicpairs(i,nacci + 4);
            % add the boom accelerations as a subplot
            axaccn = subplot(3,3,2,'Parent',FSonicSpectra);
            plot(axaccn,...
                qcd.sonicpairs{i}.boom_accn_RMS_z.value,...
                datastream{device}.config.height,...
                'ko',...
                'MarkerFaceColor',QC_color(qcd.datastream{device}.flags));
            hold(axaccn,'on')
        end
    end
    % END BOOM ACCELERATION
    
    %% SONIC FLAGS
    % get flags associated with the sonic data channels
    
    qcd.sonicpairs{i}.flags = unique(...
        [timing_flag ...
        sonicdata_flag ...
        boom_flag]);
    
    % SAVE SONIC DATA
    % get some details of the sonic
    sonic_out{i}.starttime_UTC = timestamp(1);
    sonic_out{i}.height = qcd.sonicpairs{i}.height;
    sonic_out{i}.flags = qcd.sonicpairs{i}.flags;
    sonic_out{i}.raw.datafile = fullfile(data_path,'raw_data',...
        strrep(data_file,'.dat','.mat'));
    % first get the raw data for this sonic
    sonic_out{i}.raw.dt = dt_sec;
    sonic_out{i}.raw.x = x_raw;
    sonic_out{i}.raw.y = y_raw;
    sonic_out{i}.raw.z = z_raw;
    sonic_out{i}.raw.Temp = T_raw;
    % get a nominal wind speed and direction for the high-frequency data
    sonic_out{i}.raw.CupEqHorizSpeed = STsF.CupEqHorizSpeed;
    sonic_out{i}.raw.direction = STsF.theta_m;
    if DID_ROTATION
        % then get the cleaned data
        sonic_out{i}.clean.dt = dt_sec_full;
        sonic_out{i}.clean.x = x_full;
        sonic_out{i}.clean.y = y_full;
        sonic_out{i}.clean.z = z_full;
        sonic_out{i}.clean.T = temp_full;
        % then get the rotated data
        sonic_out{i}.rot.dt = dt_sec_full;
        sonic_out{i}.rot.u = u_rot;
        sonic_out{i}.rot.v = v_rot;
        sonic_out{i}.rot.w = w_rot;
        sonic_out{i}.rot.T = temp_rot;
    else
        dummydata = NaN * ones(size(x_raw));
        % then get the cleaned data
        sonic_out{i}.clean.dt = dummydata;
        sonic_out{i}.clean.x = dummydata;
        sonic_out{i}.clean.y = dummydata;
        sonic_out{i}.clean.z = dummydata;
        sonic_out{i}.clean.T = dummydata;
        % then get the rotated data
        sonic_out{i}.rot.dt = dummydata;
        sonic_out{i}.rot.u = dummydata;
        sonic_out{i}.rot.v = dummydata;
        sonic_out{i}.rot.w = dummydata;
        sonic_out{i}.rot.T = dummydata;
    end
    
    % tidy up
    clear x_* y_* z_* T_* u_* v_* w_* SMF STsF
    clear boom_flag
    
end

%% ---------------
% GROUND HEAT FLUX
% ----------------
try
    zwT0 = NaN;
    wT0=NaN;
    npoints = NaN;
    flags = [];
    zreserve = 150;
    wT0reserve = NaN;
    reserveflags = [];
    npointsreserve = NaN;
    for i = 1:numel(tower.sonicpairs(:,1))
        % height
        z = qcd.sonicpairs{i}.height;
        wT = qcd.sonicpairs{i}.wT_mean.value;
        if (z == Sonic_zmin) & ~isnan(wT)
            zwT0 = z;
            wT0 = wT;
            flags = qcd.sonicpairs{i}.flags;
            npoints = qcd.sonicpairs{i}.npoints;
        elseif (z < zreserve) & ~isnan(wT)
            zreserve = z;
            wT0reserve = wT;
            reserveflags = qcd.sonicpairs{i}.flags;
            npointsreserve = qcd.sonicpairs{i}.npoints;
        end
    end
    % check we found something
    if isnan(wT0)
        zwT0 = zreserve;
        wT0 = wT0reserve;
        npoints = npointsreserve;
        flags = reserveflags;
    end
    % and save the answer
    qcd.surface.wT_mean.value = wT0;
    qcd.surface.wT_mean.flags = flags;
    qcd.surface.wT_mean.npoints = npoints;
    % and the height
    qcd.surface.wT_meanheight.value = zwT0;
    
    clear z* wt wT0 *reserve*
catch
    fprintf(LogFID,'* WARNING: could not estimate ground heat flux.\n');
    fprintf(1,'*WARNING: could not estimate ground heat flux.\n');
    warning('tower_doQC:GroundHeatFlux', ...
        ['Problem identifying a ground heat flux in file ' data_file]);
end

%% -------------------
% MONIN OBUKHOV LENGTH
% --------------------
% MO definition is http://glossary.ametsoc.org/wiki/Obukhov_length
try
    wT0 = qcd.surface.wT_mean.value;
    for i = 1:numel(tower.sonicpairs(:,1))
        % starting flags
        flags = qcd.surface.wT_mean.flags;
        % height
        z = qcd.sonicpairs{i}.height;
        % potential temperature
        if all(isnan(tower.thermodynamics.VT.value))
            VT = NaN;
        else
            VT = interp1(tower.thermodynamics.z,...
                tower.thermodynamics.VT.value,...
                qcd.sonicpairs{i}.height);
        end
        % flags
        % figure out which instruments we used
        VTi = [...
            max([find(tower.thermodynamics.z<=z) 1]) ...
            min([find(tower.thermodynamics.z>=z) numel(tower.thermodynamics.z)])...
            ];
        %get the flags
        for j = min(VTi):max(VTi)
            flags = unique([flags ...
                tower.thermodynamics.VT.flags{j}]);
        end
        % friction velocity. See http://link.springer.com/article/10.1023%2FA%3A1000288002105
        
        ustar = qcd.sonicpairs{i}.ustar.value;
        flags = unique([flags ...
            qcd.sonicpairs{i}.flags]);
        
        MOlength = - ustar^3 * VT / (KAPPA*GRAV*wT0);
        zoverMOlength = z / MOlength;
        
        qcd.sonicpairs{i}.MOlength.value = MOlength;
        qcd.sonicpairs{i}.MOlength.flags = flags;
        qcd.sonicpairs{i}.zoverMOlength.value = zoverMOlength;
        qcd.sonicpairs{i}.zoverMOlength.flags = flags;
    end
catch
    fprintf(LogFID,'* WARNING: could not estimate Monin-Obukhov Length.\n');
    fprintf(1,'*WARNING: could not estimate Monin-Obukhov Length.\n');
    warning('tower_doQC:MoninObukhovLength', ...
        ['Problem estimating the Monin-Obukhov Length for ' data_file]);
end


%% -------------------
% START OF DATA EXPORT
% --------------------
fprintf(LogFID,'-> Writing data to %s.\n',data_path);
fprintf(1,'-> Writing data to %s.\n',data_path);

%% -----------------------------
% FINISH STRUCTURE FUNCTION PLOT
% ------------------------------
set(0,'CurrentFigure',FSonicSF)
if exist('aDVV','var')
    % DVV plot
    xlabel(aDVV,'lag [m]')
    ylabel(aDVV,'D_{VV} [m^2s^{-2}]')
    title(aDVV,'Lag Function')
    legend(aDVV,hsonicsf,lstringsonicsf,'Location','Best')
    % cv2 plot
    xlabel(acv2,'lag [m]')
    ylabel(acv2,'cv2')
    title(acv2,'Velocity Structure Function')
    % DTT plot
    xlabel(aDTT,'lag [m]')
    ylabel(aDTT,'D_{TT} [K^2]')
    title(aDTT,'Lag Function')
    % cT2 plot
    xlabel(acT2,'lag [m]')
    ylabel(acT2,'cT2')
    title(acT2,'Temperature Structure Function')
    
    % tidy axes
    pretty_xyplot([aDVV acv2 aDTT acT2])
end

% save
% and dump it to file
fofile = fullfile(data_path,'summary_data',StrctFncImage);
try
    hgsave(FSonicSF,[fofile '.fig'])
    if ~isempty(findobj(FSonicSF,'Type','axes'))
        readyforprint([6 5],8,'k','w',0.5,FSonicSF)
    end
    print(FSonicSF,'-dpng',fofile)
    fprintf(LogFID,'* sonic anemometer structure function images written to file ''%s''.\n', StrctFncImage);
    fprintf(1,'*sonic anemometer structure function images written to file ''%s''.\n', StrctFncImage);
catch
    fprintf(LogFID,'WARNING: could not write sonic anemometer structure function images to file.\n');
    fprintf(1,'WARNING: could not write sonic anemometer structure function images to file.\n');
    warning('tower_doQC:StrctFncImageSaveFailed', ...
        ['Problem creating the structure function image files for ' data_file]);
end

close(FSonicSF);

%% ------------------
% FINISH SPECTRA PLOT
% -------------------
set(0,'CurrentFigure',FSonicSpectra)
% add labels to acceleration plots
if exist('axaccn','var')
    pretty_xyplot(axaccn)
    xlabel(axaccn,'Boom RMS z acceleration [m s^{-2}]')
    ylabel(axaccn,'Height [m]')
    title(axaccn,'Boom acceleration')
end

if exist('asonicu','var')
    % add labels to spectra plots
    axspectra = [asonicu asonicv asonicw asonicuw asonicT];
    axlabel = {'u''';...
        'v''';...
        'w''';...
        'u''w''';...
        'T''';};
    axtitle = {'Streamwise';...
        'Lateral';...
        'Vertical';...
        'Shear (u''w'')';...
        'Temperature'};
    for axi = 1:numel(axspectra)
        ax = axspectra(axi);
        axis(ax,'tight')
        set(ax,'YScale','log','XScale','log')
        ylabel(ax,['f.S(f,' axlabel{axi} ')'])
        xlabel(ax,'f [Hz]')
        title(ax,axtitle{axi})
    end
    pretty_xyplot([asonicu asonicv asonicw asonicuw asonicT]);
end

% add information about data file, etc.
axfile = subplot(3,3,1,'Parent',FSonicSpectra);
xlim(axfile,[0 1])
ylim(axfile,[0 1])
text(0, 0.5,...
    {[datestr(qcd.file.starttime,'dd mmmm yyyy') ...
    datestr(qcd.file.starttime, 'HH:MM:SS') ' ' tower.timezone ];...
    ' ';...
    ['Data file: ' strrep(tower.processing.datafile.name,'_','\_')];...
    ['Processed on: ' datestr(now, 'mmmm dd yyyy, HH:MM')];...
    ['Configuration file: ' strrep(tower.processing.configfile.name,'_','\_')];...
    ['Code version ' num2str(tower.processing.code.version)...
    ', updated ' datestr(tower.processing.code.date,'mmmm dd yyyy') '.']},...
    'HorizontalAlignment','left',...
    'VerticalAlignment','middle',...
    'Parent',axfile)
set(axfile,'Visible','off')

% save
% and dump it to file
fofile = fullfile(data_path,'summary_data',SpectraImage);
try
    hgsave(FSonicSpectra,[fofile '.fig'])
    if ~isempty(findobj(FSonicSpectra,'Type','axes'))
        readyforprint([8 11],8,'k','w',0.5,FSonicSpectra)
    end
    print(FSonicSpectra,'-dpng',fofile)
    fprintf(LogFID,'* sonic anemometer spectra images written to file ''%s''.\n', SpectraImage);
    fprintf(1,'*sonic anemometer spectra images written to file ''%s''.\n', SpectraImage);
catch
    fprintf(LogFID,'WARNING: could not write sonic anemometer spectra images to file.\n');
    fprintf(1,'WARNING: could not write sonic anemometer spectra images to file.\n');
    warning('tower_doQC:SonicAnemometerSpectraImageSaveFailed', ...
        ['Problem creating the sonic anemometer spectra image files for ' data_file]);
end
close(FSonicSpectra)

%% --------------
% TIMING ACCURACY
% ---------------
if isdeployed
    FTiming = figure('Name','Timing','Visible','off');
else
    FTiming = figure('Name','Timing','Visible','on');
end

SubDisplayTiming(tower,qcd,dt_sec,FTiming,timing_flag)

% save this  it to file
fofile = fullfile(data_path,'summary_data',TimingImage);

try
    hgsave(FTiming,[fofile '.fig'])
    if ~isempty(findobj(FTiming,'Type','axes'))
        readyforprint([6 3],8,'k','w',0.5,FTiming)
    end
    print(FTiming,'-dpng',fofile)
    fprintf(LogFID,'* tower timing images written to file ''%s''.\n', TimingImage);
    fprintf(1,'*tower timing images written to file ''%s''.\n', TimingImage);
catch
    fprintf(LogFID,'WARNING: could not write tower timing images to file.\n');
    fprintf(1,'WARNING: could not write tower timing images to file.\n');
    warning('tower_doQC:TimingImageSaveFailed', ...
        ['Problem creating the timing image files for ' data_file]);
end

close(FTiming)

%% ---------------------
% CHANNEL STATUS DISPLAY
% ----------------------
if isdeployed
    FStatus = figure('Name','Channel overview','Visible','off');
else
    FStatus = figure('Name','Channel overview','Visible','on');
end

% generate the channel status display
SubDisplayChannelStatus(tower,datastream,qcd,FStatus);

% save this  it to file
fofile = fullfile(data_path,'summary_data',StatusImage);

try
    hgsave(FStatus,[fofile '.fig'])
    if ~isempty(findobj(FStatus,'Type','axes'))
        readyforprint([10 10],8,'k','w',0.5,FStatus)
    end
    print(FStatus,'-dpng',fofile)
    fprintf(LogFID,'* tower status images written to file ''%s''.\n', StatusImage);
    fprintf(1,'*tower status images written to file ''%s''.\n', StatusImage);
catch
    fprintf(LogFID,'WARNING: could not write status images to file.\n');
    fprintf(1,'WARNING: could not write status images to file.\n');
    warning('tower_doQC:StatusImageSaveFailed', ...
        ['Problem creating the status image files for ' data_file]);
end

close(FStatus)

%% ---------------
% PROFILES DISPLAY
% ----------------
if isdeployed
    FMetDisplay = figure('Name','Data overview','Visible','off');
else
    FMetDisplay = figure('Name','Data overview','Visible','on');
end

% generate profiles to show results (realtively static)
SubDisplayMetData(tower,datastream,qcd,FMetDisplay);

% Dump the image to file
fofile = fullfile(data_path,'summary_data',ProfileImage);

try
    hgsave(FMetDisplay,[fofile '.fig'])
    if ~isempty(findobj(FMetDisplay,'Type','axes'))
        readyforprint([10 7],8,'k','w',0.5,FMetDisplay)
    end
    print(FMetDisplay,'-dpng',fofile)
    fprintf(LogFID,'* profile image written to file ''%s''.\n', ProfileImage);
    fprintf(1,'*profile image written to file ''%s''.\n', ProfileImage);
catch
    fprintf(LogFID,'WARNING: could not write profile images to file.\n');
    fprintf(1,'WARNING: could not write profile images to file.\n');
    warning('tower_doQC:ProfileImageSaveFailed', ...
        ['Problem creating the profile image files for ' data_file]);
end
close(FMetDisplay)

%% -------
% WEB PAGE
% --------
try
    fofile = fullfile(data_path,'summary_data',HTMLPage);
    pageStruct.process = fofile;
    pageStruct.description = ['QC summary for the ' tower.name ' (site ' tower.id ') tower'];
    pageStruct.timeZone = 'GMT';
    pageStruct.filestring = fullfile(data_path,data_file);
    pageStruct.datestring = [datestr(qcd.file.starttime,'dddd mmmm dd yyyy at HH:MM:SS' ) ' ' tower.timezone];
    pageStruct.webAddy = config_path;
    pageStruct.hostname = SubGetHostname;
    
    % names of image files
    images.profile = [ProfileImage '.png'];
    images.timing = [TimingImage '.png'];
    images.status = [StatusImage '.png'];
    images.sonicspectra = [SpectraImage '.png'];
    
    % generate a structure containing information about data channels
    channelData = struct([]);
    for di = 1:numel(qcd.datastream)
        % check to see if we want this data
        if ~isempty(datastream{di}) && datastream{di}.qc.doqc
            % generate the structure we'll use for the HTML page
            channelData{end+1}.id = num2str(di);
            channelData{end}.name= datastream{di}.instrument.name;
            channelData{end}.height = num2str(datastream{di}.config.height);
            channelData{end}.mean = num2str(qcd.datastream{di}.data.downsampled.statistics.mean);
            channelData{end}.min = num2str(qcd.datastream{di}.data.downsampled.statistics.min);
            channelData{end}.max = num2str(qcd.datastream{di}.data.downsampled.statistics.max);
            channelData{end}.npoints = num2str(qcd.datastream{di}.data.downsampled.statistics.npoints);
            channelData{end}.nvalid = num2str(qcd.datastream{di}.limits.ninlimit);
            channelData{end}.pcvalid = sprintf('%4.2f (%4.2f)',...
                100*qcd.datastream{di}.data.downsampled.statistics.npoints/qcd.datastream{di}.limits.ntarget, ...
                100*datastream{di}.qc.accept.rate);
            channelData{end}.flags = num2str(qcd.datastream{di}.flags);
        end
    end
    
    % generate a structure containing information about sonic data
    for di = 1:numel(qcd.sonicpairs)
        sonicData{di}.height = num2str(qcd.sonicpairs{di}.height);
        sonicData{di}.horizspeed = num2str(qcd.sonicpairs{di}.CupEqHorizSpeed.value,'%3.2f');
        sonicData{di}.pcvalidspeed = [num2str(100*qcd.sonicpairs{di}.npoints/tower.windowsize,'%3.2f') ...
            ' (' num2str(100*tower.sonicpassrate) ')'];
        sonicData{di}.Ti_horiz = num2str(qcd.sonicpairs{di}.CupEqHorizTi.value,'%3.2f');
        sonicData{di}.ustar = num2str(qcd.sonicpairs{di}.ustar.value,'%3.2f');
        sonicData{di}.MOlength = num2str(qcd.sonicpairs{di}.MOlength.value,'%3.2f');
        sonicData{di}.zoverMOlength = num2str(qcd.sonicpairs{di}.zoverMOlength.value,'%3.2f');
        sonicData{di}.npoints = num2str(qcd.sonicpairs{di}.npoints);
        sonicData{di}.pcvalidrotation = [num2str(100*qcd.sonicpairs{di}.npoints/tower.windowsize,'%3.2f') ...
            ' (' num2str(100*tower.sonicrotaterate) ')'];
        sonicData{di}.flags = num2str(qcd.sonicpairs{di}.flags);
    end
    
    % generate an HTML page using the data
    %doQC_HTML(pageStruct,channelData,...
    %    fullfile(data_path,'summary_data',[strrep(data_file,'.dat','') '_profiles.jpg']))
    SubDisplayWebpage(pageStruct,channelData,sonicData,images)
    fprintf(LogFID,'* summary web page written to ''summary_data/%s''.\n',...
        HTMLPage);
    fprintf(1,'*summary web page written to ''summary_data/%s''.\n',...
        HTMLPage);
catch
    fprintf(LogFID,'WARNING: could not write web page to file.\n');
    fprintf(1,'WARNING: could not write web page to file.\n');
    warning('tower_doQC:HTMLSummaryNotCreated', ...
        ['Problem creating the HTML summary for ' data_file]);
end


%% -----------------------
% RAW DATA EXPORT (MATLAB)
% ------------------------
try
    SubWriteRawDataMATLAB(tower,datastream,raw_data,timestamp,...
        fullfile(data_path,'raw_data'),output_file)
    fprintf(LogFID,'* raw data written to matlab file ''raw_data/%s''.\n', output_file);
    fprintf(1,'*raw data written to matlab file ''raw_data/%s''.\n', output_file);
catch
    fprintf(LogFID,'ERROR: could not write raw data to file.\n');
    fprintf(1,'ERROR: could not write raw data to file.\n');
    error('tower_doQC:RawDataMatlabSaveFailed', ...
        ['Problem creating the raw data matlab files for ' data_file]);
end

%% ----------------
% SONIC DATA EXPORT
% -----------------
try
    % write the data in the sonic_out structure to file
    SubWriteSonicDataMATLAB(sonic_out,...
        fullfile(data_path,'raw_data'),output_file)
    fprintf(LogFID,'* sonic data appended to matlab file ''raw_data/%s''.\n', output_file);
    fprintf(1,'* sonic data appended to matlab file ''raw_data/%s''.\n', output_file);
catch
    fprintf(LogFID,'ERROR: could not write sonic data to file.\n');
    fprintf(1,'ERROR: could not write sonic data to file.\n');
    error('tower_doQC:SonicAnemometerDataSaveFailed', ...
        ['Problem creating the sonic anemometer data matlab files for ' data_file]);
end
% clean up
clear sonic_out

%% ------------------
% SUMMARY DATA EXPORT
% -------------------
try
    SubWriteSummaryDataMATLAB(tower,datastream,qcd,...
        output_path,output_file)
    fprintf(LogFID,'* processed data written to file ''summary_data/%s''.\n', output_file);
    fprintf(1,'* processed data written to file ''summary_data/%s''.\n', output_file);
catch
    fprintf(LogFID,'ERROR: could not write summary data to file.\n');
    fprintf(1,'ERROR: could not write summary data to file.\n');
    error('tower_doQC:WriteDateToFile', ...
        ['Problem creating the output data files for ' data_file]);
end


%% ----
% CLOCK
% -----
t = toc;
fprintf(1,'%3.2f seconds required to process this file.\n',t);
fprintf(LogFID,'%3.2f seconds required to process this file.\n',t);

% END MAIN ROUTINE
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%%%%%%%%                                                           %%%%%%%%
%%%%%%%%                   FUNCTIONS                               %%%%%%%%
%%%%%%%%                                                           %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% -----------------------
% FUNCTION: THERMODYNAMICS
% ------------------------
% function [z_out, BP_out, T_out, RH_out, DPT_out, PT_out, VPT_out,Fogrisk_out] = thermodynamics(...
%    Zground,ATground,DPTground,Pground,...
%    z_o,AT_o,DT_o,DPT_o)
%
% Calculate profiles of temperature, density and pressure on the tower.
%
% INPUTS
% ------
% Zground - height of the lowest sensor above ground (m)
% ATground - absolute temperature at ground level (degC)
% DPTground - dew point temperature at ground level (degC)
% Pground - pressure at ground level (mBar)
% z_o - height of observations (m)
% AT_o - observed air temperature (degC)
% DT_o - observed delta air temperature (degC)
% DPT_o - observed dew point temperature (degC)

function [z_out, BP_out, T_out, RH_out, DPT_out, PT_out, VT_out, VPT_out,Fogrisk_out] = thermodynamics(...
    Zground,ATground,DPTground,Pground,...
    z_o,AT_o,DT_o,DPT_o)

% Get the observed air temperatures (ATz_o) at each height.
for zi = 1:numel(AT_o.val)
    % the calculated air temperature is the sum of the delta t's below
    % this height
    if isnan(DT_o.val(zi))
        AT_c.val(zi) = AT_o.val(zi);
        AT_c.flags{zi} = DT_o.flags{zi};
    elseif zi ==1
        AT_c.val(zi) = ATground.val + DT_o.val(1);
        AT_c.flags{zi} = union(ATground.flags{1}, DT_o.flags{1});
    else
        AT_c.val(zi) = AT_c.val(zi-1) + DT_o.val(zi);
        AT_c.flags{zi} = union(AT_c.flags{zi-1}, DT_o.flags{1});
    end
end

% convert air temperatures to Kelvin
ATground.val = ATground.val+273.15;
AT_c.val = AT_c.val + 273.15;
AT_o.val = AT_o.val + 273.15;

% get the saturation vapour pressure at each height
ESground.val = sat_vapour_pressure(ATground.val);
ESground.flags{1} = ATground.flags{1};
for zi = 1:numel(AT_c.val)
    ES.val(zi) = sat_vapour_pressure(AT_c.val(zi));
    ES.flags{zi} = AT_c.flags{zi};
end

% convert dew point temperatures to Kelvin
DPTground.val = DPTground.val+273.15;
DPT_o.val = DPT_o.val + 273.15;

% get the actual vapour pressure using dewpoint sensors
Eground.val = sat_vapour_pressure(DPTground.val);
Eground.flags{1} = DPTground.flags{1};
for zi = 1:numel(AT_c.val)
    E.val(zi) = sat_vapour_pressure(DPT_o.val(zi));
    E.flags{zi} = DPT_o.flags{zi};
end

% calculate relative humidity at all heights
RHground.val = 100* Eground.val/ESground.val;
RHground.flags{1} = union(Eground.flags{1},ESground.flags{1});
if RHground.val > 100
    RHground.flags{1} = union(RHground.flags{1}, [5008]);
end
for zi = 1:numel(AT_c.val)
    RH.val(zi) = 100* E.val(zi) / ES.val(zi);
    if RH.val(zi) > 100
        RH.flags{zi} = 5008;
    else
        RH.flags{zi} = [];
    end
    RH.flags{zi} = union(E.flags{zi},...
        union(ES.flags{zi},RH.flags{zi}));
end

% calculate specific humidity at the ground
SPHUMground.val = 0.622*(Eground.val/Pground.val);
SPHUMground.flags{1} = union(Eground.flags{1},...
    union(RHground.flags{1},Pground.flags{1}));

% look for fog using difference between dewpoint and absolute temperature
% at all heights
% http://amsglossary.allenpress.com/glossary/search?id=fog1
Fog_risk_ground = (DPTground.val - ATground.val) > - 2.5;
for zi = 1:numel(AT_o.val)
    Fog_risk_c(zi) = (DPT_o.val(zi) - AT_o.val(zi)) > - 2.5;
    if isnan(AT_o.val(zi))
        Fog_risk_c(zi) = (DPT_o.val(zi) - AT_c.val(zi)) > - 2.5;
    end
end

% calculate virtual temperature at the ground
if isnan(SPHUMground.val)
    if ~isnan(ATground.val)
        VTground.val = ATground.val;
        VTground.flags{1} = 2000;
    else
        VTground.val = NaN;
        VTground.flags{1} = 5002;
    end
else
    VTground.val = ATground.val * (1 + 0.61*SPHUMground.val);
    VTground.flags{1} = union(ATground.flags{1},...
        union(SPHUMground.flags{1},ATground.flags{1}));
end

% calculate potential tempertaure at the ground
if ~isnan(ATground.val) && ~isnan(Pground.val)
    PTground.val = ATground.val*(1000/Pground.val)^0.286;
    PTground.flags{1} = union(ATground.flags{1}, Pground.flags{1});
else
    PTground.val = NaN;
    PTground.flags{1} = 5002;
end

% calculate virtual potential tempertaure at the ground
if ~isnan(SPHUMground.val) && ~isnan(ATground.val) && ~isnan(Pground.val)
    VPTground.val = (ATground.val*(1000/Pground.val)^0.286) * (1+0.61*SPHUMground.val);
    VPTground.flags{1} = union(SPHUMground.flags{1},...
        union(ATground.flags{1},Pground.flags{1}));
elseif isnan(SPHUMground.val) && ~isnan(ATground.val)
    VPTground.val = PTground.val;
    VPTground.flags{1} = 2000;
elseif RHground.val > 100
    VPTground.val = NaN;
    VPTground.flags{1} = 5008;
else
    VPTground.val = NaN;
    VPTground.flags{1} = 5002;
end

% calculate the barometric pressure gradient
if ~isnan(VTground.val)
    DELPCHG.val = (-0.0341416*Pground.val)/VTground.val;
    DELPCHG.flags{1} = union(Pground.flags{1},VTground.flags{1});
else
    DELPCHG.val = -0.031;
    DELPCHG.flags{1} = 2000;
end

% estimate the barometric pressure at the other heights
for zi = 1:numel(z_o)
    if ~isnan(DELPCHG.val)
        BP.val(zi) = Pground.val + DELPCHG.val * (z_o(zi)-Zground);
        BP.flags{zi} = union(Pground.flags{1},DELPCHG.flags{1});
    else
        BP.val(zi) = NaN;
        BP.flags{zi} = 5002;
    end
end

% get the specific humiddity at other heights
for zi = 1:numel(z_o)
    if ~isnan(BP.val(zi))
        SPHUM.val(zi) = 0.622 * E.val(zi) / BP.val(zi);
        SPHUM.flags{zi} = union(E.flags{1},BP.flags{1});
    else
        SPHUM.val(zi) = NaN;
        SPHUM.flags{zi} = 5002;
    end
end

% estimate potential temperature at other heights
for zi = 1:numel(z_o)
    if isnan(BP.val(zi))
        PT.val(zi) = NaN;
        PT.flags{zi} = 5002;
    else
        PT.val(zi) = AT_c.val(zi) *(1000/BP.val(zi))^0.286;
        PT.flags{zi} = union(AT_c.flags{zi},BP.flags{zi});
    end
end

% estimate virtual temperature at other heights
for zi = 1:numel(z_o)
    if isnan(BP.val(zi))
        VT.val(zi) = NaN;
        VT.flags{zi} = 5002;
    else
        VT.val(zi) = AT_c.val(zi) * (1 + 0.61 * SPHUM.val(zi));
        VT.flags{zi} = union(AT_c.flags{zi},SPHUM.flags{zi});
    end
end

% estimate virtual potential temperature at other heights
for zi = 1:numel(z_o)
    if isnan(BP.val(zi))
        VPT.val(zi) = NaN;
        VPT.flags{zi} = 5002;
    elseif isnan(SPHUM.val(zi))
        VPT.val(zi) = PT.val(zi);
        VPT.flags{zi} = 2000;
    else
        VPT.val(zi) = (AT_c.val(zi) *(1000/BP.val(zi))^0.286)*(1+0.61*SPHUM.val(zi));
        VPT.flags{zi} = union(SPHUM.flags{zi},union(AT_c.flags{zi},BP.flags{zi}));
    end
end

% gather outputs
z_out = [Zground z_o];
BP_out.value = [Pground.val BP.val];
BP_out.flags = [Pground.flags BP.flags];
T_out.value = [ATground.val AT_c.val];
T_out.flags = [ATground.flags AT_c.flags];
RH_out.value = [RHground.val RH.val];
RH_out.flags = [RHground.flags RH.flags];
DPT_out.value = [DPTground.val DPT_o.val];
DPT_out.flags = [DPTground.flags DPT_o.flags];
PT_out.value = [PTground.val PT.val];
PT_out.flags = [PTground.flags PT.flags];
VT_out.value = [VTground.val VT.val];
VT_out.flags = [VTground.flags VT.flags];
VPT_out.value = [VPTground.val VPT.val];
VPT_out.flags = [VPTground.flags VPT.flags];
Fogrisk_out = [Fog_risk_ground Fog_risk_c];

end
% END THERMODYNAMICS ROUTINE

%% ----------------------------
% FUNCTION: SAT_VAPOUR_PRESSURE
% -----------------------------
function es = sat_vapour_pressure(T)
% temperature needs to be in C
T = T - 273.15;
if T >= 0
    A = 7.5;
    B = 237.3;
else
    A = 9.5;
    B = 265.5;
end
es = 6.11 * 10.^((T*A)/(T+B));

end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION: PLOT_SMOOTHED_SPECTRA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = plot_smoothed_spectra(ax,fy,Pyy,clr)

[fysmooth,Pyysmooth] = SubSmoothPowerSpectra(fy,fy.*Pyy,...
    'nperdecade',10);
h = plot(ax,fysmooth,Pyysmooth,'k-','Color',clr);
hold(ax,'on')

end

%% %%%%%%%%%%%%%%%%%
% FUNCTION: QC_color
% %%%%%%%%%%%%%%%%%%

function clr = QC_color(QC_flags)

if sum(QC_flags > 5000) >=1
    clr = [1 1 1];
elseif sum(QC_flags > 1000) >=1
    clr = [0.8 0.8 0.8];
else
    clr = [0 0 0];
end

end
