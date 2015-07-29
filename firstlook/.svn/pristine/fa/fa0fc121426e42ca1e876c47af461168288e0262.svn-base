% function SubSmoothPowerSpectra(f,p, varargin)
%
% plot the power spectra and apply some kind of averaging if required.
%
% INPUTS
% ------
%
% optional inputs are given as 'paramater',value pairs and include;
% 'nperdecade'; integrer giving the number of bins to be used per frequency
% decade. Suggested range is 1-20.
% 'filter'; aggregation method to use in each frequency bin. Required if
% 'nperdecade' is set. Valid values are 'mean','logmean'. Defaults to
% 'logmean'


function [fplot,pplot] = SubSmoothPowerSpectra(f,p,varargin)

%% DEFAULTS
% Variables
DO_AVG = 0;
filter = 'logmean';

%%------
% INPUTS
% ------

% check input arguments
optargin = size(varargin,2);
stdargin = nargin - optargin;

switch optargin
    case 0
    otherwise
        % there are optional arguments
        for k= 1:2:size(varargin,2)
            if isnumeric(varargin{k+1})
                eval([char(varargin{k}) '=' num2str(varargin{k+1}) ';']);
            elseif ischar(varargin{k+1})
                eval([char(varargin{k}) '=''' char(varargin{k+1}) ''';']);
            end
            switch char(varargin{k})
                case {'nperdecade'}
                    % the we'll be doing some averaging
                    DO_AVG = 1;
                    % figure out the frequency bands
                    fmindec = floor(log10(min(f(p>0 & f>0))));
                    fmaxdec = ceil(log10(max(f(p>0 & f>0))));
                    fbinsdec = fmindec:(1/nperdecade):fmaxdec;
                    
                    % then we should update some other variables
                    if ~exist('filter')
                        % this is required, so set jsut in case
                        filter = 'logmean';
                    end
                case {'filter'}
                    % the we'll be doing some averaging
                    DO_AVG = 1;
                    % then we should update some other variables
                    if ~exist('nperdecade')
                        nperdecade = 10;
                    end
                case {'nfft'}
                    % then we should update some other variables
            end
        end
end
    

%%%%%%%%%%%%%%
% PREPARE DATA
%%%%%%%%%%%%%%
if ~DO_AVG
    % then just show the raw spectra
    fplot = f;
    pplot = p;
else
    flog10 =  log10(f);
    % now get the data in each bin
    for j=1:numel(fbinsdec)-1
        % get the data in this bin
        ii = find((flog10>=fbinsdec(j)) & ...
            (flog10<fbinsdec(j+1)));
        fb = f(ii);
        pb = p(ii);
        % clear values where we have NaN or zero
        dnu = isnan(fb) | isnan(pb);
        fb(dnu) = [];
        pb(dnu) = [];
        % now generate the values we'll plot
        % freuqncies are always logmean;
        fplot(j) = 10^(nanmean(log10(fb)));
        switch filter
            case 'mean'
                pplot(j) = nanmean(pb);
            case 'logmean'
                pplot(j) = 10^(nanmean(log10(pb)));
        end
    end
    % remove NaN from the data
    fplot(isnan(pplot)) = [];
    pplot(isnan(pplot)) = [];
end