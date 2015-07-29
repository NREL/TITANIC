function [xout,yout,zout,AH] = plot_xyz_patches(x,y,z,xedges,yedges,zedges,varargin)

%% define defaults
options = struct('method','median',...
    'xlabel','xlabel',...
    'ylabel','ylabel',...
    'title','',...
    'cmapname','jet',...
    'cbrewer',{''},...
    'colorbartitle','',...
    'colorbarlabel','',...
    'baseline',1,...
    'DoClim',1,...
    'plotcount','off');

%# read the acceptable names
optionNames = fieldnames(options);

%# count arguments
nArgs = length(varargin);
if round(nArgs/2)~=nArgs/2
    error('plot_xyz_patches needs propertyName/propertyValue pairs')
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

%% get information about the range of data in the data set
if options.DoClim
    Dmax = -inf;
    Dmin = inf;
    % find the range of values in this dataset
    Dmax = max([Dmax max(zedges)]);
    Dmin = min([Dmin min(zedges)]);
end
dZ = zedges(2)-zedges(1);

%% get information about the colormap
m = numel(zedges)-1;
cmap = [];
switch options.cmapname
    case 'abovebelow'
        nbelow = sum(zedges<options.baseline);
        nabove = sum(zedges>=options.baseline);
        for i=1:nbelow
            cmap(i,:) = [5 + ((i-1)/nbelow)*(209-5) ...
                48 + ((i-1)/nbelow)*(229-48)...
                97 + ((i-1)/nbelow)*(240-97)]./255;
        end
        for i=1:nabove
            cmap(end+1,:) = [253 + ((i-1)/(nabove-1))*(103-253) ...
                224 + ((i-1)/(nabove-1))*(0-224)...
                144 + ((i-1)/(nabove-1))*(31-144)]./255;
        end
        %cmap(nbelow+1:end,:) = flipud(cmap(nbelow+1:end,:));
    case 'cbrewer'
        cmap = eval(['colormap(gca,cbrewer(''' options.cbrewer{1} ''',''' options.cbrewer{2} ''',m));']);
    otherwise
        cmap = eval(['colormap(gca,' options.cmapname '(m));']);
end
disp(['Generating ' num2str(m) ' contours in the range '...
    num2str(Dmin) ' to ' num2str(Dmax) '.'])

%% check we don't need to add data to the colormap

if min(z) < Dmin
    switch options.cmapname
        case 'cbrewer'
        cmap = vertcat([0.7 0.7 0.7],...
            cmap);
        otherwise
            cmap = vertcat([0.8 0.8 0.8],...
        cmap);
    end
    Dmin = zedges(1) - dZ;
    zedges = horzcat(min(z),...
        zedges);
end


if max(z) > Dmax
    cmap = vertcat(cmap,...
        [0 0 0]);
    Dmax = zedges(end) + dZ;
    zedges(end+1) = max(z);
end

%% plot the data as small patches
xout = [];
yout = [];
zout = [];

switch options.method
    case 'quiver'
        uout = [];
        vout = [];
end

for xi = 1:(numel(xedges)-1)
    xbini=(x>xedges(xi)) & (x <= xedges(xi+1));
    for yi = 1:(numel(yedges)-1)
        ybini=(y>yedges(yi)) & (y <= yedges(yi+1));
        zi = find(xbini & ybini);
        % get the value of the patch
        if isempty(zi)
            ValPatch = NaN;
        else
            switch options.method
                case 'median'
                    ValPatch = nanmedian(z(zi));
                    nPatch = numel(zi);
                case 'std'
                    ValPatch = std(z(zi));
                    nPatch = numel(zi);
                case 'quiver'
                    ValPatch = NaN;
                    if numel(zi) >= 3
                        xcolv = reshape(x(zi),[],1);
                        ycolv = reshape(y(zi),[],1);
                        zcolv = reshape(z(zi),[],1);
                        const = ones(size(xcolv));
                        coeffs = [xcolv ycolv const]\zcolv;
                        % export the data
                        uout = vertcat(uout,coeffs(1));
                        vout = vertcat(vout,coeffs(2));
                        
                        xout = vertcat(xout,median(x(zi)));
                        yout = vertcat(yout,median(y(zi)));
                    end
                otherwise
                    ValPatch = nanmedian(z(zi));
                    nPatch = 0;
            end
        end
        if ~isnan(ValPatch)
            % get the color of this patch
            [~,ci] = histc(ValPatch,zedges);
            % just make sure that the extreme value gets shoved into the
            % top category.
            ci = min(ci,length(cmap));
            switch options.method
                case 'quiver'
                otherwise
                    % plot the patch
                    plotpatch(xedges(xi),...
                        yedges(yi),...
                        xedges(xi+1)-xedges(xi),...
                        yedges(yi+1)-yedges(yi),...
                        cmap(ci,:))
                    hold on                    
            end
            switch options.plotcount
                case 'on'
                    text((xedges(xi)+xedges(xi+1))/2,...
                        (yedges(yi)+yedges(yi+1))/2,...
                        num2str(nPatch))
            end
            % export the data
            xout = vertcat(xout,median(x(zi)));
            yout = vertcat(yout,median(y(zi)));
            zout = vertcat(zout,median(z(zi)));
        end
    end
end

% finish plotting
switch options.method
    case 'quiver'
        quiver(xout,yout,uout,vout)
    otherwise
        set(gca,'CLim',[Dmin Dmax])
        caxis([Dmin Dmax])
        % get current axes
        AH(1) = gca;
        cap = get(AH(1),'Position');
        % shift them to one side a bit
        set(AH(1),'Position',[cap(1) cap(2) cap(3)-0.2 cap(4)])
        cap = get(AH(1),'Position');
        
        % COLORBAR
        % generate new axes for colorbar
        cba = axes('Position',[cap(1)+cap(3)+0.025 cap(2)+0.05 1-0.15-(cap(1)+cap(3)) cap(4)-0.1]);
        AH(2) = cba;
        % plot patches
        dx = (Dmax-Dmin)/15;
        for i =1:size(cmap,1)
            patch([0 dx dx 0],...
                [Dmin+((i-1)*dZ) Dmin+((i-1)*dZ) Dmin+(i*dZ) Dmin+(i*dZ)],...
                cmap(i,:),...
                'Parent',AH(2))
                
        end
        % add the Y-axis
        set(AH(2),'YAxisLocation','right',...
            'ActivePositionProperty','position')                
        % set the axis limits
        ylim(AH(2),[Dmin Dmin+(i*dZ)])
        xlim(AH(2),[0 dx])
        % clear the x-ticks
        set(AH(2),'XTick',[])
        set(AH(2),'YMinorTick','off')
        % lengthen the ticks where we do have colors
        set(AH(2),'TickDir','out','TickLength',[.02 .02])
        
        %colormap(gca,cmap)
        %cbar = colorbar('Clim',[Dmin Dmax]);
        % labels
        title(cba,options.colorbartitle)
        ylabel(cba,options.colorbarlabel)
        %colormap(cbar,cmap)
        %shading(cbar,'Flat')
end

%% tidy up

title(AH(1),options.title)

pretty_xyplot(AH(1))
set(AH(1),'YGrid','off')
% labels
xlabel(AH(1),options.xlabel)
ylabel(AH(1),options.ylabel)
% set the focus
axes(AH(1))

function plotpatch(x,y,dx,dy,C)
patch([x x+dx x+dx x],...
    [y y y+dy y+dy],...
    C,...
    'EdgeColor','none')

