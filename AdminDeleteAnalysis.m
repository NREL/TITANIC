close all
clear all

years = [2015];
months = [1:7 11];
data_root = 'C:\blah\MetData\M5Twr';


for yi = 1:numel(years)
    YY = num2str(years(yi));
    for mi = 1:numel(months)
        MM = num2str(months(mi),'%02d');
        
        % work through each day
        for di = 1:31
            data_path = fullfile(data_root,...
                YY,...
                MM,...
                num2str(di,'%02d'));
            if exist(data_path,'dir')
                
                %% ---------------------
                % TIDY UP OUTPUT FOLDERS
                %-----------------------
                try
                    disp(data_path)
                    % clean up directories
                    opp = fullfile(data_path,'signals');
                    if exist(opp,'dir')
                        disp('- deleting signals')
                        rmdir(opp,'s')
                    end                    
                    opp = fullfile(data_path,'summary_data');
                    if exist(opp,'dir')
                        disp('- deleting summary data')
                        rmdir(opp,'s')
                    end
                    opp = fullfile(data_path,'raw_data');
                    if exist(opp,'dir')
                        disp('- deleting raw data')
                        rmdir(opp,'s')
                    end
                catch
                    warning('tidy_directories:DeleteDataFolders', ...
                        'Error deleting folders for output data');
                end
            end
            % end of loop if the directory yyyy/mm/dd exist
        end
        % end of loop for dd
    end
    % end of loop for mm
end
% end of loop for yy