% function qc_limits_out = SubQCLimits(datain,datastream_config)
%
% check datastream values against manufacturer's and user's limits.
%
% INPUTS
% ------
% datain				input data stream (vector)
% datastream_config		configuration information
%
% OUTPUTS
% -------
% qc_limits_out         structure with information about number of data
%                           points outside of limits
% data_inlimits         structure containing logical indices of acceptabe
%                           data and the data within the limits 
%
% VERSIONING
% ----------
% 0.1	March 21 2011, concept only

function [qc_limits_out,data_inlimits] = SubQCLimits(datain,datastream_config)

% check for downsampling
if (~isfield(datastream_config.instrument,'skipnsamples'))
    skiprate = 1;
else
    skiprate = datastream_config.instrument.skipnsamples;
end
        

% get the number of data points that were input
npoints = numel(datain);
qc_limits_out.npoints = npoints;

% check for the number of NaN's
qc_limits_out.nnans = sum(isnan(datain));

% check for data out of manufacturer's limits
qc_limits_out.noverrange =  sum(datain>datastream_config.qc.range.max);
qc_limits_out.nunderrange =  sum(datain<datastream_config.qc.range.min);
qc_limits_out.ninrange = npoints - qc_limits_out.nnans - ...
	qc_limits_out.noverrange - qc_limits_out.nunderrange;

% check for data out of aceptable limits
qc_limits_out.noverlimit =  sum(datain>datastream_config.qc.accept.max);
qc_limits_out.nunderlimit =  sum(datain<datastream_config.qc.accept.min);
qc_limits_out.ninlimit = npoints - qc_limits_out.nnans - ...
	qc_limits_out.noverlimit - qc_limits_out.nunderlimit;

% export the data that are within limits
data_inlimits.logicali =  ~isnan(datain) & ...
    (datain>=datastream_config.qc.range.min) & ...
    (datain<=datastream_config.qc.range.max);
data_inlimits.i = find(data_inlimits.logicali);
data_inlimits.val = datain(data_inlimits.i);
% end