function fplot = plot_joint_PDF(x,y,xedges,yedges,fedges,varargin)


%% define defaults
options = struct('iscircularx',0,...
    'iscirculary',0,...
    'cmap','none');

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

%% deal with data

dnu = isnan(x) | isnan(y);
x(dnu) = [];
y(dnu) = [];

npoints = numel(x);

for i = 1:(numel(xedges)-1)
    xi = (x>=xedges(i)) & (x<xedges(i+1));        
    for j = 1:(numel(yedges)-1)
        yi = (y>=yedges(j)) & (y<yedges(j+1));
        xiyi = xi & yi;
        fplot(j,i) = sum(xiyi) / npoints;
        if i == 1
            yplot(j) = (yedges(j)+yedges(j+1))/2;
        end
    end
    xplot(i) = (xedges(i)+xedges(i+1))/2;
end
% deal with the circular
if options.iscirculary
    dy = (yplot(2)-yplot(1));
    yplot = horzcat(yplot(1)-dy, yplot, yplot(end)+dy);
    fplot = vertcat(fplot(end,:), fplot, fplot(1,:));
end

if options.iscircularx
    dx = (xplot(2)-xplot(1));
    xplot = horzcat(xplot(1)-dx, xplot, xplot(end)+dx);
    fplot = horzcat(fplot(:,end), fplot, fplot(:,1));
end

% get contours
switch options.cmap
    case 'none'
        [C,h] = contourf(xplot,yplot,100*fplot/sum(fplot(:)),[fedges(1) fedges(1)]);
        colormap([0.9 0.9 0.9])
        hold on
        contour(xplot,yplot,100*fplot/sum(fplot(:)),fedges,'k-');
    otherwise
        [C,h] = contourf(xplot,yplot,100*fplot/sum(fplot(:)),fedges,'k-');       
        colormap(options.cmap)
        set(h,'Linestyle','none')
        hold on
end

% mark the maximum
[r,c] = find(fplot == max(fplot(:)));
plot(xplot(c),yplot(r),'k+');