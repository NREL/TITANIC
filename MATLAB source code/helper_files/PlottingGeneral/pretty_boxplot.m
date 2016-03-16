% script to tidy up box plots using the example of http://blogs.mathworks.com/loren/2007/12/11/making-pretty-graphs/

function ah = pretty_boxplot(ah)

if exist('ah','var')
    if isempty(ah)
        ah = gca;
    end
else
    ah = gca;
end

% GET CHILDREN
kids = get(ah,'Children');

%% TICKS
% move ticks on to the outside of the axes
set(findobj(ah,'TickDir','in'),'TickDir','out');

%% OTHER BITS n'PIECES
set(ah, ...
    'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.02 .02] , ...
    'YMinorTick'  , 'on'      , ...
    'YGrid'       , 'on'      , ...
    'XColor'      , [.3 .3 .3], ...
    'YColor'      , [.3 .3 .3], ...
    'ZColor'      , [.3 .3 .3], ...
    'LineWidth'   , 1         );

set(findobj('Tag','Box'),...
    'LineWidth',1,...
    'Color','k',...
    'MarkerFaceColor','w')
set(findobj('Tag','Lower Whisker'),'LineWidth',1)
set(findobj('Tag','Upper Whisker'),'LineWidth',1)
set(findobj('Tag','Median'),'LineWidth',1)

% RESET CHILDREN
if ~isempty(kids)
    set(ah,'Children',kids);
end
