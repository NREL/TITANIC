function plot_timeheightcontours(ndatasets,varargin)

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
                legendtitle = varargin{i+1};
            case 'legendunits'
                legendunits = varargin{i+1};
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
m = ceil((Dmax - Dmin)/dc);
cmap = eval(['colormap(' cmapname '(m));']);
disp(['Generating ' num2str(m) ' contours in the range '...
    num2str(Dmin) ' to ' num2str(Dmax) '.'])

%% get the data into X Y Z vectors
x = [];
y = [];
z = [];
for di = 1:ndatasets
    % figure out if this is good data
    [ipass,iflag,ifail] = flagstopassflagfail(data{di}.flags);
    
    for ti = 1:numel(ipass)
        x(end+1) = data{di}.date(ipass(ti))+UTCoffset;
        y(end+1) = data{di}.height;
        z(end+1) = data{di}.val(ipass(ti));
    end
end

%% interpolate the data onto a regular grid
XI = unique(x);
YI = unique([0 y])';
ZI = griddata(x,y,z,XI,YI);

%% plot the data
[C,h] = contourf(XI,YI,ZI,m);
set(h,'LineColor','none')

%% tidy up
title(gca,titlestring)
set(gca,'CLim',[Dmin Dmax])
colormap(cmap)
datetick('x')
cbar = colorbar('Clim',[Dmin Dmax]);
set(get(cbar,'title'),'string',legendtitle)
set(get(cbar,'ylabel'),'string',legendunits,'Rotation',90)

pretty_xyplot
set(gca,'YGrid','off')
% labels
xlabel('Local Time')
ylabel('Height [m]')