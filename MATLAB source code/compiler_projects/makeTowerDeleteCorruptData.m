% Script to compile a file into an executable
% Run it as an m-file (>> make)
close all
clear all

%% name of the executable
exename = 'TowerDeleteCorruptData';

%% name of the file that this actually is (.m file)
mname = 'blah\MATLAB source code\helper_files\DataToolsTower\TowerDeleteCorruptData.m';

%% directories that contain additional files
adddir = {'blah\MATLAB source code\firstlook';...
    'blah\MATLAB source code\helper_files'};

%% create the directories we'll use
% append MATLAB release to exec name as reminder of version compiled for
verstring = version('-release');     % get the release string (e.g., 2013a)
distribdir = ['blah\MATLAB source code\Compiler_projects\' exename '\' verstring];
mkdir(distribdir)

%% create the compiler string
mcccommand = ['mcc -o ' exename ' '...
    '-W main:' exename ' '...
    '-T link:exe '...
    '-d ''' distribdir ''' '...
    '-w enable:specified_file_mismatch '...
    '-w enable:repeated_file '...
    '-w enable:switch_ignored '...
    '-w enable:missing_lib_sentinel '...
    '-w enable:demo_license '...
    '-v ' ...
    '''' mname ''''];

nadds = numel(adddir);
for n = 1:nadds
    mcccommand = [mcccommand ' -a ''' adddir{n} ''''];
end

disp(mcccommand)
%% execute the compiler string
eval(mcccommand)

%% save some data about the MCR installer
fid = fopen(fullfile(distribdir,'MCRinformation.txt'),'w');
[major, minor] = mcrversion;
fprintf(fid,...
    'This executable requires MCR version %d%d.',...
    major, minor);
fclose(fid);