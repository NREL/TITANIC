% script to tidy up x-y plots using the example of http://blogs.mathworks.com/loren/2007/12/11/making-pretty-graphs/

function pretty_xyplot(ah)

if exist('ah','var')
    if isempty(ah)
        ah = gca;
    end
else
    ah = gca;
end

for i =1:numel(ah)
    
    %% TICKS
    % move ticks on to the outside of the axes
    set(findobj(ah(i),'TickDir','in'),'TickDir','out');
    
    %% OTHER BITS n'PIECES
    set(ah(i), ...
        'Box', 'off', ...
        'TickDir', 'out', ...
        'TickLength', [.02 .02], ...
        'XMinorTick', 'on', ...
        'YMinorTick', 'on', ...
        'ZMinorTick', 'on', ...
        'XColor', [.3 .3 .3], ...
        'YColor', [.3 .3 .3], ...
        'ZColor', [.3 .3 .3], ...
        'LineWidth', 1 );
    
    %% draw a grid and send it to the bottom
    xon = get(ah(i),'XGrid');
    yon = get(ah(i),'YGrid');
    zon = get(ah(i),'ZGrid');
    xticks = get(ah(i),'XTick');
    yticks = get(ah(i),'YTick');
    zticks = get(ah(i),'ZTick');
    xlims = xlim(ah(i));
    ylims = ylim(ah(i));
    zlims = zlim(ah(i));
    h2 = [];
    if xon
        set(ah(i),'XGrid','off')
        if xticks(1) == min(xlims)
            firstxgrid = 2;
        else
            firstxgrid = 1;
        end        
        for ticki = firstxgrid:numel(xticks)            
                h2(end+1) = line([xticks(ticki) xticks(ticki)], ylims, ...
                    'Color',[0.8 0.8 0.8],...
                'Parent',ah(i));
        end
    end
    if yon
        set(ah(i),'YGrid','off')
        if numel(yticks) < 2
            yticks = ylims;
            firstygrid = 2;
        else
        if yticks(1) == min(ylims)
            firstygrid = 2;
        else
            firstygrid = 1;
        end
        end
        % draw the grid at constant y
        for ticki = firstygrid:numel(yticks)            
            h2(end+1) = line(xlims, [yticks(ticki) yticks(ticki)], ...
                'Color',[0.8 0.8 0.8],...
                'Parent',ah(i));
        end
    end
    % replot z grid
    if 0
        set(ah(i),'ZGrid','off')
        if zticks(1) == min(zlims)
            firstzgrid = 2;
        else
            firstzgrid = 1;
        end
        for ticki = firstzgrid:numel(zticks)            
            h2(end+1) = line(xlims, [0 0], [zticks(ticki) zticks(ticki)], ...
                'Color',[0.8 0.8 0.8],...
                'Parent',ah(i));
        end
    end
    
    uistack(h2,'bottom')
    xlim(ah(i),xlims)
    ylim(ah(i),ylims)
    zlim(ah(i),zlims)
    
    %% bring the axes to the front
    set(ah,'Layer','top')
end