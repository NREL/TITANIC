function plot_xy_boxplot(x,y,xedges)

if (isstruct(x) & isstruct(y))
    %% get good data
    [ixpass,ixflag,ixfail] = flagstopassflagfail(x.flags);
    [iypass,iyflag,iyfail] = flagstopassflagfail(y.flags);
    
    %% get observations that occurred within 1 minute of each other
    [tcxy,xi,yi] = get_common_times(x.date(ixpass),y.date(iypass),1/(24*60));
    
    % figure out the data...
    xplot = x.val(ixpass(xi));
    yplot = y.val(iypass(yi));
else
    xplot = x;
    yplot = y;
end

%% colors
AccentColor = [43, 140, 190]/255;
FillColor = [166, 189, 219]/255;

%% group x data
[n,bin] = histc(xplot, xedges);

xmid = (xedges(1:end-1) + xedges(2:end))./2;
dx = diff(xedges);

%% check to see if we should show a bin mean or not;
nbins = numel(xedges)-1;
npts = sum(~isnan(xplot)&~isnan(yplot));

%% work through each bin and get mean and extreme values

for i =1:(numel(xedges) -1)
    yy = yplot(bin==i);
    ymid = nanmedian(yy);
    y95 = prctile(yy,95);
    y75 = prctile(yy,75);
    y25 = prctile(yy,25);
    y05 = prctile(yy,5);
    %iout = outliertest(yy,y25,y75,[]);
    iout = (yy>y95) ...
        |...
        (yy<y05);
    % plot things
    hold on
    % number of points in this bin
    ninbin = numel(yy(~isnan(yy)));
    % figure out if we should plot this bin
    do_plot = ((ninbin/npts) >= 0.02) | (ninbin > 5);
    if ~isempty(yy) & do_plot
        %plot_whiskers(xedges(i),xedges(i+1),y75,y25,[])
        plot_whiskers_95_05(xedges(i),xedges(i+1),y95,y05,AccentColor)
        plot_box(xedges(i),xedges(i+1),y75,y25,AccentColor,FillColor)
        plot_midline([xedges(i) xedges(i+1)],ymid,AccentColor)
        plot(xmid(i)*ones(size(yy(iout))),yy(iout),...
            '.',...
            'MarkerEdgeColor',AccentColor,...
            'MarkerFaceColor',AccentColor,...
            'MarkerSize',4)
    end
end


%% tidy up
if (isstruct(x) & isstruct(y))
    xlabel([x.label ' (' x.units ')'])
    ylabel([y.label ' (' y.units ')'])
end




function plot_midline(x,ymid,AccentColor)
plot(gca,x,[ymid ymid],'color',AccentColor,'tag','Median')

function plot_box(l,r,t,b,AccentColor,FillColor)
if ((r-l)>0) & ((t-b)>0)
    rectangle('Position',[l,b,r-l,t-b],...
        'EdgeColor',AccentColor,...
        'FaceColor',FillColor,'Parent',gca,...
        'tag','box')
end

function plot_whiskers_95_05(l,r,y95,y05,AccentColor)
dx = (r-l) * 0.25;
plot(gca,[l+dx r-dx],[y95 y95],'color',AccentColor,...
    'Tag','Upper Whisker')
plot(gca,[l+dx r-dx],[y05 y05],'color',AccentColor,...
    'Tag','Lower Whisker')
plot(gca,[mean([l r]) mean([l r])],[y95 y05],'color',AccentColor)


function plot_whiskers(l,r,q1,q3,w,AccentColor)
if isempty(w)
    w = 1.5;
end
t = q3+w*(q3-q1);
b = q1-w*(q3-q1);

plot([l r],[t t],'color',AccentColor,...
    'Tag','Upper Whisker')
plot([l r],[b b],'color',AccentColor,...
    'Tag','Lower Whisker')
plot([mean([l r]) mean([l r])],[t b],'color',AccentColor)


function iout = outliertest(x,q1,q3,w)
if isempty(w)
    w = 1.5;
end
ix = zeros(size(x));
ix(x > (q3+w*(q3-q1))) = 1;
ix(x < (q1-w*(q3-q1))) = 1;
iout = find(ix);