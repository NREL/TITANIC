function [h,ixout,iyout] = plot_xy(x,y,varargin)

if isempty(varargin)
    data = 'val'
else
    data = varargin{1}
end

%% get good data
[ixpass,ixflag,ixfail] = flagstopassflagfail(x.flags);
[iypass,iyflag,iyfail] = flagstopassflagfail(y.flags);

%% get observations that occurred within 1 minute of each other
[tcxy,xi,yi] = get_common_times(x.date(ixpass),y.date(iypass),1/(24*60));

% figure out the data...

%% plot good data
xplot = x.val(ixpass(xi));
yplot = y.(data)(iypass(yi));

if isempty(xplot)
    h = plot(gca,nan,nan,'k.');
else
    h = plot(gca,xplot,yplot,'k.');
    
    switch data
        case 'val'
            % just plot the the good data
            hold on
        case 'npoints'
            % assume we are asking more detailed questions, so also plot
            % 'flagged' and 'failed' data
            xlims = xlim;
            % both data are flagged
            [tcxy,xi1,yi1] = get_common_times(x.date(ixflag),y.date,1/(24*60));
            [tcxy,xi2,yi2] = get_common_times(x.date,y.date(iyflag),1/(24*60));
            % get the data
            xflag = union(ixflag(xi1),xi2);
            yflag = union(yi1,iyflag(yi2));
            
            xplot = x.val(xflag);
            yplot = y.(data)(yflag);
            hold on
            h = plot(gca,xplot,yplot,'k.');
            set(h,'Color',[0.8 0.8 0.8])
            
            
            % either data are failed
            [tcxy,xi1,yi1] = get_common_times(x.date(ixfail),y.date,1/(24*60));
            [tcxy,xi2,yi2] = get_common_times(x.date,y.date(iyfail),1/(24*60));
            % get the data
            xfail = union(ixfail(xi1),xi2);
            yfail = union(yi1,iyfail(yi2));
            
            xplot = x.val(xfail);
            yplot = y.(data)(yfail);
            hold on
            h = plot(gca,xplot,yplot,'r.');
            %set(h,'Color',[0.8 0.8 0.8])
            
    end
    
end

%% tidy up
xlabel([x.label ' [' x.units ']'])
ylabel([y.label ' [' y.units ']'])
pretty_xyplot




% get the outputs
ixout = ixpass(xi);
iyout = iypass(yi);