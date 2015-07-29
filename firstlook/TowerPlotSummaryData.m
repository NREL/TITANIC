function TowerPlotSummaryData(varargin)

close all
fclose('all');

%% get some information about the expected inputs
expectedInputs = {'data_root',...
    'from_date',...
    'to_date',...
    'config_path',...
    'config_file',...
    'QCSummaryPathAndFile',...
    'DataSummaryPathAndFile'};

%% check the input data
for k = 1:2:size(varargin,2)
    fprintf(1,'... received input argument for %s ...\n', char(varargin{k}));
    if isdeployed
        switch varargin{k}
            case {'from_date';'to_date'}
                eval([char(varargin{k}) '= str2num(varargin{' num2str(k+1) '});']);
            otherwise
                eval([char(varargin{k}) '= varargin{' num2str(k+1) '};']);
        end
    else
        if isnumeric(varargin{k+1})
            eval([char(varargin{k}) '= varargin{' num2str(k+1) '};']);
        elseif ischar(varargin{k+1})
            eval([char(varargin{k}) '=''' char(varargin{k+1}) ''';']);
        end
    end
end

%% Write out inputs
fprintf(1,'Input arguments:');
for i = 1:numel(expectedInputs)
    fprintf(1,'\n %i: %s is ', i, expectedInputs{i});
    switch expectedInputs{i}
        case {'from_date';'to_date'}
            fprintf(1,'%s.',datestr(eval(expectedInputs{i}),'dd mmmm yyyy HH:MM'));
        case {'DO_MOVE'}
            fprintf(1,'%d.',eval(expectedInputs{i}));
        otherwise
            fprintf(1,'%s.',eval(expectedInputs{i}));
    end
end
fprintf(1,'\n**********\n');
fprintf(1,'Running code.\n');

%% find the files to read in
fprintf(1,'* Looking for data files from %s to %s in %s ...',...
    datestr(datenum(from_date),'dd mmmm yyyy HH:MM'),...
    datestr(datenum(to_date),'dd mmmm yyyy HH:MM'),...
    data_root);

all_data = TowerFind10minDataMATLAB('data_root',data_root,...
    'from_date',from_date,...
    'to_date',to_date);

%% -------
% QC CODES
% --------
if ~isempty(all_data)
    
    if isdeployed
        fSUM = figure('Name','Summary Data','Visible','off');
        fQC = figure('Name','QC Data','Visible','off');
    else
        fSUM = figure('Name','Summary Data','Visible','on');
        fQC = figure('Name','QC Data','Visible','on');
    end
    
    DisplayChannelQCSummary(all_data);
    % print
    readyforprint([6 8],8,'k','w',0.5,fQC)
    set(legend,'Orientation','horizontal')
    set(findobj('tag','labels'),'BackgroundColor','none')
    print('-dpng',QCSummaryPathAndFile)
    close(fQC);
    
    a = DisplayChannelDataSummary(all_data,config_path,config_file,fSUM);
    for i = 1:numel(a)
        pre = get(a(i),'Position');
        set(a(i),'Position',[pre(1) pre(2)-0.1 pre(3) 0.14]);
    end
    % print
    readyforprint([6 8],8,'k','w',0.5,fSUM)
    
    print('-dpng',DataSummaryPathAndFile)
    close(fSUM);
    
else
    fprintf(1,'No data found for this period.\n');
end
