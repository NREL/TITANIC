years = [2010];
months = [1:12];

for yi = 1:numel(years)
    YY = num2str(years(yi));
    for mi = 1:numel(months)
        MM = num2str(months(mi),'%02d');
        % create the path
        if ispc
            data_root = 'Y:\Wind\Confidential\Projects\MetData\Fluela\';
        elseif ismac
            data_root = '/Volumes/Confidential/Projects/MetData/Fluela/';
        end
        
        % work through each day
        for di =1:31
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
                    listing = dir(fullfile(data_path,'*.mat'));
                    if ~isempty(listing)
                        for listitem = 1:numel(listing)
                            old = listing(listitem).name;
                            % old format is mmddy_HH_MM_SS.mat
                            if numel((strfind(old,'_'))) == 6
                                old_name = strrep(old,'.mat','');
                                % get the bits of the name
                                old_name_mm = old_name(1:2);
                                old_name_dd = old_name(4:5);
                                old_name_yyyy = num2str(10+str2num(old_name(7:10)));
                                old_name_HH = old_name(12:13);
                                old_name_MM = old_name(15:16);
                                old_name_SS = old_name(18:19);
                                
                                % new format is mm_dd_YYYY_HH_MM_SS_FFF
                                new = sprintf('%s_%s_%s_%s_%s_%s_000.mat',...
                                    old_name_mm,...
                                    old_name_dd,...
                                    old_name_yyyy,...
                                    old_name_HH,...
                                    old_name_MM,...
                                    old_name_SS);
                                try
                                    movefile(fullfile(data_path,old),...
                                        fullfile(data_path,new));
                                end
                            end
                        end
                        try
                            % remove processed data
                            rmdir(fullfile(data_path,'summary_data','s'))
                            rmdir(fullfile(data_path,'raw_data','s'))
                        end
                    end
                catch
                    warning('AdminRenameOldFiles:FileListing', ...
                        'Error finding old data');
                end
            end
            % end of loop if the directory yyyy/mm/dd exist
        end
        % end of loop for dd
    end
    % end of loop for mm
end
% end of loop for yy