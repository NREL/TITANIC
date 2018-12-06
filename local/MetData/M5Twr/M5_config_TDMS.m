% M5_config.m
%
% File describing the configuration of the M4 (Siemens) mast. To
% be used to guide initial data QA/QC process.
%
% Changes to instrumentation should be added to the bottom of the file as a
% new or redefined datastream.
%
% Change log
% -----------
% 1.0 	5/06/2013	- updated file names
% 0.2 	7/7/2011	- added boom orientation
% 					- all channels from individual sonics are now tied together (
% 					(e.g, all 131 m, etc) so that a flag or fail on one channel
%					will cascade to the other channels on the same device. This is
%					listed in the variables, .qc.alsoflag and .qc.alsofail
% 0.1	2/14/2011	- concept file

%% ----------
% CONFIG INFO
% -----------
tower.config.date = [2014 01 06 0 0 0]; % date the configuration file was last changed.

%% --------
% MAST INFO
% ---------
tower.name = 'M5';
tower.id = '4.0';
tower.baseheight= 1845; % height of base above sea level [m]. (was 1625 - wrong!)

% time zone
tower.UTCoffset = -7;   % offset local to UTC, not including daylight savings time
tower.timezone = 'MST'; % local time zone

% DAQ details
tower.daq.freq.value(1) = 20;
tower.daq.freq.fromdate(1,:) = [0 0 0 0 0 0];
tower.daq.duration.value(1) = 10; 		% interval duration in minutes
tower.daq.duration.fromdate(1,:) = [0 0 0 0 0 0]; 

%% ----------
% PROFILE INFO
% ------------

% wind speed / direction pairs are required to calculate mean wind
% directions. Column 1 is the number of the datastream giving speed, column
% 2 is the number of the datastream giving wind direction. If no direction
% data is available, use 'NaN' in the second column.
tower.veldirpairs = [65 NaN; ...
    66 40;...
    67 NaN;...
    68 41;...
    69 NaN;...
    70 NaN;...
    71 42;...
    72 NaN;...
    73 43;...
    74 44];
tower.veldetrendingorder = 0;

% THERMODYNAMICS
% Define channels used for temperature profiles
tower.thermodynamics.zground = 32;  % channel at the ground
tower.thermodynamics.Pground = 63;  % reference pressure
tower.thermodynamics.ATground = 32; % air temperature
tower.thermodynamics.DPTground = 36;    % dewpoint temperature
tower.thermodynamics.AT = [31 30 NaN];  % air temperatures
tower.thermodynamics.DT = [39 38 37];   % temperature differentials
tower.thermodynamics.DPT = [35 34 33];  % dewpoint temperatures

% SONIC ANEMOMETERS
% Sonic Anemometer u, v, w, T pairs.
tower.sonicrotationmethod = 'pitchnyaw';    % method used for rotation
tower.sonicdetrendingorder = 0;
tower.sonicinterpmethod = 'linear';
tower.sonicpassrate = 0.92;
tower.sonicrotaterate = 0.95;
tower.sonictype = {'ATIK';'ATIK';'ATIK';'ATIK';'ATIK';'ATIK'};
% apply despiking to the sonics? (true / false matrix)
tower.sonicdespike = [1 1 1 1 1 1];
% tower.sonicpairs = u,v,w,T,x acc,y acc,z acc
tower.sonicpairs = [6 7 8 9 45 46 47;...
    10 11 12 13 48 49 50;...
    14 15 16 17 51 52 53;...
    18 19 20 21 54 55 56;...
    22 23 24 25 57 58 59;...
    26 27 28 29 60 61 62];

% RICHARDSON NUMBER
% wind speed, wind direction and temperature pairs are required to
% calculate a Richardson number. Data below are given as the index of the
% wind speed instruments to calculate the richardson number across, e.g.
% instrument 12 to 31, etc.
tower.richardsonpairs = [71 66;...  % tip-to-tip
    74 66;...   % ground-to-top
    74 68;...   % ground-to-hub
    71 73];     % tip-to-10 m

% SHEAR
tower.shearpairs{1} = [71 66];              % tip to tip
tower.shearpairs{2} = [74 66];              % tip to ground
tower.shearpairs{3} = [74 68];              % hub to ground
tower.shearpairs{4} = [71 68];              % hub to bottom
tower.shearpairs{5} = [73 68];              % hub to 10 m
tower.shearpairs{6} = [68 71 73 74];        % all heights hub to ground
tower.shearpairs{7} = [65 67 69 70 72];     % all class ones fropm top to bottom

% PRECIPITATION
tower.precipsensor = 64;

% profiles to display
% datastreams to plot as part of a velocity profile
tower.velprofile = [65 66 67 68 69 70 71 72 73 74];
% datastreams to plot as part of a tempeature profile
tower.tempprofile = [30 31 32];

%% --------
% DATA FILE
% ---------
tower.processing.datafile.type = 'NWTC_TDMS';
tower.processing.datafile.extension = '*.tdms';
tower.processing.datafile.dateFormatStr = 'mm_dd_yyyy_HH_MM_SS';

tower.processing.datafile.scaledwords = 8:76;
tower.processing.datafile.framelength = 78;
tower.processing.datafile.nframes = 12000;
tower.processing.datafile.pguword = 77;
tower.processing.datafile.asprword = 78;

%% ----------
% DATASTREAMS
% -----------

% 119 m Sonic U-component velocity
datastream{6}.config.height = 119;     % height above ground [m]
datastream{6}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{6}.config.inflow = 278;        % inflow angle [deg mag]

datastream{6}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{6}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{6}.instrument.name = 'Sonic x velocity';                 % descriptive name for charts, etc
datastream{6}.instrument.variable = 'Sonic_x_119';                  % variable name
datastream{6}.instrument.TDMSchanName = '119m_U';
datastream{6}.instrument.measures = 'velocity';             % measurement type
datastream{6}.instrument.units ='m/s';                      % units (SI as far as possible)

datastream{6}.qc.doqc = 1;
datastream{6}.qc.nanvalue =-99999;                       % NaN value
datastream{6}.qc.range.max = 35.05;              % maximum measurement value
datastream{6}.qc.range.min = -35.05;              % minimum measurement value
datastream{6}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{6}.qc.accept.max = 35.05;             % maximum acceptable value
datastream{6}.qc.accept.min = -35.05;             % minimum acceptable value
datastream{6}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{6}.qc.alsoflag = [7 8 9];                % datastream to flag as well
datastream{6}.qc.alsofail = [7 8 9];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 119 m Sonic V-component velocity
datastream{7}.config.height = 119;     % height above ground [m]
datastream{7}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{7}.config.inflow = 278;        % inflow angle [deg mag]

datastream{7}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{7}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{7}.instrument.name = 'Sonic y velocity';                 % descriptive name for charts, etc
datastream{7}.instrument.variable = 'Sonic_y_119';                  % variable name
datastream{7}.instrument.TDMSchanName = '119m_V';
datastream{7}.instrument.measures = 'velocity';             % measurement type
datastream{7}.instrument.units ='m/s';                      % units (SI as far as possible)

datastream{7}.qc.doqc = 1;
datastream{7}.qc.nanvalue =-99999;                       % NaN value
datastream{7}.qc.range.max = 35.05;              % maximum measurement value
datastream{7}.qc.range.min = -35.05;              % minimum measurement value
datastream{7}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{7}.qc.accept.max = 35.05;             % maximum acceptable value
datastream{7}.qc.accept.min = -35.05;             % minimum acceptable value
datastream{7}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{7}.qc.alsoflag = [6 8 9];                % datastream to flag as well
datastream{7}.qc.alsofail = [6 8 9];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 119 m Sonic W-component velocity
datastream{8}.config.height = 119;     % height above ground [m]
datastream{8}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{8}.config.inflow = 278;        % inflow angle [deg mag]

datastream{8}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{8}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{8}.instrument.name = 'Sonic z velocity';                 % descriptive name for charts, etc
datastream{8}.instrument.variable = 'Sonic_z_119';                  % variable name
datastream{8}.instrument.TDMSchanName = '119m_W';
datastream{8}.instrument.measures = 'velocity';             % measurement type
datastream{8}.instrument.units ='m/s';                      % units (SI as far as possible)

datastream{8}.qc.doqc = 1;
datastream{8}.qc.nanvalue =100;                       % NaN value
datastream{8}.qc.range.max = 29.95;              % maximum measurement value
datastream{8}.qc.range.min = -29.95;              % minimum measurement value
datastream{8}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{8}.qc.accept.max = 29.95;             % maximum acceptable value
datastream{8}.qc.accept.min = -29.95;             % minimum acceptable value
datastream{8}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{8}.qc.alsoflag = [6 7 9];                % datastream to flag as well
datastream{8}.qc.alsofail = [6 7 9];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 119 m Sonic Temperature
datastream{9}.config.height = 119;     % height above ground [m]
datastream{9}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{9}.config.inflow = 278;        % inflow angle [deg mag]

datastream{9}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{9}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{9}.instrument.name = 'Sonic temperature';                 % descriptive name for charts, etc
datastream{9}.instrument.variable = 'Sonic_Temp_119';                  % variable name
datastream{9}.instrument.TDMSchanName = '119m_T';
datastream{9}.instrument.measures = 'temperature';             % measurement type
datastream{9}.instrument.units =sprintf('%cC',char(176));            % units (SI as far as possible)

datastream{9}.qc.doqc = 1;
datastream{9}.qc.nanvalue =-99999;                       % NaN value
datastream{9}.qc.range.max = +49.95;              % maximum measurement value
datastream{9}.qc.range.min = -19.95;              % minimum measurement value
datastream{9}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{9}.qc.accept.max = +49.95;             % maximum acceptable value
datastream{9}.qc.accept.min = -19.95;             % minimum acceptable value
datastream{9}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{9}.qc.alsoflag = [6 7 8];                % datastream to flag as well
datastream{9}.qc.alsofail = [6 7 8];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 100 m Sonic U-component velocity
datastream{10}.config.height = 100;     % height above ground [m]
datastream{10}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{10}.config.inflow = 278;        % inflow angle [deg mag]

datastream{10}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{10}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{10}.instrument.name = 'Sonic x velocity';                 % descriptive name for charts, etc
datastream{10}.instrument.variable = 'Sonic_x_100';                  % variable name
datastream{10}.instrument.TDMSchanName = '100m_U';
datastream{10}.instrument.measures = 'MEASTYPE';             % measurement type
datastream{10}.instrument.units ='m/s';                       % units (SI as far as possible)

datastream{10}.qc.doqc = 1;
datastream{10}.qc.nanvalue =-99999;                       % NaN value
datastream{10}.qc.range.max = 35.05;              % maximum measurement value
datastream{10}.qc.range.min = -35.05;              % minimum measurement value
datastream{10}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{10}.qc.accept.max = 35.05;             % maximum acceptable value
datastream{10}.qc.accept.min = -35.05;             % minimum acceptable value
datastream{10}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{10}.qc.alsoflag = [11 12 13];                % datastream to flag as well
datastream{10}.qc.alsofail = [11 12 13];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 100 m Sonic V-component velocity
datastream{11}.config.height = 100;     % height above ground [m]
datastream{11}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{11}.config.inflow = 278;        % inflow angle [deg mag]

datastream{11}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{11}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{11}.instrument.name = 'Sonic y velocity';                 % descriptive name for charts, etc
datastream{11}.instrument.variable = 'Sonic_y_100';                  % variable name
datastream{11}.instrument.TDMSchanName = '100m_V';
datastream{11}.instrument.measures = 'velocity';             % measurement type
datastream{11}.instrument.units ='m/s';                       % units (SI as far as possible)

datastream{11}.qc.doqc = 1;
datastream{11}.qc.nanvalue =-99999;                       % NaN value
datastream{11}.qc.range.max = 35.05;              % maximum measurement value
datastream{11}.qc.range.min = -35.05;              % minimum measurement value
datastream{11}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{11}.qc.accept.max = 35.05;             % maximum acceptable value
datastream{11}.qc.accept.min = -35.05;             % minimum acceptable value
datastream{11}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{11}.qc.alsoflag = [10 12 13];                % datastream to flag as well
datastream{11}.qc.alsofail = [10 12 13];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 100 m Sonic W-component velocity
datastream{12}.config.height = 100;     % height above ground [m]
datastream{12}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{12}.config.inflow = 278;        % inflow angle [deg mag]

datastream{12}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{12}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{12}.instrument.name = 'Sonic z velocity';                 % descriptive name for charts, etc
datastream{12}.instrument.variable = 'Sonic_z_100';                  % variable name
datastream{12}.instrument.TDMSchanName = '100m_W';
datastream{12}.instrument.measures = 'velocity';             % measurement type
datastream{12}.instrument.units ='m/s';                       % units (SI as far as possible)

datastream{12}.qc.doqc = 1;
datastream{12}.qc.nanvalue =-99999;                       % NaN value
datastream{12}.qc.range.max = 29.95;              % maximum measurement value
datastream{12}.qc.range.min = -29.95;              % minimum measurement value
datastream{12}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{12}.qc.accept.max = 29.95;             % maximum acceptable value
datastream{12}.qc.accept.min = -29.95;             % minimum acceptable value
datastream{12}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{12}.qc.alsoflag = [10 11 13];                % datastream to flag as well
datastream{12}.qc.alsofail = [10 11 13];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 100 m Sonic Temperature
datastream{13}.config.height = 100;     % height above ground [m]
datastream{13}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{13}.config.inflow = 278;        % inflow angle [deg mag]

datastream{13}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{13}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{13}.instrument.name = 'Sonic temperature';                 % descriptive name for charts, etc
datastream{13}.instrument.variable = 'Sonic_Temp_100';                  % variable name
datastream{13}.instrument.TDMSchanName = '100m_T';
datastream{13}.instrument.measures = 'temperature';             % measurement type
datastream{13}.instrument.units =sprintf('%cC',char(176));          % units (SI as far as possible)

datastream{13}.qc.doqc = 1;
datastream{13}.qc.nanvalue =100;                       % NaN value
datastream{13}.qc.range.max = +49.95;              % maximum measurement value
datastream{13}.qc.range.min = -19.95;              % minimum measurement value
datastream{13}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{13}.qc.accept.max = +49.95;             % maximum acceptable value
datastream{13}.qc.accept.min = -19.95;             % minimum acceptable value
datastream{13}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{13}.qc.alsoflag = [10 11 12];                % datastream to flag as well
datastream{13}.qc.alsofail = [10 11 12];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 74 m Sonic U-component velocity
datastream{14}.config.height = 74;     % height above ground [m]
datastream{14}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{14}.config.inflow = 278;        % inflow angle [deg mag]

datastream{14}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{14}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{14}.instrument.name = 'Sonic x velocity';                 % descriptive name for charts, etc
datastream{14}.instrument.variable = 'Sonic_x_74';                  % variable name
datastream{14}.instrument.TDMSchanName = '74m_U';
datastream{14}.instrument.measures = 'velocity';             % measurement type
datastream{14}.instrument.units ='m/s';                      % units (SI as far as possible)

datastream{14}.qc.doqc = 1;
datastream{14}.qc.nanvalue =100;                       % NaN value
datastream{14}.qc.range.max = 35.05;              % maximum measurement value
datastream{14}.qc.range.min = -35.05;              % minimum measurement value
datastream{14}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{14}.qc.accept.max = 35.05;             % maximum acceptable value
datastream{14}.qc.accept.min = -35.05;             % minimum acceptable value
datastream{14}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{14}.qc.alsoflag = [15 16 17];                % datastream to flag as well
datastream{14}.qc.alsofail = [15 16 17];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 74 m Sonic V-component velocity
datastream{15}.config.height = 74;     % height above ground [m]
datastream{15}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{15}.config.inflow = 278;        % inflow angle [deg mag]

datastream{15}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{15}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{15}.instrument.name = 'Sonic y velocity';                 % descriptive name for charts, etc
datastream{15}.instrument.variable = 'Sonic_y_74';                  % variable name
datastream{15}.instrument.TDMSchanName = '74m_V';
datastream{15}.instrument.measures = 'velocity';             % measurement type
datastream{15}.instrument.units ='m/s';                      % units (SI as far as possible)

datastream{15}.qc.doqc = 1;
datastream{15}.qc.nanvalue =100;                       % NaN value
datastream{15}.qc.range.max = 35.05;              % maximum measurement value
datastream{15}.qc.range.min = -35.05;              % minimum measurement value
datastream{15}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{15}.qc.accept.max = 35.05;             % maximum acceptable value
datastream{15}.qc.accept.min = -35.05;             % minimum acceptable value
datastream{15}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{15}.qc.alsoflag = [14 16 17];                % datastream to flag as well
datastream{15}.qc.alsofail = [14 16 17];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 74 m Sonic W-component velocity
datastream{16}.config.height = 74;     % height above ground [m]
datastream{16}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{16}.config.inflow = 278;        % inflow angle [deg mag]

datastream{16}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{16}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{16}.instrument.name = 'Sonic z velocity';                 % descriptive name for charts, etc
datastream{16}.instrument.variable = 'Sonic_z_74';                  % variable name
datastream{16}.instrument.TDMSchanName = '74m_W';
datastream{16}.instrument.measures = 'velocity';             % measurement type
datastream{16}.instrument.units ='m/s';                      % units (SI as far as possible)

datastream{16}.qc.doqc = 1;
datastream{16}.qc.nanvalue =100;                       % NaN value
datastream{16}.qc.range.max = 29.95;              % maximum measurement value
datastream{16}.qc.range.min = -29.95;              % minimum measurement value
datastream{16}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{16}.qc.accept.max = 29.95;             % maximum acceptable value
datastream{16}.qc.accept.min = -29.95;             % minimum acceptable value
datastream{16}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{16}.qc.alsoflag = [14 15 17];                % datastream to flag as well
datastream{16}.qc.alsofail = [14 15 17];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 74 m Sonic Temperature
datastream{17}.config.height = 74;     % height above ground [m]
datastream{17}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{17}.config.inflow = 278;        % inflow angle [deg mag]

datastream{17}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{17}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{17}.instrument.name = 'Sonic temperature';                 % descriptive name for charts, etc
datastream{17}.instrument.variable = 'Sonic_Temp_74';                  % variable name
datastream{17}.instrument.TDMSchanName = '74m_T';
datastream{17}.instrument.measures = 'temperature';             % measurement type
datastream{17}.instrument.units =sprintf('%cC',char(176));         % units (SI as far as possible)

datastream{17}.qc.doqc = 1;
datastream{17}.qc.nanvalue =100;                       % NaN value
datastream{17}.qc.range.max = +49.95;              % maximum measurement value
datastream{17}.qc.range.min = -19.95;              % minimum measurement value
datastream{17}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{17}.qc.accept.max = +49.95;             % maximum acceptable value
datastream{17}.qc.accept.min = -19.95;             % minimum acceptable value
datastream{17}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{17}.qc.alsoflag = [14 15 16];                % datastream to flag as well
datastream{17}.qc.alsofail = [14 15 16];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 61 m Sonic U-component velocity
datastream{18}.config.height = 61;     % height above ground [m]
datastream{18}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{18}.config.inflow = 278;        % inflow angle [deg mag]

datastream{18}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{18}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{18}.instrument.name = 'Sonic x velocity';                 % descriptive name for charts, etc
datastream{18}.instrument.variable = 'Sonic_x_61';                  % variable name
datastream{18}.instrument.TDMSchanName = '61m_U';
datastream{18}.instrument.measures = 'velocity';             % measurement type
datastream{18}.instrument.units ='m/s';                      % units (SI as far as possible)

datastream{18}.qc.doqc = 1;
datastream{18}.qc.nanvalue =100;                       % NaN value
datastream{18}.qc.range.max = 35.05;              % maximum measurement value
datastream{18}.qc.range.min = -35.05;              % minimum measurement value
datastream{18}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{18}.qc.accept.max = 35.05;             % maximum acceptable value
datastream{18}.qc.accept.min = -35.05;             % minimum acceptable value
datastream{18}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{18}.qc.alsoflag = [19 20 21];                % datastream to flag as well
datastream{18}.qc.alsofail = [19 20 21];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 61 m Sonic V-component velocity
datastream{19}.config.height = 61;     % height above ground [m]
datastream{19}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{19}.config.inflow = 278;        % inflow angle [deg mag]

datastream{19}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{19}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{19}.instrument.name = 'Sonic y velocity';                 % descriptive name for charts, etc
datastream{19}.instrument.variable = 'Sonic_y_61';                  % variable name
datastream{19}.instrument.TDMSchanName = '61m_V';
datastream{19}.instrument.measures = 'velocity';             % measurement type
datastream{19}.instrument.units ='m/s';                      % units (SI as far as possible)

datastream{19}.qc.doqc = 1;
datastream{19}.qc.nanvalue =100;                       % NaN value
datastream{19}.qc.range.max = 35.05;              % maximum measurement value
datastream{19}.qc.range.min = -35.05;              % minimum measurement value
datastream{19}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{19}.qc.accept.max = 35.05;             % maximum acceptable value
datastream{19}.qc.accept.min = -35.05;             % minimum acceptable value
datastream{19}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{19}.qc.alsoflag = [18 20 21];                % datastream to flag as well
datastream{19}.qc.alsofail = [18 20 21];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 61m Sonic W-component velocity
datastream{20}.config.height = 61;     % height above ground [m]
datastream{20}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{20}.config.inflow = 278;        % inflow angle [deg mag]

datastream{20}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{20}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{20}.instrument.name = 'Sonic z velocity';                 % descriptive name for charts, etc
datastream{20}.instrument.variable = 'Sonic_z_61';                  % variable name
datastream{20}.instrument.TDMSchanName = '61m_W';
datastream{20}.instrument.measures = 'velocity';             % measurement type
datastream{20}.instrument.units ='m/s';                      % units (SI as far as possible)

datastream{20}.qc.doqc = 1;
datastream{20}.qc.nanvalue =100;                       % NaN value
datastream{20}.qc.range.max = 29.95;              % maximum measurement value
datastream{20}.qc.range.min = -29.95;              % minimum measurement value
datastream{20}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{20}.qc.accept.max = 29.95;             % maximum acceptable value
datastream{20}.qc.accept.min = -29.95;             % minimum acceptable value
datastream{20}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{20}.qc.alsoflag = [18 19 21];                % datastream to flag as well
datastream{20}.qc.alsofail = [18 19 21];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 61 m Sonic Temperature
datastream{21}.config.height = 61;     % height above ground [m]
datastream{21}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{21}.config.inflow = 278;        % inflow angle [deg mag]

datastream{21}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{21}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{21}.instrument.name = 'Sonic Temperature';                 % descriptive name for charts, etc
datastream{21}.instrument.variable = 'Sonic_Temp_61';                  % variable name
datastream{21}.instrument.TDMSchanName = '61m_T';
datastream{21}.instrument.measures = 'temperature';             % measurement type
datastream{21}.instrument.units = sprintf('%cC',char(176));             % units (SI as far as possible)

datastream{21}.qc.doqc = 1;
datastream{21}.qc.nanvalue =100;                       % NaN value
datastream{21}.qc.range.max = +49.95;              % maximum measurement value
datastream{21}.qc.range.min = -19.95;              % minimum measurement value
datastream{21}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{21}.qc.accept.max = +49.95;             % maximum acceptable value
datastream{21}.qc.accept.min = -19.95;             % minimum acceptable value
datastream{21}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{21}.qc.alsoflag = [18 19 20];                % datastream to flag as well
datastream{21}.qc.alsofail = [18 19 20];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 41 m Sonic U-component velocity
datastream{22}.config.height = 41;     % height above ground [m]
datastream{22}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{22}.config.inflow = 278;        % inflow angle [deg mag]

datastream{22}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{22}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{22}.instrument.name = 'Sonic x velocity';                 % descriptive name for charts, etc
datastream{22}.instrument.variable = 'Sonic_x_41';                  % variable name
datastream{22}.instrument.TDMSchanName = '41m_U';
datastream{22}.instrument.measures = 'velocity';             % measurement type
datastream{22}.instrument.units ='m/s';                       % units (SI as far as possible)

datastream{22}.qc.doqc = 1;
datastream{22}.qc.nanvalue =100;                       % NaN value
datastream{22}.qc.range.max = 35.05;              % maximum measurement value
datastream{22}.qc.range.min = -35.05;              % minimum measurement value
datastream{22}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{22}.qc.accept.max = 35.05;             % maximum acceptable value
datastream{22}.qc.accept.min = -35.05;             % minimum acceptable value
datastream{22}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{22}.qc.alsoflag = [23 24 25];                % datastream to flag as well
datastream{22}.qc.alsofail = [23 24 25];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 41 m Sonic V-component velocity
datastream{23}.config.height = 41;     % height above ground [m]
datastream{23}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{23}.config.inflow = 278;        % inflow angle [deg mag]

datastream{23}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{23}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{23}.instrument.name = 'Sonic y velocity';                 % descriptive name for charts, etc
datastream{23}.instrument.variable = 'Sonic_y_41';                  % variable name
datastream{23}.instrument.TDMSchanName = '41m_V';
datastream{23}.instrument.measures = 'velocity';             % measurement type
datastream{23}.instrument.units ='m/s';                       % units (SI as far as possible)

datastream{23}.qc.doqc = 1;
datastream{23}.qc.nanvalue =100;                       % NaN value
datastream{23}.qc.range.max = 35.05;              % maximum measurement value
datastream{23}.qc.range.min = -35.05;              % minimum measurement value
datastream{23}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{23}.qc.accept.max = 35.05;             % maximum acceptable value
datastream{23}.qc.accept.min = -35.05;             % minimum acceptable value
datastream{23}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{23}.qc.alsoflag = [22 24 25];                % datastream to flag as well
datastream{23}.qc.alsofail = [22 24 25];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 30 m 30m_Sonic W-component velocity
datastream{24}.config.height = 41;     % height above ground [m]
datastream{24}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{24}.config.inflow = 278;        % inflow angle [deg mag]

datastream{24}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{24}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{24}.instrument.name = 'Sonic z velocity';                 % descriptive name for charts, etc
datastream{24}.instrument.variable = 'Sonic_z_41';                  % variable name
datastream{24}.instrument.TDMSchanName = '41m_W';
datastream{24}.instrument.measures = 'velocity';             % measurement type
datastream{24}.instrument.units ='m/s';                       % units (SI as far as possible)

datastream{24}.qc.doqc = 1;
datastream{24}.qc.nanvalue =100;                       % NaN value
datastream{24}.qc.range.max = 29.95;              % maximum measurement value
datastream{24}.qc.range.min = -29.95;              % minimum measurement value
datastream{24}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{24}.qc.accept.max = 29.95;             % maximum acceptable value
datastream{24}.qc.accept.min = -29.95;             % minimum acceptable value
datastream{24}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{24}.qc.alsoflag = [22 23 25];                % datastream to flag as well
datastream{24}.qc.alsofail = [22 23 25];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 41 m Sonic Temperature
datastream{25}.config.height = 41;     % height above ground [m]
datastream{25}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{25}.config.inflow = 278;        % inflow angle [deg mag]

datastream{25}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{25}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{25}.instrument.name = 'Sonic temperature';                 % descriptive name for charts, etc
datastream{25}.instrument.variable = 'Sonic_Temp_41';                  % variable name
datastream{25}.instrument.TDMSchanName = '41m_T';
datastream{25}.instrument.measures = 'temperature';             % measurement type
datastream{25}.instrument.units = sprintf('%cC',char(176));     % units (SI as far as possible)

datastream{25}.qc.doqc = 1;
datastream{25}.qc.nanvalue =100;                       % NaN value
datastream{25}.qc.range.max = +49.95;              % maximum measurement value
datastream{25}.qc.range.min = -19.95;              % minimum measurement value
datastream{25}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{25}.qc.accept.max = +49.95;             % maximum acceptable value
datastream{25}.qc.accept.min = -19.95;             % minimum acceptable value
datastream{25}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{25}.qc.alsoflag = [22 23 24];                % datastream to flag as well
datastream{25}.qc.alsofail = [22 23 24];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 15 m Sonic U-component velocity
datastream{26}.config.height = 15;     % height above ground [m]
datastream{26}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{26}.config.inflow = 278;        % inflow angle [deg mag]

datastream{26}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{26}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{26}.instrument.name = 'Sonic x velocity';                 % descriptive name for charts, etc
datastream{26}.instrument.variable = 'Sonic_x_15';                  % variable name
datastream{26}.instrument.TDMSchanName = '15m_U';
datastream{26}.instrument.measures = 'velocity';             % measurement type
datastream{26}.instrument.units ='m/s';                       % units (SI as far as possible)

datastream{26}.qc.doqc = 1;
datastream{26}.qc.nanvalue =100;                       % NaN value
datastream{26}.qc.range.max = 35.05;              % maximum measurement value
datastream{26}.qc.range.min = -35.05;              % minimum measurement value
datastream{26}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{26}.qc.accept.max = 35.05;             % maximum acceptable value
datastream{26}.qc.accept.min = -35.05;             % minimum acceptable value
datastream{26}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{26}.qc.alsoflag = [27 28 29];                % datastream to flag as well
datastream{26}.qc.alsofail = [27 28 29];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 15 m Sonic V-component velocity
datastream{27}.config.height = 15;     % height above ground [m]
datastream{27}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{27}.config.inflow = 278;        % inflow angle [deg mag]

datastream{27}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{27}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{27}.instrument.name = 'Sonic y velocity';                 % descriptive name for charts, etc
datastream{27}.instrument.variable = 'Sonic_y_15';                  % variable name
datastream{27}.instrument.TDMSchanName = '15m_V';
datastream{27}.instrument.measures = 'velocity';             % measurement type
datastream{27}.instrument.units ='m/s';                       % units (SI as far as possible)

datastream{27}.qc.doqc = 1;
datastream{27}.qc.nanvalue =100;                       % NaN value
datastream{27}.qc.range.max = 35.05;              % maximum measurement value
datastream{27}.qc.range.min = -35.05;              % minimum measurement value
datastream{27}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{27}.qc.accept.max = 35.05;             % maximum acceptable value
datastream{27}.qc.accept.min = -35.05;             % minimum acceptable value
datastream{27}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{27}.qc.alsoflag = [26 28 29];                % datastream to flag as well
datastream{27}.qc.alsofail = [26 28 29];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 15 m Sonic W-component velocity
datastream{28}.config.height = 15;     % height above ground [m]
datastream{28}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{28}.config.inflow = 278;        % inflow angle [deg mag]

datastream{28}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{28}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{28}.instrument.name = 'Sonic z velocity';                 % descriptive name for charts, etc
datastream{28}.instrument.variable = 'Sonic_z_15';                  % variable name
datastream{28}.instrument.TDMSchanName = '15m_W';
datastream{28}.instrument.measures = 'velocity';             % measurement type
datastream{28}.instrument.units ='m/s';                       % units (SI as far as possible)

datastream{28}.qc.doqc = 1;
datastream{28}.qc.nanvalue =100;                       % NaN value
datastream{28}.qc.range.max = 29.95;              % maximum measurement value
datastream{28}.qc.range.min = -29.95;              % minimum measurement value
datastream{28}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{28}.qc.accept.max = 29.95;             % maximum acceptable value
datastream{28}.qc.accept.min = -29.95;             % minimum acceptable value
datastream{28}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{28}.qc.alsoflag = [26 27 29];                % datastream to flag as well
datastream{28}.qc.alsofail = [26 27 29];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 15 m Sonic Temperature
datastream{29}.config.height = 15;     % height above ground [m]
datastream{29}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{29}.config.inflow = 278;        % inflow angle [deg mag]

datastream{29}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{29}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{29}.instrument.name = 'Sonic temperature';                 % descriptive name for charts, etc
datastream{29}.instrument.variable = 'Sonic_Temp_15';                  % variable name
datastream{29}.instrument.TDMSchanName = '15m_T';
datastream{29}.instrument.measures = 'temperature';             % measurement type
datastream{29}.instrument.units = sprintf('%cC',char(176));            % units (SI as far as possible)

datastream{29}.qc.doqc = 1;
datastream{29}.qc.nanvalue = 100;                       % NaN value
datastream{29}.qc.range.max = +49.95;              % maximum measurement value
datastream{29}.qc.range.min = -19.95;              % minimum measurement value
datastream{29}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{29}.qc.accept.max = +49.95;             % maximum acceptable value
datastream{29}.qc.accept.min = -19.95;             % minimum acceptable value
datastream{29}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{29}.qc.alsoflag = [26 27 28];                % datastream to flag as well
datastream{29}.qc.alsofail = [26 27 28];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 87 m Air Temperature
datastream{30}.config.height = 87;     % height above ground [m]
datastream{30}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{30}.config.inflow = 278;        % inflow angle [deg mag]

datastream{30}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{30}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{30}.instrument.name = 'Air temperature';                 % descriptive name for charts, etc
datastream{30}.instrument.variable = 'Air_Temp_87m';                  % variable name
datastream{30}.instrument.TDMSchanName = 'Air_Temp_87M';
datastream{30}.instrument.measures = 'temperature';             % measurement type
datastream{30}.instrument.units =sprintf('%cC',char(176));        % units (SI as far as possible)
datastream{30}.instrument.skipnsamples = 20;

datastream{30}.qc.doqc = 1;
datastream{30}.qc.nanvalue =-99999;                       % NaN value
datastream{30}.qc.range.max = 50;              % maximum measurement value
datastream{30}.qc.range.min = -50;              % minimum measurement value
datastream{30}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{30}.qc.accept.max = 50;             % maximum acceptable value
datastream{30}.qc.accept.min = -50;             % minimum acceptable value
datastream{30}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{30}.qc.alsoflag = [37];                % datastream to flag as well
datastream{30}.qc.alsofail = [37];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 38 m Air Temperature
datastream{31}.config.height = 38;     % height above ground [m]
datastream{31}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{31}.config.inflow = 278;        % inflow angle [deg mag]

datastream{31}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{31}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{31}.instrument.name = 'Air temperature';                 % descriptive name for charts, etc
datastream{31}.instrument.variable = 'Air_Temp_38m';                  % variable name
datastream{31}.instrument.TDMSchanName = 'Air_Temp_38m';
datastream{31}.instrument.measures = 'temperature';             % measurement type
datastream{31}.instrument.units =sprintf('%cC',char(176));         % units (SI as far as possible)
datastream{31}.instrument.skipnsamples = 20;

datastream{31}.qc.doqc = 1;
datastream{31}.qc.nanvalue =-99999;                       % NaN value
datastream{31}.qc.range.max = 50;              % maximum measurement value
datastream{31}.qc.range.min = -50;              % minimum measurement value
datastream{31}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{31}.qc.accept.max = 50;             % maximum acceptable value
datastream{31}.qc.accept.min = -50;             % minimum acceptable value
datastream{31}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{31}.qc.alsoflag = [];                % datastream to flag as well
datastream{31}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 3 m Air Temperature
datastream{32}.config.height = 3;     % height above ground [m]
datastream{32}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{32}.config.inflow = 278;        % inflow angle [deg mag]

datastream{32}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{32}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{32}.instrument.name = 'Air temperature';                 % descriptive name for charts, etc
datastream{32}.instrument.variable = 'Air_Temp_3m';                  % variable name
datastream{32}.instrument.TDMSchanName = 'Air_Temp_3m';
datastream{32}.instrument.measures = 'temperature';             % measurement type
datastream{32}.instrument.units = sprintf('%cC',char(176));         % units (SI as far as possible)
datastream{32}.instrument.skipnsamples = 20;

datastream{32}.qc.doqc = 1;
datastream{32}.qc.nanvalue =-99999;                       % NaN value
datastream{32}.qc.range.max = 50;              % maximum measurement value
datastream{32}.qc.range.min = -50;              % minimum measurement value
datastream{32}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{32}.qc.accept.max = 50;             % maximum acceptable value
datastream{32}.qc.accept.min = -50;             % minimum acceptable value
datastream{32}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{32}.qc.alsoflag = [];                % datastream to flag as well
datastream{32}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 122 m Dew Point Temperature
datastream{33}.config.height = 122;     % height above ground [m]
datastream{33}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{33}.config.inflow = 278;        % inflow angle [deg mag]

datastream{33}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{33}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{33}.instrument.name = 'Dewpoint temperature';                 % descriptive name for charts, etc
datastream{33}.instrument.variable = 'Dewpt_Temp_122m';                  % variable name
datastream{33}.instrument.TDMSchanName = 'Dewpt_Temp_122m';
datastream{33}.instrument.measures = 'MEASTYPE';             % measurement type
datastream{33}.instrument.units =sprintf('%cC',char(176));                       % units (SI as far as possible)
datastream{33}.instrument.skipnsamples = 20;

datastream{33}.qc.doqc = 1;
datastream{33}.qc.nanvalue =-99999;                       % NaN value
datastream{33}.qc.range.max = 50;              % maximum measurement value
datastream{33}.qc.range.min = -50;              % minimum measurement value
datastream{33}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{33}.qc.accept.max = 50;             % maximum acceptable value
datastream{33}.qc.accept.min = -50;             % minimum acceptable value
datastream{33}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{33}.qc.alsoflag = [];                % datastream to flag as well
datastream{33}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 87 m Dew Point Temperature
datastream{34}.config.height = 87;     % height above ground [m]
datastream{34}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{34}.config.inflow = 278;        % inflow angle [deg mag]

datastream{34}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{34}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{34}.instrument.name = 'Dewpoint temperature';                 % descriptive name for charts, etc
datastream{34}.instrument.variable = 'Dewpt_Temp_87m';                  % variable name
datastream{34}.instrument.TDMSchanName = 'Dewpt_Temp_87m';
datastream{34}.instrument.measures = 'MEASTYPE';             % measurement type
datastream{34}.instrument.units =sprintf('%cC',char(176));          % units (SI as far as possible)
datastream{34}.instrument.skipnsamples = 20;

datastream{34}.qc.doqc = 1;
datastream{34}.qc.nanvalue =-99999;                       % NaN value
datastream{34}.qc.range.max = 50;              % maximum measurement value
datastream{34}.qc.range.min = -50;              % minimum measurement value
datastream{34}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{34}.qc.accept.max = 50;             % maximum acceptable value
datastream{34}.qc.accept.min = -50;             % minimum acceptable value
datastream{34}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{34}.qc.alsoflag = [];                % datastream to flag as well
datastream{34}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 38 m Dew Point Temperature
datastream{35}.config.height = 38;     % height above ground [m]
datastream{35}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{35}.config.inflow = 278;        % inflow angle [deg mag]

datastream{35}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{35}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{35}.instrument.name = 'Dewpoint temperature';                 % descriptive name for charts, etc
datastream{35}.instrument.variable = 'Dewpt_Temp_38m';                  % variable name
datastream{35}.instrument.TDMSchanName = 'Dewpt_Temp_38m';
datastream{35}.instrument.measures = 'MEASTYPE';             % measurement type
datastream{35}.instrument.units =sprintf('%cC',char(176));    % units (SI as far as possible)
datastream{35}.instrument.skipnsamples = 20;

datastream{35}.qc.doqc = 1;
datastream{35}.qc.nanvalue =-99999;                       % NaN value
datastream{35}.qc.range.max = 50;              % maximum measurement value
datastream{35}.qc.range.min = -50;              % minimum measurement value
datastream{35}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{35}.qc.accept.max = 50;             % maximum acceptable value
datastream{35}.qc.accept.min = -50;             % minimum acceptable value
datastream{35}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{35}.qc.alsoflag = [];                % datastream to flag as well
datastream{35}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 3 m Dew Point Temperature
datastream{36}.config.height = 3;     % height above ground [m]
datastream{36}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{36}.config.inflow = 278;        % inflow angle [deg mag]

datastream{36}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{36}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{36}.instrument.name = 'Dewpoint temperature';                 % descriptive name for charts, etc
datastream{36}.instrument.variable = 'Dewpt_Temp_3m';                  % variable name
datastream{36}.instrument.TDMSchanName = 'Dewpt_Temp_3m';
datastream{36}.instrument.measures = 'MEASTYPE';             % measurement type
datastream{36}.instrument.units =sprintf('%cC',char(176));    % units (SI as far as possible)
datastream{36}.instrument.skipnsamples = 20;

datastream{36}.qc.doqc = 1;
datastream{36}.qc.nanvalue =-99999;                       % NaN value
datastream{36}.qc.range.max = 50;              % maximum measurement value
datastream{36}.qc.range.min = -50;              % minimum measurement value
datastream{36}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{36}.qc.accept.max = 50;             % maximum acceptable value
datastream{36}.qc.accept.min = -50;             % minimum acceptable value
datastream{36}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{36}.qc.alsoflag = [];                % datastream to flag as well
datastream{36}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 122m-87m Delta Temperature
datastream{37}.config.height = 122;     % height above ground [m]
datastream{37}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{37}.config.inflow = 278;        % inflow angle [deg mag]

datastream{37}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{37}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{37}.instrument.name = 'Delta T';                 % descriptive name for charts, etc
datastream{37}.instrument.variable = 'DeltaT_122_87m';                  % variable name
datastream{37}.instrument.TDMSchanName = 'DeltaT_122-87m';

datastream{37}.instrument.measures = 'Differential temperature';             % measurement type
datastream{37}.instrument.units = 'K';     % units (SI as far as possible)
datastream{37}.instrument.skipnsamples = 20;

datastream{37}.qc.doqc = 1;
datastream{37}.qc.nanvalue =-99999;                       % NaN value
datastream{37}.qc.range.max = +6.667;              % maximum measurement value
datastream{37}.qc.range.min = -4.444;              % minimum measurement value
datastream{37}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{37}.qc.accept.max = +6.667;             % maximum acceptable value
datastream{37}.qc.accept.min = -4.444;             % minimum acceptable value
datastream{37}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{37}.qc.alsoflag = [30];                % datastream to flag as well
datastream{37}.qc.alsofail = [30];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 87-38m Delta Temperature
datastream{38}.config.height = 38;     % height above ground [m]
datastream{38}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{38}.config.inflow = 278;        % inflow angle [deg mag]

datastream{38}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{38}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{38}.instrument.name = 'Delta T';                 % descriptive name for charts, etc
datastream{38}.instrument.variable = 'DeltaT_87_38m';                  % variable name
datastream{38}.instrument.TDMSchanName = 'DeltaT_87-38m';

datastream{38}.instrument.measures = 'Differential temperature';             % measurement type
datastream{38}.instrument.units = 'K';        % units (SI as far as possible)
datastream{38}.instrument.skipnsamples = 20;

datastream{38}.qc.doqc = 1;
datastream{38}.qc.nanvalue = -99999;                       % NaN value
datastream{38}.qc.range.max = +6.667;              % maximum measurement value
datastream{38}.qc.range.min = -4.444;              % minimum measurement value
datastream{38}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{38}.qc.accept.max = +6.667;             % maximum acceptable value
datastream{38}.qc.accept.min = -4.444;             % minimum acceptable value
datastream{38}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{38}.qc.alsoflag = [];                % datastream to flag as well
datastream{38}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 38-3m_Delta Temperature
datastream{39}.config.height = 3;     % height above ground [m]
datastream{39}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{39}.config.inflow = 278;        % inflow angle [deg mag]

datastream{39}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{39}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{39}.instrument.name = 'Delta T';                 % descriptive name for charts, etc
datastream{39}.instrument.variable = 'DeltaT_38_3m';                  % variable name
datastream{39}.instrument.TDMSchanName = 'DeltaT_38-3m';
datastream{39}.instrument.measures = 'MEASTYPE';             % measurement type
datastream{39}.instrument.units = 'K';      % units (SI as far as possible)
datastream{39}.instrument.skipnsamples = 20;

datastream{39}.qc.doqc = 1;
datastream{39}.qc.nanvalue =-99999;                       % NaN value
datastream{39}.qc.range.max = +6.667;              % maximum measurement value
datastream{39}.qc.range.min = -4.444;              % minimum measurement value
datastream{39}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{39}.qc.accept.max = +6.667;             % maximum acceptable value
datastream{39}.qc.accept.min = -4.444;             % minimum acceptable value
datastream{39}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{39}.qc.alsoflag = [];                % datastream to flag as well
datastream{39}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 122m Wind Direction
datastream{40}.config.height = 122;     % height above ground [m]
datastream{40}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{40}.config.inflow = 278;        % inflow angle [deg mag]

datastream{40}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{40}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{40}.instrument.name = 'Vane wind direction';                 % descriptive name for charts, etc
datastream{40}.instrument.variable = 'Vane_WD_122m';                  % variable name
datastream{40}.instrument.TDMSchanName = 'Vane_WD_122m';
datastream{40}.instrument.measures = 'wind direction';             % measurement type
datastream{40}.instrument.units = sprintf('%c',char(176));              % units (SI as far as possible)
datastream{40}.instrument.skipnsamples = 20;

datastream{40}.qc.doqc = 1;
datastream{40}.qc.nanvalue =-99999;                       % NaN value
datastream{40}.qc.range.max = 359.99;              % maximum measurement value
datastream{40}.qc.range.min = 0;              % minimum measurement value
datastream{40}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{40}.qc.accept.max = 359.99;             % maximum acceptable value
datastream{40}.qc.accept.min = 0;             % minimum acceptable value
datastream{40}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{40}.qc.alsoflag = [];                % datastream to flag as well
datastream{40}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 87 m Wind Direction
datastream{41}.config.height = 87;     % height above ground [m]
datastream{41}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{41}.config.inflow = 278;        % inflow angle [deg mag]

datastream{41}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{41}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{41}.instrument.name = 'Vane wind direction';                 % descriptive name for charts, etc
datastream{41}.instrument.variable = 'Vane_WD_87m';                  % variable name
datastream{41}.instrument.TDMSchanName = 'Vane_WD_87m';
datastream{41}.instrument.measures = 'wind direction';             % measurement type
datastream{41}.instrument.units = sprintf('%c',char(176));            % units (SI as far as possible)
datastream{41}.instrument.skipnsamples = 20;

datastream{41}.qc.doqc = 1;
datastream{41}.qc.nanvalue =-99999;                       % NaN value
datastream{41}.qc.range.max = 359.99;              % maximum measurement value
datastream{41}.qc.range.min = 0;              % minimum measurement value
datastream{41}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{41}.qc.accept.max = 359.99;             % maximum acceptable value
datastream{41}.qc.accept.min = 0;             % minimum acceptable value
datastream{41}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{41}.qc.alsoflag = [];                % datastream to flag as well
datastream{41}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 38 m Wind Direction
datastream{42}.config.height = 38;     % height above ground [m]
datastream{42}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{42}.config.inflow = 278;        % inflow angle [deg mag]

datastream{42}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{42}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{42}.instrument.name = 'Vane wind direction';                 % descriptive name for charts, etc
datastream{42}.instrument.variable = 'Vane_WD_38m';                  % variable name
datastream{42}.instrument.TDMSchanName = 'Vane_WD_38m';
datastream{42}.instrument.measures = 'wind direction';             % measurement type
datastream{42}.instrument.units = sprintf('%c',char(176));                   % units (SI as far as possible)
datastream{42}.instrument.skipnsamples = 20;

datastream{42}.qc.doqc = 1;
datastream{42}.qc.nanvalue =-99999;                       % NaN value
datastream{42}.qc.range.max = 359.99;              % maximum measurement value
datastream{42}.qc.range.min = 0;              % minimum measurement value
datastream{42}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{42}.qc.accept.max = 359.99;             % maximum acceptable value
datastream{42}.qc.accept.min = 0;             % minimum acceptable value
datastream{42}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{42}.qc.alsoflag = [];                % datastream to flag as well
datastream{42}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 10 m Wind Direction
datastream{43}.config.height = 10;     % height above ground [m]
datastream{43}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{43}.config.inflow = 278;        % inflow angle [deg mag]

datastream{43}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{43}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{43}.instrument.name = 'Vane wind direction';                 % descriptive name for charts, etc
datastream{43}.instrument.variable = 'Vane_WD_10m';                  % variable name
datastream{43}.instrument.TDMSchanName = 'Vane_WD_10m';
datastream{43}.instrument.measures = 'wind direction';             % measurement type
datastream{43}.instrument.units = sprintf('%c',char(176));                  % units (SI as far as possible)
datastream{43}.instrument.skipnsamples = 20;

datastream{43}.qc.doqc = 1;
datastream{43}.qc.nanvalue =-99999;                       % NaN value
datastream{43}.qc.range.max = 359.99;              % maximum measurement value
datastream{43}.qc.range.min = 0;              % minimum measurement value
datastream{43}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{43}.qc.accept.max = 359.99;             % maximum acceptable value
datastream{43}.qc.accept.min = 0;             % minimum acceptable value
datastream{43}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{43}.qc.alsoflag = [];                % datastream to flag as well
datastream{43}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 3 m 3m_Wind Direction
datastream{44}.config.height = 3;     % height above ground [m]
datastream{44}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{44}.config.inflow = 278;        % inflow angle [deg mag]

datastream{44}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{44}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{44}.instrument.name = 'Vane wind direction';                 % descriptive name for charts, etc
datastream{44}.instrument.variable = 'Vane_WD_3m';                  % variable name
datastream{44}.instrument.TDMSchanName = 'Vane_WD_3m';
datastream{44}.instrument.measures = 'wind direction';             % measurement type
datastream{44}.instrument.units =sprintf('%c',char(176));                 % units (SI as far as possible)
datastream{44}.instrument.skipnsamples = 20;

datastream{44}.qc.doqc = 1;
datastream{44}.qc.nanvalue =-99999;                       % NaN value
datastream{44}.qc.range.max = 359.99;              % maximum measurement value
datastream{44}.qc.range.min = 0;              % minimum measurement value
datastream{44}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{44}.qc.accept.max = 359.99;             % maximum acceptable value
datastream{44}.qc.accept.min = 0;             % minimum acceptable value
datastream{44}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{44}.qc.alsoflag = [];                % datastream to flag as well
datastream{44}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 119 m Sonic head X acceleration
datastream{45}.config.height = 119;     % height above ground [m]
datastream{45}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{45}.config.inflow = 278;        % inflow angle [deg mag]

datastream{45}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{45}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{45}.instrument.name = 'Acceleration in x';                 % descriptive name for charts, etc
datastream{45}.instrument.variable = 'Accel_x_119';                  % variable name
datastream{45}.instrument.TDMSchanName = '119_Accel_X';
datastream{45}.instrument.measures = 'acceleration';             % measurement type
datastream{45}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{45}.qc.doqc = 1;
datastream{45}.qc.nanvalue =-99999;                       % NaN value
datastream{45}.qc.range.max = 2;              % maximum measurement value
datastream{45}.qc.range.min = -2;              % minimum measurement value
datastream{45}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{45}.qc.accept.max = 2;             % maximum acceptable value
datastream{45}.qc.accept.min = -2;             % minimum acceptable value
datastream{45}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{45}.qc.alsoflag = [];                % datastream to flag as well
datastream{45}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 119 m sonic head Y acceleration
datastream{46}.config.height = 119;     % height above ground [m]
datastream{46}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{46}.config.inflow = 278;        % inflow angle [deg mag]

datastream{46}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{46}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{46}.instrument.name = 'Acceleration in y';                 % descriptive name for charts, etc
datastream{46}.instrument.variable = 'Accel_y_119';                  % variable name
datastream{46}.instrument.TDMSchanName = '119_Accel_Y';
datastream{46}.instrument.measures = 'accleration';             % measurement type
datastream{46}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{46}.qc.doqc = 1;
datastream{46}.qc.nanvalue =-99999;                       % NaN value
datastream{46}.qc.range.max = 2;              % maximum measurement value
datastream{46}.qc.range.min = -2;              % minimum measurement value
datastream{46}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{46}.qc.accept.max = 2;             % maximum acceptable value
datastream{46}.qc.accept.min = -2;             % minimum acceptable value
datastream{46}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{46}.qc.alsoflag = [];                % datastream to flag as well
datastream{46}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 119 m sonic head Z acceleration
datastream{47}.config.height = 119;     % height above ground [m]
datastream{47}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{47}.config.inflow = 278;        % inflow angle [deg mag]

datastream{47}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{47}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{47}.instrument.name = 'Acceleration in z';                 % descriptive name for charts, etc
datastream{47}.instrument.variable = 'Accel_z_119';                  % variable name
datastream{47}.instrument.TDMSchanName = '119_Accel_Z';
datastream{47}.instrument.measures = 'acceleration';             % measurement type
datastream{47}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{47}.qc.doqc = 1;
datastream{47}.qc.nanvalue =-99999;                       % NaN value
datastream{47}.qc.range.max = 2;              % maximum measurement value
datastream{47}.qc.range.min = -2;              % minimum measurement value
datastream{47}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{47}.qc.accept.max = 2;             % maximum acceptable value
datastream{47}.qc.accept.min = -2;             % minimum acceptable value
datastream{47}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{47}.qc.alsoflag = [];                % datastream to flag as well
datastream{47}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 100 m 100m sonic head X acceleration
datastream{48}.config.height = 100;     % height above ground [m]
datastream{48}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{48}.config.inflow = 278;        % inflow angle [deg mag]

datastream{48}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{48}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{48}.instrument.name = 'Acceleration in x';                 % descriptive name for charts, etc
datastream{48}.instrument.variable = 'Accel_x_100';                  % variable name
datastream{48}.instrument.TDMSchanName = '100_Accel_X';
datastream{48}.instrument.measures = 'acceleration';             % measurement type
datastream{48}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{48}.qc.doqc = 1;
datastream{48}.qc.nanvalue =-99999;                       % NaN value
datastream{48}.qc.range.max = 2;              % maximum measurement value
datastream{48}.qc.range.min = -2;              % minimum measurement value
datastream{48}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{48}.qc.accept.max = 2;             % maximum acceptable value
datastream{48}.qc.accept.min = -2;             % minimum acceptable value
datastream{48}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{48}.qc.alsoflag = [];                % datastream to flag as well
datastream{48}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 100 m 100m sonic head Y acceleration
datastream{49}.config.height = 100;     % height above ground [m]
datastream{49}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{49}.config.inflow = 278;        % inflow angle [deg mag]

datastream{49}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{49}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{49}.instrument.name = 'Acceleration in y';                 % descriptive name for charts, etc
datastream{49}.instrument.variable = 'Accel_y_100';                  % variable name
datastream{49}.instrument.TDMSchanName = '100_Accel_Y';
datastream{49}.instrument.measures = 'acceleration';             % measurement type
datastream{49}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{49}.qc.doqc = 1;
datastream{49}.qc.nanvalue =-99999;                       % NaN value
datastream{49}.qc.range.max = 2;              % maximum measurement value
datastream{49}.qc.range.min = -2;              % minimum measurement value
datastream{49}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{49}.qc.accept.max = 2;             % maximum acceptable value
datastream{49}.qc.accept.min = -2;             % minimum acceptable value
datastream{49}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{49}.qc.alsoflag = [];                % datastream to flag as well
datastream{49}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 100 m sonic head Z acceleration
datastream{50}.config.height = 100;     % height above ground [m]
datastream{50}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{50}.config.inflow = 278;        % inflow angle [deg mag]

datastream{50}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{50}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{50}.instrument.name = 'Acceleration in z';                 % descriptive name for charts, etc
datastream{50}.instrument.variable = 'Accel_z_100';                  % variable name
datastream{50}.instrument.TDMSchanName = '100_Accel_Z';
datastream{50}.instrument.measures = 'acceleration';             % measurement type
datastream{50}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{50}.qc.doqc = 1;
datastream{50}.qc.nanvalue =-99999;                       % NaN value
datastream{50}.qc.range.max = 2;              % maximum measurement value
datastream{50}.qc.range.min = -2;              % minimum measurement value
datastream{50}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{50}.qc.accept.max = 2;             % maximum acceptable value
datastream{50}.qc.accept.min = -2;             % minimum acceptable value
datastream{50}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{50}.qc.alsoflag = [];                % datastream to flag as well
datastream{50}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 74 m sonic head X acceleration
datastream{51}.config.height = 74;     % height above ground [m]
datastream{51}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{51}.config.inflow = 278;        % inflow angle [deg mag]

datastream{51}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{51}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{51}.instrument.name = 'Acceleration in x';                 % descriptive name for charts, etc
datastream{51}.instrument.variable = 'Accel_x_74';                  % variable name
datastream{51}.instrument.TDMSchanName = '74_Accel_X';
datastream{51}.instrument.measures = 'acceleration';             % measurement type
datastream{51}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{51}.qc.doqc = 1;
datastream{51}.qc.nanvalue =-99999;                       % NaN value
datastream{51}.qc.range.max = 2;              % maximum measurement value
datastream{51}.qc.range.min = -2;              % minimum measurement value
datastream{51}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{51}.qc.accept.max = 2;             % maximum acceptable value
datastream{51}.qc.accept.min = -2;             % minimum acceptable value
datastream{51}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{51}.qc.alsoflag = [];                % datastream to flag as well
datastream{51}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 74 m sonic head Y acceleration
datastream{52}.config.height = 74;     % height above ground [m]
datastream{52}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{52}.config.inflow = 278;        % inflow angle [deg mag]

datastream{52}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{52}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{52}.instrument.name = 'Acceleration in y';                 % descriptive name for charts, etc
datastream{52}.instrument.variable = 'Accel_y_74';                  % variable name
datastream{52}.instrument.TDMSchanName = '74_Accel_Y';
datastream{52}.instrument.measures = 'acceleration';             % measurement type
datastream{52}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{52}.qc.doqc = 1;
datastream{52}.qc.nanvalue =-99999;                       % NaN value
datastream{52}.qc.range.max = 2;              % maximum measurement value
datastream{52}.qc.range.min = -2;              % minimum measurement value
datastream{52}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{52}.qc.accept.max = 2;             % maximum acceptable value
datastream{52}.qc.accept.min = -2;             % minimum acceptable value
datastream{52}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{52}.qc.alsoflag = [];                % datastream to flag as well
datastream{52}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 76 m sonic head Z acceleration
datastream{53}.config.height = 74;     % height above ground [m]
datastream{53}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{53}.config.inflow = 278;        % inflow angle [deg mag]

datastream{53}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{53}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{53}.instrument.name = 'Acceleration in z';                 % descriptive name for charts, etc
datastream{53}.instrument.variable = 'Accel_z_74';                  % variable name
datastream{53}.instrument.TDMSchanName = '74_Accel_Z';
datastream{53}.instrument.measures = 'acceleration';             % measurement type
datastream{53}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{53}.qc.doqc = 1;
datastream{53}.qc.nanvalue =-99999;                       % NaN value
datastream{53}.qc.range.max = 2;              % maximum measurement value
datastream{53}.qc.range.min = -2;              % minimum measurement value
datastream{53}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{53}.qc.accept.max = 2;             % maximum acceptable value
datastream{53}.qc.accept.min = -2;             % minimum acceptable value
datastream{53}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{53}.qc.alsoflag = [];                % datastream to flag as well
datastream{53}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 61 m sonic head X acceleration
datastream{54}.config.height = 61;     % height above ground [m]
datastream{54}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{54}.config.inflow = 278;        % inflow angle [deg mag]

datastream{54}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{54}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{54}.instrument.name = 'Acceleration in x';                 % descriptive name for charts, etc
datastream{54}.instrument.variable = 'Accel_x_61';                  % variable name
datastream{54}.instrument.TDMSchanName = '61_Accel_X';
datastream{54}.instrument.measures = 'acceleration';             % measurement type
datastream{54}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{54}.qc.doqc = 1;
datastream{54}.qc.nanvalue =-99999;                       % NaN value
datastream{54}.qc.range.max = 2;              % maximum measurement value
datastream{54}.qc.range.min = -2;              % minimum measurement value
datastream{54}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{54}.qc.accept.max = 2;             % maximum acceptable value
datastream{54}.qc.accept.min = -2;             % minimum acceptable value
datastream{54}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{54}.qc.alsoflag = [];                % datastream to flag as well
datastream{54}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 61 m sonic head Y 6
datastream{55}.config.height = 61;     % height above ground [m]
datastream{55}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{55}.config.inflow = 278;        % inflow angle [deg mag]

datastream{55}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{55}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{55}.instrument.name = 'Acceleration in y';                 % descriptive name for charts, etc
datastream{55}.instrument.variable = 'Accel_y_61';                  % variable name
datastream{55}.instrument.TDMSchanName = '61_Accel_Y';
datastream{55}.instrument.measures = 'acceleration';             % measurement type
datastream{55}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{55}.qc.doqc = 1;
datastream{55}.qc.nanvalue =-99999;                       % NaN value
datastream{55}.qc.range.max = 2;              % maximum measurement value
datastream{55}.qc.range.min = -2;              % minimum measurement value
datastream{55}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{55}.qc.accept.max = 2;             % maximum acceptable value
datastream{55}.qc.accept.min = -2;             % minimum acceptable value
datastream{55}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{55}.qc.alsoflag = [];                % datastream to flag as well
datastream{55}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 61 m sonic head Z acceleration
datastream{56}.config.height = 61;     % height above ground [m]
datastream{56}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{56}.config.inflow = 278;        % inflow angle [deg mag]

datastream{56}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{56}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{56}.instrument.name = 'Acceleration in z';                 % descriptive name for charts, etc
datastream{56}.instrument.variable = 'Accel_z_61';                  % variable name
datastream{56}.instrument.TDMSchanName = '61_Accel_Z';
datastream{56}.instrument.measures = 'Acceleration';             % measurement type
datastream{56}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{56}.qc.doqc = 1;
datastream{56}.qc.nanvalue =-99999;                       % NaN value
datastream{56}.qc.range.max = 2;              % maximum measurement value
datastream{56}.qc.range.min = -2;              % minimum measurement value
datastream{56}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{56}.qc.accept.max = 2;             % maximum acceptable value
datastream{56}.qc.accept.min = -2;             % minimum acceptable value
datastream{56}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{56}.qc.alsoflag = [];                % datastream to flag as well
datastream{56}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 41 m sonic head X acceleration
datastream{57}.config.height = 41;     % height above ground [m]
datastream{57}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{57}.config.inflow = 278;        % inflow angle [deg mag]

datastream{57}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{57}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{57}.instrument.name = 'Acceleration in x';                 % descriptive name for charts, etc
datastream{57}.instrument.variable = 'Accel_x_41';                  % variable name
datastream{57}.instrument.TDMSchanName = '41_Accel_X';
datastream{57}.instrument.measures = 'acceleration';             % measurement type
datastream{57}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{57}.qc.doqc = 1;
datastream{57}.qc.nanvalue =-99999;                       % NaN value
datastream{57}.qc.range.max = 2;              % maximum measurement value
datastream{57}.qc.range.min = -2;              % minimum measurement value
datastream{57}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{57}.qc.accept.max = 2;             % maximum acceptable value
datastream{57}.qc.accept.min = -2;             % minimum acceptable value
datastream{57}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{57}.qc.alsoflag = [];                % datastream to flag as well
datastream{57}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 41 m sonic head Y acceleration
datastream{58}.config.height = 41;     % height above ground [m]
datastream{58}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{58}.config.inflow = 278;        % inflow angle [deg mag]

datastream{58}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{58}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{58}.instrument.name = 'Acceleration in y';                 % descriptive name for charts, etc
datastream{58}.instrument.variable = 'Accel_y_41';                  % variable name
datastream{58}.instrument.TDMSchanName = '41_Accel_YX';
datastream{58}.instrument.measures = 'acceleration';             % measurement type
datastream{58}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{58}.qc.doqc = 1;
datastream{58}.qc.nanvalue =-99999;                       % NaN value
datastream{58}.qc.range.max = 2;              % maximum measurement value
datastream{58}.qc.range.min = -2;              % minimum measurement value
datastream{58}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{58}.qc.accept.max = 2;             % maximum acceptable value
datastream{58}.qc.accept.min = -2;             % minimum acceptable value
datastream{58}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{58}.qc.alsoflag = [];                % datastream to flag as well
datastream{58}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 41 m sonic head Z acceleration
datastream{59}.config.height = 41;     % height above ground [m]
datastream{59}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{59}.config.inflow = 278;        % inflow angle [deg mag]

datastream{59}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{59}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{59}.instrument.name = 'Acceleration in z';                 % descriptive name for charts, etc
datastream{59}.instrument.variable = 'Accel_z_41';                  % variable name
datastream{59}.instrument.TDMSchanName = '41_Accel_Z';
datastream{59}.instrument.measures = 'acceleration';             % measurement type
datastream{59}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{59}.qc.doqc = 1;
datastream{59}.qc.nanvalue =-99999;                       % NaN value
datastream{59}.qc.range.max = 2;              % maximum measurement value
datastream{59}.qc.range.min = -2;              % minimum measurement value
datastream{59}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{59}.qc.accept.max = 2;             % maximum acceptable value
datastream{59}.qc.accept.min = -2;             % minimum acceptable value
datastream{59}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{59}.qc.alsoflag = [];                % datastream to flag as well
datastream{59}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 15 m sonic head X acceleration
datastream{60}.config.height = 15;     % height above ground [m]
datastream{60}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{60}.config.inflow = 278;        % inflow angle [deg mag]

datastream{60}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{60}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{60}.instrument.name = 'Acceleration in x';                 % descriptive name for charts, etc
datastream{60}.instrument.variable = 'Accel_x_15';                  % variable name
datastream{60}.instrument.TDMSchanName = '15_Accel_X';
datastream{60}.instrument.measures = 'acceleration';             % measurement type
datastream{60}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{60}.qc.doqc = 1;
datastream{60}.qc.nanvalue =-99999;                       % NaN value
datastream{60}.qc.range.max = 2;              % maximum measurement value
datastream{60}.qc.range.min = -2;              % minimum measurement value
datastream{60}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{60}.qc.accept.max = 2;             % maximum acceptable value
datastream{60}.qc.accept.min = -2;             % minimum acceptable value
datastream{60}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{60}.qc.alsoflag = [];                % datastream to flag as well
datastream{60}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 15 m sonic head Y acceleration
datastream{61}.config.height = 15;     % height above ground [m]
datastream{61}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{61}.config.inflow = 278;        % inflow angle [deg mag]

datastream{61}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{61}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{61}.instrument.name = 'Acceleration in y';                 % descriptive name for charts, etc
datastream{61}.instrument.variable = 'Accel_y_15';                  % variable name
datastream{61}.instrument.TDMSchanName = '15_Accel_Y';
datastream{61}.instrument.measures = 'acceleration';             % measurement type
datastream{61}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{61}.qc.doqc = 1;
datastream{61}.qc.nanvalue =-99999;                       % NaN value
datastream{61}.qc.range.max = 2;              % maximum measurement value
datastream{61}.qc.range.min = -2;              % minimum measurement value
datastream{61}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{61}.qc.accept.max = 2;             % maximum acceptable value
datastream{61}.qc.accept.min = -2;             % minimum acceptable value
datastream{61}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{61}.qc.alsoflag = [];                % datastream to flag as well
datastream{61}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 15 m sonic head Z acceleration
datastream{62}.config.height = 15;     % height above ground [m]
datastream{62}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{62}.config.inflow = 278;        % inflow angle [deg mag]

datastream{62}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{62}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{62}.instrument.name = 'Acceleration in z';                 % descriptive name for charts, etc
datastream{62}.instrument.variable = 'Accel_z_15';                  % variable name
datastream{62}.instrument.TDMSchanName = '15_Accel_Z';
datastream{62}.instrument.measures = 'acceleration';             % measurement type
datastream{62}.instrument.units ='mg';                      % units (SI as far as possible)

datastream{62}.qc.doqc = 1;
datastream{62}.qc.nanvalue =-99999;                       % NaN value
datastream{62}.qc.range.max = 2;              % maximum measurement value
datastream{62}.qc.range.min = -2;              % minimum measurement value
datastream{62}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{62}.qc.accept.max = 2;             % maximum acceptable value
datastream{62}.qc.accept.min = -2;             % minimum acceptable value
datastream{62}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{62}.qc.alsoflag = [];                % datastream to flag as well
datastream{62}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 3 m 3m Barometric Pressure
datastream{63}.config.height = 3;     % height above ground [m]
datastream{63}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{63}.config.inflow = 278;        % inflow angle [deg mag]

datastream{63}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{63}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{63}.instrument.name = 'Station Pressure';                 % descriptive name for charts, etc
datastream{63}.instrument.variable = 'Baro_Presr_3m';                  % variable name
datastream{63}.instrument.TDMSchanName = 'Baro_Press_3m';
datastream{63}.instrument.measures = 'MEASTYPE';             % measurement type
datastream{63}.instrument.units ='hPa';                      % units (SI as far as possible)
datastream{63}.instrument.skipnsamples = 20;

datastream{63}.qc.doqc = 1;
datastream{63}.qc.nanvalue =-99999;                       % NaN value
datastream{63}.qc.range.max = 1000;              % maximum measurement value
datastream{63}.qc.range.min = 740;              % minimum measurement value
datastream{63}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{63}.qc.accept.max = 1000;             % maximum acceptable value
datastream{63}.qc.accept.min = 740;             % minimum acceptable value
datastream{63}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{63}.qc.alsoflag = [];                % datastream to flag as well
datastream{63}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 0 m Precipitation intensity (relative)
datastream{64}.config.height = 0;     % height above ground [m]
datastream{64}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{64}.config.inflow = 278;        % inflow angle [deg mag]

datastream{64}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{64}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{64}.instrument.name = 'Precipitation intensity';                 % descriptive name for charts, etc
datastream{64}.instrument.variable = 'PRECIP_INTEN';                  % variable name
datastream{64}.instrument.TDMSchanName = 'Precip_Inten';
datastream{64}.instrument.measures = 'precipitation intensity';             % measurement type
datastream{64}.instrument.units ='VDC';                      % units (SI as far as possible)
datastream{64}.instrument.skipnsamples = 20;

datastream{64}.qc.doqc = 1;
datastream{64}.qc.nanvalue =-99999;                       % NaN value
datastream{64}.qc.range.max = 4;              % maximum measurement value
datastream{64}.qc.range.min = 0;              % minimum measurement value
datastream{64}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{64}.qc.accept.max = 4;             % maximum acceptable value
datastream{64}.qc.accept.min = 0;             % minimum acceptable value
datastream{64}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{64}.qc.alsoflag = [];                % datastream to flag as well
datastream{64}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------
% FREQUENCY SIGNALS
% -------------------------------------------------------------------------------

% 130 m Cup Wind Speed (IEC First Class)
datastream{65}.config.height = 130;     % height above ground [m]
datastream{65}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{65}.config.inflow = 278;        % inflow angle [deg mag]

datastream{65}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{65}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{65}.instrument.name = 'Cup wind speed';                 % descriptive name for charts, etc
datastream{65}.instrument.variable = 'Cup_WS_C1_130m';                  % variable name
datastream{65}.instrument.TDMSchanName = 'Cup_WS_130m';
datastream{65}.instrument.measures = 'speed';             % measurement type
datastream{65}.instrument.units ='m/s';                      % units (SI as far as possible)
datastream{65}.instrument.skipnsamples = 20;

datastream{65}.qc.doqc = 1;
datastream{65}.qc.nanvalue =-99999;                       % NaN value
datastream{65}.qc.range.max = 75;              % maximum measurement value
datastream{65}.qc.range.min = 0;              % minimum measurement value
datastream{65}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{65}.qc.accept.max = 74;             % maximum acceptable value
datastream{65}.qc.accept.min = 0;             % minimum acceptable value
datastream{65}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{65}.qc.alsoflag = [];                % datastream to flag as well
datastream{65}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 122 m Cup Wind Speed
datastream{66}.config.height = 122;     % height above ground [m]
datastream{66}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{66}.config.inflow = 278;        % inflow angle [deg mag]

datastream{66}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{66}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{66}.instrument.name = 'Cup wind speed';                 % descriptive name for charts, etc
datastream{66}.instrument.variable = 'Cup_WS_122m';                  % variable name
datastream{66}.instrument.TDMSchanName = 'Cup_WS_122m';
datastream{66}.instrument.measures = 'speed';             % measurement type
datastream{66}.instrument.units ='m/s';                      % units (SI as far as possible)
datastream{66}.instrument.skipnsamples = 20;

datastream{66}.qc.doqc = 1;
datastream{66}.qc.nanvalue =-99999;                       % NaN value
datastream{66}.qc.range.max = 90;              % maximum measurement value
datastream{66}.qc.range.min = 0;              % minimum measurement value
datastream{66}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{66}.qc.accept.max = 89;             % maximum acceptable value
datastream{66}.qc.accept.min = 0;             % minimum acceptable value
datastream{66}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{66}.qc.alsoflag = [];                % datastream to flag as well
datastream{66}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 105 m Cup Wind Speed (IEC First Class)
datastream{67}.config.height = 105;     % height above ground [m]
datastream{67}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{67}.config.inflow = 278;        % inflow angle [deg mag]

datastream{67}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{67}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{67}.instrument.name = 'Cup wind speed';                 % descriptive name for charts, etc
datastream{67}.instrument.variable = 'Cup_WS_C1_105m';                  % variable name
datastream{67}.instrument.TDMSchanName = 'Cup_WS_105m';
datastream{67}.instrument.measures = 'speed';             % measurement type
datastream{67}.instrument.units ='m/s';                      % units (SI as far as possible)
datastream{67}.instrument.skipnsamples = 20;

datastream{67}.qc.doqc = 1;
datastream{67}.qc.nanvalue =-99999;                       % NaN value
datastream{67}.qc.range.max = 75;              % maximum measurement value
datastream{67}.qc.range.min = 0;              % minimum measurement value
datastream{67}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{67}.qc.accept.max = 74;             % maximum acceptable value
datastream{67}.qc.accept.min = 0;             % minimum acceptable value
datastream{67}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{67}.qc.alsoflag = [];                % datastream to flag as well
datastream{67}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 87 m Cup Wind Speed
datastream{68}.config.height = 87;     % height above ground [m]
datastream{68}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{68}.config.inflow = 278;        % inflow angle [deg mag]

datastream{68}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{68}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{68}.instrument.name = 'Cup wind speed';                 % descriptive name for charts, etc
datastream{68}.instrument.variable = 'Cup_WS_87m';                  % variable name
datastream{68}.instrument.TDMSchanName = 'Cup_WS_87m';
datastream{68}.instrument.measures = 'speed';             % measurement type
datastream{68}.instrument.units ='m/s';                      % units (SI as far as possible)
datastream{68}.instrument.skipnsamples = 20;

datastream{68}.qc.doqc = 1;
datastream{68}.qc.nanvalue =-99999;                       % NaN value
datastream{68}.qc.range.max = 90;              % maximum measurement value
datastream{68}.qc.range.min = 0;              % minimum measurement value
datastream{68}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{68}.qc.accept.max = 89;             % maximum acceptable value
datastream{68}.qc.accept.min = 0;             % minimum acceptable value
datastream{68}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{68}.qc.alsoflag = [];                % datastream to flag as well
datastream{68}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 80 m Cup Wind Speed (IEC First Class)
datastream{69}.config.height = 80;     % height above ground [m]
datastream{69}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{69}.config.inflow = 278;        % inflow angle [deg mag]

datastream{69}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{69}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{69}.instrument.name = 'Cup wind speed';                 % descriptive name for charts, etc
datastream{69}.instrument.variable = 'Cup_WS_C1_80m';                  % variable name
datastream{69}.instrument.TDMSchanName = 'Cup_WS_80m';
datastream{69}.instrument.measures = 'speed';             % measurement type
datastream{69}.instrument.units ='m/s';                      % units (SI as far as possible)
datastream{69}.instrument.skipnsamples = 20;

datastream{69}.qc.doqc = 1;
datastream{69}.qc.nanvalue =-99999;                       % NaN value
datastream{69}.qc.range.max = 90;              % maximum measurement value
datastream{69}.qc.range.min = 0;              % minimum measurement value
datastream{69}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{69}.qc.accept.max = 89;             % maximum acceptable value
datastream{69}.qc.accept.min = 0;             % minimum acceptable value
datastream{69}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{69}.qc.alsoflag = [];                % datastream to flag as well
datastream{69}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 55 m Cup Wind Speed (IEC First Class)
datastream{70}.config.height = 55;     % height above ground [m]
datastream{70}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{70}.config.inflow = 278;        % inflow angle [deg mag]

datastream{70}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{70}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{70}.instrument.name = 'Cup wind speed';                 % descriptive name for charts, etc
datastream{70}.instrument.variable = 'Cup_WS_C1_55m';                  % variable name
datastream{70}.instrument.TDMSchanName = 'Cup_WS_55m';
datastream{70}.instrument.measures = 'speed';             % measurement type
datastream{70}.instrument.units ='m/s';                      % units (SI as far as possible)
datastream{70}.instrument.skipnsamples = 20;

datastream{70}.qc.doqc = 1;
datastream{70}.qc.nanvalue =-99999;                       % NaN value
datastream{70}.qc.range.max = 90;              % maximum measurement value
datastream{70}.qc.range.min = 0;              % minimum measurement value
datastream{70}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{70}.qc.accept.max = 89;             % maximum acceptable value
datastream{70}.qc.accept.min = 0;             % minimum acceptable value
datastream{70}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{70}.qc.alsoflag = [];                % datastream to flag as well
datastream{70}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 38 m Cup Wind Speed
datastream{71}.config.height = 38;     % height above ground [m]
datastream{71}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{71}.config.inflow = 278;        % inflow angle [deg mag]

datastream{71}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{71}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{71}.instrument.name = 'Cup wind speed';                 % descriptive name for charts, etc
datastream{71}.instrument.variable = 'Cup_WS_38m';                  % variable name
datastream{71}.instrument.TDMSchanName = 'Cup_WS_38m';
datastream{71}.instrument.measures = 'speed';             % measurement type
datastream{71}.instrument.units ='m/s';                      % units (SI as far as possible)
datastream{71}.instrument.skipnsamples = 20;

datastream{71}.qc.doqc = 1;
datastream{71}.qc.nanvalue =-99999;                       % NaN value
datastream{71}.qc.range.max = 90;              % maximum measurement value
datastream{71}.qc.range.min = 0;              % minimum measurement value
datastream{71}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{71}.qc.accept.max = 89;             % maximum acceptable value
datastream{71}.qc.accept.min = 0;             % minimum acceptable value
datastream{71}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{71}.qc.alsoflag = [];                % datastream to flag as well
datastream{71}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 30 m Cup Wind Speed
datastream{72}.config.height = 30;     % height above ground [m]
datastream{72}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{72}.config.inflow = 278;        % inflow angle [deg mag]

datastream{72}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{72}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{72}.instrument.name = 'Cup wind speed';                 % descriptive name for charts, etc
datastream{72}.instrument.variable = 'Cup_WS_C1_30m';                  % variable name
datastream{72}.instrument.TDMSchanName = 'Cup_WS_30m';
datastream{72}.instrument.measures = 'speed';             % measurement type
datastream{72}.instrument.units ='m/s';                      % units (SI as far as possible)
datastream{72}.instrument.skipnsamples = 20;

datastream{72}.qc.doqc = 1;
datastream{72}.qc.nanvalue =-99999;                       % NaN value
datastream{72}.qc.range.max = 90;              % maximum measurement value
datastream{72}.qc.range.min = 0;              % minimum measurement value
datastream{72}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{72}.qc.accept.max = 89;             % maximum acceptable value
datastream{72}.qc.accept.min = 0;             % minimum acceptable value
datastream{72}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{72}.qc.alsoflag = [];                % datastream to flag as well
datastream{72}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 10 m Cup Wind Speed
datastream{73}.config.height = 10;     % height above ground [m]
datastream{73}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{73}.config.inflow = 278;        % inflow angle [deg mag]

datastream{73}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{73}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{73}.instrument.name = 'Cup wind speed';                 % descriptive name for charts, etc
datastream{73}.instrument.variable = 'Cup_WS_10m';                  % variable name
datastream{73}.instrument.TDMSchanName = 'Cup_WS_10m';
datastream{73}.instrument.measures = 'speed';             % measurement type
datastream{73}.instrument.units ='m/s';                      % units (SI as far as possible)
datastream{73}.instrument.skipnsamples = 20;

datastream{73}.qc.doqc = 1;
datastream{73}.qc.nanvalue =-99999;                       % NaN value
datastream{73}.qc.range.max = 90;              % maximum measurement value
datastream{73}.qc.range.min = 0;              % minimum measurement value
datastream{73}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{73}.qc.accept.max = 89;             % maximum acceptable value
datastream{73}.qc.accept.min = 0;             % minimum acceptable value
datastream{73}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{73}.qc.alsoflag = [];                % datastream to flag as well
datastream{73}.qc.alsofail = [];                % datastream to kill as well

% -------------------------------------------------------------------------------

% 3 m Cup Wind Speed
datastream{74}.config.height = 3;     % height above ground [m]
datastream{74}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{74}.config.inflow = 278;        % inflow angle [deg mag]

datastream{74}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{74}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{74}.instrument.name = 'Cup wind speed';                 % descriptive name for charts, etc
datastream{74}.instrument.variable = 'Cup_WS_3m';                  % variable name
datastream{74}.instrument.TDMSchanName = 'Cup_WS_3m';
datastream{74}.instrument.measures = 'speed';             % measurement type
datastream{74}.instrument.units ='m/s';                      % units (SI as far as possible)
datastream{74}.instrument.skipnsamples = 20;

datastream{74}.qc.doqc = 1;
datastream{74}.qc.nanvalue =-99999;                       % NaN value
datastream{74}.qc.range.max = 90;              % maximum measurement value
datastream{74}.qc.range.min = 0;              % minimum measurement value
datastream{74}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{74}.qc.accept.max = 89;             % maximum acceptable value
datastream{74}.qc.accept.min = 0;             % minimum acceptable value
datastream{74}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{74}.qc.alsoflag = [];                % datastream to flag as well
datastream{74}.qc.alsofail = [];                % datastream to kill as well

% --------
% DIGITALS
% --------

% Precipitation presence
datastream{75}.config.height = 0 ;     % height above ground [m]
datastream{75}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{75}.config.inflow = 278;        % inflow angle [deg mag]

datastream{75}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{75}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{75}.instrument.name = 'Precipitation presence';                 % descriptive name for charts, etc
datastream{75}.instrument.variable = 'Precip_TF';                  % variable name
datastream{75}.instrument.TDMSchanName = 'PRECIP';
datastream{75}.instrument.measures = 'Precipitation';             % measurement type
datastream{75}.instrument.units ='TF';                      % units (SI as far as possible)
datastream{75}.instrument.skipnsamples = 20;

datastream{75}.qc.doqc = 1;
datastream{75}.qc.nanvalue =-99999;                       % NaN value
datastream{75}.qc.range.max = 1.1;              % maximum measurement value
datastream{75}.qc.range.min = -0.1;              % minimum measurement value
datastream{75}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{75}.qc.accept.max = 1.1;             % maximum acceptable value
datastream{75}.qc.accept.min = -0.1;             % minimum acceptable value
datastream{75}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{75}.qc.alsoflag = [];                % datastream to flag as well
datastream{75}.qc.alsofail = [];                % datastream to kill as well

% --------
% DIGITALS
% --------

% GPS Locked
datastream{76}.config.height = 0 ;     % height above ground [m]
datastream{76}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{76}.config.inflow = 285;        % inflow angle [deg mag]

datastream{76}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{76}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{76}.instrument.name = 'GPS Locked';                 % descriptive name for charts, etc
datastream{76}.instrument.variable = 'GPS_Lock_TF';                  % variable name
datastream{76}.instrument.TDMSchanName = 'GPSLOCK';
datastream{76}.instrument.measures = 'GPS';             % measurement type
datastream{76}.instrument.units ='TF';                      % units (SI as far as possible)
datastream{76}.instrument.skipnsamples = 20;

datastream{76}.qc.doqc = 1;
datastream{76}.qc.nanvalue =-99999;                       % NaN value
datastream{76}.qc.range.max = 1.1;              % maximum measurement value
datastream{76}.qc.range.min = -0.1;              % minimum measurement value
datastream{76}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{76}.qc.accept.max = 1.1;             % maximum acceptable value
datastream{76}.qc.accept.min = 0.5;             % minimum acceptable value
datastream{76}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{76}.qc.alsoflag = [];                % datastream to flag as well
datastream{76}.qc.alsofail = [];                % datastream to kill as well
datastream{76}.qc.warnifover = inf;
datastream{76}.qc.warnifunder = 0.5;
datastream{76}.qc.warnrate = 0.5;
% UPS Status
datastream{77}.config.height = 0 ;     % height above ground [m]
datastream{77}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{77}.config.inflow = 278;        % inflow angle [deg mag]

datastream{77}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{77}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{77}.instrument.name = 'UPS OK';                 % descriptive name for charts, etc
datastream{77}.instrument.variable = 'UPS_OK_TF';                  % variable name
datastream{77}.instrument.TDMSchanName = 'UPS_STATUS';
datastream{77}.instrument.measures = 'UPS';             % measurement type
datastream{77}.instrument.units ='TF';                      % units (SI as far as possible)
datastream{77}.instrument.skipnsamples = 20;

datastream{77}.qc.doqc = 1;
datastream{77}.qc.nanvalue =-99999;                       % NaN value
datastream{77}.qc.range.max = 1.1;              % maximum measurement value
datastream{77}.qc.range.min = -0.1;              % minimum measurement value
datastream{77}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{77}.qc.accept.max = 1.1;             % maximum acceptable value
datastream{77}.qc.accept.min = 0.5;             % minimum acceptable value
datastream{77}.qc.accept.rate = 0.99;           % minimum acceptable rate to pass / interval
datastream{77}.qc.alsoflag = [];                % datastream to flag as well
datastream{77}.qc.alsofail = [];                % datastream to kill as well
datastream{77}.qc.warnifover = inf;
datastream{77}.qc.warnifunder = 0.5;
datastream{77}.qc.warnrate = 0.5;

% -------------------------------------------------------------------------------

% Aspirator 1 Status
datastream{78}.config.height = 122;     % height above ground [m]
datastream{78}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{78}.config.inflow = 278;        % inflow angle [deg mag]

datastream{78}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{78}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{78}.instrument.name = 'Aspirator on';                 % descriptive name for charts, etc
datastream{78}.instrument.variable = 'Asp_122';                  % variable name
datastream{78}.instrument.TDMSchanName = 'ASP_STAT_122m';
datastream{78}.instrument.measures = 'Aspirator';             % measurement type
datastream{78}.instrument.units ='TF';                      % units (SI as far as possible)
datastream{78}.instrument.skipnsamples = 20;

datastream{78}.qc.doqc = 1;
datastream{78}.qc.nanvalue =-99999;                       % NaN value
datastream{78}.qc.range.max = 1.1;              % maximum measurement value
datastream{78}.qc.range.min = -0.1;              % minimum measurement value
datastream{78}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{78}.qc.accept.max = 1.1;             % maximum acceptable value
datastream{78}.qc.accept.min = 0.5;             % minimum acceptable value
datastream{78}.qc.accept.rate = 0.5;           % minimum acceptable rate to pass / interval
datastream{78}.qc.alsoflag = [37];                % datastream to flag as well
datastream{78}.qc.alsofail = [];                % datastream to kill as well
datastream{78}.qc.warnifover = inf;
datastream{78}.qc.warnifunder = 0.5;
datastream{78}.qc.warnrate = 0.5;

% -------------------------------------------------------------------------------

% Aspirator 2 Status
datastream{79}.config.height = 87;     % height above ground [m]
datastream{79}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{79}.config.inflow = 278;        % inflow angle [deg mag]

datastream{79}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{79}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{79}.instrument.name = 'Aspirator on';                 % descriptive name for charts, etc
datastream{79}.instrument.variable = 'Asp_87';                  % variable name
datastream{79}.instrument.TDMSchanName = 'ASP_STAT_87m';
datastream{79}.instrument.measures = 'Aspirator';             % measurement type
datastream{79}.instrument.units ='TF';                      % units (SI as far as possible)
datastream{79}.instrument.skipnsamples = 20;

datastream{79}.qc.doqc = 1;
datastream{79}.qc.nanvalue =-99999;                       % NaN value
datastream{79}.qc.range.max = 1.1;              % maximum measurement value
datastream{79}.qc.range.min = -0.1;              % minimum measurement value
datastream{79}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{79}.qc.accept.max = 1.1;             % maximum acceptable value
datastream{79}.qc.accept.min = 0.5;             % minimum acceptable value
datastream{79}.qc.accept.rate = 0.5;           % minimum acceptable rate to pass / interval
datastream{79}.qc.alsoflag = [30];                % datastream to flag as well
datastream{79}.qc.alsofail = [];                % datastream to kill as well
datastream{79}.qc.warnifover = inf;
datastream{79}.qc.warnifunder = 0.5;
datastream{79}.qc.warnrate = 0.5;

% -------------------------------------------------------------------------------

% Aspirator 3 Status
datastream{80}.config.height = 38;     % height above ground [m]
datastream{80}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{80}.config.inflow = 278;        % inflow angle [deg mag]

datastream{80}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{80}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{80}.instrument.name = 'Aspirator on';                 % descriptive name for charts, etc
datastream{80}.instrument.variable = 'Asp_38';                  % variable name
datastream{80}.instrument.TDMSchanName = 'ASP_STAT_38m';
datastream{80}.instrument.measures = 'Aspirator';             % measurement type
datastream{80}.instrument.units ='TF';                      % units (SI as far as possible)
datastream{80}.instrument.skipnsamples = 20;

datastream{80}.qc.doqc = 1;
datastream{80}.qc.nanvalue =-99999;                       % NaN value
datastream{80}.qc.range.max = 1.1;              % maximum measurement value
datastream{80}.qc.range.min = -0.1;              % minimum measurement value
datastream{80}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{80}.qc.accept.max = 1.1;             % maximum acceptable value
datastream{80}.qc.accept.min = 0.5;             % minimum acceptable value
datastream{80}.qc.accept.rate = 0.5;           % minimum acceptable rate to pass / interval
datastream{80}.qc.alsoflag = [31];                % datastream to flag as well
datastream{80}.qc.alsofail = [];                % datastream to kill as well
datastream{80}.qc.warnifover = inf;
datastream{80}.qc.warnifunder = 0.5;
datastream{80}.qc.warnrate = 0.5;

% -------------------------------------------------------------------------------

% Aspirator 4 Status
datastream{81}.config.height = 3;     % height above ground [m]
datastream{81}.config.boomlength = 0.0;  % length of boom from tower face [m]
datastream{81}.config.inflow = 278;        % inflow angle [deg mag]

datastream{81}.instrument.installdate = [2011 04 01 00 00 00];    % installation date [yyyy mm dd HH MM SS]
datastream{81}.instrument.serialno = 'XXXXXXXXX';               % serial number associated
datastream{81}.instrument.name = 'Aspirator on';                 % descriptive name for charts, etc
datastream{81}.instrument.variable = 'Asp_3';                  % variable name
datastream{81}.instrument.TDMSchanName = 'ASP_STAT_3m';
datastream{81}.instrument.measures = 'Aspirator';             % measurement type
datastream{81}.instrument.units ='TF';                      % units (SI as far as possible)
datastream{81}.instrument.skipnsamples = 20;

datastream{81}.qc.doqc = 1;
datastream{81}.qc.nanvalue =-99999;                       % NaN value
datastream{81}.qc.range.max = 1.1;              % maximum measurement value
datastream{81}.qc.range.min = -0.1;              % minimum measurement value
datastream{81}.qc.range.rate = 0.99;            % minimum range rate to pass / interval
datastream{81}.qc.accept.max = 1.1;             % maximum acceptable value
datastream{81}.qc.accept.min = 0.5;             % minimum acceptable value
datastream{81}.qc.accept.rate = 0.5;           % minimum acceptable rate to pass / interval
datastream{81}.qc.alsoflag = [32];                % datastream to flag as well
datastream{81}.qc.alsofail = [];                % datastream to kill as well
datastream{81}.qc.warnifover = inf;
datastream{81}.qc.warnifunder = 0.5;
datastream{81}.qc.warnrate = 0.5;
