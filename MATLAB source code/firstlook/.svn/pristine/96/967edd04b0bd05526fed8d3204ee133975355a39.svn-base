% function plotxyf(x,y,xedges,yedges,df,scaling,DO_LABEL)

function plotxyf(x,y,xedges,yedges,df,scaling,DO_LABEL)

if isempty(scaling)
    scaling = 'linear';
end

% -----------
% TIDY INPUTS
% -----------
x = reshape(x,numel(x),1);
y = reshape(y,numel(y),1);

% remove NaN
ni = isnan(x) | isnan(y);
x(ni) = [];
y(ni) = [];

% --------------
% AMOUNT OF DATA
% --------------
nf = numel(x);

% bin the data in x and y
[nx,binx] = histc(x,xedges);
[ny,biny] = histc(y,yedges);

for i = 1:numel(xedges)-1
    for j = 1:numel(yedges)-1
        ij = (binx == i) & (biny==j);
        n(j,i) = sum(ij);
    end
end

% figure out the nominal mid points in x and y
xmid = xedges(1:end-1) + diff(xedges)./2;
ymid = yedges(1:end-1) + diff(yedges)./2;

% -----------
% Now plot it
% -----------

plot(x,y,'k.',...
    'Color',[0.8 0.8 0.8],'MarkerSize',4)
hold on

% figure out the levels we'll plot
switch scaling
    case 'linear'
        z = n./nf;
        v = 0:df:1;
        [C,h]=contour(xmid',ymid',z,v);
    case 'log10'
        z = log10(n./nf);
        zall = z(:);
        zall(isinf(abs(zall))) = [];        
        vmin = floor(min(zall(zall~=0)))
        vmax = ceil(max(zall(zall~=0)))
        v = vmin:1:vmax;
        [C,h]=contour(xmid',ymid',z,v,'k-','LineWidth',1);
        switch DO_LABEL
            case 1
                clabel(C,h,'LabelSpacing',720) 
        end
end
% and add labels
%clabel(C,h,v,'LabelSpacing',72,'BackgroundColor','w',...
%    'Edgecolor','k');