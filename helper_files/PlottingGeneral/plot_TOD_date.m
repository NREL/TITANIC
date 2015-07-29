function plot_TOD_date(t,x,trange,binedges,binedgelabels,varargin)

%% define defaults
options = struct('cmapname','jet',...
    'customcmap','',...
    'cbrewer',{''},...
    'binlabels','',...
    'xlabel','Time of day (UTC)',...
    'ylabel','Date',...
    'title','',...
    'colorbartitle','');

%# read the acceptable names
optionNames = fieldnames(options);

%# count arguments
nArgs = length(varargin);
if round(nArgs/2)~=nArgs/2
    error('plot_TOD_date needs propertyName/propertyValue pairs')
end

for pair = reshape(varargin,2,[]) %# pair is {propName;propValue}
    inpName = lower(pair{1}); %# make case insensitive
    
    if any(strmatch(inpName,optionNames))
        %# overwrite options. If you want you can test for the right class here
        %# Also, if you find out that there is an option you keep getting wrong,
        %# you can use "if strcmp(inpName,'problemOption'),testMore,end"-statements
        options.(inpName) = pair{2};
    else
        error('%s is not a recognized parameter name',inpName)
    end
end

%% process inputs
USE_BINEDGELABELS = 0;
if ~exist('binedgelabels','var')
    USE_BINEDGELABELS = 0;
elseif isempty(binedgelabels)
    USE_BINEDGELABELS = 0;
else
    USE_BINEDGELABELS = 1;
end

ninrange = numel(binedges)-1;
more_bottom=0;
if min(x) < min(binedges)
    binedges = [floor(min(x)) binedges];
    more_bottom = 1;
end

more_top = 0;
if  max(x) > max(binedges)
    binedges = [binedges ceil(max(x))];
    more_top = 1;
end

%binedges = [-inf binedges inf];

HH = str2num(datestr(t,'HH'));
MM = str2num(datestr(t,'MM'));
TOD = HH + MM/60;

dd = floor(t);

%% reshape data
x = reshape(x,1,[]);
dd = reshape(dd,1,[]);
TOD = reshape(TOD,1,[]);

%% generate the color map
switch options.cmapname
    case 'custom'
        cmap = options.customcmap;
    case 'cbrewer'
        cmap = eval(['colormap(cbrewer(''' options.cbrewer{1} ''',''' options.cbrewer{2} ''',ninrange));']);
    otherwise
        cmap = eval(['colormap(' options.cmapname '(ninrange));']);
end
if more_top
    cmap(end+1,:) = [0 0 0];
end
if more_bottom
    cmap = [0.8 0.8 0.8;...
        cmap];
end
colormap(cmap);

%% plot each box
A1 = axes();
hold on
dt_all = diff(sort(TOD(~isnan(x))));
min_dt = mode(dt_all(dt_all>0));
min_dy = 1;

ylim([trange])
xlim([0 24])

%% pcolor version
pcolorx = [0:min_dt:24-min_dt]/24;
pcolory = floor(min(dd)):1:floor(max(dd));
pcolorval = NaN * ones(length(pcolorx),length(pcolory));
for yi = 1:length(pcolory)
    for xi = 1:length(pcolorx)
        pcolort = pcolory(yi)+pcolorx(xi);
        dt = abs(t-pcolort);        
        vali = find(dt < (min_dt/24/2),1,'first');
        if isempty(vali)
            val = NaN;
        else
        val = x(vali);        
        end
        pcolorval(xi,yi) = val;
    end
end

%% now need to scale those values to the colormap
pcolorc = pcolorval;
for i = 1:(numel(binedges)-1)
   ii = (pcolorval >= binedges(i)) & (pcolorval < binedges(i+1));
   pcolorc(ii) = i+0.5;
end

%% plot
pcolor(24*repmat(pcolorx,length(pcolory),1),...
    repmat(pcolory',1,length(pcolorx)),...
    pcolorc')

%% apply the color scale
caxis(A1,[1 numel(binedges)])
colormap(A1,cmap)

%% tidy up
set(A1,'Xtick',0:6:24,'XTickLabel',num2str([0:6:24]'))
xlabel(options.xlabel)
ylabel(options.ylabel)
if ~isempty(options.title)
    title(options.title)
end
datetick('y','mm/dd','keepticks','keeplimits')


%% add a colorbar (cheating)
A2 = colorbar('location','EastOutside')
colormap(A2,cmap)
ylims = get(A2,'YLim')
% sort out the labels
set(A2,'YTickLabelMode','manual')
set(A2,'Ylim',ylims)
set(A2,'YTick',[min(ylims):diff(ylims)/(numel(binedges)-1):max(ylims)])
if USE_BINEDGELABELS
    set(A2,'YTickLabel',binedgelabels)
else
    set(A2,'YTickLabel',binedges)
end

% clear the x-ticks
set(A2,'XTick',[])
set(A2,'YMinorTick','off')
% lengthen the ticks where we do have colors
set(A2,'TickDir','out','TickLength',[.02 .02])

%colormap(gca,cmap)
%cbar = colorbar('Clim',[Dmin Dmax]);
% labels
title(A2,options.colorbartitle)

%% fisnish up
shading(A1,'flat')
shading(A2,'flat')
pretty_xyplot