% function qc_flag = qc_limits(datain,datastream_config)
%
% flag data stream with error codes to show sub-optimal performance.
%
% INPUTS
% ------
% datain				input data stream (vector)
% datastream_config		configuratioin information
%
% VERSIONING
% ----------
% 0.1	March 21 2011, concept only

function qc_flag = qc_flags(datain,qc_info,datastream_config)

% generate an empty vector
qc_flag = [];

% check the number of data points;
npoints = numel(datain);

% Check for reasons to flag data, using a code from 5000 to 5999
% to indicate flagging. This assumes that we have max 999 channels,
% and if one of those causes the problem we'll use the channel
% number as a qc code)

%%%%%%%%%%%%%%
% MISSING DATA
%%%%%%%%%%%%%%
% 5001; empty datastream
if isempty(datain)
	qc_flag(end+1) = 5001;
end
% 5002; all bad values
if sum(datain == datastream_config.instrument.nanvalue) == npoints
	qc_flag(end+1) = 5002;
end
% 5003; All NaN's
if sum(isnan(datain)) == numel(datain) | isnan(qc_info.statistics.mean)
    qc_flag(end+1) = 5003;
end

% 5004; Boom motion is over 0.1 m/s; coded elsewhere

% 5005; known outage

% and add more reasons to flag as required...

%% CHECK FOR NO FLAGS
if isempty(qc_flag)
    qc_flag = NaN;
end
%end