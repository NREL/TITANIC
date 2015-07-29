function plot_timeheight_patches(ndatasets,varargin)

%% set defaults
dz = 5;
dt = 10/(24*60);
DO_CLIM = 1;
UTCoffset = 0;

%% handle inputs
optargin = numel(varargin);
stdargin = nargin - optargin;

% get the data
for i = 1:ndatasets
    data{i} = varargin{i};
end

% get the arguments
for i = 1+ndatasets:optargin
    if ischar(varargin{i})
        switch lower(varargin{i})
            case 'utcoffset'
                UTCoffset = varargin{i+1};
            case 'dz'
                dz = varargin{i+1};
            case 'dt'
                dt = varargin{i+1};
            case 'cmap'
                cmapname = varargin{i+1};
            case 'dc'
                dc = varargin{i+1};
            case 'clim'
                Dmax = max(varargin{i+1});
                Dmin = min(varargin{i+1});
                DO_CLIM = 0;
            case 'title'
                titlestring = varargin{i+1};
            case 'legendtitle'
                legendstring = varargin{i+1};
        end
    end
end

%% get information about the range of data in the data set
if DO_CLIM
    Dmax = -inf;
    Dmin = inf;
    
    for di = 1:ndatasets
        % figure out if this is good data
        [ipass,iflag,ifail] = flagstopassflagfail(data{di}.flags);
        
        % find the range of values in this dataset
        Dmax = max([Dmax max(data{di}.val(ipass))]);
        Dmin = min([Dmin min(data{di}.val(ipass))]);
    end
end

%% get information about the colormap
m = ceil(Dmax - Dmin)/dc;
cmap = eval(['colormap(' cmapname '(m));']);
disp(['Generating ' num2str(m) ' contours in the range '...
    num2str(Dmin) ' to ' num2str(Dmax) '.'])

%% plot the data as small patches
for di = 1:ndatasets
    % figure out if this is good data
    [ipass,iflag,ifail] = flagstopassflagfail(data{di}.flags);
    
    for ti = 1:numel(ipass)
        ValPatch = data{di}.val(ipass(ti));
        % get the color of this patch
        ci = cindex(ValPatch,[Dmin Dmax],m);
        plotpatch(data{di}.date(ipass(ti))+UTCoffset,...
            data{di}.height,...
            dt,dz,...
            cmap(ci,:))
    end
end

%% tidy up
title(gca,titlestring)
set(gca,'CLim',[Dmin Dmax])
colormap(gca,cmap)
datetick('x')
cbar = colorbar('Clim',[Dmin Dmax]);
set(get(cbar,'title'),'string',legendstring)
colormap(cbar,cmap)
shading(cbar,'Flat')
pretty_xyplot
set(gca,'YGrid','off')
% labels
xlabel('Local Time')
ylabel('Height [m]')

function index = cindex(C,CRange,m)
cmin = min(CRange);
cmax = max(CRange);
% the rest of this function taken verbatim from the help for caxis
index = fix((C-cmin)/(cmax-cmin)*m)+1;
%Clamp values outside the range [1 m]
index(index<1) = 1;
index(index>m) = m;

function plotpatch(x,y,dx,dy,C)
patch([x x+dx x+dx x],...
    [y y y+dy y+dy],...
    C,...
    'EdgeColor','none')

