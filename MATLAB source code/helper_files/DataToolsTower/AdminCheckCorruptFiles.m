% script AdminCheckCorruptFiles.m
%
% runs through and checks for corrupt Matlab data files in the analysis
% structure

function AdminCheckCorruptFiles(output_path)

years = [2011 2012 2013];
months = [1:12];
towers = {'M4Twr';'M5Twr'};

%% loop through the data
for yi = 1:numel(years)
    YY = num2str(years(yi));
    for mi = 1:numel(months)
        MM = num2str(months(mi),'%02d');
        disp(['Checking ' MM ' ' YY])
        % work through each tower
        for ti = 1:numel(towers)
            % create the path
            if ispc
                data_root = fullfile(output_path,...
                    towers{ti});
            elseif ismac
                data_root = fullfile('/Volumes/Confidential/Projects/MetData',...
                    towers{ti});
            end
            
            % work through each day
            for di =1:31
                data_path = fullfile(data_root,...
                    YY,...
                    MM,...
                    num2str(di,'%02d'),...
                    'summary_data');
                if exist(data_path,'dir')
                    
                    %% ---------------------
                    % TIDY UP OUTPUT FOLDERS
                    %-----------------------
                    try
                        disp(data_path)
                        % clean up directories
                        listing = dir(fullfile(data_path,'*.mat'));
                        for li = 1:numel(listing)
                            sprintf('%s',listing(li).name);
                            try
                                A = load(fullfile(data_path,listing(li).name));
                                clear('A');
                                sprintf(' OK.\n');
                            catch err
                                sprintf(' corrupt...');
                                delete(fullfile(data_path,listing(li).name));
                                sprintf(' deleted.\n');
                            end
                        end
                    catch
                        warning('AdminCheckCorruptFiles:DeleteDataFiles', ...
                            'Error deleting old data');
                    end
                end
                % end of loop if the directory yyyy/mm/dd exist
            end
            % end of loop for dd
        end
        % end of the loop for towers
    end
    % end of loop for mm
end
% end of loop for yy