% function outage admin_add_outage(filename,filepath)
%
% Define outages by data and instrument affected. Apend outages to a file
% or create a new one as required.
%
% Designed to be run interactively as part of the housekeeping for the NWTC
% meteorological towers. The output file is a structure that can be edited
% directly in matlab if/as required.
%
% Some error checking is included in the function; if an outage cannot be
% parsed, it is deleted from the record.
%
% INPUTS
% -------
% filename: name of the file to store the outages in, e.g. M4_outage.mat.
%           Defaults to outages.mat
% filepath: path to the file. Defaults to current directory (pwd).
%
% Written by Andy Clifton, February 2012.

function outage = admin_add_outage(filename,filepath)

if isempty(filepath)
    filepath = '';
end
if isempty(filename)
    filename = 'outages.mat';
end

outagefile = fullfile(filepath,filename);
fileexists =0;

% go looking for the file
if exist(outagefile,'file') == 2
    fileexists =1;
    load(outagefile)
    disp(['... loading existing outage information from ' filename ' in ' filepath])
    outage = print_outages(outage);
    n1 = numel(outage);
else    
    disp(['... creating new outage file, ' filename ' in ' filepath])
    outage = {};
    n1 = 0;
end

%% prompt for outages
addoutage = 'Y';

fprintf('\n');
try
    while strcmpi(addoutage(1),'y')
        fprintf('\n');
        addoutage = input('Do you wish to add outages? Y/N [Y]','s');
        if isempty(addoutage)
            addoutage = 'Y';
        end
        
        switch lower(addoutage(1))
            case 'y'
                % 1. get the channels that are affected
                channels = input('1. Which channels are affected? please use integer values e.g 1 5 6 7 11 [all]','s');
                if isempty(channels)
                    % assume we want to mark all channels
                    channels = [-inf inf];
                else
                    channels = cell2mat(textscan(channels,'%f '));
                end
                % 2a. get the start date
                fprintf('2. Enter outage dates as dd mm yyyy HH MM (using UTC)\n');
                startdate = input('- start date? [now]','s');
                if isempty(startdate)
                    startdatenum = now;
                else
                    startdatenum = datenum(startdate,'dd mm yyyy HH MM');
                end
                % 2b. Start date
                enddate = input('- end date? [now]','s');
                if isempty(enddate)
                    stopdatenum = now;
                else
                    stopdatenum = datenum(enddate,'dd mm yyyy HH MM');
                end
                %3 Reason
                reason = input('3. Please supply a short reason [unknown]','s');
                if isempty(reason)
                    reason = 'unknown';
                end
                
                % create the outage structure
                outage{end+1}.channels = channels;
                outage{end}.startdatenum = startdatenum;
                outage{end}.stopdatenum = stopdatenum;
                outage{end}.reason = reason;
                outage{end}.dateadded = now;
                
                % save outages
                disp(['Saving data to file ' outagefile])
                save(outagefile,'outage')
                
            case 'n'
                % finished
                disp(['Saving data to file ' outagefile])
                save(outagefile,'outage')                
        end
    end
    
    % print outages
    fprintf('\n');
    if fileexists
        if (numel(outage)-n1) == 0
            disp('No new outages added to existing file')
        else
            disp(['Added ' num2str(numel(outage)-n1) ' new outage records to existing file.']);
        end
    else
        disp(['Created new file with ' num2str(numel(outage)) ' outage records.']);
    end
    
catch
    disp('***********')
    disp('** ERROR **')
    disp('***********')
    disp('This function is not very intelligent.')
    disp('Please follow formats given inprompts _exactly_, or it will crash.')
    disp('***')
end

disp('The following outages have been written to file')
outage = print_outages(outage);
%save(outagefile,'outage')


function cleanout = print_outages(outage)
cleanout = {};
for i = 1:numel(outage)
    try
        fprintf('outage %i:\n',i)
        fprintf('- reason: %s \n',outage{i}.reason)
        fprintf('- instrument channels ')
        for c = 1:numel(outage{i}.channels)-1
            fprintf(' %i,',outage{i}.channels(c))
        end
        fprintf(' %i.',outage{i}.channels(end))
        fprintf('\n- from %s',datestr(outage{i}.startdatenum,'HH:MM mmmm dd, yyyy'))
        fprintf(' to %s.',datestr(outage{i}.stopdatenum,'HH:MM mmmm dd, yyyy'))
        if ~isfield(outage{i},'dateadded')
            outage{i}.dateadded = now;
        else
            fprintf(' added %s.',datestr(outage{i}.dateadded,'HH:MM mmmm dd, yyyy'))
        end
        fprintf('\n')
        % output this one
        cleanout{end+1} = outage{i};
    catch
        fprintf('\n\n** ERROR ** in outage cell array. Removing this entry!\n\n')
    end
end