% function [n_sector,binsize] = get_wind_sector(theta_m,binsize)
%
function [n_sector,binsize] = get_wind_sector(theta_m,binsize)

% first check that we didn't get a silly bin size, e.g. 27 degrees... 
% silly means a non-integer number of bins
% round the bin size up, so 27 degrees would give us a 30-degree bin
binsize=360/(floor(360/binsize));


% generate an empty output vector
n_sector = NaN.*theta_m;

% get the number of the sector (0 is the bin centered on North/360)...
n_sector = floor(mod((theta_m+(binsize/2)),360)./binsize);

% deal with NaN inputs
n_sector(isnan(theta_m))=NaN;
