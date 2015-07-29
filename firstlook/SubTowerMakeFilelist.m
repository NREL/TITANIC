% function make_file_list(data_path,from_date)
%
% generate a list of data files in the directory data_path with time stamps
% between the date 'from_date' and 'to_date'
%
% INPUTS
% ------
% data_path;    directory of interest; assume it contains directories of
% the form yyy/mm/dd
% from_date;    time stamp [yyyy mm dd HH MM SS]

function [process_path,process_file] = SubTowerMakeFilelist(data_path,...
    from_date,to_date,data_extension,formatStr,LogFID)

% generate empty output structures
process_path = {};
process_file = {};

% convert the from_date into a datenum
from_datenum = datenum(from_date);
to_datenum = datenum(to_date);

fprintf(LogFID,'\n*********\nSubTowerMakeFileList.m\n*********\n');
fprintf(1,'\n*********\nSubTowerMakeFileList.m\n*********\n');

for search_datenum = floor(from_datenum):1:ceil(to_datenum)
    
    %% start by looking for files in the current directory
    dir_path = fullfile(data_path,...
        datestr(search_datenum,'yyyy'),...
        datestr(search_datenum,'mm'),...
        datestr(search_datenum,'dd'));
    
    fprintf(LogFID, '* looking for %s files in %s ', data_extension, dir_path);
    fprintf(1, '* looking for %s files in %s ', data_extension, dir_path);
    listing = dir(fullfile(dir_path, data_extension));
    
    process_path_was = numel(process_path);
    % process this
    for f = 1:numel(listing)
        listing(f).datefromname = TowerConvertDatafilenameDatenum(listing(f).name,formatStr);
        if (listing(f).datefromname >= from_datenum) && (listing(f).datefromname <= to_datenum)
            process_path{end+1} = dir_path;
            process_file{end+1} = listing(f).name;
        end
    end
    fprintf(LogFID, '... found %i files.\n', numel(process_path) - process_path_was);
    fprintf(1, '... found %i files.\n', numel(process_path) - process_path_was);
end


