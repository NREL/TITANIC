function a = DisplayChannelDataSummary(all_data,config_path,config_file,fh)

%% --------------------------
% LOAD THE CONFIGURATION FILE
% ---------------------------
try
    load(fullfile(config_path,config_file));
    fprintf(1,'Loaded file %s\n', config_file);
catch
    fprintf(1,'Problem with reading config file %s', config_file);
    error('tower_doQC:LoadConfigFile', ...
        ['Problem loading the config file ' config_file]);
end
% now have access to the structure, 'tower'.

%% --------------------
% FIGURE OUT PLOT DATES
% ---------------------
allfields = fieldnames(all_data);
t0 = inf;
t1 = -inf;
% figureout how many good data points we have
for i = 1:numel(allfields)
    if strncmp(allfields{i},'Raw_',4)
        if strfind(allfields{i},'_mean')
            t0 = min([min(all_data.(allfields{i}).date) t0]);
            t1 = max([max(all_data.(allfields{i}).date) t1]);
        end
    end
end

%% plot the velocities
a(1) = subplot(5,1,1,'Parent',fh);
% get the indices of the instruments that have the name, 'wind speed cup'
plot_timeseries('Wind_Speed_Cup_',[],[],a(1),all_data)
title(a(1),'Wind Speed (Cups)')
ylabel(a(1),'Wind Speed [m/s]')

%% plot the wind directions
a(2) = subplot(5,1,2,'Parent',fh);
% get the indices of the instruments that are used for the velocity profile
plot_timeseries('Wind_Direction_Vane','and','mean',a(2),all_data)
title(a(2),'Wind Direction (Vanes)')
ylabel(a(2),'Direction [^\circ]')

%% plot the air temperatures
a(3) = subplot(5,1,3,'Parent',fh);
% get the indices of the instruments that are used for the velocity profile
plot_timeseries('Air_Temperature','not','Sonic',a(3),all_data)
title(a(3),'Air temperature (RTD)')
ylabel(a(3),'Temperature [^\circ K]')
plot(a(3),xlim(a(3)),[273 273],'k--')

%% plot the sonic velocities
a(4) = subplot(5,1,4,'Parent',fh);
% get the indices of the instruments that are used for the velocity profile
plot_timeseries('Wind_Speed_CupEq_Sonic',[],[],a(4),all_data)
title(a(4),'Wind Speed (Sonic Anemometers)')
ylabel(a(4),'Speed [m/s]')

%% plot the sonic wind directions
a(5) = subplot(5,1,5,'Parent',fh);
% get the indices of the instruments that are used for the velocity profile
plot_timeseries('Wind_Direction_Sonic',[],[],a(5),all_data)
title(a(5),'Wind Direction (Sonic Anemometers)')
ylabel(a(5),'Direction [^\circ]')

%% set all axes to the same time period
linkaxes(a,'x')
set(a(1:4),'XTickLabel','')
xlabel(a(5),['Time (UTC, ' datestr(t0,'dd mmm') ' - ' datestr(t1,'dd mmm') ')'])

function plot_timeseries(searchstr,logic,substr,ax,all_data)

% initialise the plot
h = [];
lstring  ={};
t0 = inf;
t1 = -inf;

% find datastreams with the right names
fnames = fieldnames(all_data);
idx =  strfind(fnames,searchstr);
datastreams = {};
for i = 1:numel(fnames)
    if strncmp(fnames{i},'Raw_',4)
        if strfind(fnames{i},'_mean')
            t0 = min([min(all_data.(fnames{i}).date) t0]);
            t1 = max([max(all_data.(fnames{i}).date) t1]);
        end
    end
    if idx{i}
        if isempty(substr)|isempty(logic)
            found =1;
        else
            switch logic
                case 'not'
                    if strfind(fnames{i},substr)
                        % then we actually don't want this data
                        found = 0;
                    else
                        found =1;
                    end
                case 'and'
                    if strfind(fnames{i},substr)
                        %then there's a chance we might want it
                        found =1;
                    else
                        found =0;
                    end
            end
        end
    else
        found =0;
    end
    if found
        datastreams{end+1} = fnames{i};
    end
end

colors = colormap(lines(numel(datastreams)));
lstring = cell(numel(datastreams),1);
h = zeros(numel(datastreams),1);
if ~isempty(datastreams)
    for ii = 1:numel(datastreams)
        VarVals = all_data.(datastreams{ii}).val;
        % get the name for the legend
        lstring{ii} = num2str(all_data.(datastreams{ii}).height);
        % figure out pass / fail
        [~,iflag,ifail] = flagstopassflagfail(all_data.(datastreams{ii}).flags);
        
        % ----
        % PLOT
        % ----
        x = all_data.(datastreams{ii}).date;
        y = VarVals;
        % 1. plot all of the data
        if isempty(y(~isnan(y)))
            h(ii) = plot(ax,NaN,NaN,...
                'k-',...
                'Color',colors(ii,:));
        else
            h(ii) = plot(ax,x(~isnan(y)),y(~isnan(y)),...
                'k-',...
                'Color',colors(ii,:));
        end
        hold(ax,'on')
        % 2. plot the flags
        plot(ax,x(iflag),...
            y(iflag),'ko',...
            'Color',[0.8 0.8 0.8],...
            'MarkerFaceColor',[0.8 0.8 0.8],...
            'MarkerSize',4)
        % 3. plot the fails
        plot(ax,x(ifail),...
            y(ifail),'ko',...
            'Color','r',...
            'MarkerFaceColor','r',...
            'MarkerSize',4)
    end
    
    % tidy up
    legend(ax,h,lstring,...
        'Location','EastOutside')
    xlim(ax,[t0 t1])
    datetick(ax,'x','Keeplimits')
else
    disp('No data found')
end