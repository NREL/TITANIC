% function DisplayChannelQCSummary(all_data)
%
% Display a summary of the QC results for all raw data channels

function DisplayChannelQCSummary(all_data)

allfields = fieldnames(all_data);

% create some empty variables
catstring = {};
npass = [];
nflag = [];
nfail = [];
z = [];
t0 = inf;
t1 = -inf;
% figureout how many good data points we have
for i = 1:numel(allfields)
    if strncmp(allfields{i},'Raw_',4)
        if strfind(allfields{i},'_mean')
            [ipass,iflag,ifail] = flagstopassflagfail(all_data.(allfields{i}).flags);
			% add a space before the height
            catstring{end+1} = strrep(all_data.(allfields{i}).label,'(',' (');
			% check for double spaces
			catstring{end} = strrep(catstring{end},'  ',' ');
            npass(end+1,1) = numel(ipass);
            nflag(end+1,1) = numel(iflag);
            nfail(end+1,1) = numel(ifail);
            z(end+1,1) =  all_data.(allfields{i}).height;
            t0 = min([min(all_data.(allfields{i}).date) t0]);
            t1 = max([max(all_data.(allfields{i}).date) t1]);
        end
    end
end

% plot the results
myplot(npass,nflag,nfail,catstring)

% tidy up a bit
title(['QC codes ' datestr(t0, 'dd mmm yyyy HH:MM') ...
    ' - ' datestr(t1, 'dd mmm yyyy HH:MM')])


function myplot(npass,nflag,nfail,catstring)

% draw some patches
for i = 1:numel(npass)
    h(1) = addpatch(0,...
        npass(i,1),...
        i,...
        [1 1 1]);
    hold on    
end
lstring{1} = 'Pass';

% draw some patches for the flagged data
for i = 1:numel(nflag)
    h(2) = addpatch(npass(i,1),...
        nflag(i,1),...
        i,...
        [0.8 0.8 0.8]);
    hold on    
end
lstring{2} = 'Flag';

% draw some patches for failed data
for i = 1:numel(nfail)
    h(3) = addpatch(npass(i,1)+nflag(i,1),...
        nfail(i,1),...
        i,...
        [1 0.1 0.1]);
    hold on    
end
lstring{3} = 'Fail';

% add some labels
xlims = xlim;
xlim('manual')
P = get(gca,'Position');
set(gca,'Position',[P(1)-0.05 P(2)-0.05 3*P(3)/4 P(4)+0.05],'Clipping','off')
for i = 1:numel(catstring)
    text(xlims(2),...
        i,...
        catstring{i},...
        'FontSize',8,...
        'VerticalAlignment','middle',...
    'HorizontalAlignment','left',...
    'BackgroundColor','none',...
    'tag','labels')
end

% add some details of the color scheme
legend(h,lstring,...
    'Location','SouthOutside',...
    'Orientation','horizontal',...
    'FontSize',8)

% tidy up
xlabel('Count')
set(gca,'YTickLabel','')
ylim([0.5 numel(npass)+0.5])
%set(gca,'YColor','none')

function h = addpatch(x,dx,y,C)
X = [x x+dx x+dx x];
Y = [y-0.35 y-0.35 y+0.35 y+0.35];
h = patch(X,Y,C);
