% function stats = SubQCBasicStats(datain,dmin,dmax)
%
% Filter data to find the number of data points above or below limits.
%
% INPUTS
% ------
% datain		Input data stream (vector)
% dmin			Data below this value are rejected
% dmax			Data above this value are rejected
%
% VERSIONING
% ----------
% 0.1	March 21 2011, concept only

function stats = SubQCBasicStats(datain,dmin,dmax);

% find data that are within range
di = (datain>dmin) & (datain<dmax) & ~isnan(datain);
% and the data itself
y = datain(di);
if ~isempty(y)
	% and now get statistical measures
    % number of points
    stats.npoints = numel(datain);
    % number of points
    stats.nvalid = numel(y);    
	% mean
	stats.mean = mean(y);
	% max
	stats.max = max(y);
	% min
	stats.min = min(y);
	% standard deviation
	stats.std = std(y);
	% maximum step
	stats.maxstep = max(abs(diff(y)));
	% maximum spike (single value excursion, value is the sum of
	% changes on either side)
	stats.maxspike = max(diff(diff(y)));
	
else
	% no data in the 'y' vector, so we have NaN's in the output
    stats.npoints = 0;
	stats.mean = NaN;
	stats.max = NaN;
	stats.min = NaN;
	stats.std = NaN;
	stats.maxstep = NaN;
	stats.maxspike = NaN;
end

% end