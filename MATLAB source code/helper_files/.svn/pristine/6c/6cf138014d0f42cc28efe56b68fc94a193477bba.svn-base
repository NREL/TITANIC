years = [2011 2012];
months = [1:12];

UseNewerThan = datenum([2012 12 13 0 0 0]);

for yi = 1:numel(years)
    YY = num2str(years(yi));
    for mi = 1:numel(months)
        MM = num2str(months(mi),'%02d');        
        % create the path
        if ispc
            data_root = 'Y:\Wind\Confidential\Projects\MetData\M5Twr\';
        elseif ismac
            data_root = '/Volumes/Confidential/Projects/Other/M5TWR/';
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
                        if listing(li).date < UseNewerThan
                            delete(fullfile(data_path,listing(li).name));
                        end
                    end					
				catch					
                    warning('tidy_oldfiles:DeleteDataFolders', ...
                        'Error deleting old data');
                end
            end
            % end of loop if the directory yyyy/mm/dd exist
        end
        % end of loop for dd
    end
    % end of loop for mm
end
% end of loop for yy