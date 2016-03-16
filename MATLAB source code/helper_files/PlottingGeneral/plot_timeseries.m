function h = plot_timeseries(ah,varargin)

if isempty(ah)
    ah = gca;
end

% work out the number of arguments
optargin = size(varargin,2);
stdargin = nargin - optargin;

switch optargin
    case 1
        x = varargin{1};
        if isfield(x,'flags')            
        % get the data quality        
        [xpass,xflag,xfail] = flagstopassflagfail(x.flags);
        
        % figure out how to plot it
        xplot = x.date;
        yplot(xpass) = x.val(xpass);
        yplot(xflag) = NaN;
        yplot(xfail) = NaN;
        
        %% show the QC process
        % plot good data
        h = plot(ah,xplot,yplot,'k.');
        hold on
        ylims = ylim;
        plot(ah,x.date(xflag),x.val(xflag),'k.',...
            'MarkerFaceColor',[0.8 0.8 0.8],...
            'MarkerEdgeColor',[0.8 0.8 0.8])
        plot(ah,x.date(xfail),x.val(xfail),...
            'r.',...
            'MarkerFaceColor','r')
        else
            h = plot(ah,x.date,x.val,'k.');
            hold on
            ylims = ylim;
        end
        % tidy up
        xlim(ah,[floor(min(x.date)) ceil(max(x.date))])
        xlims = xlim;
        ylim(ylims)
        datetick('x','keeplimits')
        ylabel(x.label)
        
    otherwise
        newcmap = colormap(jet(optargin+2));
        for i = 1:optargin
            x = varargin{i};            
            % generate the dataset to actually plot
            y = NaN * ones(size(x.val));            
            if isfield(x,'flags')
                % get the data quality
                [xpass,xflag,xfail] = flagstopassflagfail(x.flags);                
                y(xpass) = x.val(xpass);
            else
                y = x.val;
            end
            
            %% show the QC process
            % plot good data
            h(i) = plot(ah,x.date,y,'k-');
            set(h(i),'Color',newcmap(i+1,:))
            lstring{i} = x.label;
            hold on
        end
        % tidy up
        datetick('x','keeplimits')
        ylabel('Value')
        legend(ah,h,lstring,...
            'Location','best')
end
