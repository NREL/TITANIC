% function diurnal_cycle
%
% Shows heat fluxes on the M4 tower

function diurnal_cycle(x)

dummy = datevec(x.date);
hour = dummy(:,4);

[ipass,iflag,ifail] = flagstopassflagfail(x.flags);

figure

% plot the raw data
a1 = subplot(2,1,1);
plot(a1,hour(ipass),x.val(ipass),'k.')
hold on
plot(a1,hour(iflag),x.val(iflag),'k.','Color',[0.8 0.8 0.8])

a2 = subplot(2,1,2)
% plot box-and-whisker plots
plot(a2,[0 24],[0 0],'k-')
hold on

grouporder = {};
grouporder = cellstr(num2str(unique(hour(ipass)),'%d'));

boxplot(a2,x.val(ipass),num2str(hour(ipass),'%d'),...
    'outliersize',4,...
    'symbol','k+',...
    'grouporder',grouporder)

% tidy up
xlabel(a2,'Hour of Day')
ylabel(x.label)
xlim(a1,[-0.5 23.5])
xlim(a2,[0.5 24.5])