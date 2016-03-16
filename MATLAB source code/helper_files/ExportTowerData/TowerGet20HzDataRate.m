% function all_data = TowerGet20HzDataRate(varargin)
%
% find 20 Hz tower data within a certain time-frame and show frequency

function [data_path,data_file] = TowerGet20HzDataRate(varargin)

% define default values
if ispc
    data_root = 'Y:\Wind\Confidential\Projects\Other\M4TWR\';
elseif ismac
    data_root = '/Volumes/Confidential/Projects/Other/M4TWR/';
end
to_date = now;
from_date = now-2;

%% now parse inputs
optargin = size(varargin,2);
switch optargin
    case 0
    otherwise
        % there are optional arguments
        for k= 1:2:size(varargin,2)
            if isnumeric(varargin{k+1})
                eval([char(varargin{k}) '= varargin{' num2str(k+1) '};']);
            elseif ischar(varargin{k+1})
                eval([char(varargin{k}) '=''' char(varargin{k+1}) ''';']);
            end
        end
end

%% find the data files
data_path = {};
data_file = {};
ndays = max(ceil(datenum(to_date))- floor(datenum(from_date)),1);
for d = 1:ndays
    date = datenum(from_date)+(d-1);
    if ismac
        mypath = fullfile(data_root,datestr(date,'yyyy/mm/dd'),'summary_data');
    elseif ispc
        mypath = fullfile(data_root,datestr(date,'yyyy\\mm\\dd'),'summary_data');
    end
    % get a list of data files in these directories
    listing = dir(fullfile(mypath,[datestr(date,'mmdd'),'*.mat']));
    if ~isempty(listing)
        for i = 1:numel(listing)
            filedatenum = TowerConvertDatafilenameDatenum(listing(i).name);
            inrange = (filedatenum >= datenum(from_date)) ...
                & ...
                (filedatenum<= datenum(to_date));
            if inrange
                data_path{end+1} = mypath;
                data_file{end+1} = listing(i).name;
                disp(['Found ' data_file{end} ]);
            end
        end
    end
end


%% ------------
% GET DATA RATE
% -------------
%data_path and data_file contain all of the file names
npoints = repmat(NaN,numel(data_path),1);
values = npoints;
tstamp = npoints;
for fi =1:numel(data_path)
    try
        % load
        fromNameAndPath = fullfile(data_path{fi},data_file{fi});
        all_data = load(fromNameAndPath);
        % get the data
        values(fi) = all_data.(variable).val;
        npoints(fi) = all_data.(variable).npoints;
        tstamp(fi) = all_data.(variable).date;
        disp(['checked ' data_file{fi}])
    end
end

%% -------------
% PLOT DATA RATE
% --------------

% export the data as a text file
if isempty(output_path)
    error
end
if ~exist(output_path,'dir')
    mkdir(output_path)
end

% create the plot
fH = figure;
% plot the values
aH = subplot(4,1,1,'Parent',fH);
stem(aH,tstamp,values,'k.')
% tidy up
datetick('x')
ylabel('Value')
title(strrep(variable,'_','\_'))
pretty_xyplot

% plot the counts
aH = subplot(4,1,2,'Parent',fH);
stem(aH,tstamp,100*npoints/12000,'k.')
% tidy up
ylim([85 100])
datetick('x')
ylabel('Valid data (%)')
pretty_xyplot

% comapre counts to values
aH = subplot(4,1,[3:4],'Parent',fH);
plot(aH,100*npoints/12000,values,'.k')
xlim([85 100])
xlabel('Valid data (%)')
ylabel('Value')
pretty_xyplot

% print
fo = fullfile(output_path,[variable '_' datestr(from_date,'mmddyy_HHMM') '_' datestr(to_date,'mmddyy_HHMM')]);
readyforprint([6 5],10,'k','w',[])
print('-dpng',fo)
close(fH)
