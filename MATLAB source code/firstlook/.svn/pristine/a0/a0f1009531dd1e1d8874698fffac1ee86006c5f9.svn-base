% function qc_flags_out = SubQCFlags(datain,qc_limits_out,datastream_config,tower)
%
% flag data stream with error codes to show sub-optimal performance.
%
% INPUTS
% ------
% datain				input data stream (vector)
% qc_limits_out			data
% datastream_config		configuration information
% tower                 tower information
%
% VERSIONING
% ----------
% 0.1	March 21 2011. Concept
% 0.2   July 12, 2011. Added checking of number of data points
% 0.3   January 5, 2015. Enabled variable sampling rate.

function qc_flag = SubQCFlags(datain,qc_info,datastream_config,tower)

% generate an empty vector
qc_flag = [];

% check the number of data points;
ntarget = qc_info.limits.ntarget;

% Check for reasons to flag data, using a code from 1000 to 2000
% to indicate flagging. This assumes that we have max 999 channels,
% and if one of those causes the problem we'll use the channel
% number as a qc code)

%%%%%%%%%%%%
% DATA RATES
%%%%%%%%%%%%
% 1002; number of data points between manufacturer-defined limits is low
if ((qc_info.limits.ninrange / ntarget) < datastream_config.qc.range.rate)
	qc_flag(end+1) = 1002;
end
% 1003; number of data points between user-defined limits is low
if ((qc_info.limits.ninlimit / ntarget) < datastream_config.qc.accept.rate);
	qc_flag(end+1) = 1003;
end

% 1004 is reserved for sonic anemometers where there is not enough data

% 1005 indicates Rain. NOT USED.

% 1006; Standard deviation below 0.01%
% check for digitial signal
if all(datain == 0) | all(datain == 1)
	% then assume this was a digital signal	
else
if (abs(nanstd(datain) / nanmean(datain)) *100) < 0.01
    qc_flag(end+1) = 1006;
end
end

% 1007; Magnitude of Ri above 10