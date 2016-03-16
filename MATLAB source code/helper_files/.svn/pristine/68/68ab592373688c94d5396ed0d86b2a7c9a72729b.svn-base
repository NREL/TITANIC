% function all_data = TowerDeleteCorruptData(varargin)
%
% Test raw, summary, web data for corrupt files

function TowerDeleteCorruptData(varargin)

%% parse inputs
optargin = size(varargin,2);
switch optargin
    case 0
    otherwise
        % there are optional arguments
        for k= 1:2:size(varargin,2)
            if isdeployed
                switch varargin{k}
                    case {'from_date';'to_date'}
                        eval([char(varargin{k}) '= str2num(varargin{' num2str(k+1) '});']);
                    otherwise
                        if isnumeric(varargin{k+1})
                            eval([char(varargin{k}) '= varargin{' num2str(k+1) '};']);
                        elseif ischar(varargin{k+1})
                            eval([char(varargin{k}) '=''' char(varargin{k+1}) ''';']);
                        end
                end
            else
                if isnumeric(varargin{k+1})
                    eval([char(varargin{k}) '= varargin{' num2str(k+1) '};']);
                elseif ischar(varargin{k+1})
                    eval([char(varargin{k}) '=''' char(varargin{k+1}) ''';']);
                end
            end
        end
end

%% create a sequence of dates
dates = datevec(floor(datenum(from_date)):1:ceil(datenum(to_date)));

%% FIND DATA FILES
for datei = 1:size(dates,1)
    datepath = fullfile(data_root,datestr(dates(datei,:),'yyyy/mm/dd/'));
    if exist(datepath,'dir')
        disp(['Creating list of .mat files in ' datepath])
        % apply a method found at http://stackoverflow.com/questions/20284377/matlab-list-all-unique-subfolders
        [~,message,~] = fileattrib([datepath '*']);
        %// final '\*' is needed to make the search recursive
        isfolder = [message(:).directory]; %// true for folders, false for files
        [folders{1:sum(isfolder)}] = deal(message(isfolder).Name); %// keep folders only
        %// folders is a cell array of strings with all folder names
        
        %% --------------
        % DATA FILE CHECK
        % ---------------
        for folderi = 1:numel(folders)
            files = dir(fullfile(folders{folderi},'*.mat'));
            for filei = 1:numel(files)
                NameAndPath = fullfile(folders{folderi},files(filei).name);
                try
                    disp(['Checking source file ' NameAndPath])
                    WaitYourTurnToLoad(NameAndPath);
                catch
                    disp('...File corrupt. Will be deleted.')
                    delete(NameAndPath)
                end
            end
        end
        clear folders
    end
end